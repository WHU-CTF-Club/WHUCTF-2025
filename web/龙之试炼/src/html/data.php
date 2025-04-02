<?php
error_reporting(0);

header("Content-Type: application/json; charset=UTF-8");
$webdog_name = "123";
$token = "123";
$Config = [
    "webdog-name" => "$webdog_name",
    "token" => "$token"
];;
echo json_encode($Config, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
