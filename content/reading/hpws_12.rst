HPWS 12
===================

:date: 2009-04-07 14:04:45
:tags: Javascript, note


Rule 13: Configure ETags

What's an ETag?
Entity tags(ETags) are a mechanism that web servers and browsers use to validate cached components.

Expires Header
How far is "far" depends on the component in question.
It's most efficient to avoid HTTP requests by setting the expiration date so far in the future that the components are unlikely to expire.

Conditional GET Requests
Last-Modified Date
the browser uses the If-Modified-Since header to pass the last-modified date back to the origin server for comparison. If the last-modified date on the origin server matches that sent by the browser, a 304 response is returned.

ETags provide another way to determine whether the component in the browser's cache matches the one on the origin server. An ETag is a string that uniquely identifies a specific version of a component(or called entity). 这个字符串必须使用引号.

::

    HTTP/1.1 200 OK
    Last-Modified: ...
    ETag: "10c24bc...."
    Content-Length: 1195

ETags were added to provide a more flexible mechanism for validating entities than the last-modified date. If, for example, an entity changes based on the User-Agent or Accept-Language headers, the state of the entity can be reflected in the ETag.
Later, if the browser has to validate a component, it uses the If-None-Match header to pass the ETag back to the origin server. If the ETags match, a 3.4 status code is returned, reducing the response by 1195 bytes.

The problem with ETags
很显然, 这个ETags构造的必须是唯一的标识.另外, ETags won't match when a browser gets the original component from one server and later makes a conditional GET request that goes to a different server--a situation that is all too common on web sites that use a cluster of servers to handle requests. By default, both Apache and IIS embed data in the ETag that drmatically reduces the odds of the validity test succeeding on web sites with multiple servers.

IIS支持ETags格式为Filetimestamp:ChangeNumber

剩下有很多看不懂...xx

Reconfigure or remove ETags.