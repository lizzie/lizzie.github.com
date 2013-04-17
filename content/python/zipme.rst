Zipme
=============================

:date: 2008-06-25 14:06:47
:tags: GAE, Python

将GAE站点的代码打包成zip包并下载，这就可以定期保存站点代码。因为GAE不提空版本控制，每次更新只保存最新代码。

来自：http://xuming.net/2008/06/gae-zipme.html
`源码下载 <http://manatlan.com/blog/zipme___download_sources_of_your_gae_website__as_a_zip_file>`_ 不过这个链接我上不去。所以直接用一下代码：

.. sourcecode:: python

    #!/usr/bin/env python
    # -*- coding: UTF-8 -*-
    """
    ##########################################################################
    ZipMe : GAE Content Downloader                                                            # manatlan
    ##########################################################################
    Just add this lines in your app.yaml :

    - url: /zipme
      script: zipme.py

    ##########################################################################
    """

    from google.appengine.ext import webapp
    from google.appengine.api import users

    import wsgiref.handlers
    import zipfile
    import os,re,sys,stat
    from cStringIO import StringIO

    def createZip(path):

        def walktree (top = ".", depthfirst = True):
            names = os.listdir(top)
            if not depthfirst:
                yield top, names
            for name in names:
                try:
                    st = os.lstat(os.path.join(top, name))
                except os.error:
                    continue
                if stat.S_ISDIR(st.st_mode):
                    for (newtop, children) in walktree (os.path.join(top, name),
                                                        depthfirst):
                        yield newtop, children
            if depthfirst:
                yield top, names

        list=[]
        for (basepath, children) in walktree(path,False):
              for child in children:
                  f=os.path.join(basepath,child)
                  if os.path.isfile(f):
                        f = f.encode(sys.getfilesystemencoding())
                        list.append( f )

        f=StringIO()
        file = zipfile.ZipFile(f, "w")
        for fname in list:
            nfname=os.path.join(os.path.basename(path),fname[len(path)+1:])
            file.write(fname, nfname , zipfile.ZIP_DEFLATED)
        file.close()

        f.seek(0)
        return f

    class ZipMaker(webapp.RequestHandler):
        def get(self):
            if users.is_current_user_admin():
                folder = os.path.dirname(__file__)
                self.response.headers['Content-Type'] = 'application/zip'
                self.response.headers['Content-Disposition'] = 'attachment; filename="%s.zip"' % os.path.basename(folder)
                fid=createZip(folder)
                while True:
                    buf=fid.read(2048)
                    if buf=="": break
                    self.response.out.write(buf)
                fid.close()
            else:
                self.response.headers['Content-Type'] = 'text/html'
                self.response.out.write("<a href=\"%s\">You must be admin</a>." %
                                        users.create_login_url("/zipme"))

    def main():
        application = webapp.WSGIApplication(
                                           [('/zipme', ZipMaker)],
                                           debug=False)
        wsgiref.handlers.CGIHandler().run(application)

    if __name__ == "__main__":
        main()

根据这段代码，新进一个py脚本，放上代码，并修改app.yaml如代码首部。就OK了。

另外，看了下代码，有些可以改进的地方，比如说遍历站点文件夹的方式，明明可以用walk的。不过，一个很巧妙的地方是，因为GAE不支持写文件，那么file = zipfile.ZipFile(f, "w")这个是用"w"方式的，这个f不是物理文件，而是用了StringIO，所以就可以实现了。

::

    StringIO(...)
        StringIO([s]) -- Return a StringIO-like stream for reading or writing

再另外，下载下来的zip文件夹对比本地的工程文件夹，还是有区别的。

首先，zip文件夹下文件都变成只读文件。这估计是GAE上是只读的。

其次，.pyc都不会上传。

最后，media文件夹没有打包，是因为GAE上真正没有放在工程目录下而是放在别的地方，还是因为上述代码中的walktree没有生成？越看walktree越别扭。——测试 http://lizziesky.appspot.com/test/ 得到目录结构就是不包含media文件夹的，估计是放在别的地方了。