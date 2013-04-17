Mootools Note 1
=========================================================

:date: 2009-10-28 01:10:42
:tags: Javascript

Mootools文档: http://mootools.net/docs

第一部分是核心函数.

$chk(item);

    检查对象是否存在或者是否为0, 是的话返回true, 否则为false.

$clear(timer);

    清除一定时器或定时间隔, 和Function:delay, Function:periodical配合使用.
    timer为setInterval(periodical)和setTimeout(delay)的标识符. 返回为null.

    .. sourcecode:: js

        var myTimer = myFunction.delay(5000); //delay and periodical
        myTimer = $clear(myTimer);

$defined(obj);

    检测obj的值是否被定义.不为null和undefined时返回true, 否则返回false.

$arguments(i)

    返回一个函数的第index个参数.

    .. sourcecode:: js

        var secondArgument = $arguments(1);
        alert(secondArgument('a', 'b', 'c')); // Alerts "b"

$empty

    占位函数, 通常用作事件处理函数.

    .. sourcecode:: js

        var myFunc = $empty;

$lambda(sth);

    返回一函数用于直接返回传入的值(其他什么都不做).

    .. sourcecode:: js

        myLink.addEvent('click', $lambda(false)); // 阻止click事件.

$extend(original, extension);

    拷贝第二个对象的所有属性给第一个对象.


    .. sourcecode:: js

        var firstObj = {
            'name': 'John',
            'lastName': 'Doe'
        };
        var secondObj = {
            'age': '20',
            'sex': 'male',
            'lastName': 'Dorian'
        };
        $extend(firstObj, secondObj);
        //firstObj is now: {'name': 'John', 'lastName': 'Dorian', 'age': '20', 'sex': 'male'};

$merge();

    (递归)合并多个对象.

    .. sourcecode:: js

        var nestedObj1 = {a: {b: 1, c: 1}};
        var nestedObj2 = {a: {b: 2}};
        var nested = $merge(nestedObj1, nestedObj2); // {a: {b: 2, c: 1}} 其中的值是根据什么规则来计算的??

$each(iterable, fn[, bind]);

    对于每个iterable中的元素执行fn, fn包含当前对象, 当前对象的位置, 和总对象.

    .. sourcecode:: js

        fn(item, index, object)
        //Alerts "The first day of the week is Sunday", "The second day of the week is Monday", etc:
        $each({first: "Sunday", second: "Monday", third: "Tuesday"}, function(value, key){
            alert("The " + key + " day of the week is " + value);
        });

$pick

    返回第一个有效定义(不为null)的值.

    .. sourcecode:: js

        var picked = $pick(var1[, var2[, ...]]);

$random(min, max);

    随机返回min和max中的一个值. 闭区间.

    .. sourcecode:: js

            alert($random(5, 20));

$splat(obj);

    将obj转换成数组.

    .. sourcecode:: js

        $splat('hello'); //Returns ['hello'].
        $splat(['a', 'b', 'c']); //Returns ['a', 'b', 'c']. 汗...这个有何意义?

$time();

    返回当前时间.


$try(fn[, fn, fn, fn, ...]);

    尝试执行多个fn, 返回的值为第一个正确执行的函数返回值.

$type(obj);

    一字符串形式返回obj的类型

Browser

    获得浏览器的相关信息, 使用引擎版本, 平台等.