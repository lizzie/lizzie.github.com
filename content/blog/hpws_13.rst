HPWS 13
===================

:date: 2009-04-11 14:04:32
:tags: Javascript, note

Rule 14: Make Ajax Cacheable

首先讲了下Web 2.0, DHTML和Ajax三者的关系. 大体为Web 2.0是网页更具有丰富的, 用户界面友好的功能, 集成多种服务, 使得网页越来越像具有友好输入输出的应用. DHTML和Ajax是实现Web2.0中关键概念的技术. DHTML允许页面被加载之后改变现实, 即使用了JavaScript和CSS, 利用DOM交互. Ajax是在没有重新加载页面时显示新请求过来的数据.

Ajax inserts a layer between the UI and web server. This Ajax layer resides on the client, interacting with the web server to get requested information, and interfacing with the presentation layer to update only the components necessary. It transforms the Web experience from "viewing pages" to "interacting with an application." IFrames, 也允许异步加载页面内容.

作者推荐使用YUI作为Ajax开发工具 http://developer.yahoo.com/yui/connection

Passive requests, might be used to download sth before it's actually needed. 也就如基于web的邮件客户端, 可能事先把相关东西, 如通讯录, 加载进来.

而Active requests, 就是指用户当前的主动请求. 这个请求过程中, 用户还有需要等待.

Optimizing Ajax Requests

最重要的提高主动Ajax请求速度的方法就是make the responses cacheable. 还有其他的几条, 如, Rule 4, Gzip Components, Rule 9 Reduce DNS lookups, Rule 10, Minify JavaScript, Rule 11, Avoid Redirects, Rule 13: ETags--Use 'Em' or Lose 'Em'

Caching Ajax in the Real World

在浏览器中缓存一些动态数据, 为什么呢? 拿邮箱来说, 当用户异步请求某个邮件内容, 还是需要等待一段时间才能看到, 那如果现在这个用户离开当前页面访问其他网站, 然后又回到刚才的邮件页面, 还是得重新开始下载相关邮件内容, 因为这些Ajax response没有被保存到用户浏览器中. 如果在这些请求头中包含一个far future Expires header(chapter 3), 那么有很大可能用户回到邮件页面时可以直接读取数据了.

怎么样? 除了改变HTTP headers之外, 还有考虑, the personalized and dynamic nature of the response has to be reflected in what's cached. The best way to do this is with query string parameters. 如

/ws/mail/v1/formrpc?m=GetMessage&yid=steve_sounders&msgid=001234

其中一些内容不断变化的参数就不要使用了, 而可以使用唯一性的如信息id等, 但是由于data privacy原因, 对相应数据不进行缓存也是必要的, 因为不要依靠它来保证数据隐私. 所以一种更好的方法处理数据隐私是, 使用a secure communications protocol such as Secure Sockets Layer(SSL). SSL responses are cacheable (only for the current browser session in Firefox), so it provides a compromise: data privacy is ensured while cached responses improve performance during the current session.

举了一个google doc的例子, 如果要将某个doc缓存下来, 那么, 就要考虑, 当用户修改doc内容时怎样告诉浏览器缓存中的doc已经过期了, 一个简单的解决方式就是用query string. The Google Spreadsheets backend could save a timestamp representing when the last modifications were made. and embed this in the query string of the Ajax requests.

这让我想到最近google doc上的同步问题, 因为使用了google gears, 网络不好时会出现离线编辑状态, 而当我新建几个文档时, 并成功保存了, doc主页上也显示了这些新文档, 但下次打开时, 发现这些新文档全部消失, 似乎是google gears的问题, 因为在linux下没有使用google gears下, 也就是不是离线版的google doc下, 从没有出现过这个奇怪问题. 所以非常想知道google gears的缓存目录是在哪个位置.
一些关于google gears 的资料:

1) gears介绍 http://blog.csdn.net/yarshray/archive/2009/02/05/3863629.aspx
2) gears官方文档及API参考 http://code.google.com/intl/zh-CN/apis/gears/

oy, 找到本地数据库所在位置 http://code.google.com/intl/zh-CN/apis/gears/api_localserver.html#filesystem_location, 在本机上的C:\Documents and Settings\shengyan\Local Settings\Application Data\Mozilla\Firefox\Profiles\o1ygde2v.default\Google Gears for Firefox\docs.google.com\https_443 大概占四十几兆, 而gmail的高达几百兆(同步这么多的数据速度比dropbox快多了) , 目录中包含多个文件, 其中本地数据库说是一个sqlite, 不知道内部表结构是怎样的, 如果知道的话,不久可以自己编程读取了...

Make sure your Ajax requests follow the performance guidelines, especially having a far future Expires header.

今天终于把这书上的Rule1~14看完了, 没想到薄薄的一本书东西还不少, 只能说是了解了大概, 好多没有在实际中使用. 总之, 看了下, 图个印象吧...