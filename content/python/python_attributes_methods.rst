Attributes and Methods
======================================

:date: 2010-01-15 14:01:28
:tags: Python

`原文 <http://www.cafepy.com/article/python_attributes_and_methods/python_attributes_and_methods.html>`_

什么是属性
----------------------

属性是从一个对象访问另一个对象的方式(挺怪的解释), 使用点号, 如obj.attribute..(从obj访问attribute, 这样看貌似前面的解释有点道理)


属性的访问
----------------------

class.__dict__以字典对象列出class的所有属性, 包含一些Python-provided(内置)属性(__dict__并不是所有对象都具有的).
obj.att 依次查找的顺序

* The object itself (objectname.__dict__ or any Python-provided attribute of objectname). --- obj本身
* The object's type (objectname.__class__.__dict__). Observe that only __dict__ is searched, which means only user-provided attributes of the class. In other words objectname.__bases__ may not return anything even though objectname.__class__.__bases__ does exist. ---obj的类中的属性, 即和obj.__class__有关, 不和obj.__base__有关
* The bases of the object's class, their bases, and so on. (__dict__ of each of objectname.__class__.__bases__). More than one base does not confuse Python, and should not concern us at the moment. The point to note is that all bases are searched until an attribute is found.obj的类的__base__, 即各级父类

如果没有从这些中找到, 会抛出AttributeError异常. 注意, 属性的查找不会从objectname.__class__.__class__(obj的类型的类型)...中找

dir() 以列表方式列出obj的所有属性
类属性的查找有点特殊, 是先class的__class__(类型, type)中找, 再从class.__base__(父类)中找.


函数/方法
----------------------

::

    >>> cobj.f is C.__dict__['f'] 3
    False
    >>> cobj.f 4
    <bound method C.f of <__main__.C instance at 0x008F9850>>
    >>> C.__dict__['f'].__get__(cobj, C) 5
    <bound method C.f of <__main__.C instance at 0x008F9850>>

使用__dict__来查找时需要调用这个__get__()方法并返回结果. 这个__get__()是将普通函数转成bound method(绑定方法?其实是和普通函数一样的)
Anyone can put objects with a __get__() method inside the class __dict__ and get away with it.
Such objects are called descriptors and have many uses.


descriptor
----------------------

__get__() 读取属性时调用(eg. print objectname.attrname)
__set__() 写属性值时调用(eg. objectname.attrname = 12)
__delete__() 删除属性时调用(eg. del objectname.attrname)
Descriptors work only when attached to classes. Sticking a descriptor in an object that is not a class gives us nothing.

上面的都是指data descriptor, 还有一种叫做non-data descriptor

    Data descriptors are useful for providing full control over an attribute.
    This is what one usually wants for attributes used to store some piece
    of data. For example an attribute that gets transformed and saved
     somewhere on setting, would usually be reverse-transformed and
    returned when read. When you have a data descriptor, it controls
    all access (both read and write) to the attribute on an instance.
    Of course, you could still directly go to the class and replace the
    descriptor, but you can't do that from an instance of the class.

    Non-data descriptors, in contrast, only provide a value when an
    instance itself does not have a value. So setting the attribute on
     an instance hides the descriptor. This is particularly useful in the
     case of functions (which are non-data descriptors) as it allows
    one to hide a function defined in the class by attaching one to
     an instance.

大概意思是Data descriptor完全控制属性的读和写. 而Non-data descriptor 只提供对象不包含值时的值, 当给属性设置时会隐藏这个descriptor. 这可隐藏类的函数f, 而对象的f仍然可以另外定义)

查找obj.attribute的顺序, 再一次:

* If attrname is a special (i.e. Python-provided) attribute for objectname, return it.
* Check objectname.__class__.__dict__ for attrname. If it exists and is a data-descriptor, return the descriptor result. Search all bases of objectname.__class__ for the same case.
* Check objectname.__dict__ for attrname, and return if found. If objectname is a class, search its bases too. If it is a class and a descriptor exists in it or its bases, return the descriptor result.
* Check objectname.__class__.__dict__ for attrname. If it exists and is a non-data descriptor, return the descriptor result. If it exists, and is not a descriptor, just return it. If it exists and is a data descriptor, we shouldn't be here because we would have returned at point 2. Search all bases of objectname.__class__ for same case.
* Raise AttributeError

a = property(get_a, set_a, del_a, "docstring") # property的get, set, del, docstring, 可以这样定义


Method Resolution Order
------------------------------------

.. image:: http://www.cafepy.com/article/python_attributes_and_methods/images/classic_diamond.png

针对继承中的相同方法的执行顺序问题. 如A, B, C, D中都有do_your_stuff()方法, 那么D中的do_your_stuff()中会执行A.do_your_stuff()两次....

解决一:

.. sourcecode:: python

    # 使用自定义的next列表
    D.next_class_list = [D,B,C,A]

    class B(A):
        def do_your_stuff(self):
            next_class = self.find_out_whos_next()
            next_class.do_your_stuff(self)
            # do stuff with self for B

        def find_out_whos_next(self):
            l = self.next_class_list           # l depends on the actual instance
            mypos = l.index(B)  1            # Find this class in the list
            return l[mypos+1]                  # Return the next one

解决二:
provides a class attribute __mro__ for each class, and a type called super. The __mro__ attribute is a tuple containing the class itself and all of its superclasses without duplicates in a predictable order. A super object is used in place of the find_out_whos_next() method.

.. sourcecode:: python

    class B(A): 1
        def do_your_stuff(self):
            super(B, self).do_your_stuff() 2
            # do stuff with self for B


    #...more super
    class B(A):

        def do_your_stuff(self):
            self.__super.do_your_stuff()
            # do stuff with self for B

    B._B__super = super(B)


__mro__的优先顺序:

* If A is a superclass of B, then B has precedence over A. Or, B should always appear before A in all __mro__s (that contain both). In short let's denote this as B > A.
* If C appears before D in the list of bases in a class statement (eg. class Z(C,D):), then C > D.
* If E > F in one scenario (or one __mro__), then it should be that E > F in all scenarios (or all __mro__s).

这个优先顺序的计算按照下图中的例子就很容易算了:

.. image:: http://www.cafepy.com/article/python_attributes_and_methods/images/beads_on_strings_solved.png

从左到右, 都要满足各串上的约束条件, 各串上"节点"的相对位置不能冲突, 互换某串上的节点位置, 可以此来决定类的继承顺序. 注: 得到的结果并不唯一.

下面还有些关于特殊方法的特殊使用, 包括如何自定义这样特殊方法, 如果继承内置类...详见原文.


Lizzer
----------------------

最后介绍个小工具. 叫做Lizzer, 因为和我英文名字类似. 所以这里介绍一下.
这个是一个js bookmarklet小工具,

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGKGDAQw

当你在当前页面中激活这款小产品, 他可以方便地位用户在几乎所有的Web邮件系统, 博客平台以及 Twitter 等任何支持富媒体编辑功能的站点上引用外站的内容(Google, Yahoo!, Flickr, Delicious, Docstoc ,Youtube etc.)到编辑器中.

可貌似这些大多都不能访问(如上图所示, 汗死也)...

更多js bookmarklet工具可另见 http://www.showeb20.com/?p=2606