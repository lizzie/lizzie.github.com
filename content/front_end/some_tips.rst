Some Tips
===================

:date: 2009-07-03 14:07:00
:tags: Python, Javascript


1) 生成缩略图时. 一般是保存原图, 之后直接生成缩略图保存. 网上很简单, 使用PIL的Image相关函数.

    比如, models中有个字段定义为:

    .. sourcecode:: python

        pic = models.ImageField(upload_to=settings.IMAGE_DIR) # 主要用于存放完整大图. 缩略图的话, 可以使用FilePathField来保存, 但我没有使用, 直接默认路径为IMAGE_DIR下的thumb目录. 然后在取路径时, 只需稍作处理就可以了.

    views中保存原始图片:

    .. sourcecode:: python

        pic = request.FILES.get("pic", None)
        newdn.pic.save(_get_upload_filename(pic.name, settings.IMAGE_DIR), pic) # 直接保存就行, django底层利用的是一个叫做InMemoryUploadedFile类来保存.
        _generate_thumb(settings.IMAGE_DIR, pic, fn)


    生成缩略图:

    .. sourcecode:: python

        def _generate_thumb(where, pic, fn):
            path = os.path.join(settings.MEDIA_ROOT, where, 'thumb')
            if not os.path.isdir(path):
                os.mkdir(path)
            try:
                pic.seek(0)
                image = Image.open(pic)
                image.thumbnail(_get_is(image.size), Image.ANTIALIAS)

                image.save(os.path.join(path, fn), image.format)
            except Exception,e:
                print e

    之前没写pic.seek(0) 导致一直产生错误: cannot identify image file, 后来找了半天才明白, 原来在先前保存大图时, pic文件指针读取已到文件末尾, 所以接下去再读的时候, 就不能读取任何信息了. 所以报这个错误.

2) models中的默认值. 对于某个field加了auto_now_add的选项之后, 有个好玩的问题. 比如

    .. sourcecode:: python

        startDate = models.DateTimeField(auto_now_add=True)    # 开始时间


    然后对于新建的一个x= X()之后, 再x.createDate = newDate, 然后保存x.save(), 会:

    x仍然是之前的auto_now_add的值. 解决办法: 索性去掉auto_now_add, 但这样对于没有输入createDate来说的话,就是None值.

    或者x=X(); x.save(); x.createDate = newDate; 再x.save(); 也就是傻不拉唧的保存俩次.


3) js中, 去掉字符串两端空格, 可以使用

    .. sourcecode:: js

        String.prototype.trim = function() { return this.replace(/(^\s*)|(\s*$)/g, ""); }
        // 后来发现可以直接使用 $j.trim(" some string ");

貌似还有些...不过忘了, 算了, 记得再添加吧～