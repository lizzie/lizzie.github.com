Test Swarm
===================

:date: 2010-10-17 11:10:56
:tags: Tools, Javascript


TestSwarm http://github.com/jeresig/testswarm/wiki

上次调研 TestSwarm 时, 他官网上给了个使用教程, 后来稍加翻译了下,, 有兴趣玩玩.


简介
------------

TestSwarm 提供了 JavaScript 的分布式/持续集成测试功能. 它由 `John Resig <http://ejohn.org/>`_ 创建, 当初作为 jQuery 的支持工具, 现已成为 Mozilla Labs 项目之一.

注意: TestSwarm 现在还处于 Aplha 状态. 主要存在问题: 1) 测试结果丢失数据, 2) 客户端连接断开, 3) 其他非预期的影响因素. 请在使用过程中记住这些问题的存在.

TestSwarm 的初衷是要解决如下文章中提出的问题:

* `JavaScript Testing Does Not Scale <http://ejohn.org/blog/javascript-testing-does-not-scale/>`_
* `the following recorded presentation <http://ejohn.org/blog/jsconf-talk-games-performance-testswarm/>`_

TestSwarm 主要的目标是为了简化原本多浏览器中执行很复杂的, 又耗时的 JavaScript test suites 测试过程. TestSwarm 的大致过程可在 `这个视频 <http://www.vimeo.com/6281121>`_ 中了解到.


TestSwarm 的最终结果是类似如下的页面:

.. image:: http://farm4.static.flickr.com/3500/3723002475_d628e85afb.jpg

他显示了每次源代码提交(垂直方向上)后, 在不同浏览器(水平方向上)中的运行情况. 绿色表示100%通过, 红色表示至少有一个TC失败, 黑色表示包含了非常严重的错误, 灰色表示还没有进行测试.


架构
-----------

.. image:: http://ejohn.org/files/ts-swarm.png

* 中心服务器, 客户端连接到这里, 并且任务也会被提交到这里(后端使用PHP/MySQL).
* 客户端是被加载到浏览器中的 TestSwarm Test runner 实例. 一个用户(如 'john')可以运行多个客户端, 不同浏览器上或是同一浏览器上的不同标签页.
* Test runner 非常简单 - JS 实现. 它每30秒钟 ping 服务器, 查询是否有新的 test suite 需要执行, 如果有, 则执行它(在一个iframe中)并且把结果发送给服务器; 如果没有, 则睡眠/等待.
* 一个任务(Job)包含两样东西: test suites 和 browsers. 当一个项目提交一个任务, 指明需要执行哪个 test suites 和需要在哪些浏览器中执行;
* 最后, 产生一批 'runs' (一个 run 表示在特定浏览器上执行特定的 test suite 过程). 一个 run 至少执行一次.

其实, 可以把服务器看成是一个巨大的队列. 任务被添加, 然后被推送到队列中, 客户端不断去取这些新来的任务并执行, 客户端执行之后, 收集这些返回的结果.

结果正确性
----------------------
TestSwarm 的一个重要方面是它能主动纠正客户端不正确的结果. 浏览器不靠谱(不一致的结果, 浏览器bugs, 网络问题等), TestSwarm 做了一些尝试来尽可能生成靠谱的结果:

* 如果客户端失去网络连接, 或者停止响应时, 自动被 swarm 清除;
* 如果客户端不能与服务端通信, 它会重复尝试连接(甚至重载页面);
* 客户端有一个全局的超时检测, 检查 test suites 是否不可通信;
* 客户端可以检查自己的测试时间, 允许只发送部分结果给服务端;
* 客户端提交的不正确的结果(错误, 失败, 超时等)自动会在一个新客户端中重新执行, 以尽可能通过测试(重复执行次数由提交任务时设定)


设置你自己的Swarm
----------------------

* `下载源码 <http://github.com/jeresig/testswarm/tree/master>`_ . TestSwarm 依赖 PHP 和 MySQL, 确保 Apache 的 rewrite rules 可用. 通过编辑数据库的 useragents 表来配置浏览器列表.
* 设置自动发送任务脚本, 'scripts' 目录下有样例脚本. 与 svn/git 一起, 也可作为 crob 任务.
* 也可通过Web接口提交, 立即可用.
* TestSwarm 支持如下的测试框架: QUnit(JQuery), UnitTestJS(Prototype), JSSpec(MooTools), JSUnit, Selenium, 和 Dojo Objective Harness.
* 示例脚本中有一点很重要, 就是你需要在 suite 中增加一个 script 元素, 其指向服务器上的 /js/inject.js -- 这个注入脚本用于允许 test suites 捕获并与 TestSwarm 通信.
* 增加你自己的 test suite, 可以通过一个 HTML 序列化钩子, 重载 window.TestSwarm.serialize. 另外, 一个 test suites 完成后, 你需要调用 window.TestSwarm.submit , 加上 所有失败数, 错误数, 运行次数. 也可在每次测试完成后调用 window.TestSwarm.heartbeat() 来提供更好的测试超时时间.
* 提交任务需要 AUTH 标记. 在数据库中的 users 表中查询获得 --- 是在生成用户时自动生成的.
* 开始推送 test suites 到 swarm, 允许客户端连接并执行测试.


TestSwarm区别于
----------------------

`Selenium <http://seleniumhq.org/>`_ 功能比较全面. 包含 test suite, test driver, 自动启动浏览器, 多台机器上的分布式测试(使用他们的网格功能). 与 TestSwarm 的不同在于:

* TestSwarm 是不可知的 test suite. 不为特定 test runner 设计, 而是支持一般性 JavaScript test suite.
* TestSwarm 更分散. 任务可被提交到 TestSwarm时不需要客户端连接 -- 只会在最终连接上的客户端上执行一次.
* TestSwarm 自动纠正一些误导的结果.
* TestSwarm 从源码控制到浏览器, 保持连续的体验?
* TestSwarm 不需要任何浏览器插件/扩展 , 不需要在客户端安装任何软件.

JSTestDriver and Other Browser Launchers
--------------------------------------------
有很多浏览器启动工具( watir ), 但他们都有同样的如上的问题 -- 缺乏高级特征, 如连续集成.

Server-Side Test Running
--------------------------------------------
另外一种替代方式是在仿浏览器(或模拟的浏览器环境, 如 Rhino )中执行测试. 他们存在的严重问题: 不是在真实的浏览器中执行, 结果就不可保证.