Ajax Note Part I
======================================

:date: 2010-01-07 10:01:00
:tags: Javascript, note


HTML
------------------

SGML: Standard Generalized Markup Language. 标记元语言(metalanguage).
HTML: 基于SGML, 但SGML太过庞大, HTML仅采用了部分SGML标准.
XML: Extensible Markup Language.

HTML 4.01 并不与XML兼容, 所以, W3C又提出XHMTML, 一个HTML的重写版本, 以使其能够与XML兼容.
HTML/XML标准定义主要原则: 内容高于视觉表现. 你要以设计HTML和XHTML的方式使用它们, 表明文档的结构以便浏览器能够正确显示他们的内容.


调试工具
------------------

* firebug.

    * console.log(); // 控制台输出信息
    * console.debug(); // 链接显示
    * console.info(); // 信息图标
    * console.warn(); // 警告
    * console.error(); // 错误
    * console.assert(); // 断言 表达式值true时不输出信息, 为false输出
    * console.dir(); // 直接将对象或html元素的详细信息输出到firebug
    * console.dirxml(); // xml
    * console.trace(); // 调用过程信息
    * console.group("AAA"); // 分组标识,
    * console.groupEnd(); // 分组结束
    * console.time("AAA"); // 计时某段代码执行时间
    * console.timeEnd("AAA"); // 停止计时
    * console.profile("AAA"); // 对所包含的代码段的性能测试数据
    * console.profileEnd("AAA");
    * console.count("FuncA"); // 统计其自身被执行的次数
    * 控制台命令:

* alert
* run
* clear
* copy

    * 其他浏览器下firebug使用firebuglite(www.getfirebug.com/firebuglite/lite.html), 下载其js, css, html, png等. firebug/firebug.js
    * window.console[names[i]] = function(){} // 屏蔽console对象中所有调试信息

* Fidder(IE下类似firebug的工具).
* Firefox 插件: web developer, Scrapbook, JsView


Javscript 基础
-----------------------------

AJAX: Asynchronous JS and XML

数据类型
------------------

* 数字, 不区分整数和其他, 都以浮点数来表示.

    * IEEE754 64位浮点格式;
    * Infinity(无穷大值);
    * -Infinity(无穷小值);
    * 非数字值, NaN, 与自己在内的任何值都不想等, isNaN()检测NaN;
    * isFinity()检测NaN, [-]Infinity;
    * Infinity, NaN, Number.NaN, Number.MAX_VALUE, Number.MIN_VALUE, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY.

* 字符串, unicode字符序列.

    * \xXX: 2位十六进制的latin-1字符;
    * \uXXXX: 4位...unicode字符;

* 布尔值.
* null(空), 没有值;
* undefined(未定义), undefined == null 为true, undefined === null为false;
* js中的 *函数* 是一个数据类型, 类.

    .. sourcecode:: js

        var person = new Object();
        person.name = "xxx";
        person.sex = 'F';

        var person = {name: "xxx", sex:'F'};
        person['name']; // 关联数组, 所谓也

* js中的数组每个元素都有一个名字, 每个元素都有一个编号(下标), new Array(); [1,2,3]; new Array(8);

    .. sourcecode:: js

        function test(){
            a = "global";
        }
        // a是隐式声明, 全局性, 所以在函数体外也能访问.
        var b = "global";
        function test(){
            alert(b); // undefined
            var b = "local";
            alert(b); // local
        }
        test();
        // 因为函数体内有局部变量b的定义, 隐藏了全局变量.

基本类型: 简单数据类型
引用类型(引用): 符合数据类型(对象, 数组, 函数)


"==" & "==="
---------------------

* ==, 对于引用类型, 比较的是两个变量是否引用同一个.

    * 类型转换, 两个值的类型相同, 比较它们的值或引用是否完全相同;
    * 两个值的类型不同时,
    * null, undefined相等;
    * 数字字符串,先将字符串转换为数字,再比较;
    * 布尔值先转换位数字, true为1, false为0;
    * 对象比较时, 先将对象转换为简单数据类型, 再进行比较, 依次 valueOf(), toString(), 而Date则是先是toString();

* ===, 不进行类型转换, null 与 undefined不等


语法
---------------------

* a in b:

    * 检查a 是否为b 的属性名;
    * 若b 是数组, 则检查a 是否为b的索引之一, 不是值;
    * for (a in b) {} 列出b的属性, for / in语句并不能列出对象所有的属性, 因为一些对象的属性被标记成只读, 永久的(不可删除)或不可列举的, 这些属性不能被列举出来.

* a instanceof b:
    * 检查a是否为b的实例;
    * date instanceof Date; //true

* break/continue:
    * break + label, 跳出label, 主要用于跳出外部循环;
    outerloop:

    .. sourcecode:: js

        for (var i=1; i<=10; i++){
            innerloop:
            for (var j=1; j<=10; j++){
                if (j == 8) { break innerloop; }
                if (i*j == 24) { break outerloop; }
            }
        }


    * continue + label;
    * return, 不带返回值时, 这是函数的返回值为undefined.

* throw 异常信息:

    * throw new Error("xx");
    * try{ } catch(varible){ } finally{ };

* 函数:
    * function Name(arg){}
    * var Name = function(arg){}
    * var Name = new Function(arg, "函数体"), eg var add = new Function('x', 'y', 'return x+y');
    * 当某些函数只需要执行一次, 可以声明匿名函数并立即调用, eg,

    .. sourcecode:: js

        (function(a, b){
            return a+b;
        })(1, 2);


    * 实际参数可遇形参列表不一致, 实参都被存到函数的arguments属性中, arguments.length, arguments.callee(x, y); // callee为该当前函数的引用, 这就很容易实现递归了

    .. sourcecode:: js

        /**
         * 十/二进制转换
         */
        function recursion(x){
            if (typeof arguments[1] == "undefined"){
                var num = '';
            } else {
                var num = arguments[1];
            }
            var y = parseInt(x/2);
            num = x % 2 + num;
            if (y == 1){
                return '1' + num;
            } else {
                num = arguments.callee(y, num);
            }
            return num;
        }

Array
--------------------------

* a.length = 5; // 长度可变
* a.unshift(32); // 将一个新的元素添加到数组开头
* a.push(1); // ...末尾
* a.shift(); // 删除第一个元素
* a.pop(); // 删除末尾一个元素
* a.splice(a, [b]); // 删除从a到b(末尾)的元素
* a.splice(a, b, extra); // 删除从a到b的元素后掺入extra
* a.slice(a, b); // 切片
* a.reverse(); // 反转数组
* a.join('..'); // 以..链接数组成字符串
* a.sort(); // 排序, 可自定义函数, 每次取2个元素, 类似于冒泡

    .. sourcecode:: js

        var a = [4, 1, 23, 3];
        a.sort(function(x, y){
            return y-x; // 若需要前一元素排在后裔元素后面, 则返回大于0的数, 反之. 位置不变, 返回0.
        });


String
--------------------------

* "aaa".length;
* "aaa".substring(a,b); // 从a到b截取, 不包含b
* "aaa".replace(a, b); // 以b代替a, a可以为正则式
* "aaa".toUpperCase(); // 大写
* "aaa".toLowerCase(); // 小写
* "aaa".split(''); // 将字符串转换成数组
* ["aaa", "bbb"].join(''); // 拼接字符串


RegExp
--------------------------

* RegExp("..."); new RegExp("\\d+", 'gi');
* /.../; /\d+/gi;
* i: 忽略大小写, g: 全局匹配, m: 多行匹配
* reg.source： 获得正则式文本
* reg.global: 是否开启全局匹配模式
* reg.ignoreCase
* reg.multiline
* reg.lastIndex: 记录在全局匹配模式下, 在字符串中下一次开始匹配的位置
* str.search(/.../); // 返回第一个与之匹配的字符串的开始位置, 如果没有任何子字符串与之匹配, 则返回-1
* str.replace
* str.match 返回的第一个元素是匹配的子字符串, 从第二个元素开始是分组所匹配的内容, 如果是全局匹配模式, 则返回的数组是字符串中所有匹配的子字符串;
* 在非全局模式, index表所匹配的子字符串在原字符串中的位置; input保存了原字符的一个副本.
* str.split(reg)
* reg.test(str) // true/false
* reg.exec(str) // 每次只匹配一个结果, lastIndex 当匹配结束时, lastIndex为0, 返回null


Date
--------------------------

* new Date(数字) 日期的内部数字表示, 单位ms
* new Date(字符串) 含日期的字符串
* new Date(year, month, day, hours, minutes, secondes, ms);
* d.getFullYear();
* d.getMonth();
* d.getDate();
* d.getHours();
* d.getMinutes();
* d.getSeconds();
* d.getMilliseconds();
* d.getTime(); // 内部毫秒表示
* d.getTimezoneOffset(); // 本地时间与UTC时间之差, 以分钟为单位
* d.set同上


Math
--------------------------

* Math.ceil(a); // 上舍
* Math.floor(a); // 下舍
* Math.random(); // 返回一个介于0~1的随机数
* Math.pow(a, b); // a^b
* Math.max(...); // 0个参数, 则返回-Infinity
* Math.min(...); //...返回Infinity


全局对象
--------------------------

* alert(...);
* confirm(...); // true/false
* prompt(...); // 输入的值/null
* window.status // 状态栏
* setTimeout,,,clearTimeout(id);
* setInterval,,,clearInterval(id);
* window.location,,,window.location.href
* history.back();
* history.forward();
* history.go(n);
* window.resizeTo(width, height); // 绝对
* window.resizeBy(x, y); // 相对原来窗口大小, 像素为单位
* window.moveTo(x, y); // 移动窗口到x, y坐标
* window.moveBy(x, y); // 相对
* var newwindow = window.open("窗口url", "窗口名字", "height=100, width=400, top=0, left=0, toolbar=no, menubar=no等特性", false); // 最后的false指定是否是已存在的窗口
* 只有在open方法是用一个已经存在的窗口时才会生效, 其作用是声明由第一个参数指定的url是应该替换历史记录的当前项, 还是创建一个新项, 默认为后者.
* focus/blur: 获得/失去焦点
* screen.availWidth 实际可用的显示器大小
* screen.availHeight
* screen.colorDepth 可显示的颜色数, 以2为底的对数
* navigator 属性保存客户端浏览器的总体信息
* navigator.appName Web浏览器名称
* navigator.appVersion 内部版本号
* navigator.userAgent HTTP请求时, USER-AGENT头信息中的数据
* navigator.appCodeName 浏览器的代码名
* navigator.platform 运行浏览器的硬件平台


document对象
--------------------------

描述HTML文档的整体信息属性

* document.write();
* document.writeln();
* document.title;
* document.images; // 一数组, 保存了对当前HTML文档中所有图像的引用
* document.getElementById("xxx").style.border...
* document.links; // 一数组, 保存了文档中所有超链接的引用
* document.forms; // 一数组, 保存当前文档中所有表单的引用

DOM: Document Object Module, 文档对象模型, 表示文档, 访问和操作文档元组的API. 树型结构

======================  ===========
 结点类型                  nodeType
======================  ===========
 Element                    1
 Attr                       2
 Text                       3
 Comment                    8
 Document                   9
 DocumentFragment           11
======================  ===========

* Element.innerHTML
* document.getElementsByName("xxx"); // 指定name的属性的结点集合
* document.getElementsByTagName("xxx"); // 查找所有标签名为xxx的下属节点, 返回一数组
* Node.parentNode.id // 当前节点的父节点
* Node.childNodes
* Node.firstChild
* Node.lastChild
* Node.previousSibling //节点的上一个兄弟节点的引用
* Node.nextSibling //...下一个
* document.createElement("标签名"); // 使用createElement创建元素结点后, 元素并没有被立即加入到当前的DOM树中, 而被存放到内存中. 只有使用添加结点的相关方法进行操作. 才真正将元素加入到DOM树中.
* document.createTextNode("this is text"); // 创建文本结点后并没有立即被添加到DOM树中
* node.appendChild(newNode); // 添加结点
* parentNode.insertBefore(newNode, childNode); // 插入子结点
* parentNode.replaceChild(newNode, childNode); // 替换子结点
* newchone = node.cloneNode(true/false); // 复制结点, true和false表示是否包含原节点的子结点
* parentNode.removeChild(childNode); // 删除子结点

    .. sourcecode:: js

        /**
         * 删除一个直属子结点
         */
        document.onclick = function(e){
            var evt = arguments[0] || event;
            var elm = evt.target || evt.srcElement;
            if (elm.type == "button" && elm.classname == "btn"){
                var li = elm.parentNode;
                li.parentNode.removeChild(li);
            }
        }

* node.getAttribute(...); // 获得结点的某一属性的值, 或直接使用. 属性
* node.setAttribute(attName, attValue);
* node.removeAttribute(attName);

控制元素样式:

* 设置class属性, setAttribute("class", "xxx");
* element.className = "link";
* node.style.css样式 = 值;

    * '-' 去掉, 第二个单词首字母大写
    * css属性名与js保留字冲突的话, 则单词前面加上style, 如styleFloat

事件处理
------------------------

IE事件模型和标准时间模型的区别两点:

* 事件对象的差异:

    * IE事件模型, window对象提供一个event属性保存当前事件对象, 所以, 可在程序中直接访问时间对象event;
    * 标准时间模型, 事件对象是在时间被触发时生成, 然后作为参数传递给时间处理程序, 所以在标准时间模型中, 事件是局部的.

* 事件的传播机制:

    * 标准事件传播分为3个阶段:
    * 捕捉阶段(capturing), 时间从document对象沿着文档树向下往目标节点传播, 如果在传播过程中的任何一结点注册了处理该事件的事件处理程序, 则程序会被执行. 即在这个阶段目标节点的任何祖先结点都有机会来处理事件.
    * 发生在目标节点自身, 注册在目标节点上的合适的事件处理程序将被执行.
    * 起泡阶段, 事件将会沿着文档树从目标结点回传给document对象. 所有的事件都受捕捉机制的支配, 但并非所有的事件都起泡.
    * 事件分为两类: 输入事件和高级语义事件. 输入事件指用户操作产生的事件; 语义事件指由系统内部触发的事件. 所有语义事件不会起泡.
    * 在IE事件模型中, 只支持起泡形式的事件传播, 而不支持捕捉形式的事件传播.

* 注册事件处理程序:

    * 当作属性: node.onclick = function(){}
    * 在标准事件模型中: obj.addEventListener(eventName, eventHandler, useCapture); // useCapture: bool, true表指定的事件处理程序将在事件传播的捕捉阶段用于捕捉事件; false表当事件直接发生的对象上, 或发生砸iduixiang的子结点并起泡到对象上的, 调用处理函数, 默认为false.
    * 注: 使用addEventListener可给目标的同一事件注册多个事件处理程序, 好处是使程序可模块化开发, 不用担心冲突.
    * IE事件模型中, 使用obj.attachEvent("on"+eventName, eventHandler);

    .. sourcecode:: js

        function addEvent(obj, name, handler, useCapture){
            if (window.event){
                obj.attachEvent("on"+name, handler);
            } else {
                obj.addEventListener(name, handler, useCapture);
            }
        }

* 注销事件处理程序:

    * 将对象的响应属性设置为null来注销
    * detachEvent()/removeEventListener()

    .. sourcecode:: js

        function removeEvent(obj, name, handler, useCapture){
            if (window.event){
                obj.detachEvent("on"+name, handler);
            } else {
                obj.removeEventListener(name, handler, useCapture);
            }
        }


===========================    =============================    ==================================================================
  标准事件模型                      IE事件模型
===========================    =============================    ==================================================================
  target                          srcElement                       发生事件的目标元素
  type                            type                             发生事件的类型
  keyCode                         keyCode                          声明了keydown, keyup事件的按键代码
  clientX, clientY                clientX, clientY                 相对于窗口左上角的坐标
  preventDefault()                returnValue                      returnValue为false阻止浏览器执行与事件相关的默认动作
  stopPropagation()               cancelBubble                     cancelBubble为true阻止事件起泡
  altKey,ctrlKey,shiftKey         altKey,ctrlKey,shiftKey          布尔属性, 事件发生时, 是否按住了这些键
===========================    =============================    ==================================================================

    .. sourcecode:: js

        /**
         * 实例事件处理
         */
        function mouseoverEventHandler(e){
            var evt = e || event;
            var elm = evt.target || evt.srcElement;
            if (elm.tagName.toLowerCase() == "td"){
                elm.style.border = "1px ...";
            }
        }

