NPAPI
================

:date: 2013-2-6 17:11:08
:tags: Chrome, Plugins, FireBreath, note

近来在写一个 Chrome 扩展, 大概需求是截取地图, 传到后台分析地图图片上的一些位置并返回给前台, 最后存坐标入数据库.
其中分析这步, 是部署在IIS上的C#程序, C#再去调用底层的C++算法. 虽说 Chrome 扩展中可以发送跨域请求, 不过还是感觉绕了一大圈.
偶尔看到扩展中可以载入 Plugin 并可以被 js 调用. 于是, 琢磨了下这类 Plugin 的写法. 如果可以的话, 那就可以在Chrome里面分析图片上的位置直接返回.

这相关的资料, 网上找了一圈, 都比较零散, 要么就是非常成旧的, 以致刚开始看比较晕. 所以这边就整理下思路:

首先, Chrome 扩展对 Plugin 的使用说明, 官方有 `Chrome扩展对NPAPI的使用说明 <http://developer.chrome.com/extensions/npapi.html>`_ , 只要按照上面的写法就能载入 Plugin.

但是如何去生成这个 Plugin 呢?  而且什么是 NPAPI 呢? 对于我这种刚开始连 Plugin 是干嘛的都不知道的人来说... 简直就是无从下手.

网上胡乱搜了一圈的资料, 感觉比较有用的就是:

- `NPAPI的历史由来 <http://en.wikipedia.org/wiki/Netscape_Plugin_Application_Programming_Interface>`_ , 主要包含 LiveConnect, XPConnect, NPRuntime 三个阶段
- `Plugin和Browser相互调用图解及步骤说明 <http://jldupont.blogspot.com/2009/11/notes-on-npapi-based-plugins.html>`_

我自己总结下就是:

- Plugin 是让浏览器可以去执行桌面端程序的一种方式,
- 比如说可以操作本地文件, 图像处理等. Plugin 本质上就是一些 .dll, .so,
- 这些是针对不同操作系统上, 不同编译器上编译出来的可执行程序. 至于这些用什么语言来写的, 那就没关系了. 可生成的 .dll/.so 只是在桌面端来执行的.
- 那如何在浏览器内执行呢? 是不是要专门定些接口? 不同的浏览器也有不同的实现,
- 上面提到的 LiveConnect(类似于java applet, 要执行必须依赖于jvm, 就是说浏览器中得包含个jvm, 这样就能执行java代码了), XPConnect(mozilla提的一种), NPRuntime, 就是不同时期, 不同浏览器厂商提供的执行插件程序的API.
- 最后的 NPRuntime 就是后来多个浏览器厂商都支持的一种规范 API, 目前都支持.

那差不多了解了, 就可以依据 NPAPI 的规范来开发浏览器 Plugin 了.


NPAPI 有 `提供 SDK <http://code.google.com/p/npapi-sdk/source/checkout>`_ , C代码, 看头文件的话, 定义了一些 initialize/new/destory等方法和数据类型(里面列出的所有API说明,
可以在 `这篇博文 <http://colonelpanic.net/2009/05/building-a-firefox-plugin-part-two/>`_ 中找到, 这也是一篇很少的文章).

此sdk还包含 linux/mac 的示例代码. 尝试了 mac 下 xcodeproj, 编译之后可以生成一个 BasicPlugin, 然后把这个 .plugin 文件拷贝到用户目录下的 Internet Plugins 目录,
重启浏览器, 打开示例页面, 照理应该可以载入了, 但我这边一直提示没有正确载入. 鉴于老早就把 C/C++ 语言忘得一干二净了, 所以也不知道该改哪边.

这个 sdk, 不好的地方是, 需要对不同操作系统分别写代码, 分别编译生成. 针对我们开发者来说, 很不方便.

另外, Mozilla 也提供了针对不同操作系统的 `Gecko_SDK <https://developer.mozilla.org/en-US/docs/Gecko_SDK>`_ (和 npapi-sdk 的几个文件是同步的),
不过光看文档, 里面就一大堆的依赖(`真的是一大堆的依赖啊~~~ <https://developer.mozilla.org/en-US/docs/Developer_Guide/Build_Instructions/Mac_OS_X_Prerequisites>`_),
没敢尝试下去.

所以找了另一种方式, 使用 `FireBreath <http://www.firebreath.org/>`_

::

    - 下载完他的sdk, 解压.
    - python fbgen.py                   # 生成新工程模板, 好处在于她把所有操作系统平台下的模板代码都生成好了, 爽, 基本上只要填空就行了.
    - ./prepmac.sh                      # 预编译过程, 在mac下会生成 xcodeproj.
    - 进入 build 目录, 执行 xcodebuild    # 真正编译, 生成 plugin. 搞定且成功载入到页面.

最后总结就是, 要快速开发跨平台跨浏览器插件, 使用 FireBreath 开发遵循 NPAPI 规范的插件.