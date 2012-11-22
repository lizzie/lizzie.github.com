GAE Error II
================

:date: 2008-11-19 13:11:08
:tags: GAE, Python

今天又碰到些GAE中奇怪的错误,整理如下:

1) 在本地gae_sdk中,保存数据记录时,总是会先出现

::

    TypeError at /code/save/ coercing to Unicode: need string or buffer, NoneType found

下面是一大堆...GET POST 都没有数据显示,,,但是在view中测试request的确有数据值

刷新页面n次都没有用,但是奇怪的是将后台./dev_appserver.py 关掉,再开,再刷新刚才的保存页面,重新发送数据后终于可以转入正常了...这个奇怪现象一直出现,尤其是,,,因为本地数据库中内容存不了多长时间,似乎隔了一天,数据就没了,然后得重新保存测试数据到数据库,这时就会出现这个错误...而之后就不会.

这在以前的sdk上没有碰到这个问题,难道是更新了的sdk的bug??

2)上传时

::

    File "/usr/lib/python2.5/httplib.py", line 349, in _read_status
    raise BadStatusLine(line)
    httplib.BadStatusLine

总是出现这个错误,,,上传了多次终于ok,怀疑这个错误是不是网络不好导致?找到别人也提出的问题 http://www.nabble.com/-CPyUG:58906--%E3%80%90GAE%E3%80%91%E7%96%AF%E4%BA%86-appcfg%E6%80%8E%E4%B9%88%E6%8A%A5%E8%BF%99%E6%A0%B7%E7%9A%84%E9%94%99-td18424778.html
上面说"子文件夹的内容放到外面就好了",似乎不是吧....

3)有关index.yaml

这个也是有关数据库表的一个索引文件,由于频繁出现上述Httplib.BadStatusLine错误,以为是本地哪个文件上传时出现问题,于是乎找./app_cfg --help里面看到个vacuum_indexes: Delete unused indexes from application.这句话,手痒似的就输入了...后才发现错了...进入这个网站页面报

::

    NeedIndexError at /code/
    no matching index found. This query needs this index: - kind: CEntry properties: - name: pub_date direction: desc

明显是缺少索引文件,,,又看到admin logs中出现一行:


::

    10/20/08 03:44:14 shengyan1985@gmail.com Deleted 7 indexes kinds=CEntry, CTodayWords, Comment, Entry, Greeting, TodayWords

这个就是我刚才所作的错误操作,删除全部索引导致,,,最终只能乖乖在index.yaml中加入:

::

    # Used 3 times in query history.
    - kind: Entry
      properties:
      - name: pub_date
        direction: desc
    ...类似的,一定要注意格式,不然又报yaml parser错误.

其实这个文件是自动更新的,在本地sdk上运行时,对测试的数据库进行索引,主要是些表中自动增加的字段.但我记得以前我把整个文件清空再上传都没有问题,也一直以为这个index对真正数据库中没有关系,现在看来我又错了.

4)加入google analytics,这个比较简单,只要设置下增加这个网站url,并在基本页面中的body之前加入一段javascript,如:

.. sourcecode:: html

    <script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
    var pageTracker = _gat._getTracker("UA-4419044-2");
    pageTracker._trackPageview();
    </script>



5)

::

    File "/usr/lib/python2.5/pickle.py", line 1374, in loads return Unpickler(file).load()
    File "/usr/lib/python2.5/pickle.py", line 858, in load dispatch[key](self)
    KeyError: '\x00'

找到原因说 http://code.google.com/p/googleappengine/issues/detail?id=417

::

    Most likely the problem is that you should not be storing pickled data in Text properties -- you should use Blob properties.

解决方法, 就是将之前Text类型换成Blob,
但是程序中使用的pickle.loads()的参数应该是字符串类型的,
loads(string) -> object, 那为什么要成Blob二进制文件呢?

6)

GAE中本地文件上传文件大小最大为1MB, 所以当有超过1MB的文件时会出现

::

    2008-11-17 18:59:54,756 ERROR appcfg.py:1031 Ignoring file 'lib/wordnet3.0/dict/index.noun': Too long (max 1048576 bytes, file is 4786655 bytes)
    ...

那么,如何将超过1MB的文件保存到GAE服务器上呢?