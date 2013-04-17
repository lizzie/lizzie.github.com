HPWS 10
===================

:date: 2009-04-04 12:04:58
:tags: Javascript, note


Rule 11: Avoid Redirects

Types of Redirects

响应的状态码以3开头, 以3开头的表示需要进一步的处理.

    1) 300: Multiple Choices(based on Content-Type)
    2) 301: Moved Permanently
    3) 302: Moved Temporarily
    4) 303: See Other(clarification of 302)
    5) 304: Not Modified .. It is not really a redirect -- it's used in response to conditional GET requests to avoid downloading data that is already cached by the browser.
    6) 305: Use Proxy
    7) 306: (no longer used)
    8) 307: Temporary Redirect (clarification of 302)

The 301 and 302 status codes are the ones used most often. Status codes 303 and 307 were added in the HTTP/1.1 specification to clarigy the (mis)use of 302, but the adoption of 303 and 307 is almost nonexistent, as most web sites continue to use 302.

在HTTP头中包含一个Location值代表要转到的目标url. 而response对象的body一般为空.

另外一种自动跳转的方法是, 使用meta的refresh, 如

.. sourcecode:: html

    <meta http-equiv="refresh" content="0; url=http://stevesounders.com/newuri">

JavaScript也可以跳转页面, 通过设置document.location.

Alternatives to Redirects

    1) a trailing slash(/) is missing from a URL that should otherwise have one. autoindexing使得当请求的url不存在时去寻找些默认的页面. 注意如果主机名后来没加/是不会redirect.
    2) use the mod_rewrite,

Alias /astrology /usr/local/apache/htdocs/astrology/index.html

.. sourcecode:: html

    <Location /astrology>
        DirectorySlash Off
        SetHandler astrologyhandler
    </Location>

Connecting Web Sites

    1) Alias, mod_rewrite, and DirectorySlash require committing to an interface (handlers or filenames) in addition to URLs, but are simple to implement.
    2) If the rwo backends reside on the same server, it's likely that code itself could be linked. For example, the older handler code could call the new handler code programmatically.
    3) If the domain name changes, a CNAME (a DNS record that creates an alias pointing from one domain name to another) can be used to make both hostnames point to the same servers. If this is possible, the techniques mentioned here(Alias, mod_rewrite, DirectorySlash, and directly linking code) are viable.

The key is to find a way to have these simpler URLs without the redirects. Rather than forcing users to undergo an additional HTTP request, it would be better to avoid the redirect using Alias, mod_rewrite, DirectorySlash, and directly linking code.

Find ways to avoid redirects.