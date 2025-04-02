<?php
error_reporting(0);
if (isset($_GET['hello-webdog'])) {
    highlight_file(__FILE__);
} else {
    die("see me?");
}
$name = $_POST['name'];
$token = $_POST['token'];
$pattern = "/[<\"'\\\\;\?>]/";

if (preg_match($pattern, $name) || preg_match($pattern, $token)) {
    echo json_encode(["error" => "非法字符检测到"]);
    exit;
}
$open = fopen("data.php", "w");
$str = '<?php  header("Content-Type: application/json; charset=UTF-8");error_reporting(0);';
$str .= '$webdog_name = "';
$str .= "$name";
$str .= '"; ';
$str .= '$token = "';
$str .= "$token";
$str .= '"; $Config = [
    "webdog-name" => "$webdog_name",
    "token" => "$token"
];';
$str .= ' ;return json_encode($Config);?>';
fwrite($open, $str);
fclose($open);
