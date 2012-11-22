JS Encoding
===================

:date: 2010-07-04 06:07:12
:tags: Javascript


escape, encodeURIComponent, encodeURI
--------------------------------------------------

都是将字符转换成百分比编码, 但各自排除编码的字符不同:

    以上函数对 [0-9A-Za-z] 都不作变换。
    escape() 不变换的字符是 *+-./@_ 。
    encodeURI() 不变换的字符是 !#$'()*+,-./:;=?@_~ 。
    encodeURIComponent() 不变换的字符只有 !'()*-._~ 。

from http://my.opera.com/jlake/blog/2009/02/20/escape-encodeuri-encodeuricomponent

escape() 变换的结果是 %uXXXX，encodeURL() 以及 encodeURIComponent() 的变换结果是 %XX%XX%XX, %uXXXX是非标准Pecent-encoding, 现已没有标准支持.

from http://lifesinger.org/blog/2009/03/escape-encodeuricomponent-cencodeuri/


而标准的Pecent-encoding中, %xx%xx%xx, xx为一个字符在unicode字符集中数字序号二进制按照utf-8编码后得到不等长字节(这里是3个)的十六进制编码.

NCR编码, 口, 21475 同样是unicode编码(十进制) 口(十六进制的), 利用此在html能显示任何一个字符.

base64, 传输层传输任何二进制数据, 包括图片和音频.


* `HTML与javascript中常用编码浅析 <http://ued.koubei.com/?p=537>`_


* `Hex, NCR, Percent encode, Base64解码编码工具 <http://stauren.net/lab>`_


referrer
--------------------------------------------------

document.referrer: The referrer property returns the URL of the document that loaded the current document.

iframe
--------------------------------------------------

http://sxlkk.javaeye.com/blog/558352

* "window.location.href"、"location.href"是本页面跳转
* "parent.location.href"是上一层页面跳转
* "top.location.href"是最外层的页面跳转

举例说明：

如果A,B,C,D都是jsp，D是C的iframe，C是B的iframe，B是A的iframe，如果D中js这样写

    * "window.location.href"、"location.href"：D页面跳转
    * "parent.location.href"：C页面跳转
    * "top.location.href"：A页面跳转

如果D页面中有form的话,

    ::

        <form>: form提交后D页面跳转
        <form target="_blank">: form提交后弹出新页面
        <form target="_parent">: form提交后C页面跳转
        <form target="_top"> : form提交后A页面跳转

关于页面刷新，D 页面中这样写：

    ::

        "parent.location.reload();": C页面刷新 （当然，也可以使用子窗口的 opener 对象来获得父窗口的对象：window.opener.document.location.reload(); ）
        "top.location.reload();": A页面刷新

Test
--------------------------------------------------

test.html

    .. sourcecode:: html

        <p>test.html</p>

        <iframe src="test1.html"></iframe>
        <script>
            console.log(document.referrer); //test.html的referrer. eg: localhost:8083/
        </script>



test1.html

    .. sourcecode:: html

        <p>test1.html</p>

        <script>
            console.log(parent.document.referrer); // 如果test1.html被iframe的话, parent则为父对象, 为父对象的referrer, 否则为parent空
            if (location != parent.location) { // 如果是被iframe的话, 当前location 不等于parent.location
                consle.info(document.referrer);      // 并且, 子对象的document.referrer就为父对象, 即document.referrer==parent.location;
                console.info(location);
                console.info(parent.location);
            } else { // 不是iframe的话, 这两个是相等的
                console.info(location);
                console.info(parent.location);
            }
        </script>

再测试一个.
test1.html再嵌一个test11.html

    .. sourcecode:: html

        <p>test11.html</p>

        <script>
            console.log([document.referrer, parent.document.referrer, top.document.referrer]);
            console.info([location.href, parent.location.href, top.location.href]);
            //  ["http://localhost:8083/test1.html", "http://localhost:8083/test.html", "http://localhost:8083/"]
            //  ["http://localhost:8083/test11.html", "http://localhost:8083/test1.html", "http://localhost:8083/test.html"]
        </script>

结论: document.referrer == parent.location


最后.

    .. sourcecode:: js

        wd = wd.replace(/_0db[\d]/g, '');
        var bids = (wd === "" ? [] : wd.split(',').slice(0, 3)), data = [];

        for (var i = 0; i < bids.length; ++i) {
            data.push(["0", "0", bids[i], "1"].join("\x03")); // 还是没明白为何需要这样??
        }

        return encodeURIComponent(data.join("\x02"));

        // 话说\x03和\x02是干嘛的?