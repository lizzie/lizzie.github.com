Target Blank
===================

:date: 2009-07-10 10:07:22
:tags: HTML, Javascript


原先一直以为只有链接 a 才可以使用 target="_blank" , 这也就让链接在另外一个窗口中打开.

现在想实现个预览效果, 想让表单提交并在一个新窗口中显示, 而原来的窗口内容不变. google下, 发现有些直接是window.open(url...), 那这个就是直接打开对应的url. 而现在需要提交表单. 找到可以使用 target="_blank" .就可.

此为其一. 那现在 有一个 提交和预览按钮, 针对同一个form. 提交按钮不需要在新窗口中打开, 而预览则最好打开另一个窗口. 自然而然想到的是, 对提交按钮不需要form的target属性, 而预览需要. 简单js下:

    .. sourcecode:: js

        $j("input#preview").click(function(){

            $j(this).attr("disabled", "true");
            $j("form#frm").attr("target", "_blank");
            $j("form#frm").submit();
            $j(this).removeAttr("disabled");
            $j("form#frm").removeAttr("target");
        });

可这段代码并不能在新窗口中打开, 而直接在当前窗口. 但测试submit前的确form是target为_blank.

后来猜到是否需要有个延迟时间. 于是,

    .. sourcecode:: js

        $j("input#preview").click(function(){

            $j(this).attr("disabled", "true");
            if (!$j("input#prw").length) $j(this).after('<input type="hidden" name="preview" value="1" id="prw" />');

            $j("form#frm").attr("target", "_blank");
            setTimeout(function(){
                $j("form#frm").submit();
                $j(this).removeAttr("disabled");
                $j("form#frm").removeAttr("target");
            }, 1000);
        });

果然可以~~~

后来, 发现光光这样做. 打开IE时会提示弹出窗口的提示.这个不怎么好.

所以换成.

.. sourcecode:: html

    <div class="btn">
        <input type="submit" value="发  布" class="gBtnGreen" id="sbm" onmouseover="this.className='gBtnGreenHover'" onmouseout="this.className='gBtnGreen'" onclick="this.form.target='_parent';" />
        <input type="submit" value="预  览" class="gBtnGray" onmouseover="this.className='gBtnGrayHover'" onmouseout="this.className='gBtnGray'" id="preview" onclick="this.form.target='_blank';" />
    </div>

也就是type为submit，而不是button，然后onclick上设置form的target属性。

对应的js就不需要了。只要设置写不可用属性就可。