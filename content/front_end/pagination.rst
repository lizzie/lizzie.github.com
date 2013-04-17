Pagination
===================

:date: 2009-05-02 14:05:39
:tags: Python

Django的0.96中的ObjectPaginator, 在Django1.0中换成了Paginator.
Paginator使用记录下:

.. sourcecode:: python

    ## view.py
        p = Paginator(mylist, settings.PAGE_NUM)
        try:
            page = int(request.GET.get('page', '1'))
            cp = p.page(page)
        except  InvalidPage:
            raise Http404
        return HttpResponse(MakoTemplate(templatename="bulletin.htm",
                                         current_page=cp,
                                         totalpage=p.num_pages,
                                         currentpage=page,
                                         ))

    ## cp对象一些方法:
    current_page.has_previous()  # 是否具有先前页面
    current_page.previous_page_number()  # 先前页面号码
    current_page.has_next()      # 是否具有接下来的页面
    current_page.next_page_number()      # 接下来的页面号码
    current_page.object_list     # 获得当前页面上的对象


具体见Django的 `Paginator文档 <http://docs.djangoproject.com/en/dev/topics/pagination/>`_