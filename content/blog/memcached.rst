Memcached
================

:date: 2009-09-16 05:09:57
:tags: Life


# libevent, http://www.monkey.org/~provos/libevent/


::

    ls /usr/local/lib/libevent-1.4.so.2

# memcached, http://danga.com/memcached/


::

    ./configure --with-libevent=/usr/local/lib
    make
    sudo make install

# memcached -d -m 100 -l 127.0.0.1 -p 11211
###memcached: error while loading shared libraries: libevent-1.4.so.2: cannot open shared object file: No such file or directory

# python-binding http://gijsbert.org/cmemcache/
# libmemcache-1.4.0 http://people.freebsd.org/~seanc/libmemcache, 这边需要patch
#wget http://people.freebsd.org/~seanc/libmemcache/libmemcache-1.4.0.rc2.tar.bz2
#tar xvfj libmemcache-1.4.0.rc2.tar.bz2
#cd libmemcache-1.4.0.rc2/
#wget --no-check-certificate https://svn.pardus.org.tr/pardus/devel/programming/libs/libmemcache/files/libmemcache.patch
#patch -p1 < libmemcache.patch

::

    sudo apt-get install automake1.9
    ./configure && make
    sudo make install

# cmemcache

::

    sudo python setup.py install

## 如果上面的libmemcache没打补丁的话, 会出现下面的错误:

::

    >>> import cmemcache
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
      File "/usr/lib/python2.5/site-packages/cmemcache.py", line 60, in <module>
        from _cmemcache import StringClient
    ImportError: /usr/local/lib/libmemcache.so.0: undefined symbol: mcm_buf_len


settings的

.. sourcecode:: python

    CACHE_BACKEND = 'memcached://127.0.0.1:11211/?timeout=60'
    MIDDLEWARE_CLASSES = (
    "django.middleware.cache.CacheMiddleware",
    #...
    }
    # CACHE_MIDDLEWARE_SECONDS 每页缓存时间, 默认为600
    # CACHE_MIDDLEWARE_KEY_PREFIX 默认为空


# 启动memcached

::

    memcached -d -m 100 -l 127.0.0.1 -p 11211 # 127.0.0.1:11211 占用100mb内存，作为守护进程