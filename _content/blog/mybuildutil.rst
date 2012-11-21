MyBuildUtil
===================

:date: 2010-08-07 11:08:02
:tags: Python, Tools

话说Java ant实在用不惯, 而现有的build配置尝试了好久还是不懂, 再次鄙视下xml. 汗个那么多的标签~

正因如此, 周末赶紧写了个js/css打包压缩小脚本, 目前能够已满足我的小需求:

* 写个依赖(配置)文件, 定义哪些js/css合并成xx文件;
* 生成压缩文件;

暂时还不支持的功能:

* 替换html的js/css, ps: 话说有时候, 程序并不能清楚的知道哪个页面上需要哪些功能, 这些功能在哪些文件中, 所以目前手工替换. 或许也可在生成html时根据配置替换调试时的js/css文件. 再议吧..
* 自动检测文件编码功能, 目前默认都是utf-8, 可以考虑用chardet试试.

这里不贴代码了, 完整的在 http://code.google.com/p/lizworkspace/source/browse/trunk/tools, 有兴趣的可以试一下.
简单的使用:

    ::

        D:\workspace\myserver\tools>python mybuild.py --help
        Usage: mybuild.py [options] xxx

        Options:
          -h, --help            show this help message and exit
          -c CONFIG, --config=CONFIG
                                config file # 配置文件
          -z, --zip             zip or not # 需不需要压缩, 如果设置-z 就需要用到yuicompressor
          -d DEST, --dest=DEST  dest dir # 生成目标目录, 默认是当前目录的tmp下


        如:
        D:\workspace\myserver\tools>python mybuild.py -z -c configfile -d destdir


config的写法, 很简单

    ::

        ks-mkt
        <script src="../../libs/kissy/1.1.0/build/anim/anim-pkg-min.js"></script>
        <script src="../../libs/kissy/1.1.0/build/datalazyload/datalazyload-min.js"></script>
        <script src="../../libs/kissy/1.1.0/build/switchable/switchable-pkg-min.js"></script>

        =====
        mkt-base
        <script src="../../src/js/market/m/base.js"></script>
        <script src="../../src/js/market/m/pagenation.js"></script>
        <script src="../../src/js/market/m/searchbox.js" charset="utf-8"></script>
        <script src="../../src/js/market/m/imageshow.js" charset="utf-8"></script>
        <script src="../../src/js/market/m/sortorder.js" charset="utf-8"></script>
        <script src="../../src/js/market/m/starscore.js" charset="utf-8"></script>

        =====
        mkt-dialog
        <script src="../../libs/yui/2.8.1/build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script src="../../libs/yui/2.8.1/build/connection/connection-min.js"></script>
        <script src="../../src/js/tshop.js"></script>
        <script src="../../src/js/ds/widgets/dialog.js"></script>
        <script src="../../src/js/ds/request-manager.js"></script>
        <script src="../../src/js/ds/widgets/dialogable.js"></script>

        =====
        mkt-editor
        <script src="../../libs/yui/2.8.1/build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script src="../../libs/yui/2.8.1/build/connection/connection-min.js"></script>
        <script src="../../libs/kissy/1.0.4/build/editor/editor-min.js"></script>

        =====
        mkt-validate
        <script src="../../src/js/market/m/signin.js" charset="utf-8"></script>
        <script src="../../src/js/market/m/order4.js" charset="utf-8"></script>
        <script src="../../src/js/market/m/report.js" charset="utf-8"></script>
        <script src="../../src/js/market/m/upload1.js" charset="utf-8"></script>
        <script src="../../src/js/market/m/upload2.js" charset="utf-8"></script>
        <script src="../../src/js/market/m/close.js" charset="utf-8"></script>

Note: ``=====`` 为分隔符, 接下来的第一行是压缩后的文件名字, 余下的都是所需原js文件,
咔咔, 这里直接从html里拷贝过来(偷懒ing), 其实只要文件名就可以了, 路径是相对于config文件
来说的, 不是运行时目录. 不然可能会找不到文件~

最简单的实现. 以后需要再扩充吧~~

