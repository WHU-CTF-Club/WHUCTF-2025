<?php
$messages = [
    "签到都签不上吗？",
    "快渗透啊！你不是渗透高手吗？",
    "CTF与她皆失",
    "我知道你很急但你先别急",
    "破防了？"
];
?>

<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>炫酷的消息轮播</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            transition: background-color 1s ease;
            background-color: #f0f0f0;
        }

        .container {
            margin-top: 50px;
        }

        .message {
            font-size: 36px;
            color: #333;
            margin: 20px;
            opacity: 0;
            display: inline-block;
            animation: fadeIn 1.5s ease-out forwards, shake 0.5s ease-in-out 2s;
        }

        button {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        /* 动画效果：文字淡入 */
        @keyframes fadeIn {
            0% {
                opacity: 0;
                transform: translateY(-20px);
            }

            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 动画效果：震动 */
        @keyframes shake {
            0% {
                transform: translateX(0);
            }

            25% {
                transform: translateX(-5px);
            }

            50% {
                transform: translateX(5px);
            }

            75% {
                transform: translateX(-5px);
            }

            100% {
                transform: translateX(0);
            }
        }
    </style>
</head>

<body>

    <div class="container">
        <h1>Colar world</h1>
        <p class="message" id="message"><?php echo $messages[0]; ?></p>
        <br>
        <button id="changeColorBtn">color</button>
    </div>

    <script>
        // 将 PHP 数组转换为 JavaScript 数组
        const messages = <?php echo json_encode($messages); ?>;
    </script>
    <script>
        const messageElement = document.getElementById("message");
        let index = 0; // 当前消息索引

        // 切换消息
        function changeMessage() {
            index = (index + 1) % messages.length; // 轮播消息
            messageElement.style.opacity = "0"; // 先隐藏
            setTimeout(() => {
                messageElement.textContent = messages[index]; // 更新文本
                messageElement.style.animation = "none"; // 清除动画
                messageElement.offsetHeight; // 触发重绘，重新应用动画
                messageElement.style.animation = "fadeIn 1.5s ease-out forwards, shake 0.5s ease-in-out 2s";
            }, 500);
        }

        // 每 3 秒自动切换消息
        setInterval(changeMessage, 3000);
        // dawn.php
        // 获取按钮和背景颜色
        const button = document.getElementById('changeColorBtn');
        const colors = ['#FF5733', '#33FF57', '#3357FF', '#FF33A1', '#FFD700'];
        // 点击按钮更改背景色 & 手动切换消息
        button.addEventListener("click", function () {
            const randomColor = colors[Math.floor(Math.random() * colors.length)];
            document.body.style.backgroundColor = randomColor;
            changeMessage();
        });
        button.addEventListener('click', function() {
            // 随机选择一个颜色
            const randomColor = colors[Math.floor(Math.random() * colors.length)];
            document.body.style.backgroundColor = randomColor;

        });
    </script>
</body>

</html>