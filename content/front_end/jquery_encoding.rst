jQuery Encode
======================

:date: 2009-06-05 06:06:28
:tags: Javascript

jQuery中的中文编码问题

在页面中检测用户名可用时, 通过ajax发送数据给后台进行检测. 如果输入的用户名是中文, 后台接受到的中文编码混乱.

举例下面的一段代码:

    .. sourcecode:: js

        $j.ajax({
               url: "/checkusername",
               data: "user="+$j("input#user").val(),
               beforeSend: function(){
                   show_msg("user", "检测中...", 0);
               },
        //...


首先说在ff下, ajax发送过去的数据, 后台显示了请求的url, 如/checkusername?user=%E7%9B%9B%E8%89%B3, 也就是中文自动换成%形式, 当然编码是utf-8, 那在后台获取值时, 默认也是utf-8编码, 所以编码解码都没有任何问题. 同样如果在地址栏里直接输入/checkusername?user=中文, 之后后台也会成为%形式.

而奇怪的IE下, ajax发送过去数据之后, 获得的url为/checkusername?user=中文, 后台接收到的值为u'\ufffd\ufffd', 而真正的中文两字的unicode编码为u'\u4e2d\u6587', 所以检测肯定不正确.
IE发送数据已经设置为utf-8编码, 而url中的中文, IE没有进行转换. 所以需要在js中进行转换.

    .. sourcecode:: js

        $j.ajax({
               url: "/checkusername",
               data: "user="+encodeURIComponent($j("input#user").val()),
               beforeSend: function(){
                   show_msg("user", "检测中...", 0);
               },

也就是使用encodeURIComponent将中文转换.

这个问题终于解决了..小结一下的话. 变态ie总是比较变态. 考虑js兼容还真是麻烦. 所以为了减少麻烦. 尤其是中文编码带来的一系列问题. 建议, 全部使用utf-8编码. 包括html页头声明, 文件存储编码, 程序中的编码方式全部统一成utf-8方式.