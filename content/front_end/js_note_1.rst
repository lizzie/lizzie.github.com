JS Note 1
================

:date: 2008-12-01 03:12:11
:tags: Javascript

1) escape()可以将字符串,尤其是url中的特殊字符, 如空格, 问号...转换成对应acsii码的十六进制数.

    .. sourcecode:: js

        escape("?!=()#%&"); // 结果为%3F%21%3D%28%29%23%25%26``

    详细描述在 http://www.w3schools.com/jsref/jsref_escape.asp

2) document.write()使用

    .. sourcecode:: js

        document.write(somehtmltext);

    直接将新的html代码写到页面上.

3) replace()将符合一定模式的字符串替换成目标字符串

    引自: http://zhidao.baidu.com/question/12458171.html
    主要使用:
    语法: stringObj.replace(rgExp, replaceText)

    stringObj 必选项。要执行该替换的 String 对象或文字。该对象不会被 replace 方法修改。
    rgExp 必选项。描述要查找的内容的一个正则表达式对象。
    replaceText 必选项。是一个String 对象或文字，对于stringObj 中每个匹配 rgExp 中的位置都用该对象所包含的文字加以替换。

    .. sourcecode:: js

        function ReplaceDemo()
        {
        var r, re;
        var s = "The quick brown fox jumped over the lazy yellow dog.";
        re = /fox/i;
        r = s.replace(re, "pig");
        return(r);
        }

    另外, replace 方法也可以替换模式中的子表达式。 下面的范例演示了交换字符串中的每一对单词：

    .. sourcecode:: js

        function ReplaceDemo()
        {
        var r, re;
        var s = "The quick brown fox jumped over the lazy yellow dog.";
        re = /(\S+)(\s+)(\S+)/g;
        r = s.replace(re, "$3$2$1"); //交换每一对单词。
        return(r);
        }

    JavaScript中replace() 方法如果直接用str.replace("-","!") 只会替换第一个匹配的字符. str.replace(/\-/g,"!")则可以替换掉全部匹配的字符（g为全局标志）。

4) parseInt() 将字符串转成整型, 其他还有:

    引自: http://www.logang.com/article.asp?id=41
    javascript有两种数据类型的转换方法：一种是将整个值从一种类型转换为另一种数据类型（称作基本数据类型转换），另一种方法是从一个值中提取另一种类型的值，并完成转换工作。

    基本数据类型转换的三种方法：

    1.转换为字符型：String(); 例：String(678)的结果为"678"
    2.转换为数值型：Number(); 例：Number("678")的结果为678
    3.转换为布尔型：Boolean(); 例：Boolean("aaa")的结果为true

    从一个值中提取另一种类型的值的方法：

    1.提取字符串中的整数：parseInt(); 例：parseInt("123zhang")的结果为123
    2.提取字符串中的浮点数：parseFloat(); 例：parseFloat("0.55zhang")的结果为0.55
    3.执行用字符串表示的一段javascript代码：eval(); 例：zhang=eval("1+1")的结果zhang=2


另外还有 http://shiningray.cn/type-cast-in-javascript.html 有点类似的内容.