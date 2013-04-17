Little JS note
==============================

:date: 2009-08-23 13:08:21
:tags: Javascript

今天看到一段js代码, 实现前面补零至n位

    .. sourcecode:: js

        function pad3(num, n) {
            return (Array(n).join(0) + num).slice(-n);
        }

里面有三个以前不熟悉的地方:

    1) Array数组, Array(10), 10个元素的数组
    2) join(x), 以x连接多个数组中的元素
    3) slice(-x), 如果是负的, 就是从后往前切, 类似于python的[-x:], 从-1往左数, 包括-x; 如果是正的, 也类似于python的[:x], 从0往右数, 不包括x.