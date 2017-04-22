yzhu73@gmail.com
1234ttt

### 依赖包

pip3 install requests
pip3 install lxml

### 程序使用方法
程序通过解析 date.txt 文件中的日期来查询相应的数据，
使用时，需要按照 date.txt 中的例子填写日期即可。

关于登录，需要先用账号、密码在 wsj 网站进行登录，然后在浏览器控制台中，
复制出来 Cookie 信息，填写在 config.py 里面的 cookie 字段中即可。

配置好以上两点，即可下载文章详情。
