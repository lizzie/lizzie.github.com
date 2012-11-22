Type and Object
======================================

:date: 2010-01-14 14:01:02
:tags: Python

`原文 <http://www.cafepy.com/article/python_types_and_objects/python_types_and_objects.html>`_

这篇文章讲Python中的Type和Object的关系.

英文描述较多, 还是看里面的两幅图比较清楚些:

.. image:: http://www.cafepy.com/article/python_types_and_objects/images/types_map.png

这图很形象的表示Python中的type和object的关系.

* 虚箭头表示__class__关系, 即A是B的实例; 实箭头表示__base__关系, A是B的子类;
* type 'type' 是个metaclass,type 'type' 是自身的实例, 又是type 'object'的子类 ----metaclass
* type 'object'是type 'type'的实例, 也是最基类(is a subclass of no object), type 'list', type 'dict'等其他type继承type 'object' ---class
* object是class的实例.

.. image:: http://www.cafepy.com/article/python_types_and_objects/images/relationships_transitivity.png


上图说明了 Transitivity of Relationships, 即:

* Dashed Arrow Up Rule : If X is an instance of A, and A is a subclass of B, then X is an instance of B as well.
* Dashed Arrow Down Rule : If B is an instance of M, and A is a subclass of B, then A is an instance of M as well.

乍看这文章, 貌似是越来越糊涂, 不过只要记住这个就ok:
Python中只分为types和Non-types, types等价于class,即type(xxx) == xxx.__class__, xxx的类型等于xxx的__class__属性, 所对应的类, 而Non-types==instance, 就是类的实例化,