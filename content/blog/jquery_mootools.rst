jQuery and Mootools
=========================

:date: 2009-02-26 13:02:14
:tags: Javascript

jQuery 和 Mootools的冲突, 当同时使用两个库(还有其他的库)时, 会产生冲突, 也就是会只有一个库产生效果. 其主要是由于各库的命名空间产生冲突, 一些全局对象定义冲突, 特别是变量"$", 更详细的原因 http://www.javaeye.com/topic/84683

解决方法: http://hi.baidu.com/beyondwebstudio/blog/item/e39105a8dc1ddefb1f17a27c.html

方式一:

.. sourcecode:: html

    <html>
    <head>
         <script src="prototype.js"></script>
         <script src="jquery.js"></script>
         <script>
           jQuery.noConflict();

          // Use jQuery via jQuery(...)
           jQuery(document).ready(function(){
             jQuery("div").hide();
           });

          // Use Prototype with $(...), etc.
           $('someid').style.display = 'none';
         </script>
     </head>
     <body></body>
     </html>


方式二:

.. sourcecode:: html

     <html>
     <head>
         <script src="prototype.js"></script>
         <script src="jquery.js"></script>
         <script>
           var $j = jQuery.noConflict();

          // Use jQuery via $j(...)
           $j(document).ready(function(){
             $j("div").hide();
           });

          // Use Prototype with $(...), etc.
           $('someid').style.display = 'none';
         </script>
     </head>
     <body></body>
     </html>


方式三：

.. sourcecode:: html

    <html>
    <head>
         <script src="prototype.js"></script>
         <script src="jquery.js"></script>
         <script>
           jQuery.noConflict();

          // Put all your code in your document ready area
           jQuery(document).ready(function($){
            // Do jQuery stuff using $
             $("div").hide();
           });

          // Use Prototype with $(...), etc.
           $('someid').style.display = 'none';
         </script>
     </head>
     <body></body>
     </html>

