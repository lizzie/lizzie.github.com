HPWS 4
===================

:date: 2009-03-22 14:03:05
:tags: Javascript, note


Rule 4: Gzip Components

It reduces response times by reducing the size of the HTTP response.

gzip and deflate

It's worthwhile to gzip your scripts and stylesheets, but many web sites miss this opportunity(in fact, it's worthwhile to compress any text response including XML and JSON). Image and PDF files should not be gzipped because they are already compressed.

There is a cost to gzipping: it takes additional CPU cycles on the server to carry out the compression and on the client to decompress the gzipped file. To determine whether the benefits outweigh the costs you would have to consider the size of the response, the bandwidth of the connection, and the Internet distance between the client and the server. This information isn't generally available, and even if it were, there would be too many variables to take into consideration. It's worth gzipping any file greater than 1 or 2K. The mod_gzip_minimum_file_size directive controls the minimum file size you're willing to compress. The default value is 500 bytes.

Gzipping generally reduces the response size by about 70%.

Apache 1.3 users mod_gzip while Apache 2.x uses mod_deflate. 相关配置可见apache文档

Proxy Caching
Vary: Accept-Encoding

Edge Cases 主要讲当浏览器不支持gzip时, 比如说早期的浏览器版本.
The alternative serving compressed content to a browser that can't support it, is far worse. Using mod_gzip in Apache 1.3, a browser whitelist is specified using mod_gzip_item_include with the appropriate User-Agent values:
mod_gzip_item_include reqheader "User-Agent: MSIE [6-9]"
mod_gzip_item_include reqheader "User-Agent: Mozilla/[5-9]"


In Apache 2.x use the BrowserMatch directive:
BrowserMatch ^MSIE [6-9] gzip
BrowserMatch ^Mozilla/[5-9] gzip


Adding proxy caches, like Vary: Accept-Encoding,User-Agent

综合考虑:

* If your site has few users and they're a niche audience, edge case browsers are less of a concern. Compress your content and use Vary: Accept-Encoding. This improves the user experience by reducing the size of components and leveraging proxy caches.
* If you;re watching bandwidth costs closely, do the same as in the previous case: compress your content and use Vary: Accept-Encoding. this reduces the bandwidth costs from your servers and increases the number of requests handled by proxies
* If you have a large, diverse audience, can afford higher bandwidth costs, and have a reputation for high quality, compress your content and use Cache Control: Private. this diables proxies but avoids edge case bugs.

In Action

Nothing Gzipped: http://stevesouders.com/hpws/nogzip.html
HTML Gzipped: http://stevesouders.com/hpws/gzip-html.html
Everything Gzipped: http://stevesouders.com/hpws/gzip-all.html