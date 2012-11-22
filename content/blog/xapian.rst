Xapian
==============================

:date: 2009-07-28 13:06:48
:tags: Python

Xapian is an Open Source Search Engine Library, released under the GPL. It's written in C++, with bindings to allow use from Perl, Python, PHP, Java, Tcl, C# and Ruby (so far!)

ok, let's go!

Install
---------------------

* download xapian-core-1.0.13 and xapian-bindings-1.0.13, then compile them in general way.
* test xapian in python shell.

Usage
---------------------

It is very easy to use the api, like this:

    .. sourcecode:: python

        def job(self):
            try:
                now = datetime.now()
                last = now - timedelta(seconds=MakeIndex.run_every*60)
                new_dn = DN.objects.filter(createDate__gt=last, createDate__lte=now)
                if new_dn:
                   database = xapian.WritableDatabase(settings.SEARCH_INDEX_DB, xapian.DB_CREATE_OR_OPEN)   ## the database will be created if it is not exists.
                   stemmer = xapian.Stem("english")  ## the stemmer, can be none

                   for dn in new_dn:
                       name, oname, descrip, url = dn.name, dn.otherName.split(","), dn.domainDes, dn.get_absolute_url()
                       doc = xapian.Document()   ## new Document, like an object
                       doc.set_data(url)         ## set data, here i set the object's url
                       doc.add_value(0, name)    ## the value
                       doc.add_term(name.lower())## the term like features, no position info
                       for i in oname:
                          if i.strip():
                              doc.add_term(i.strip().lower())
                       pos = 1
                       for i in get_terms(descrip):
                           doc.add_posting(stemmer(i), pos) ## add term with position info
                           pos += 1
                       database.add_document(doc)           ## add the new document
            except Exception,e:
                print e

that's it, the indexer is ready. And then, is searching.

    .. sourcecode:: python

        keywords = keywords.strip()
        if not keywords:
            return HttpResponse('search')
        try:
            database = xapian.Database(settings.SEARCH_INDEX_DB)   ## get the database
            enquire = xapian.Enquire(database)                     ## This provides an interface to the ir system for searching
            stemmer = xapian.Stem("english")                       ## still the stemmer

            terms = [stemmer(term) for term in get_terms(keywords)]
            query = xapian.Query(xapian.Query.OP_OR, terms)        ## query class
            enquire.set_query(query)                               ## set query for searching
            mset = enquire.get_mset(0,10)                          ## return the match set
            return HttpResponse(MakoTemplate(templatename="search.htm",

                                             ruser=ruser,

                                             nexturl=urlquote(request.get_full_path()),
                                             mset = mset,

                                             ))
        except Exception,e:
            print e

        ## and the result in matchset is:
        ## 共有 ${mset.get_matches_estimated()} 个搜索结果

        ## {% for match in mset: %}
        ## <% doc = match[xapian.MSET_DOCUMENT] %>\
        ## ${match.rank}, ${doc.get_value(0)}, ${doc.get_data()}
        ## {% endfor %}

ok, it's done!!! my search engine. hhe

some links
------------------------

* http://www.xapian.org/docs/
* http://www.oschina.net/c/article/11205
* http://blog.csdn.net/visualcatsharp/archive/2009/05/13/4176083.aspx

ps: my poor poor...stupid english!!