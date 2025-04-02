package main

import (
	"fmt"
	"log"
	"net/http"
	"os/exec"

	"github.com/gin-gonic/gin"
)

var indexHtml = "<!DOCTYPE html>\n<html lang=\"zh\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>星光罗盘的启示</title>\n    <style>\n        body {\n            font-family: Arial, sans-serif;\n            padding: 20px;\n            background-color: #f4f4f4;\n            text-align: center;\n        }\n        .container {\n            max-width: 600px;\n            margin: auto;\n            background: white;\n            padding: 20px;\n            border-radius: 10px;\n            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);\n        }\n        input {\n            width: 80%;\n            padding: 10px;\n            margin: 10px 0;\n            border: 1px solid #ccc;\n            border-radius: 5px;\n        }\n        button {\n            padding: 10px 15px;\n            background: #007bff;\n            color: white;\n            border: none;\n            border-radius: 5px;\n            cursor: pointer;\n            font-size: 16px;\n        }\n        button:hover {\n            background: #0056b3;\n        }\n        iframe {\n            width: 100%;\n            height: 500px;\n            border: none;\n            margin-top: 20px;\n            border-radius: 5px;\n        }\n    </style>\n</head>\n<body>\n<div class=\"container\">\n    <h2>向星光罗盘祈祷</h2>\n    <input type=\"text\" id=\"urlInput\" placeholder=\"输入网址...\" value=\"www.baidu.com\">\n    <button onclick=\"loadWebsite()\">祈祷</button>\n    <p>星光罗盘给予的启示:</p>\n    <iframe id=\"websiteFrame\"></iframe>\n</div>\n\n<script>\n    async function loadWebsite() {\n        const url = document.getElementById('urlInput').value;\n        if (!url) {\n            alert('请输入有效的网址');\n            return;\n        }\n\n        await fetch(`/query?url=${url}`).then(\n            data => data.json()\n        ).then(\n            v => {\n                const iframe = document.getElementById(\"websiteFrame\");\n                if (iframe !== null && v.result.length > 0) {\n                    const ifrdoc = iframe.contentWindow.document;\n                    ifrdoc.designMode = \"on\";\n                    ifrdoc.open();\n                    ifrdoc.write(v.result);\n                    ifrdoc.close();\n                    ifrdoc.designMode =\"off\";\n                }\n            }\n        ).catch(\n            e => {\n                const errorPage = '<h1 style=\"text-align: center\">404 Not Found</h1>'\n                const iframe = document.getElementById(\"websiteFrame\");\n                const ifrdoc = iframe.contentWindow.document;\n                ifrdoc.designMode = \"on\";\n                ifrdoc.open();\n                ifrdoc.write(errorPage);\n                ifrdoc.close();\n                ifrdoc.designMode =\"off\";\n            }\n        );\n    }\n</script>\n</body>\n</html>\n"

func main() {
	router := gin.Default()
	router.GET("/query", func(c *gin.Context) {
		url := c.Query("url")
		if url == "" {
			c.JSON(http.StatusBadRequest, gin.H{
				"error": "url is empty",
			})
			return
		}
		fmt.Printf("curl %s\n", url)
		cmd := exec.Command("curl", "-s", url)
		out, err := cmd.CombinedOutput()
		if err != nil {
			log.Println(err)
			c.JSON(http.StatusBadRequest, gin.H{
				"error": "something went wrong",
			})
			return
		} else {
			fmt.Println(string(out))
		}
		c.JSON(200, gin.H{
			"result": string(out),
		})
	})
	router.GET("/", func(c *gin.Context) {
		c.Header("Content-Type", "text/html; charset=utf-8")
		c.String(200, indexHtml)
	})
	err := router.Run(":8080")
	if err != nil {
		log.Fatalln(err)
	}
}
