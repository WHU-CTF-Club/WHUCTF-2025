// clang-format off
#define PHNT_VERSION PHNT_THRESHOLD
#include <phnt_windows.h>
#include <phnt.h>
// clang-format on

#include <intrin.h>

#include <chrono>
#include <format>
#include <semaphore>
#include <string>
#include <unordered_map>
#include <vector>

#include <turbobase64/turbob64.h>
#include <wil/win32_helpers.h>
#include <xorstr.hpp>

extern "C" bool FAST_SYSCALL;
extern "C" int SYSCALL_NR;
extern "C" void MYSYSCALL();

std::binary_semaphore sem{false};

bool SetupFastSyscall() {
  FAST_SYSCALL = false;

  int cpuid[4];
  __cpuid(cpuid, 0);
  // IsIntel
  if (cpuid[1] == 'uneG' && cpuid[3] == 'Ieni' && cpuid[2] == 'letn') {
    __cpuid(cpuid, 0x80000001);
    if (cpuid[3] & (1 << 11)) {
      FAST_SYSCALL = true;
    }
  } else if (cpuid[1] == 'htuA' && cpuid[3] == 'itne' && cpuid[2] == 'DMAc') {
    FAST_SYSCALL = true;
  } else {
    return false;
  }

  return true;
}

struct SyscallNRInternal {
  int FnNtWaitForSingleObject;
  int FnNtReadFile;
  int FnNtWriteFile;
  int FnNtClose;
  int FnNtCreateThreadEx;
  int FnNtTerminateProcess;
  int FnNtQueryInformationProcess;
};

static std::unordered_map<USHORT, SyscallNRInternal> SyscallNRMap = {
    {7601, {1, 3, 5, 12, 165, 41, 22}},  {9200, {1, 4, 6, 13, 175, 42, 23}},  {9600, {2, 5, 7, 14, 176, 43, 24}},
    {10240, {3, 6, 8, 15, 179, 44, 25}}, {10586, {4, 6, 8, 15, 180, 44, 25}}, {14393, {4, 6, 8, 15, 182, 44, 25}},
    {15063, {4, 6, 8, 15, 185, 44, 25}}, {16299, {4, 6, 8, 15, 186, 44, 25}}, {17134, {4, 6, 8, 15, 187, 44, 25}},
    {17763, {4, 6, 8, 15, 188, 44, 25}}, {18362, {4, 6, 8, 15, 189, 44, 25}}, {18363, {4, 6, 8, 15, 189, 44, 25}},
    {19041, {4, 6, 8, 15, 193, 44, 25}}, {19042, {4, 6, 8, 15, 193, 44, 25}}, {19043, {4, 6, 8, 15, 193, 44, 25}},
    {19044, {4, 6, 8, 15, 194, 44, 25}}, {19045, {4, 6, 8, 15, 194, 44, 25}}, {22000, {4, 6, 8, 15, 198, 44, 25}},
    {22621, {4, 6, 8, 15, 199, 44, 25}}, {22631, {4, 6, 8, 15, 199, 44, 25}}, {26100, {4, 6, 8, 15, 201, 44, 25}},
};
static SyscallNRInternal* SystemSyscalls = nullptr;

#define NTCALL(function, ...)                \
  SYSCALL_NR = SystemSyscalls->Fn##function; \
  reinterpret_cast<decltype(function)*>(MYSYSCALL)(__VA_ARGS__)

static void MyCloseHandle(HANDLE handle) { NTCALL(NtClose, handle); }

static void MyTerminateProcess(HANDLE process, UINT exit_code) { NTCALL(NtTerminateProcess, process, exit_code); }

static __forceinline bool CheckIsBeingDebugged() {
  if (NtCurrentPeb()->BeingDebugged) {
    return true;
  } else {
    HANDLE debug_port = nullptr;
    NTSTATUS status = NTCALL(NtQueryInformationProcess, NtCurrentProcess(), ProcessDebugPort, &debug_port,
                             sizeof(debug_port), nullptr);
    if (!NT_SUCCESS(status) || debug_port) {
      return true;
    }
  }

  return false;
}

static void AntiDebugThread() {
  do {
    if (CheckIsBeingDebugged()) {
      MyTerminateProcess(NtCurrentProcess(), 0xdeadbeef);
    }
  } while (!sem.try_acquire_for(std::chrono::milliseconds{100}));
}

static HANDLE MyCreateThread(PVOID routine) {
  HANDLE result;
  NTSTATUS status = NTCALL(NtCreateThreadEx, &result, THREAD_ALL_ACCESS, nullptr, NtCurrentProcess(), routine, nullptr,
                           0, 0, 0, 0, nullptr);
  if (!NT_SUCCESS(status)) {
    return nullptr;
  }

  return result;
}

static DWORD MyWaitForSingleObject(HANDLE handle, DWORD milliseconds) {
  PLARGE_INTEGER p = nullptr;
  LARGE_INTEGER timeout;
  if (milliseconds != INFINITE) {
    timeout.QuadPart = -10000LL * milliseconds;
    p = &timeout;
  }

  const auto status = NTCALL(NtWaitForSingleObject, handle, FALSE, p);
  if (!NT_SUCCESS(status)) {
    return WAIT_FAILED;
  }

  return static_cast<DWORD>(status);
}

static bool MyReadFile(HANDLE file, PVOID buffer, DWORD length, DWORD* bytes_read) {
  if (bytes_read) {
    *bytes_read = 0;
  }

  IO_STATUS_BLOCK io;
  auto status = NTCALL(NtReadFile, file, nullptr, nullptr, nullptr, &io, buffer, length, nullptr, nullptr);

  if (status == STATUS_PENDING) {
    DWORD wait_result = MyWaitForSingleObject(file, INFINITE);
    if (wait_result != WAIT_OBJECT_0) {
      return false;
    }
    status = io.Status;
  }

  if (NT_SUCCESS(status)) {
    if (bytes_read) {
      *bytes_read = static_cast<DWORD>(io.Information);
    }
    return true;
  }

  if (status == STATUS_END_OF_FILE) {
    if (bytes_read) {
      *bytes_read = 0;
    }
    return true;
  }

  if (NT_WARNING(status) && bytes_read) {
    *bytes_read = static_cast<DWORD>(io.Information);
    return false;
  }

  return false;
}

static bool MyWriteFile(HANDLE file, LPCVOID buffer, DWORD length, DWORD* bytes_written) {
  if (bytes_written) {
    *bytes_written = 0;
  }

  IO_STATUS_BLOCK io;
  auto status =
      NTCALL(NtWriteFile, file, nullptr, nullptr, nullptr, &io, const_cast<PVOID>(buffer), length, nullptr, nullptr);

  if (status == STATUS_PENDING) {
    DWORD wait_result = MyWaitForSingleObject(file, INFINITE);
    if (wait_result != WAIT_OBJECT_0) {
      return false;
    }
    status = io.Status;
  }

  if (NT_SUCCESS(status)) {
    if (bytes_written) {
      *bytes_written = static_cast<DWORD>(io.Information);
    }
    return true;
  }

  if (NT_WARNING(status) && bytes_written) {
    *bytes_written = static_cast<DWORD>(io.Information);
    return false;
  }

  return false;
}

struct MD5Context {
  unsigned int buf[4];
  unsigned int bytes[2];
  unsigned int in[16];
  unsigned char out[16];
};

int main() {
  if (!SetupFastSyscall()) {
    return 1;
  }

  const auto peb = NtCurrentPeb();
  const auto itr = SyscallNRMap.find(peb->OSBuildNumber);
  if (itr == SyscallNRMap.end()) {
    return 1;
  }

  SystemSyscalls = &itr->second;

  HANDLE anti_debug = MyCreateThread(AntiDebugThread);
  if (anti_debug == nullptr) {
    return 1;
  }

  using FnMd5Init = void(MD5Context*);
  using FnMd5Update = void(MD5Context*, unsigned char const*, unsigned int);
  using FnMd5Final = void(MD5Context*);
  const auto ntdll = ::GetModuleHandleW(L"ntdll.dll");
  if (ntdll == nullptr) {
    return 1;
  }

  const auto md5_init = reinterpret_cast<FnMd5Init*>(::GetProcAddress(ntdll, "MD5Init"));
  const auto md5_update = reinterpret_cast<FnMd5Update*>(::GetProcAddress(ntdll, "MD5Update"));
  const auto md5_final = reinterpret_cast<FnMd5Final*>(::GetProcAddress(ntdll, "MD5Final"));
  if (md5_init == nullptr || md5_update == nullptr || md5_final == nullptr) {
    return 1;
  }
  auto md5 = [md5_init, md5_update, md5_final](const void* ptr, unsigned int length) {
    MD5Context ctx;
    md5_init(&ctx);
    md5_update(&ctx, static_cast<const unsigned char*>(ptr), length);
    md5_final(&ctx);
    std::string result;
    for (unsigned char i : ctx.out) {
      result += std::format("{:02x}", i);
    }
    return result;
  };

  auto dout = [peb](const void* buffer, DWORD length) {
    MyWriteFile(peb->ProcessParameters->StandardOutput, buffer, length, nullptr);
  };
  auto sout = [peb](std::string_view str) {
    MyWriteFile(peb->ProcessParameters->StandardOutput, str.data(), static_cast<DWORD>(str.size()), nullptr);
  };
  auto derr = [peb](const void* buffer, DWORD length) {
    MyWriteFile(peb->ProcessParameters->StandardError, buffer, length, nullptr);
  };
  auto serr = [peb](std::string_view str) {
    MyWriteFile(peb->ProcessParameters->StandardError, str.data(), static_cast<DWORD>(str.size()), nullptr);
  };
  auto din = [peb](void* buffer, DWORD length) {
    MyReadFile(peb->ProcessParameters->StandardInput, buffer, length, nullptr);
  };
  auto sin = [peb](std::string& buffer, DWORD length) {
    DWORD bytes_read;
    buffer.resize(length);
    MyReadFile(peb->ProcessParameters->StandardInput, buffer.data(), length, &bytes_read);
    buffer.resize(bytes_read);
    if (!buffer.empty()) {
      buffer.erase(0, buffer.find_first_not_of(" \t\n\r"));
      buffer.erase(buffer.find_last_not_of(" \t\n\r") + 1);
    }
  };

  sout("Please input: ");
  std::string buffer;
  // WHUCTF{Cl0se_S0urc3d_System_1s_N0t_SO_Ha3d}
  sin(buffer, 64);
  if (!buffer.starts_with("WHUCTF{") || !buffer.ends_with("}")) {
    sout("Invalid input\n");
    return 1;
  }

  buffer = buffer.substr(7, buffer.size() - 8);
  // split buffer by '_'
  for (const auto& ch : buffer) {
    if (ch <= 32 || ch >= 126) {
      sout("Invalid character");
      return 1;
    }
  }

  std::vector<std::string> parts;
  while (true) {
    const auto pos = buffer.find_first_of('_');
    if (pos == std::string::npos) {
      break;
    }
    const auto tmp = buffer.substr(0, pos);
    if (!tmp.empty()) {
      parts.push_back(tmp);
    }
    buffer.erase(0, pos + 1);
  }

  if (!buffer.empty()) {
    parts.push_back(buffer);
  }
  buffer.clear();

  if (parts.size() != 7) {
    sout("Invalid part count");
    return 1;
  }

  using unique_unicode_string =
      wil::unique_any<PUNICODE_STRING, decltype(&::RtlFreeUnicodeString), ::RtlFreeUnicodeString>;

  std::vector<unique_unicode_string> us_parts;
  for (const auto& part : parts) {
    auto us = std::make_unique<UNICODE_STRING>();
    if (!RtlCreateUnicodeStringFromAsciiz(us.get(), part.c_str())) {
      serr("Failed");
      return 1;
    }
    us_parts.emplace_back(us.release());
  }

  constexpr size_t kLengths[7] = {5, 7, 6, 2, 3, 2, 4};
  constexpr ULONG32 kCRCAnswer[7] = {0x7439f61c, 0x0d82fdac, 0x54ab2bbe, 0x6dc16aed,
                                     0x3fe88eec, 0x8f1d2c9a, 0xbffd2322};
  constexpr std::string_view kMD5Answer[7] = {"57f650568eb39c9b1f5e60ca9e583eab", "eb65eec0cd7a09f1a2cd8988916806c0",
                                              "a4d5fa0f29b424492a8e2302f80f179d", "a3f11de53829d5978ef28f599f0ba825",
                                              "739df9a3b39609d6a4e50516bac3d19d", "2a78fea533b26a7d58c3c02cfad822a9",
                                              "dfd7572d3b4a5b786de1328be0057577"};
  const std::string_view kB64Answer[7] = {xorstr_("QwBsADAAcwBlAA=="), xorstr_("UwAwAHUAcgBjADMAZAA="),
                                          xorstr_("UwB5AHMAdABlAG0A"), xorstr_("MQBzAA=="),
                                          xorstr_("TgAwAHQA"),         xorstr_("UwBPAA=="),
                                          xorstr_("SABhADMAZAA=")};

  for (size_t i = 0; i < 7; ++i) {
    if (us_parts[i].get()->Length != kLengths[i] * sizeof(WCHAR)) {
      sout("Wrong!");
      return 1;
    }
  }

  std::vector<ULONG32> hashes;
  for (auto& us_part : us_parts) {
    hashes.push_back(RtlComputeCrc32(0, us_part.get()->Buffer, us_part.get()->Length));
  }

  std::vector<std::string> md5s;
  for (auto& us_part : us_parts) {
    md5s.push_back(md5(us_part.get()->Buffer, us_part.get()->Length));
  }

  std::vector<std::string> base64s;
  for (auto& us_part : us_parts) {
    std::string tmp;
    tmp.resize(tb64enclen(us_part.get()->Length));
    tb64enc(reinterpret_cast<const unsigned char*>(us_part.get()->Buffer), us_part.get()->Length,
            reinterpret_cast<unsigned char*>(tmp.data()));
    base64s.push_back(tmp);
  }

  if (std::equal(hashes.begin(), hashes.end(), kCRCAnswer) && std::equal(md5s.begin(), md5s.end(), kMD5Answer) &&
      std::equal(base64s.begin(), base64s.end(), kB64Answer)) {
    sout("Congratulations! You got the flag!\n");
  } else {
    sout("Wrong!");
  }

  sem.release();
  MyWaitForSingleObject(anti_debug, INFINITE);
  MyCloseHandle(anti_debug);

  return 0;
}