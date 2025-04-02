<?php
highlight_file(__FILE__);
$file = "web-dog.png"; // 图片路径
//dawn.php
if (!isset($_POST['f'])) {
    $info = getimagesize($file);
    echo "宽度: " . $info[0] . " 像素<br>";
    echo "高度: " . $info[1] . " 像素<br>";
    echo "MIME 类型: " . $info['mime'] . "<br>";
} else {
    $info = getimagesize($_POST['f']);
}
?>
<html>
    <img src="web-dog.png" alt="示例图片">
</html>
