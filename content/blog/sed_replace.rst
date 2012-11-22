SedReplace
===================

:date: 2009-05-15 05:05:53
:tags: Other


将某目录下的一批文件中的某个单词替换成另一个单词, 之前碰到过, 忘了在哪了, 现记录下.

.. sourcecode:: bash

    for i in `ls | grep -vE "converted\.sh"`
    do
        echo $i
        sed -e 's/\.\.\/_static\/doctools\.js/\/site_media\/\js\/pymotw\/doctools\.js/g' $i > a
        mv a $i
    done


网上找到另一种一句命令就能搞定的方法:

.. sourcecode:: bash

    find -name *.html -type f | xargs perl -pi -e 's|xxxxxxx|yyyyyyyy|'

ok