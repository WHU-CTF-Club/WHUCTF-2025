<?php
$file = $_POST['url_image'];
?>
<?php
//reousrce code is in ./picture/dawn.txt
if (!isset($_POST['url_image'])) {
    // 获取图片内容
    $imageUrl = 'http://i.postimg.cc/CL9rHhBL/60933562efee5a81ddce9b14f055c8b7.jpg';
    $imageData = file_get_contents($imageUrl);

    if ($imageData === false) {
        die('无法加载图片，请检查 URL 是否正确。');
    }
    // 将图片内容转换为 base64 编码
    $base64Image = base64_encode($imageData);
    //存入图库
    file_put_contents('./picture/image.jpg', $imageData);
?>


<?php
} else if (isset($_POST['url_image'])) {
    $imageData = file_get_contents($file);

    // 将图片内容转换为 base64 编码
    $base64Image = base64_encode($imageData);
    //存入图库
    file_put_contents('./picture/image.jpg', $imageData);
}
?>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your image</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
        }

        img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>

<body>
    <h1>Your image</h1>
    <img src="data:image/jpeg;base64,<?php echo $base64Image; ?>" alt="动态图片">
</body>

</html>
<script>
    alert("The image has been saved in the gallery")
</script>
