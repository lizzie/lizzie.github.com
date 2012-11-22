threeCSSProperty
===================

:date: 2010-07-21 12:07:50
:tags: CSS

white-space
----------------------

https://developer.mozilla.org/en/CSS/white-space

用于控制容器内的空格如何处理.
针对所有元素, 可继承.

值:

* normal(默认值): 空格序列被合并起来, 换行字符如同空格, 会断行(长单词内不会断行)以尽可能的填充整个盒子
* pre: 空格序列被保留, 一行只有碰到换行字符才换行, 文本内部不会换行(but suppresses line breaks (text wrapping) within text).
* nowrap: 空格被合并, 但文本内部不会被强行换行. 如果溢出容器也不会被换行.
* pre-wrap: firefox3+ 空格序列被保留, 一行只有碰到换行字符才换行, 也是尽可能填充行盒子, firefox2可以用-moz-pre-wrap.
* pre-line: firefox3.5+ 空格序列被合并. 碰到换行字符才换行, 尽可能填充行盒子.

word-wrap
----------------------

https://developer.mozilla.org/en/CSS/word-wrap

是否允许字内断行, 阻止文本太长而导致溢出(specify whether or not the browser is allowed to break lines within words in order to prevent overflow when an otherwise unbreakable string is too long to fit.)

* normal(默认值): 断行仅在正常词语结束后, 完整的一个词不会被强行截断;
* break-word: 词语可能会在任意点上被截断.

white-space: nowrap 针对一行文本, 如果超出容器, 不要自动换行,,就是除非你手写换行字符是绝对不会换行的;

word-wrap: break-word; 针对一行中的一个词, 本来这个词是不可断的, 但设置之后会强行截断.


text-overflow
----------------------

当文本内容溢出容器时, 是否显示...号. (杯具的firefox不支持)

ellipse: 显示省略号
clip: 默认值, 不显示

例子: http://www.quirksmode.org/css/textoverflow.html

    .. sourcecode:: css

        p {
            white-space: nowrap;
            width: 100%;                   /* IE6 needs any width */
            overflow: hidden;              /* "overflow" value must be different from "visible" */

            -o-text-overflow: ellipsis;    /* Opera */
            text-overflow:    ellipsis;    /* IE, Safari (WebKit) */

        }

三个地方, 设置white-space, 设置width, 设置overflow, 最后的text-overflow.