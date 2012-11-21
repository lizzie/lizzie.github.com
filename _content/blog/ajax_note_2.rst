Ajax Note Part II
======================================

:date: 2010-01-07 10:01:12
:tags: Javascript, note


.. sourcecode:: js

    try {
        var xmlhttp = new XMLHttpRequest();
    } catch(e) {
        var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.open("POST", "/ajax/helloworld/", true);
    xmlhttp.onreadystatechange = function(){
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200){
            alert(xmlhttp.responseText);
            document.getElementById("words").innerHTML = xmlhttp.responseText;
        }
    }
    xmlhttp.send();


定义

* new XMLHttpRequest();
* new ActiveXObject("Microsoft.XMLHTTP");

初始化一个请求

* XMLHttpRequest.open(method, url, 是否异步);
* XMLHttpRequest.open(strMethod, strUrl, boolAsync, strUser, strPassword); // 需要验证时的用户名和密码
* boolAsync, true, 异步方式, 当状态改变时会调用onreadystatechange

设置请求的HTTP头信息

* XMLHttpRequest.setRequestHeader(strHeader, strValue);
* Content-Type: text/xml or application/x-www-form-urlencoded
* COOKIE: cookiename = cookievalue

发送请求

* XMLHttpRequest.send(varBody)
* 通过请求发送的数据, 字符串, DOM, 任意数据流

XMLHttpRequest对象在生命周期中有5种状态:

# 0(未初始化) 对象已创建, 但未调用open初始化
# 1(初始化) 对象已初始化, 但未调用send
# 2(发送数据) send已调用, 但HTTP状态和HTTP未知
# 3(数据传送中) 已开始接受数据, 但响应数据和HTTP头信息不全
# 4(完成) 数据接收完成

* .readyState 指示上述5种状态
* .status 返回请求的HTTP状态码
* readystatechange事件调用onreadystatechange处理函数
* .getResponseHeader("xxx"); //获得信息的HTTP头
* .getAllResponseHeaders(); // 获得信息的所有HTTP头
* 取得返回的数据: responseText(作为字符串格式), responseXML(XML文档)
* .abort(); // 重新返回到未初始化状态

.. sourcecode:: js

    function parseXMLData(data) { // data为XML格式
        var children = data.childNodes;
        if (children.length>0){
            document.body.innerHTML += "<div>"+data.nodeName+"</div>";
            for (var i=0; i<children.length; i++){
                parseXMLData(children[i]);
            }
        } else {
            document.body.innerHTML += data.nodeName + data.nodeValue;
        }
    }

    /**
     * 一个基本的封装好的Ajax开发框架
     *
     * @author:
     */

    /**
     * 对不同浏览器下XMLHttpRequest对象的简单封装
     * @function    getTransport
     * @constructor
     * @returns     XMLHttpRequest对象 or undefined
     */
    function getTransport(){
        var version = [
            function(){
                return new XMLHttpRequest();
            },
            function(){
                return new ActiveXObject('Microsoft.XMLHTTP');
            },
            function(){
                return new ActiveXObject('Microsoft.XMLHTTP');
            }];

        var request;
        for (var i=0; i<version.length; i++){
            var lambda = version[i];
            try{
                request = lambda();
                break;
            } catch(e){}
        }
        return request;
    }

    /**
     * 根据用户指定的URL，方法，参数，HTTP头，及回调函数，创建XMLHttpRequest对象并发送请求
     * @function ajaxRequest
     * @param {string} url 请求的URL地址
     * @param {object} options 参数集合
     */
    function ajaxRequest(url, options){
        var request = getTransport();
        if (typeof request == "undefined"){
            throw new Error("Browser does not Supper");
            return;
        }
        var url = url;
        var method = (options.method || "POST").toUpperCase();
        if (method != "GET" && method != "POST") {
            method = "POST";
        }
        var parameters = options.parameters || null;
        var headers = options.headers || {};
        var onLoadingEventHandler = options.onLoading || function(){};
        var onCompleteEventHandler = options.onComplete || function(){};
        var onSuccessEventHandler = options.onSuccess || function(){};
        var onFailureEventHandler = options.onFailure || function(){};

        if (method == "GET" && parameters != null){
            if (url.indexOf('?')>-1){
                url += '&' + parameters;
            } else {
                url += '?' + parameters;
            }
            parameters = null;
        }
        request.open(method, url, true);
        request.setRequestHeader("contentType", "application/x-www-form-urlencoded");
        for (var name in headers){
            request.setrequestHeder(name, headers[name]);
        }
        request.onreadystatechange = function(){
            if (request.readyState == 1){
                onLoadingEventHandler(request);
            }
            if (request.readyState == 4){
                onCompleteEventHandler(request);
                if (request.status && request.status>=200 && request.status<300){
                    onSuccessEventHandler(request);
                } else {
                    onFailureEventHandler(request);
                }
            }
        }
        request.send(parameters);
    }

编码:

    XMLHttpRequest返回数据是按UTF-8编码, 保持前后台一致, 即请求头和响应头编码一致就不会有问题

缓存:

    对请求url加个随机变化的参数

请求方式:

    POST, 创建, 更新资源, 有副作用
    GET, 查询, 无副作用, 长度限制1024字节

控制多个ajax请求

    * 轮询模式: 将下一次请求的发起放在上一个请求完成的回调函数中
    * 事件响应模式: 等用户完成输入或者到达预期的位置后才发送必要的请求, 但是开发者并不能预先知道用户需要什么,,,,可以给每次请求设置延迟, 在每次事件中, 设置一个延迟来发送请求, 在下一次事件中预先判断是否存在仍然处于延迟阶段,未被发送的请求, 如果存在, 则取消这个请求的发送, 然后重新设置一个新的延迟发送的请求, 延迟的时间间隔视需要而定(可将延迟时间设置为略大于用户每步操作的平均时间间隔)

AJAX请求安全性:

    一是身份验证
    二是后台检测输入的内容有效性
    三是防范js注入, 同样也是建立有效的检测校验机制

XML
    <![CDATA[ ... ]]>
    包含的文本被当作普通文本处理


ZXml:

    跨浏览器的XML开发框架

JSON vs XML

JSON:

    * 更简洁, 字节数少
    * 解析方便, 与js对象一致
    * 结构简单
    * 但没有像XML的命名空间机制

    xml2json: 将xml文档转成json

OOP
------------------

类

* this.添加的属性都是public的
* 局部变量可认为是私有变量, 由作用域控制
* 静态属性和方法, 直接给类名, eg, A.aaa = ...; A.b = function(){}
* 原型对象prototype, 每个对象可以参考一个原型对象, 原型对象包含自己的属性, 按照需要随时对类进行扩展无须改动原有的定义

.. sourcecode:: js

    /**
     * 类的使用
     */
    function People(name, sex, deposit){
        this.name = name;
        this.sex = sex;
        var deposit = deposit; //私有属性
        this.changeName = function(newName){
            this.name = newName;
        }
        this.consume = function(money){
            if (deposit>=money){
                deposit -= money;
            } else {
                throw new Error("Not Enough");
            }
        }
        var _this = this;
        var digest = function(food){ //私有方法
            _this.thew++;
        }
        this.eat = function(food){ //共有方法
            digest(food);
        }
    }
    People.staticProperty = "static property"; //静态属性
    People.staticMethod = function(){} //静态方法

    People.prototype = {  // 原型
        thew: 1,
        changeName: function(newName){
            this.Name = newName;
        }
    }
    People.prototype.shout = function(){};

    // 对象冒充
    var j = new People("J");
    var a = new People("A");
    j.getName.call(a); // "A"
    a.getName.call(j);

    function Shape(name){
        var name = name;
        this.getName = function(){
            return name;
        }
    }
    function Circle(center, radius){
        Shape.call(this, "circle");
        this.center = center;
        this.radius = radius;
    }
    //对于父类的原型，子类继承时，
    for (var member in Shape.prototype){
        if (!Circle.prototype[member]){
            Circle.prototype[member] = Shape.prototype[member];
        }
    }
    /**
     * 简单封装继承
     */
    Function.prototype.inherit = function(instance, baseClass, arguments){
        this._baseClass = baseClass;
        baseClass.apply(instance, arguments); // 使用对象冒充调用基类的构造函数
        for (var member in baseClass.prototype){
            if (!this.prototype[member]){
                this.prototype[member] = baseClass.prototype[member];
            }
        }
    }
    // 对于Circle，使用如下方式继承Shape
    function Circle(center, radius){
        Circle.inherit(this, Shape, ["circle"]);
        //...
    }

    // 命名空间
    if (typeof Sys == "undefined"){
        Sys = {};
    } else {
        if (typeof Sys != "object"){
            throw new Error("type error");
        }
    }
    // 子命名空间
    Sys.Utility = {};
    Sys.Utility.StringBuilder = function(){}

    // 短命名
    function imports(namespace){
        for (var member in namespace){
            if (!window[member]){
                window[member] = namespace[member];
            }
        }
    }
    imports(Sys.Utility);


JSVM:

    完整的代码组织管理方案

浏览器兼容性示例
-----------------------

* form.elements 获取表单元素集合
* .getAttribute("XXX");
* window.open(); 来打开新的窗口, 不用什么乱七八糟的模态窗口
* window.frameName.location = "XXX"; 使用iframe的名字, 不用它的id

.. sourcecode:: js

    // 父元素使用parentNode
    if (!window.ActiveXObject){
        // outerText兼容性问题解决
        HTMLElement.prototype._defineGetter_("outerText", function(){
            return this.textContent;
        });
        HTMLElement.prototype._defineSetter_("outerText", function(value){
            var textNode = document.createTextNode(value);
            this.parentNode.replaceChild(textNode, this);
        });
        // innerText
        HTMLElement.prototype._defineGetter_("innerText", function(){
            return ;
        });
        HTMLElement.prototype._defineSetter_("innerText", function(value){
            this.textContent = value;
        });
        // outerHTML
        HTMLElement.prototype._defineGetter_("outerHTML", function(){
            var attr;
            var attrs = this.attributes;
            var str = "<" + this.tagName.toLowerCase();
            for (var i=0; i<attrs.length; i++){
                attr = attrs[i];
                if (attr.specified){
                    str += "" + attr.name + '="' + attr.value +'"';
                }
            }
            str += '>' + this.innerHTML + "</" + this.tagName.toLowerCase() + ">";
            return str;
        });
        HTMLElement.prototype._defineSetter_("outerHTML", function(sHTML){
            var range = this.ownerDocument.createRange();
            range.setStartBefore(this);
            var domFragment = range.createContextualFragment(sHTML);
            this.parentNode.replaceChild(domFragment, this);
        });
    }

* 解决Ajax和搜索引擎收录问题:

    * 区分对象, 普通http请求和ajax请求;
    * 对ajax, a标签注册click事件, 以href值进行ajax请求;
    * 对爬虫, 仍然是普通链接.

* Ajax的前进和后退问题:

    * Gecko核心: url加#号后的hash值, 改变后, 直接触发firefox的historyChange函数
    * IE: 如果一个页面包含一个或者多个iframge, 若iframge中页面发生了跳转, 那么也会被浏览器记录到历史记录中, 如果单击浏览器的前进和后退, 主页面不受影响, 智慧让iframe中的页面发生跳转, 那么, 可以将#后的hash值交给iframe保存, ajax请求并更新界面时, 改变iframe地址...比较含糊.