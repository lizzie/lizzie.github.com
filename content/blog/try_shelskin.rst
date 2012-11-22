ShedSkin
===============

:date: 2009-05-20 03:05:48
:tags: Tools


http://code.google.com/p/shedskin/

这是个Google Code上的工程, 主要用于将Python代码自动转换成C++代码.

嘿嘿, 找这个, 是因为自己几乎把C++忘的差不多了, 但现在要快速写些C++小程序, 一个偷懒的办法就是先用Python写好, 然后再转成C++代码.

好了, 具体使用介绍下.

安装
-------------

1) 将项目svn下载下来, 安装这些依赖: sudo apt-get install g++ libpcre3-dev libgc-dev
2) 进入工程目录, python setup.py之后, 生成一个叫shedskin的bash脚本, 其中主要是设定ShedSkin根目录, 和执行ss.py脚本.


使用
-------------

1) python脚本test.py放于shedskin同级目录,
2) 执行 shedskin test 之后, 会在当前目录下生成test.ss.py, test.cpp, test.hpp文件, .ss.py是一个中间文件, 用于标记变量类型.

    ## 这里需要注意的地方: 如果将要转换的py脚本放在其他目录中, 比如./mytest/下, 执行./shedskin mytest/aabbcc会报*ERROR*:mytest/aabbcc.py: module names should consist of letters, digits and underscores, 所以还是放于工程目录下,

3) make run, 生成test可执行文件test并运行它.


Python支持
-------------

1) 不支持动态类型

因为Python是动态类型语言, 而C++的类型需要在编译时就确定下来, 确定下来之后不能更改. 所以在编写Python程序的时候, 需要注意不能对某个变量类型改变, 比如, 刚开始一个变量类型为None, 之后赋予整型0, 这会在转换时, 出现warning:

::

    *WARNING* lcs.py: variable (function find_lcs, 'd') has dynamic (sub)type: {None, int}

解决办法就是, 对于每个变量初始化成一个类型, 并且在程序运行时也不能改变该类型.

2) 除了类型固定外, 还有其他的限制:

    * variable numbers of arguments and keyword arguments 可变参数
    * arbitrary-size arithmetic (integers become 32-bit on most architectures!)
    * reflection (getattr, hasattr), eval, or other really dynamic stuff
    * multiple inheritance
    * generator expressions
    * nested functions and classes
    * inheritance from builtins (excluding Exception and object)
    * some builtins, such as map, filter and reduce

等等, 这还是由于C++不是动态语言. 另外, Python的容器类型中包含的类型不能是混合的, 比如[1, '2']这种是不允许的.

3) 当然, Python中提供的模块, 有很大一部分是不支持的. 不过对于小型程序来说, 不会涉及到很多模块.


测试
-------------

1) 测试了一个Longest Common Subsequence. 原来60行的python程序, 经过转换后, cpp和头文件超过100行. 看到生成的CPP代码中, 把原来Python中的字符串常量都表示成动态的str数组了, 而不是使用C++中的字符串常量,,这可能是因为Python的字符串对象还是有一些方法, 如果直接变成C++中的字符串常量, 那岂不对应的方法就不能用了.

2) 使用gcc 编译生成的lcs.cpp和lcs.hpp

    make lcs之后使用的g++命令, 看到

    ::

        g++ -O2 -pipe -Wno-deprecated -I. -I/home/shengyan/workspace/shedskin-read-only/lib /home/shengyan/workspace/shedskin-read-only/lib/builtin.cpp lcs.cpp /home/shengyan/workspace/shedskin-read-only/lib/re.cpp -lgc -lpcre -o lcs

    依赖的库有好多, lib下面主要是些python模块的cpp版本, 把这些依赖的库找到..
    而且还有gc,和pcre两个库, 一个Garbage Collection, 另一个是正则式的.

3) make时间比较长,,,是否是cpp生成的东西太多了?

其他
-------------

命令行选项

::

    -a --noann             Don't output annotated source code
    -b --nobounds          Disable bounds checking
    -d --dir               Specify alternate directory for output files 可将生成的文件放在一个目录中
    -e --extmod            Generate extension module
    -f --flags             Provide alternate Makefile flags
    -r --random            Use fast random number generator
    -w --nowrap            Disable wrap-around checking

