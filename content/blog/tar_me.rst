TARME
============

:date: 2008-06-27 14:06:30
:tags: Python, GAE

模仿昨天的ZipMe，写了个TarMe用来保存数据库中的数据。本来照着ZipMe中的使用ZipFile，具体用了ZipFile.writestr，但是结果保存下来的zip文件无法打开，错误为

::

    bad CRC 98daad55  (should be cb648565)

后来直接不用压缩，直接保存txt得了。具体如下

.. sourcecode:: python

    #!/usr/bin/env python
    # -*- coding: UTF-8 -*-
    """
    ##########################################################################
    TarMe : GAE DataBase Content Downloader                                                            # lizzie
    ##########################################################################
    Just add this lines in your app.yaml :

    - url: /tarme
      script: tarme.py

    ##########################################################################
    """

    from google.appengine.ext import webapp
    from google.appengine.api import users

    import wsgiref.handlers
    #import zipfile
    import os
    from cStringIO import StringIO

    from myblog.models import Entry
    from myblog.models import Comment

    import sys     #之前同样出现编码问题，因为Entry中保存时使用utf-8
    reload(sys)
    sys.setdefaultencoding('utf8')

    def createZip(all_flag):
        """保存数据库中全部数据
        @param all_flag: 表示是否全部都保存
        @type all_flag: bool, True表示全部，False表示部分，现在没有用到
        @todo: 现在是全部数据库中保存，以后分类或部分存储
        """
        #f = StringIO()
        #file = zipfile.ZipFile(f, "w")
        all_entry = Entry.all().order("-pub_date")
        all_comment = Comment.all().order("-date")

        all_str = ''
        for e in all_entry:
            #e_str = "Entry Name: %s\nPublic Time: %s\nTags: %s\n%s\n%s\n%s\n\n" % (e.title, e.pub_date, e.tags, '='*20, e.body, '='*40)
            #nfname = 'post'+str(e.key().id())
            #file.writestr(nfname, e_str)
            all_str += "Entry Name: %s\nPublic Time: %s\nTags: %s\n%s\n%s\n%s\n\n" % (e.title, e.pub_date, e.tags, '='*20, e.body, '='*40)

        #c_str = ' '
        for c in all_comment:
            #c_str += "Comment To Post: %s\nAuthor: %s\nEmail:%s\nWebsite:%s\nDate: %s\n%s\n%s\n%s\n\n" % (c.post.title, c.author, c.email, c.website, c.date, '+'*20, c.body, '+'*40)
            all_str += "Comment To Post: %s\nAuthor: %s\nEmail:%s\nWebsite:%s\nDate: %s\n%s\n%s\n%s\n\n" % (c.post.title, c.author, c.email, c.website, c.date, '+'*20, c.body, '+'*40)

        return all_str
        #file.writestr('all_comment', c_str)
        #file.close()

        #f.seek(0)
        #return f

    class TarMaker(webapp.RequestHandler):
        def get(self):
            if users.is_current_user_admin():
                self.response.headers['Content-Type'] = 'text/txt'
                self.response.headers['Content-Disposition'] = 'attachment; filename="tarme.txt"'
                self.response.out.write(createZip(True))
                return

                fid = createZip(True)
                while True:
                    buf = fid.read(2048)
                    if buf == "": break
                    self.response.out.write(buf)
                fid.close()
            else:
                self.response.headers['Content-Type'] = 'text/html'
                self.response.out.write("&lt;a href=\"%s\">You must be admin&lt;/a>." %
                                        users.create_login_url("/tarme"))

    def main():
        application = webapp.WSGIApplication(
                                           [('/tarme', TarMaker)],
                                           debug=False)
        wsgiref.handlers.CGIHandler().run(application)

    if __name__ == "__main__":
        main()


另外，看到个判断当前用户是否是admin可以使用users.is_current_user_admin()。