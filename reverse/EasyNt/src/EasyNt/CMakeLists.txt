set(TARGET_NAME EasyNt)

find_path(XORSTR_INCLUDE_DIRS "xorstr.hpp")
find_path(PHNT_INCLUDE_DIRS "ntbcd.h")
find_package(wil CONFIG REQUIRED)
find_package(turbobase64 CONFIG REQUIRED)

enable_language(ASM_MASM)

file(GLOB_RECURSE ASM_FILES *.asm)
file(GLOB_RECURSE SRC_FILES *.cpp)

add_executable(${TARGET_NAME} ${SRC_FILES} ${ASM_FILES})

set(TARGET_THIRDPARTY_LIBRARIES WIL::WIL turbo::base64)
set(TARGET_SYSTEM_LIBRARIES ntdll)
set(TARGET_LIBRARIES ${TARGET_THIRDPARTY_LIBRARIES} ${TARGET_SYSTEM_LIBRARIES})

target_link_libraries(${TARGET_NAME} PRIVATE ${TARGET_LIBRARIES})
target_include_directories(${TARGET_NAME} PRIVATE ${PHNT_INCLUDE_DIRS} ${XORSTR_INCLUDE_DIRS})

set_target_properties(${TARGET_NAME} PROPERTIES
	MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
)