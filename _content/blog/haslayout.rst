HasLayout
===================

:date: 2010-07-23 07:07:48
:tags: CSS


what Layout?
-----------------------------

“Layout” is an IE/Win proprietary concept that determines how elements draw and bound their content, interact with and relate to other elements, and react on and transmit application/user events.

why Layout?
-----------------------------

A lot of Internet Explorer's rendering inconsistencies can be fixed by giving an element “layout.”
Consequences of an element having, or not having “layout” can include:

    - Many common IE float bugs.
    - Boxes themselves treating basic properties differently.
    - Margin collapsing between a container and its descendants.
    - Various problems with the construction of lists.
    - Differences in the positioning of background images.
    - Differences between browsers when using scripting.

which element
-----------------------------

body, html, table, tr, td, th, img, hr, input, button, file, select, textarea, fieldset, marquee, frameset, frame, iframe, objects, applets, embed

Those other properties are:

* display: inline-block ##Sometimes a cure when the element is at inline level and needs layout.
* height: (any value except auto)
* float: (left or right)
* position: absolute
* width: (any value except auto)
* writing-mode: tb-rl
* zoom: (any value except normal) ## always triggers hasLayout.

另外IE7

* min-height: (any value)
* max-height: (any value except none)
* min-width: (any value)
* max-width: (any value except none)
* overflow: (any value except visible)
* overflow-x: (any value except visible)
* overflow-y: (any value except visible)5
* position: fixed

    .. sourcecode:: js

        alert(eid.currentStyle.hasLayout)


Notes
-----------------------------

- It's not a good idea to give all elements a layout.
- the standard approach for triggering an element to gain a layout in IE6, set height to 1% as long as the overflow property is not set to anything except visible. overflow设置为默认的visible, 容器高度会尽可能的撑开(不管设置的高度是多少), 其他浏览器会遵循height为1%, 所以这种方式只针对IE6.



IE下条件注释
-----------------------------

* http://reference.sitepoint.com/css/conditionalcomments

    ::

        <!--[if IE ]>
        ...
        <![endif]-->

        if语句支持 lt, lte, gt, gte, !, &, (), |, true, false

        <!--[if !IE]>-->
        <p>...</p>
        <!--<![endif]-->


* http://reference.sitepoint.com/css/haslayout
* http://www.satzansatz.de/cssd/onhavinglayout.html 这里末尾有很多有关layout引起的问题例子.
