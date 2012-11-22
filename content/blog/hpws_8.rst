HPWS 8
===================

:date: 2009-03-29 13:03:47
:tags: Javascript, note

Rule 9: Reduce DNS Lookups

Factors Affecting DNS Caching

1) TTL, time-to-live. 告诉客户端缓存多长时间.
2) Keep-Alive, the HTTP protocol's feature, Keep-Alive can override both the TTL and the browser's time limit. In other words, as long as the browser and the web server are happily communicating and keeping their TCP connections open, there's no reason for a DNS lookup.

使用ipconfig显示和清空DNS记录

1) ipconfig /displaydns
2) ipconfig /flushdns
不同浏览器的dns缓存时间, keepalive时间也不同,

Reducing DNS Lookups

Reducing the number of unique hostnames has the potential to reduce the amount of parallel downloading that takes place in the page. Avoiding DNS lookups cuts response times, but reducing parallel downloads may increase response tiems.
Using one hostname minimizes the number of possible DNS lookups while maximizing parallel downloads.
Most pages have lots of components, the guideline is to split these components across at least two but no more than four hostnames. This results in a good compromise between reducing DNS lookups and allowing a high degree of parallel downloads.

Keep-Alive, that is reuses an existing connection, thereby improving response times by avoiding TCP/IP overhead. Making sure your servers support Keep-Alive also reduces DNS lookups, especially for Firefox users.

补充最后一句精简的话: Reduce DNS lookups by using Keep-Alive and fewer domains.