HPWS 2
===================

:date: 2009-03-13 03:03:03
:tags: Javascript, note

Rule 2: Use a Content Delivery Network

* It's necessary to deploy content across multiple, geographically dispersed servers.

* if the component web servers are closer to the user, the response times of many HTTP requests are impoved.

A content delivery netword(CDN) is a collection of web servers ditributed across multiple locations to deliver content to users more efficiently. eg, CDN may choose the server with the fewest network hops or the server with the quickest response time.

CDN service providers: Akamai,Mirror Image, Limelight, SAVVIS
free CDN services: Globule(http://www.globule.org), CoDeeN(http://codeen.cs.princeton.edu), CoralCDN(http://www.coralcdn.org),

CDN bring other benefits: backups, extended storage capacity, caching,

Drawback: your response times can be affected by traffic from other web sites; the occasional inconvenience of not having direct control of the content servers, eg, modifying the HTTP response headers; If CDN service provider's performance degrades, so does yours. so, like eBay and MySpace each use two CDN service providers,,,

CDNs are used to deliver static content, images, scripts, stylesheets and flash. Serving dynamic HTML pages involves specialized hosting requirment: database connections, state management, authentication, hardware and OS optimizations --- the complexities are beyond what a CDN provides.

测试:

* http://stevesouders.com/hpws/ex-cdn.php -- 17659 ms
* http://stevesouders.com/hpws/ex-nocdn.php -- 40981 ms