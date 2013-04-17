HPWS 11
===================

:date: 2009-04-06 13:04:10
:tags: Javascript, note

Rule 12: Remove Dupicate Scripts

去除重复的脚本

两个导致重复脚本产生可能性增加的因素是: team size and numbers of scripts. 前一个是说开发团队的大小, 这很能想象出, 如果多个人合作开发一个网站, 虽然负责的不同的部分, 但比如说两个人同时需要对一个html文件中加入不同的东西, 而这可能用到同样的一个js文件, 一个人可能不会意识到另外一个人也包含了相关脚本.

Duplicate Scripts Hurt Performance

1) unnecessary HTTP requests. 对于IE来说, 如果一个脚本包含两次而且没被缓存, 那么会产生两次HTTP请求. 但在ff中是不会的.
2) wasted JavaScript execution.

    * Including the same script multiple times in a page makes it slower.
    * In IE, extra HTTP requests are made if the script is not cacheable or when the page is reloaded.
    * In both Firefox and IE, the script is evaluated multiple times.

Avoiding Duplicate Scripts

to implement a script management module in your templating system. 就是说利用模板, 判断是否已经包含这个脚本了, 另外还有脚本之间的依赖关系(capture these dependencys using hash or database 或者如果规模小的话, 可手工定义. for more complex sites, you may choose to automate the generation of dependencies by scanning the scripts to find symbol definitions).

在各个脚本文件名字中, 推荐加入版本信息. 一个php的例子代码

.. sourcecode:: php

    <?php
    function insertScript($jsfile){
        if (alreadyInserted($jsfile)) {
            return;
        }
        pushInserted($jsfile);
        if (hasDependencies($jsfile)) {
            $dependencies = getDependencies($jsfile);
            foreach ($dependencies as $script) {
                insertScript($script);
            }
        }
        echo '<script type="text/javascript" src=""'.getVersion($jsfile).'"></script>";
    }
    ?>



Make sure scripts are included only once