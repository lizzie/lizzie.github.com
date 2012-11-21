三款小巧服务器
===================

:date: 2010-04-30 10:04:36
:tags: Tools

介绍三款简单小巧的服务器

Nano
-------------------

java的超级小巧服务器, http://elonen.iki.fi/code/nanohttpd/NanoHTTPD.java 只要设置个文件路径, 就可以使用了.


node.js
-------------------

http://nodejs.org/ 完全js语法编写,

    .. sourcecode:: js

        var sys = require('sys'),
           http = require('http');
        http.createServer(function (req, res) {
          setTimeout(function () {
            res.writeHead(200, {'Content-Type': 'text/plain'});
            res.end('Hello World\n');
          }, 2000);
        }).listen(8000);
        sys.puts('Server running at http://127.0.0.1:8000/');

运行:

    ::

        $ node example.js
        Server running at http://127.0.0.1:8000/

功能强大.


Flask
-------------------

http://flask.pocoo.org/ python实现, 又一款轻型框架~

    .. sourcecode:: python

        from flask import Flask
        app = Flask(__name__)

        @app.route('/')
        def hello_world():
            return "Hello World!"

        if __name__ == '__main__':
            app.run()

运行:

    ::

        $ python hello.py
         * Running on http://127.0.0.1:5000/
