Mootools Note 2
=========================================================

:date: 2009-10-28 01:10:50
:tags: Javascript


Array
-------------

Array.each(fn[, bind]): 同$each

Array.every(fn[, bind]): 测试每个元素是否满足fn, 满足返回true. //dropwhile or takewhile

Array.filter(fn[, bind]): 过滤出满足条件的元素组成一个新的数组. //ifilter

Array.clean(): 创建一个新数组,其元素都为有效(非null和非undefined).

Array.indexOf(item[, from]): 返回元素在数组中的位置, 不存在时为-1. //index

Array.map(fn[, bind]): 创建一个新数组, 其元素为老数组中经过fn计算之后的值. //imap

Array.some(fn[, bind]): 只要有一个元素满足条件就返回true.

Array.associate(obj): 创建一个字典对象. 对象列表作为value, 参数列表作为key

Array.link(array, object): 根据类型创建一个字典. 这个有点意思, 看个例子:

    .. sourcecode:: js

        var el = document.createElement('div');
        var arr2 = [100, 'Hello', {foo: 'bar'}, el, false];
        arr2.link({myNumber: Number.type, myElement: Element.type, myObject: Object.type, myString: String.type, myBoolean: $defined});
        //returns {myNumber: 100, myElement: el, myObject: {foo: 'bar'}, myString: 'Hello', myBoolean: false}

Array.contains(item[, from]): 测试数组是否包含item

Array.extend(array): 扩展一个数组 //chain or extend

Array.getLast(): 获得数组的最后一个元素

Array.getRandom(): 随机获得数组中的某个元素

Array.include(item): 将对象item添加到数组中(类型, 大小写敏感), 构成一个新数组

Array.combine(array): 合并数组(类型, 大小写敏感), 构成一个新数组

Array.erase(item): 将item从数组中删除.

Array.empty(): 清空数组.

Array.flatten(): 将多维数组转成一维数组.

Array.hexToRgb([array]): 将十六进制形式的颜色值转换成rgb形式. array为输出结构标志, 当为true时, 结果以数组形式输出(如[255, 51, 0]), 为false时, 以字符串形式输出(如: "rgb(255,51,0)").默认是字符串形式.

Array.rgbToHex([array]): rgb to hex. array含义同上.

    .. sourcecode:: js

        ['11','22','33'].hexToRgb(); //returns "rgb(17,34,51)"
        ['11','22','33'].hexToRgb(true); //returns [17, 34, 51]

        [17,34,51].rgbToHex(); //returns "#112233"
        [17,34,51].rgbToHex(true); //returns ['11','22','33']
        [17,34,51,0].rgbToHex(); //returns "transparent"

$A: 拷贝数组.

    .. sourcecode:: js

        function myFunction(){
            $A(arguments).each(function(argument, index){
                alert(argument);
            });
        };
        myFunction("One", "Two", "Three");


Function
-------------------

Function.create()

    .. sourcecode:: js

        var myFunction = function(){
            alert('hi');
        };

        var mySimpleFunction = myFunction.create(); //只是简单的拷贝;

        var myAdvancedFunction = myFunction.create({//设置相关参数
            arguments: [0, 1, 2, 3],//标准参数, event
            attempt: true, //尝试执行返回的函数, 返回其值或错误.
            delay: 1000,//延时
            bind: myElemet, //函数this可以引用的对象
        });


Function.pass()

    .. sourcecode:: js

        var myFunction = function(){
            var result = "Passed: ";
            for (var i = 0, l = arguments.length; i < l; i++){
                result += (arguments[i] + ' ');
            }
            return result;
        }
        var myHello = myFunction.pass('hello');
        var myItems = myFunction.pass(['peach', 'apple', 'orange']);

        alert(myHello()); // 'hello'
        alert(myItmes()); // 'peach' 'apple' 'orange'


Function.attempt()
尝试执行函数

    .. sourcecode:: js

        myFunction.attempt([args[, bind]]);
        var myObject = {
            'cow': 'moo!'
        };

        var myFunction = function(){
            for (var i = 0; i < arguments.legnth; i++){
                if (!this[arguments[i]]) throw('doh!');
            }
        };

        var result = myFunction.attempt(['pig', 'cow'], myObject); // result = null


Function.bind()
改变目标函数的this范围, 为bind.

    .. sourcecode:: js

        myFunction.bind([bind[, args[, evt]]]);

        function myFunction(){
            //刚开始this指向windows, 而不是一个元素
            this.setStyle("color", "red");
        };
        var myBoundFunction = myFunction.bind(myElement);
        myBoundFunction(); // this为myElement, 让myElement文本颜色为红色



        Function.bindWithEvent()
        myFunction.bindWithEvent([bind[, args[, evt]]]);
        var Logger = new Class({
            log: function(){
                console.log.apply(null, arguments);
            }
        });

        var Log = new Logger();

        $("myElement").addEvent("click", function(event, offset){
            offset += event.client.x;
            this.log("clicked; moving to:", offset); // this 指向myClass
            event.target.setStyle("top", offset);
            return false;
        }.bindWithEvent(Log, 100));


Function.delay()
等待执行某函数

    .. sourcecode:: js

        var timeoutID = myFunction.delay(delay[, bind[, args]]);

        (function(){alert("one second later...");}).delay(1000);
        var myFunction = function(){ alert("hi"+this.id); };
        myFunction.delay(50, myElement);


Function.periodical()
周期执行某函数

    .. sourcecode:: js

        var Site = { counter: 0 };
        var addCount = function(){ this.counter++; };
        addCount.periodical(1000, Site);

Function.run()
执行函数

    .. sourcecode:: js

        myFunction.run(args[, bind]);
        var myFn = function(a, b, c){
            return a+b+c;
        }
        var myArgs = [1,2,3];
        myFn.run(myArgs); // return 6

        var myFn2 = function(a, b, c){
            return a+b+c+this;
        }
        var myArgs = [1,2,3];
        myFn2.run(myArgs, 6); // return 12


Number
---------------

Number对象

myNumber.limit(min, max); 返回与min和max中的值

myNumber.round([precision]);

    .. sourcecode:: js

        (12.45).round() // 12
        (12.45).round(1) // 12.5
        (12.45).round(-1) // 10  即在各位上取整

myNumber.times(fn[, bind]);

    .. sourcecode:: js

        (4).times(alert); // alerts 0, 1, 2, 3

myNumber.toFloat();
Strings和Numbers都可用这个函数将其转换成浮点数

    .. sourcecode:: js

        (111.1).toFloat(); //return 111.1

myNumber.toInt([base]);
按照base进制转换成整数

    .. sourcecode:: js

        (111).toInt(2); // return 7


String
-----------------

myString.test(regex[, params]);//正则式匹配

myString.contains(string[, separator]);
后面的separator为分隔符, 默认为''

    .. sourcecode:: js

        alert('a bc'.contains('b')); //true
        alert('a bc'.contains('b', ' ')); //false

myString.trim(); //去除前导, 尾处空格

myString.clean(); //删除所有多余的空格. 多个连续空格变成一个空格

    .. sourcecode:: js

        " i      like     cookies      \n\n".clean(); //returns "i like cookies"

myString.camelCase(); // 格式化字符串, 以首字符大写形式, 和下面的hyphenate()作用正好相反.

    .. sourcecode:: js

        "I-like-cookies".camelCase(); // returns "ILikeCookies"

myString.hyphenate();

    .. sourcecode:: js

        "ILikeCookies".hyphenate(); // returns "I-like-cookies"

myString.capitalize();//大写

myString.escapeRegExp(); //转义所有正则式中的特殊字符, 如. 转换为\.

myString.toInt([base]);//以base进制转换成一整型, 返回number, 或NaN

myString.toFloat(); // float or NaN

    .. sourcecode:: js

        "4em".toInt(); // returns 4
        "10px".toInt(); // returns 10
        "95.335%".toFloat(); // returns 95.335

myString.hexToRgb([array]);//将十六进制形式的颜色转成RGB形式, array为布尔型, true时返回的结果以数组形式而不是字符串的"rgb(0,0,0)"

myString.rgbToHex([array]); //RGB转成十六进制..."rgb(255,255,255)", or "rgba(255,255,255,1)"

    .. sourcecode:: js

        "#123".hexToRgb(); // "rgb(17, 34, 51)"
        "112233".hexToRgb(); // "rgb(17, 34, 51)"
        "#112233".hexToRgb(true); // [17, 34, 51]

        "rgb(17,34,51)".rgbToHex(); //returns "#112233"
        "rgb(17,34,51)".rgbToHex(true); //returns ['11','22','33']
        "rgba(17,34,51,0)".rgbToHex(); //returns "transparent"

myString.stripScripts([evaluate]);//过滤script标签

evaluate为true时, 字符串中包含的脚本会被执行.

myString.substitute(object[, regexp]); // 对象形式提供值以替换字符串中的变量. regexp默认为/\?{([^}]+)}/g

    .. sourcecode:: js

        var myString = "{a} is {b}";
        var myObject = {a:'aa', b:'aa'};
        myString.substitute(myObject); // aa is aa


Hash
----------------

自定义对象Object不能使用Object.prototype. 但Hash可以使用prototype.

    .. sourcecode:: js

        var myHash = new Hash([object]);

返回一个新的Hash实例

    .. sourcecode:: js

        myHash.each(fn[, bind]);
        fn(value, key, hash)
        var hash = new Hash({first: "Sunday", second: "Monday"});
        hash.each(function(value, key){
            alert("the "+key+" day of the week is "+value);
        });

myHash.has(item); //测试是否包含指定key

myHash.keyOf(item); //和Array:indexOf()类似. 返回item的key值, 不存在的话返回false

myHash.hasValue(value); //是否包含某个值

myHash.extend(properties); // 扩展键值对

myHash.combine(properties); //联合, 里面不允许重复(旧值不能被覆盖), 大小写和类型敏感.

myHash.erase(key); //去除某个key. 返回去除之后的hash

myHash.get(key); // 获得key对应的值, 不存在时返回null

myHash.set(key, value); // 插入/修改key的值为value

myHash.empty(); //清空hash对象

myHash.include(key, value); // 如果key不存在, 则将key-value插进去. 存在key的话, 不做修改

myHash.map(fn[, bind]); // 创建一个新的map, 其对应值是对于hash中每个值计算fn之后的值.

    .. sourcecode:: js

        var timesTwo = new Hash({a:1, b:2, c:3}).map(function(value, key){
            return value*2;
        }); // timesTwo为{a: 2, b:4, c:6};

myHash.filter(fn[, bind]); //过滤fn返回true的元素.

myHash.every(fn[, bind]); // 测试hash中每个值是否满足fn, 都满足返回true, 否则false.

myHash.some(fn[, bind]); // 至少一个值满足fn, 返回true, 都不满足返回false

myHash.getClean(); // 返回一个"干净"的对象, 即不包括任何键值对.

myHash.getKeys(); // 返回所有key的数组.

myHash.getValues(); // 返回所有value的数组, 和上面的key相同顺序.

myHash.getLenght(); // 返回Hash的长度, 即key的个数.

myHash.toQueryString(); // 返回URI中的查询字符串.

Hash.toQueryString({apple: "red", lemon: "yellow"}); //returns "apple=red&lemon=yellow"

$H // 用于创建Hash的快捷方法.


Event
-------------

new Event([event[, win]]); // event指HTML事件对象, win表示windows, 表示事件的上下文.

它有很多的属性.

    * shift - (boolean) True if the user pressed the shift key.
    * control - (boolean) True if the user pressed the control key.
    * alt - (boolean) True if the user pressed the alt key.
    * meta - (boolean) True if the user pressed the meta key.
    * wheel - (number) The amount of third button scrolling.
    * code - (number) The keycode of the key pressed.
    * page.x - (number) The x position of the mouse, relative to the full window.
    * page.y - (number) The y position of the mouse, relative to the full window.
    * client.x - (number) The x position of the mouse, relative to the viewport.
    * client.y - (number) The y position of the mouse, relative to the viewport.
    * key - (string) The key pressed as a lowercase string. key can be 'enter', 'up', 'down', 'left', 'right', 'space', 'backspace', 'delete', and 'esc'.
    * target - (element) The event target, not extended with $ for performance reasons.
    * relatedTarget - (element) The event related target, NOT extended with $.

    .. sourcecode:: js

        $("myLink").addEvent("keydown", function(event){ //传递过来的event已经是一个event对象
            alert(event.key); //按键字符的小写.
            alert(event.shift); //如果按了shift键就为true.
            if (event.key == 's' && event.control) alert("Document saved.") // 这很方便获取键盘的ctrl+s哪~~
        });

myEvent.stop(); // 停止事件, 并执行preventDefault.

    .. sourcecode:: js

        // <a id="myAnchor" href="http://google.com/">Visit Google.com</a>

        $("myAnchor").addEvent("click", function(event){
            event.stop(); // 阻止浏览器
            this.set("text", "Where do you think you're going?"); // "this" 是触发该事件的元素.
            (function(){
                this.set("text", "blog").set("href", "http://blog.mootools.net");
            }).delay(500, this); //500后设置新的链接
        });

myEvent.stopPropagation(); //停止"传播", 子元素触发的事件后, 阻止父子元素触发事件.

    .. sourcecode:: js

        //<div id="myElement">
        //    <div id="myChild"></div>
        //</div>

        $("myElement").addEvent("click", function(){
            alert("click");
            return false; // 等价于stopPropagation.
        });
        $("myChild").addEvent("click", function(event){
            event.stopPropagation(); // stop之后, 就不会触发父元素的点击事件.
        });

myEvent.preventDefault(); // 阻止事件的默认操作

    .. sourcecode:: js

        //<form>
        //    <input id="myCheckbox" type="checkbox" />
        //</form>

        $("myCheckbox").addEvent("click", function(event){
            event.preventDefault(); // myCheckbox不会是选中状态.
        });

Event.Keys // 可以增加额外的事件key代码

    .. sourcecode:: js

        Event.Keys.shift = 16; // 没明白这句...
        $("myInput").addEvent("keydown", function(event){
            if (event.key == "shift") alert("pressed shift");
        });
