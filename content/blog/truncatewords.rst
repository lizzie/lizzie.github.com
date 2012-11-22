truncatewords
=================

:date: 2008-06-20 14:06:43
:tags: GAE, Python

Django模板中 truncatewords 对中文失效的替代方法：

1) 使用slice

.. sourcecode:: html

    <li>
    {% if com.website %}
             <a href="{{ com.website }}">{{ com.author }}</a> says:
    {% else %}
               {{ com.author }} says:
    {% endif %}
              <a href="/blog/post/{{ com.post.key.id }}#cmt_form">{{ com.body|escape|linebreaks|slice:":40" }}...</a>
    </li>

2) 牛人们的项目 code.google.com/p/pyzh --有中文折行的模块