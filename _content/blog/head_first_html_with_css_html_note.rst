Head First HTML with CSS & XHTML零散笔记
=========================================================

:date: 2009-11-04 23:11:10
:tags: HTML, CSS, note


标签 <q></q> 用于引用文字, inline element, 适用于短小文本的引用;
标签 <blockquote></blockquote> 块引用, block element.


典型的inline元素: <q> <a> <em> <img>(这个有点特别,但确是行内元素)
block元素: h1, h2, ..., h6, p, blockquote, 块元素和行内元素的主要区别, 块元素之前之后都换行. Each block element is displayed on its own, as if it has a linebreak before and after it. Block elements separate content into blocks.
Remember: block elements stand on their own; inline elements go with the flow.

<br> <img>: empty element, 不包含任何内容; <br> does create a linebreak, but isn't typically displayed with space above and blow it like block elments are.

<ol>: orderlist; <ul>: unorderedlist; <li>: list item
<dl>: definition lists; <dt>: definition term; <dd>: description.

特殊字符 & 由&amp;表示

"No matter where you go, there you are."

<code>
<address>
<strong>: to mark up text you want emphasized with extra strength. make a big point
<em>: use this element to mark up text you want emphasized. emphasizing.
<hr>: horizontal rules, like to start a new section without a heading.
<a id="chai"> some tee </a> <-- anchors, index#chai

images: JPEG和GIF
JPEG, for photos and complex graphics; 16万种颜色, 不支持透明, 有损压缩;
GIF, for images solid colors, logos and geometric shapes. 256种颜色, 无损压缩, 支持透明.
PNG, support both JPEG and GIF styles of image, width, height.
<img> is an inline element.


文档类型定义

HTML4.01的 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  还有strict.dtd
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"> 作为head的第一个子元素, 告诉浏览器此文档的content type, what kinds of characters are used to encode it.
meta元素都是告诉浏览器一些信息的, 这个meta是说, 该文档类型为text/html, 字符集是ISO-8859-1.

XHTML 1.0的<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
XHTML中每个元素都以/>结尾. html元素需要包含xmlns, lang, xml:lang属性.

<link type="text/css" rel="stylesheet" href="lounge.css" />  rel表示relationship between XHTML and the thing you're linking to.


serif(衬体): 印刷, 像这种字体, 有明显边角
sans-serif(无衬体): 屏幕, 边角圆滑,


/* comments in css */

"conflict" in css properity: If one rule is more specific than others, then it wins. If you can't reolve a conflict because two selectors are equally specific, you use the ordering of rules in your style sheet file. 如果对于class来说, order指在css中定义的class的顺序, 而不是元素中声明class值的顺序.
css validator: http://jigsaw.w3.org/css-validater/


关于字体的

font-family(顺序是先详细字体名, 后字体族), font-size, font-weight(lighter, normal, bold, bolder)
color关键词: Aqua, FuchSia, Lime, Olive, Red, Black, Gray, Maroon, Orange, Silver, Blue, Green, Navy, Purple, Teal,,,,
text-decoration(none, underline, overline, line-through, blink), 最后一个很少用.
font-family五种字体族

1) sans-serif: Verdana Arial, 可读性更好
2) serif: Time New Roman, 报纸上常用的字体
3) monospace: Curier Mono, 等宽字体, 常作代码
4) cursive: Comic Sans, 手写体
5) fantasy: Last MINIA, 装饰体,   4和5字体很多.


body {
    font-family: Verdana, Geneva, Arial, sans-serif;
}

逗号分隔, 字体名区分大小写, 字体名若有空格的话,可以使用"xx xx" serif, sans-serif是字体族, 都有默认的哪种字体.
上面的body字体设置为: 大多数PC使用Verdana, Mac上Geneva, 都没有使用Arial(多种系统上都是常见的字体). 字体声明时最好是包括多种os平台上支持的字体.


font-size: 14px; 14像素表示字体的字符最高到最低共有14px. p确切告诉显示多大, 以像素单位. x%表相对大小, 为父元素*x的大小. em为相对大小, Scaling factor).
h2 {
    font-size: 1.2em; /* 父元素的1.2倍 */
}

大小关键词: xx-small, x-small, small, medium, large, x-large, xx-large. 一般是20%的间隔大小, 12px的高度. 关键字定义大小对于每种浏览器的大小定义都是不同的.


如何选择?
1) 选择keyword(small or medium)指定为body的font-size;
2) 使用em/percentages 对于其他子元素. "慎用绝对, 妙用相对大小"
默认的body的font-size为16px 情况下, h1=200%*body, h2=150%*body, h3=120%*body, h4:100%, h5:90%, h6:60%
body设置为90%的话,表示body的默认大小的90%, 即16*90% = 14


font-style: italic,不是所有字体都支持斜体, 则可用oblique, 虽然也是斜体, 但两者有区别.
颜色名不区分大小写. rgb(80%, 40%, 0%) == rgb(204, 102, 0) == #CC6600 == #C60   80%*255 = 204
text-decoration: underline overline; /* 既有上线又有下线 */ 多值以空格分隔.


标签<del>表示删除的文本
标签<ins>表示插入的文本
Blink装饰, is a holdover from an old Netscape style.


background-position, sets the position of the image and can be specified in pixels or as a percentage, or by using keywords like top, left, right, bottom, and center.
background-repeat: no-repeat, repeat-x, repeat-y, inhreit(看父元素)
border-style: solid, double, groove, outset, dotted, dashed, inset, ridge.

style sheets的顺序是有关的, 从上到下, 下的优先.

<link type="text/css" rel="stylesheet" href="xxx.css" media="screen" /> media指定设备类型, 不指定media表示对所有设备. screen表示屏幕, print表示打印机, handheld表示小型设备. 之间顺序还是从上到下的优先级从小到大. 注意, 不是所有浏览器都支持media属性的

css盒模型控制元素的显示.


<p>中不能包含块元素.

Use, don't abuse, <div>s in your pages. Add additional structure where it helps you separate a page into logical sections for clarity and styling. Adding <div>s just for the sake of creating a lot of structure in your pages in complicates them with no real benifit.
<div> 只是结构.
text-align will align all inline content(for inline element) in a block element. this property should be set on block elements only.

#elixirs > h2: css中选择元素的直接后继使用">", 空格表示所有后继.


多个property合起来写
background: white url(image/cocktail.gif) repeat-x;
font: font-style font-variant font-weight font-size/line-height font-family;

<span> give you a way to logically separate inline content in the same way with divs allow you to create logical separation for block level content. just change the style of certain words.

对于inline元素的margin和padding, 和块元素表现有所不同. if you add a margin on all sided of an inline element, you'll only see space added to the left and right. you can add padding to the top and bottom of an inline element but the padding doesn't affact the spacing of the other inline elements around it, so the padding will overlap other inline elements. 但image和其他inline元素有所不同, 更像块元素.

伪类 a:link(未访问时) a:visited(访问之后) a:hover(鼠标移上去时) a:focus a:action(这两个已不被支持)

!important...

flow, 对于块元素, put a linebreak between each one. 从上到下依次显示, 每个元素间linebreak, 而inline元素, 水平上, 从左到右排列, 只要有空间就排列, inline在block元素内排列.


inline的margin的间距就是设置的space. 但对于block元素来说, 上下边距会合并起来, 去两者的大者. 嵌套元素的边距也可能被合并起来.
whenever you have two veritical margins touching, they will collapse, even if one element is nested inside the other.
Notice that if the outer element has a border, the margins will never touch, so they won't collapse. But if you remove the border, they will.


float, 从当前flow中删除该float元素, 其余块元素继续被填入, 但对于行内元素的边界为float元素所在之处. they flow around the borders of the floating element.


clear 元素, 用于清除当前flow, 如clear: right; 在该元素的左部不允许有floating的内容.
float只能是right和left, 没有center.
float元素边距不会重叠.
inline元素也可设置float, 常见的是img设置float.


liquid vs frozen
前者可缩放, 后者固定大小, 锁定.


"righty tighty, lefty loosey."

position为absolute时, top right, bootom left, 也从当前flow中移除, 独立开来; 有继承性, 其子元素看最近父元素的设置.
position默认为static, 即由flow来决定.
position为fixed时, is relative to the browser window rather than page, so fixed elements never move. 固定, IE6不支持fixed.
position为relative时, take an elemnet and flows it on the page just like normal, but then offsets it before displaying it on the page. 仍然是flow中.

position数值最好用%表示, 不要用px.

<table summary="xxx">
     <caption>XXX</caption> 相当于表格的标题
...

border-spacing 边与边之间的距离
border-collapse: collapse
caption-side: bottom, 表格标题位置
td的rowspan="2"表示合并2行, 上一行设置rowspan, 下一行空出, 不需要
text-align, vertical-align, 设置表格中文字对齐方式.
colspan: 合并列

<tr>
    <th></th>
    <td></td>
</tr> <th>即可在每行中设置, 也可独立到某一行中.


list样式
list-style-type: disc(默认, 实心圆); circle(空心圆); square(实心方块); none(不显示)
list-style-image: url(images/back.gif);

order list样式
list-style-type: decimal(数字); upper-alpha; lower-alpha; upper-roman; lower-roman
list-style-position: inside(text wrap under the marker); outside(wrap under the text above it)


checkbox等多值标签可以命名为含[]的字符串形式.


GET请求限制为256个字符; POST没有限制.
form中标签

<fieldset>
    <legend>xxx</legend>
    <input />
</fieldset>


<label for="hot">hot</label>  for后面是别的元素id
multiple="multiple" --> select的多选


1) 伪类 pseudo-classes, pseudo-elements,,,:first-letter, :first-line
2) 属性选择器,,,img[width], img[height="200"], img[alt~="flowers"] alt中包含flowers的
3) h1+p, "+"表示h1的兄弟p
4) frames, 切分网页

<frameset rows="30%, *, 20%">
    <frame name="header" src="header.html" />
    <frame name="content" src="content.html" />
    <frame name="footer" src="footer.html" />
</frameset>
<a href="newpage.html" target="content">new content</a> 链接到content这个frame上
iframe: inline frame element. 允许你在一个网页中任意安放一个frame
<iframe name="inlinecontent" src="newcontent.html" width="400" height="200" />


使用frames需要设置特殊的DOCTYPE
HTML4.01 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
XHTML1.0 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xthml1/DTD/xhtml1-frameset.dtd">


5) <object> <embed> 多媒体标签
6) Emacs
7) js/client-side scripting
8) server-side scripting
9) meta的name和content
<meta name="description" content="一些描述" />
<meta name="keywords" content="关键词定义" />
<meta name="robots" content="noindex,nofollow" /> 告诉搜索引擎忽略此页


看完, 总结下来, 这书比较基础, 简单易懂, 但对于布局那边还不是很明白, 有空再好好看看.