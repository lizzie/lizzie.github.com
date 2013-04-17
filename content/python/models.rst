Models中的唯一性
====================

:date: 2008-06-17 13:06:50
:tags: Python, GAE


GAE中的key是唯一的，具有id，一般可以通过obj.key().id()得到对应唯一的id数。

之前文章也说了，pre_entry和next_entry根据什么来实现。今天终于解决。
首先，看到GAE讨论上关于自动增1：

::

    [google-appengine] Auto increment
    Do you really need this? Remember, an autoincrement means every new
    table row has to hit this one field - a situation which won't scale
    well.
    Consider these alternatives:
    * Use the automatically-assigned key for the object (probably the
    easiest method)
    * Use a random string
    * Use some timestamp-derived key (timestamp, then random hash to
    prevent collisions)
    If you really, really, truly, absolutely need autoincrement, you could
    do it by creating some special model for sequence numbers, then
    increment it and return the new value in a transaction. However I
    again stress that this is almost certainly not what you really want,
    and won't scale well.
    //////////////////
    Every entity has a unique key, in your templates you can use {{ entity.key }}:

    <a href="/path?key={{entity.key}}">link</a>

    in the request handler you can get the entitiy with:

    def get(self):
       key = self.request.get('key')
       entity = db.get(db.Key(key)) #or entity = ModelName.get(db.Key(key))

    ///////////////////
    lrk = Lyrics.get(lrkid)


知道没有多大必要自己去解决自动增1。那么pre_entry和next_entry即可利用本身pub_date实现

::

    # 找当前entry的前继和后续
    pre_entry = None
    next_entry = None
    pub_entry_list = list(all_entry.order("-pub_date"))
    entry_count = len(pub_entry_list)
    for index in range(entry_count):
        if pub_entry_list[index].key().id() == onepost.key().id():
            if index < entry_count-1:
                pre_entry = pub_entry_list[index+1]
            if index > 0:
                next_entry = pub_entry_list[index-1]


这个速度是很慢的，不知道有没更好的方法？

突然发现，new一个entry时，点击已有标签，文章标签输入中没有出现，奇怪了。