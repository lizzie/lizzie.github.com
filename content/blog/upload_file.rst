Upload Files
===================

:date: 2009-05-01 13:05:07
:tags: Python


在django中, 实现上传文件或图片相关步骤:

1) models中

    .. sourcecode:: python

        class PhotoRecommend(models.Model):
            pic = models.ImageField(upload_to=settings.PHOTORECOMM_IMAGE_DIR)   # 图片

        # settings中的PHOTORECOMM_IMAGE_DIR = 一个文件夹, 或者路径, 如'photos', 就是需要将文件存放在哪里的路径
        # 另外还需设置变量
        MEDIA_ROOT = '/home/shengyan/media/tmpimages/'  ##　这个为上传后文件所在的物理基位置

        MEDIA_URL = 'http://127.0.0.1:8000/site_media/tmpimages/' ## 为文件的访问基位置


2) views中

    .. sourcecode:: python

        try:
            oldpicpath = None
            if not prid:
                pr = PhotoRecommend()
            else:
                pr = PhotoRecommend.objects.get(id=prid)
                # 待删除原有的图片
                oldpicpath = pr.pic.path

            placeid = request.POST.get("placeid", None)
            url = request.POST.get("url", None)
            pr.placeid = int(placeid)
            pr.url = url

            pic = request.FILES.get("pic", None)
            if not pic:
                raise Exception, "请上传图片"
            pr.pic.save(pic.name, pic)        ## 主要是这句话, 可以将pic存储到MEDIA_ROOT/upload_to/这个位置, 并可以自动获得path, url等
            pr.save()

            if oldpicpath:
                try:
                    os.remove(oldpicpath)
                except Exception,e:
                    print e
            return HttpResponseRedirect("/admin/photoRecommend/")
        except Exception,e:
            return HttpResponse(e)


    在pr.pic.save之前, 我采用上传文件函数, 如:

    .. sourcecode:: python

        def _handle_uploaded_file(myfile, where):
            """上传文件处理
            """
            import os
            import random
            import settings

            where = os.path.join(settings.MEDIA_ROOT, where)
            if not os.path.isdir(where):

                os.mkdir(where)

            if myfile.size>1048576:
                return False
            dot_index = myfile.name.rfind('.')
            fn = myfile.name
            if os.path.isfile(os.path.join(where, myfile.name)):
                fn = myfile.name[:dot_index]+'_'+str(random.randint(0, 100))+myfile.name[dot_index:]
            des = open(os.path.join(where, fn), 'wb+')
            for chunk in myfile.chunks():
               des.write(chunk)
            des.close()

    这样是可以将文件保存到指定位置, 而且也可以重新命名文件, 但这样做以后, 使得稍后的pr.pic.path和pr.pic.url都只有MEDIA_ROOT/filename, 而没有放到upload_to中,,,,页面中所以无法找到...后来才知道, 不需自己写上传函数, 直接用pr.pic.save, 具体可以参考http://scottbarnham.com/blog/2008/08/25/dynamic-upload-paths-in-django/

3) 另外, upload_to可以是一个函数, 这样就可以自己定义文件路径, 动态的. 网上有很多资料, 如 `资料1 <http://oteam.cn/2008/10/4/dynamic-upload-paths-in-django/>`_, `资料2 <http://www.joshourisman.com/2008/11/18/dynamic-upload-path-django-filefieldimagefield/>`_, `资料3 <http://pandemoniumillusion.wordpress.com/2008/08/06/django-imagefield-and-filefield-dynamic-upload-path-in-newforms-admin/>`_, `资料4 <http://www.blogjava.net/rain1102/archive/2009/04/03/263806.html>`_, 总结一下子的话, 比较好的做法就是继承ImageStorage或者ImageField, 重载相关方法符合自己需要即可.

4) Django中相关文档链接

    * http://docs.djangoproject.com/en/dev/topics/files/
    * http://docs.djangoproject.com/en/dev/ref/models/fields/#imagefield
