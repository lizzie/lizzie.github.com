reSub
===================

:date: 2010-07-17 10:07:33
:tags: Python


Python中, re的sub方法,

doc http://docs.python.org/library/re.html#re.sub

    ::

        re.sub(pattern, repl, string[, count, flags])
        Return the string obtained by replacing the leftmost non-overlapping occurrences of pattern in string by the replacement repl. If the pattern isn’t found, string is returned unchanged. repl can be a string or a function; if it is a string, any backslash escapes in it are processed. That is, \n is converted to a single newline character, \r is converted to a linefeed, and so forth. Unknown escapes such as \j are left alone. Backreferences, such as \6, are replaced with the substring matched by group 6 in the pattern.

* pattern为目标替换串,
* repl为新的串,
* string为原始串,
* count为替换个数, 默认全部替换,
* flags为re的一些全局标志, 比如忽略大小写, 换行等

得到的是, 在原串string中将符合一定模式pattern的字符串使用repl替换掉并返回.
pattern, 没话好说, 就是一般的正则式,
repl, 可以是正则, 也可以是一个函数, 如果是函数, 函数的传入参数就为match对象, 函数内可直接操作这个match对象, 返回处理后的字符串结果.

看几个例子:

1) 最普通的:

    ::

        >>> re.sub(r'def\s+([a-zA-Z_][a-zA-Z_0-9]*)\s*\(\s*\):',
        ...        r'static PyObject*\npy_\1(void)\n{',
        ...        'def myfunc():')
        'static PyObject*\npy_myfunc(void)\n{'
        ## \n会保留的

2) 使用函数的例子:

    ::

        >>> def dashrepl(matchobj):
        ...     if matchobj.group(0) == '-': return ' '
        ...     else: return '-'
        >>> re.sub('-{1,2}', dashrepl, 'pro----gram-files')
        'pro--gram files'

3) 我的例子, 想把模板中生成出完整的html代码并保存下来, 在模板中有些不想输出, 用<!-- delete --->和<!-- delete END --->标记出来, 输出时将这之间的内容去除.

    .. sourcecode:: python

        import re
        ac = """. abcd <!--delete--> abcd. <!--delete End-->abcd <!--delete--> abcd. <!--delete End-->fs"""
        ad = """
        ... abcd
        ... <!--delete-->
        ... abcd
        ... <!--delete End-->
        abcd

        ... <!--delete-->
        ... abcd
        ... <!--delete End-->
        abcd

        """
        #print re.sub(r'<!--delete-->.*<!--delete End-->', r'', ac)
        #print re.sub(r'<!--delete-->(.|\n)*<!--delete End-->', r'', ac)
        print re.sub(r'<!--delete-->(.|\n)*?<!--delete End-->', r'', ac)
        print '---------------------'
        print re.sub(r'<!--delete-->(.|\n)*?<!--delete End-->', r'', ad)

        #print re.sub(r'.*', r'', ac) --- 机上python2.5, 还不支持flags=re.DOTALL, 所以换行的话压根替换不了. 但诡异的是, 文档上说2.4之后就能用flags, 但机器上2.5版本竟然不支持!
        #print re.sub(r'(.|\n)*', r'', ac) --- 加上\n,支持换行了,,,不过是最大贪婪匹配了, 最前一个delete和最后一个delete END之间的完全替换掉了..
        #print re.sub(r'(.|\n)*?', r'', ac) --- 嗯嗯, 加个?, 改成非贪婪模式就好了..


最后, re.subn(pattern, repl, string[, count, flags]) Perform the same operation as sub(), but return a tuple (new_string, number_of_subs_made). 和sub唯一的区别就是返回的是一个元组, 新字符串和被替换的次数.

