div Vertical Middle
========================

:date: 2010-06-22 11:06:13
:tags: Javascript, CSS

有n久没写东西了,,,唉...实在是罪过罪过,,,借口还是有些的, 但最主要还是一个字----懒:P
其他废话不说了, 转入正题. 今天查了下div中内容垂直居中的一些资料, 虽说貌似n久前也找过, 但方法压根没记下来. 这次索性就做个整理.


div内容居中
-----------------------

* http://fyting.javaeye.com/blog/92437
* http://dudo.org/2008/06/236/


单行垂直居中
-----------------------

只需要设置它的实际高度height和所在行的高度line-height相等即可. 具体原因可参见 http://isd.tencent.com/?p=1503 或者 http://www.slideshare.net/maxdesign/line-height

    .. sourcecode:: css

        div {
            height:25px;
            line-height:25px;
            overflow:hidden;
        }

多行文本固定高度
-----------------------

使用table的vertical-align属性, 因为表格可以使用vertical-align属性达到非常好的表格内容垂直居中效果, 所以可以如下设置:

    .. sourcecode:: css

        div#wrap {
            height:400px;
            display:table;
        }
        div#content {
            vertical-align:middle;
            display:table-cell;
        }

给容器设置display为table, 其内容作为表格单元来做.

但IE6不能理解display: table/table-cell, 则需要其他方法:

    .. sourcecode:: html

        <div id="wrap">
         <div id="subwrap">
             <div id="content">
            </div>
        </div>
        </div>


        div#wrap {
            height:400px;
            position:relative;
        }
        div#subwrap {
            position:absolute;
            top:50%;
        }
        div#content {
            position:relative;
            top:-50%;
        }

原因如下:

    如果我们对subwrap进行了绝对定位，那么content也会继承了这个这个属性，虽然它不会在页面中马上显示出来，但是如果再对content进行相对定位的时候，你使用的100%分比将不再是content原有的高度。例如，我们设定了subwrap的position为40%，我们如果想使content的上边缘和wrap重合的话就必须设置top:-80%;那么，如果我们设定subwrap的top:50%的话，我们必须使用100%才能使content回到原来的位置上去，但是如果我们把content也设置50%呢？那么它就正好垂直居中了。所以我们可以使用这中方法来实现Internet Explorer 6中的垂直居中：

不同浏览器合并起来解决方案

    .. sourcecode:: css

        div#wrap {
            display:table;
            border:1px solid #FF0099;
            background-color:#FFCCFF;
            width:760px;
            height:400px;
            _position:relative;
            overflow:hidden;
        }
        div#subwrap {
            vertical-align:middle;
            display:table-cell;
            _position:absolute;
            _top:50%;
        }
        div#content {
            _position:relative;
            _top:-50%;
        }

这些方法中, 容器div的高度必须得设定.


其他的方法
-----------------------

也是类似使用table的vertical-align

    .. sourcecode:: html

        <div class="con_div">
            <span class="fixie"></span>
            aaa
        </div>

    .. sourcecode:: css

        .con_div{
            width:400px;
            height:300px;
            border:1px solid #777;
            text-align:center;
            display:table-cell;
            vertical-align:middle;
            background:red;
            color:#fff;
        }
        /*FOR IE*/
        .fixie{
            width:0;
            height:100%;
            display:inline-block;
            vertical-align:middle;
        }

其他的点儿
-----------------------

* chrome也会检查js中的注释规范, 注释中不能出现符号/ , 刚才误用了, 导致一直报奇怪的语法错误,,,奇怪了很久, 后来还亏yubo帮忙找出来.
* 上面给出的关于line-height的有个ppt, 强烈建议多看几遍. 嗯嗯. 记住: 字体大小尽可能使用不带单位的数字, 不要使用%和px, 原因见ppt.
* document.referrer保存了来源网页的url, 且当当前页面刷新之后, 这个值仍会保留下来.
* 早前就知道css各个属性的书写顺序有猫腻, 不同的顺序导致repaint/reflow可能不一样, 所以我之前就偷懒自己写完之后, 放在firebug中, 拷贝她的出现次序...今天才知道, 原来他的顺序是按照属性字母排序,,不是按照什么什么规范来的,,,诺达一滴汗呀....
* css的字体设置, 第一不要出现中文, 而使用它的unicode字符. 如: font: 12px/1.5 tahoma, arial, \5b8b\4f53, sans-serif; 具体关于字体的知识, 可见 http://lifesinger.org/blog/2009/08/font-family-in-css/ 及相关文章.
* css中属性, 能合并就尽量合并, 尽可能采用缩写形式.
* style和script可以省略type属性.
* 最后,,,想想一个大头, 就是使用border画小图....这个能说很多,,稍后再整理吧(ps: 这也是小组里第一次做分享,,,刚开始以为没啥讲头的, 后来经师兄指点,,哇, 内容不少呢)


以上这些都是在做我的第一个简单页面中学到的, 任务虽然相对简单, 但还是能学到很多东西, 尤其是, 是之前学生时期从未考虑过的方面, 比如说, 尽量能简写, 减少字节, 尽量不用图片(气泡效果, 后来用css实现后完全节省了两张图片), 优雅降级, 书写规范主要是能方便其他人阅读你的代码.

咔咔咔, 虽然看着很简单的页面, 但还是小show下完成的第一个tb页面, 娃哈哈, http://www.taobao.com/503.html