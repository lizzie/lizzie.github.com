HPWS 9
===================

:date: 2009-03-31 14:03:11
:tags: Javascript, note

Rule 10: Minify JavaScript

Minification is the practice of removing unnecessary characters from code to reduce its size, thereby improving load times. all comments, whitespace, rename the variables.

Obfuscation

对js文件进行約简之后, 首先不易读, 维护困难, 出现Bugs的可能性增大, Debugging也困难.

The Savings

JSMin: http://crockford.com/javascript/jsmin 最流行js压缩工具. 这个将js源代码空格, 换行都去除了.

Dojo compressor: http://dojotoolkit.org/docs/shrinksafe 另一个比较好的. 这个变量名重新替换, 但保留了换行符, 所以看起来比较好. 这个压缩比例比jsmin高一点.

Inlne Javascipt blocks should also be minified, though this practice is less evident on today's websites. 现在很多网站大多没有将嵌入式的js进行压缩.

Gzip and Minification

可以将js文件的物理压缩和js源代码的压缩结合起来. Gzip compression has the biggest impact, but minification further reduced file sizes, as the use and size of JavaScript increase, so will the savings gained by minifying your JavaScript code.

Minifying CSS

The savings from minifying CSS are typically less than the savings from minifying JavaScript because CSS generally has fewer comments and less whitespace than JavaScript. The greatest potential for size savings comes from optimizing CSS---merging identical classes, removing unused classes. But this is a complex problem, given the order-dependent nature of CSS (that is cascading). 最好的方法目前为止是, 移除注释, 空白, 使用缩写和移除不必要的字符串.

Minify your JavaScript source code.