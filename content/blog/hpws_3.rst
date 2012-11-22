HPWS 4
===================

:date: 2009-03-15 14:03:34
:tags: Javascript, note

Rule 3: Add an Expires Header

A web server uses the Expires header to tell the web client that it can use the current copy of a component until the specified time.

Max-Age and mod_expires
Cache-Control header was introduced in HTTP/1.1 to overcome limitations with the Expires header. Because the Expires header uses a specific date, it has sticter clock synchronization requirments between server and client. Also, the expiration dates have to be constantly checked, and when that future date finally arrives, a new date must be provided in the server's configuration.

Cache-Control uses the max-age directive to specify how long a component is cached. You could specify both response headers, Expires and Cache-Controk max-age. If both are present, the HTTP specification dictates that the max-age directive will override the Expires header.

the mod_expires Apache module lets you use an Expires header that sets the date in a relative fashion similar to max-age. via ExpiresDefault.

.. sourcecode:: xml

    <FilesMatch "\.(gif|jpg|js|css)$">
      ExpiresDafault "access plus 10 years"
    </FileMatch>

## years, months, weeks, days, hours, minutes, seconds


It sends both an Expires header and a Cache-Control max-age header in the response.

Using a far future Expires header affects page views only after a user has already visited your site. It has no effect on the number of HTTP requests when a user visits your site for the first time and the browser's cache is empty. So, the impact of this performance improvement depends on how often users hit your pages with a primed cache. It's likely that a majority of your traffic comes from users with a primed cache. Making your components cacheable improves the response time for these users.

A far future Expries header should be included on any component that changes infrequently, including scripts, stylesheets, and flash components.

Last-Modified header allows us to see when a component was last modified.
The logic behind not caching these components was that the user should request them every time in order to get updates because they changed frequently. However, when we discovered how infrequenntly the files changed in practice, we realized that making them cacheable resulted in a better user experience.

Revving Filenames
"The most effective solution is to change any links to them; that way, completely new representations will be loaded fresh from the origin server." -- 改变url，这里有一个小tricky，如果说对一图片url http://www.something.com/images/aa.gif, 如果想每次都去请求aa.gif，而不是用缓存中的，可以使用http://www.something.com/images/aa.gif?some=arandomint, 动态产生一个随机数，那么每次请求的链接都不同，那么aa.gif不断更新，浏览器中也会不断更新.
At yahoo!, often make this step part of the build process: a version number is embedded in the component's filename and the revved filename is automatically updated in the global mapping.
Embedding the version number not only changes the filename, it also makes it easier to find the exact source code when debugging.

Examples

No Expries: http://stevesouders.com/hpws/expiresoff.php
Far Future Expries: http://stevesouders.com/hpws/expireson.php


Add a far future Expires header to your components.