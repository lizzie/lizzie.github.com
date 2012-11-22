JS Base
===================

:date: 2009-02-20 12:02:26
:tags: Javascript, note

之前一直直接学的Jquery库, 而最基本的Javascript语法似乎都没真正学过, 现在觉得基础还是很重要的. 于是乎在网上找了些js基本语法, 整理下.

参考自:

* http://blog.csdn.net/dxmdxs/archive/2005/08/12/452780.aspx
* http://www.9java.com/article/study/299.htm这有小例子和基本语法.

1) 变量声明: var name=0;
2) function(args){...}, return
3) if(...){...}else{...}

.. sourcecode:: js
    
    switch(expression){
        case lable1:
        ...
        case lable2:
        ...
        default:
        ...
    }

4) for (init; condition; update){ ... }

.. sourcecode:: js
    
    do{ ... }while(condition)

    break, continue

5) 表达式和运算符: ＋, -, *, /, %, --, --, &&, ||, !, <, >, <=, >=, ==, !=, (10>8)?"big":"small"

6) js事件

    * onClick=alert("hi")
    * onChange
    * onSelect
    * onFocus
    * onLoad
    * onUnload
    * onBlur: 当光标离开文本框中时发生的事件
    * onMouseover
    * onMouseout
    * onDbclick
    * onAbort: 当页面上图像没完全下载时,访问者单击浏览器上停止按钮的事件
    * onAfterUpdate: 数据元素完成更新的事件
    * onBeforeUpdate: 元素被改变且失去焦点
    * onBounce: 移动的Marquee(?)文字到达移动区域边界
    * onError: 页面或页面图像下载出错
    * onFinish: 移动的Marquee文字完成一次移动
    * onHelp: 访问者单击浏览器上帮助按钮
    * onKeyDown: 按下键盘
    * onKeyPress: 按下键盘且释放
    * onKeyUp: 按下键盘且释放
    * onMouseDown: 按下鼠标按钮
    * onMouseMove
    * onMouseUp: 松开鼠标
    * onMove: 窗口被移动
    * onReadyStateChange: 元素状态被改变
    * onReset: 元素值被重置
    * onResize: 改变窗口或框的大小
    * onScroll: 使用滚动条
    * onStart: Marquee文字开始移动
    * onSubmit: 表单被提交

7) JS对象

* Navigator: 当前浏览器信息

   - AppName: 提供字符串形式的浏览器名称. 在使用Navigator时, appName的值为NetScape, 在使用Internet Explorer时, appName的值为MSIE.
   - AppVersion: 反映浏览器的版本号
   - AppCodeName: 反映用字符串表示的当前浏览器的代码名字. 对于Navigator的所有版本, 这个值都是Mozilla
   - UserAgent 返回当前浏览器用户代标志

* Windows对象: 处于整个从属表的最顶级位置, 每一个windows对象代表一个浏览器窗口

   - open(URL,windowName,parameterList): open方法创建一个浏览器窗口, 并在新窗口中载入一个指定的URL地址, 如: window.open ("9-1.htm", "newwindow", "height=400, width=400, top=100, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no")
   - close(): close方法关闭一个浏览器窗口
   - alert(): 弹出一个消息框
   - confirm(): 弹出一个确认框
   - prompt(): 弹出一个提示框
   - window.event.button==1/2/3 鼠标键左键等于1右键等于2两个键一起按为3
   - window.screen.availWidth 返回当前屏幕宽度(空白空间)
   - window.screen.availHeight 返回当前屏幕高度(空白空间)
   - window.screen.width  返回当前屏幕宽度(分辨率值)
   - window.screen.height  返回当前屏幕高度(分辨率值)
   - window.document.body.offsetHeight; 返回当前网页高度
   - window.document.body.offsetWidth; 返回当前网页宽度
   - window.resizeTo(0,0)  将窗口设置宽高
   - window.moveTo(0,0)  将窗口移到某位置
   - window.focus()  使当前窗口获得焦点
   - window.scroll(x,y) 窗口滚动条坐标，y控制上下移动，须与函数配合
   - window.open()  window.open("地址","名称","属性")

* Location对象: 含有当前网页的URL地址

     .. sourcecode:: html

        <Input type="button" Value="click" onclick="window.location.href='/test/';">

* Document对象: 含有当前网页的各种特性, 页面上的内容

   - document.my.elements[0].value=this.value;
   - document.write ("<br>")
   - document.write(document.lastModified)  网页最后一次更新时间
   - document.ondblclick=x  当双击鼠标产生事件
   - document.onmousedown=x  单击鼠标键产生事件
   - document.body.scrollTop; 返回和设置当前竖向滚动条的坐标值，须与函数配合,
   - document.body.scrollLeft; 返回和设置当前横向滚动务的坐标值，须与函数配合，
   - document.title  document.title="message"; 当前窗口的标题栏文字
   - document.bgcolor document.bgcolor="颜色值"; 改变窗口背景颜色
   - document.Fgcolor document.Fgcolor="颜色值"; 改变正文颜色
   - document.linkcolor document.linkcolor="颜色值"; 改变超联接颜色
   - document.alinkcolor document.alinkcolor="颜色值"; 改变正点击联接的颜色
   - document.VlinkColor document.VlinkColor="颜色值"; 改变已访问联接的颜色
   - document.forms.length 返回当前页form表单数
   - document.anchors.length 返回当前页锚的数量
   - document.links.length 返回当前页联接的数量
   - document.onmousedown=x 单击鼠标触发事件
   - document.ondblclick=x 双击鼠标触发事件

* History对象: 含有以前访问过的网页的URL地址

   - onClick="history.go(-1)"
   - onClick="history.go(1)

8) JS内置对象

* String对象

   - charAt(idx): 返回指定位置处的字符
   - indexOf(Chr): 返回指定子字符串的位置,从左到右.找不到返回-1.
   - lastIndexOf(chr): 返回指定子字符串的位置,从右到左.找不到返回-1.
   - toLowerCase(): 将字符串中的字符全部转化成小写.
   - toUpperCase(): 将字符串中的字符全部转化成大写.
   - charAt(x)对象 反回指定对象的第多少位的字母
   - lastIndexOf("string") 从右到左询找指定字符，没有返回-1
   - indexOf("string") 从左到右询找指定字符，没有返回-1
   - LowerCase()  将对象全部转为小写
   - UpperCase()  将对象全部转为大写
   - substring(0,5)  string.substring(x,x)  返回对象中从0到5的字符
   - setTimeout("function",time) 设置一个超时对象
   - setInterval("function",time) 设置一个超时对象
   - x.toLocaleString()  从x时间对象中获取时间，以字符串型式存在
   - typeof(变量名)   检查变量的类型，值有：String,Boolean,Object,Function,Underfined

* Math对象

   - with(Match){ a=sin(1);} //在 with与语句的作用范围之内,凡是没有指出对象的属性和方法,都是指默认的对象,这个默认的对象在 with语句的开头给出
   - Math.random() 随机涵数,只能是0到1之间的数,如果要得到其它数,可以为*10,再取整
   - Math.floor(number) 将对象number转为整数，舍取所有小数
   - Math.min(1,2)  返回1,2哪个小
   - Math.max(1,2)  返回1,2哪个大

* Date对象

   - var now=new Date();

   .. sourcecode:: js

        now.getDate();// getDay getHours getMinutes getMonth getSeconds getTime getTimeZoneOffset getYear

* Array对象

    .. sourcecode:: js

         var my_array = new Array();
         for (i = 0; i < 10; i--)
         {
             my_array[i] = i;
         }
         x = my_array[4];
         document.write (x)

* Event对象

   - event.clientX  返回最后一次点击鼠标X坐标值；
   - event.clientY  返回最后一次点击鼠标Y坐标值；
   - event.offsetX  返回当前鼠标悬停X坐标值
   - event.offsetY  返回当前鼠标悬停Y坐标值

* 自定义对象

    .. sourcecode:: html

        <script language="JavaScript">
            function PCard()
            { document.write("<b>Name:</b>",this.name,"<br>");
            document.write("<b>Address:</b>",this.address,"<br>");
            document.write("<b>WorkPho:</b>",this.work_phone,"<br>");
            document.write("<b>HomePhone:</b>",this.home_phone,"<hr>");
            }
            function Pname()
            {
            document.write("<b>Name:</b>",this.name,"<br>");
            }
            function Card(name,address,work,home) //自定义的Card对象
            { this.name=name;
            this.address=address;
            this.work_phone=work;
            this.home_phone=home;
            this.PrintCard=PCard;
            this.Pname=Pname;
            }
        </script>

        <script language="JavaScript">
            sue=new Card("sueers","123-street","555-123","555-134");
            phr=new Card("phre","145-street","555-137","555-234");
            henry=new Card("heny","134-street","555-167","555-234");
            sue.PrintCard();
            phr.PrintCard();
            henry.PrintCard();
            sue.Pname();
        </script>

9) 杂

    - isNumeric  判断是否是数字
    - innerHTML  xx=对象.innerHTML  输入某对象标签中的html源代码
    - innerText  divid.innerText=xx  将以div定位以id命名的对象值设为XX
    - defaultStatus  window.status=defaultStatus; 将状态栏设置默认显示
    - location.reload(); 使本页刷新，target可等于一个刷新的网页

    - click()   对象.click()   使对象被点击。
    - closed   对象.closed   对象窗口是否已关闭true/false
    - clearTimeout(对象) 清除已设置的setTimeout对象
    - clearInterval(对象) 清除已设置的setInterval对象
    - confirm("提示信息") 弹出确认框，确定返回true取消返回false
    - cursor:样式  更改鼠标样式 hand crosshair text wait help default auto e/s/w/n-resize

