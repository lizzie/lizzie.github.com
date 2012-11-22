Search and Tag
====================

:date: 2008-06-11 14:06:34
:tags: Python, GAE

今天把搜索，按日期和标签显示功能完成，但是效率不高，因为没有找到gae提供的api，所以我只能自己遍历寻找合适的。

.. sourcecode:: python

    def get_posts_by(request, different_entry, all_entry):

        # 所有Entry的分页显示
        paginator = ObjectPaginator(different_entry, 6)
        # 所有Entry取前5个
        some_entry = all_entry.order('-pub_date').fetch(5)
        # 所有tag
        all_tag = Tag.all()
        # 所有评论取前5个
        some_comment = Comment.all().order('-date').fetch(5)

        # 取得commentset不为空的Entry
        #for en in all_entry:
        #    if en.comment_set:
        #        some_entry.append(en)

        # 获得所有Links
        links = Links.all()

        try:
            # 获得对应页面
            page = int(request.GET.get('page', '1'))
            entry = paginator.get_page(page-1)
        except  InvalidPage:
            raise Http404
        return render_to_response("blog/main.html",{
                    'entry_list': entry,
                    'latest_entry_list': some_entry,
                    'is_paginated': paginator.pages > 1,
                    'has_next': paginator.has_next_page(page - 1),
                    'has_previous': paginator.has_previous_page(page - 1),
                    'current_page': page,
                    'next_page': page + 1,
                    'previous_page': page - 1,
                    'pages': paginator.pages,
                    'page_numbers': range(paginator.pages+1)[1:],
                    'comment_list': some_comment,
                    'tags': all_tag,
                    'link_list': links})

还有，似乎没有自动增1的选项，因为想把id自定义，而不是利用key.id，这样可以实现pre_entry和next_entry。

修改models，会把原来已存记录因为BadValue Exception而无法显示，所以以后改models得想想清楚了，不过，这样来，不用数据库更方便。

request中是否能够知道当前访问的url？