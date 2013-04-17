jQuery Note
================

:date: 2008-11-19 13:11:08
:tags: Javascript

要通过js实现请求后台数据显示到页面中, 但请求的数据中有js, 那么怎么样才能让新的js执行并显示正确?

1) 直接跳转页面, 这是最简单的

    .. sourcecode:: js

        $("#generate").click(function(){
                var data = "";
                $.each($("input[name='tabledata']"), function(i, n){
                    data += $(n).val()+","
                });
                var nametype = "";
                $.each($("input[name='nametype']"), function(i, n){
                    nametype += $(n).val()+","
                });
                window.location="/chart/?charttype="+$("#charttype").val()+"&rownum="+rownum+"&colnum="+colnum+"&data="+data+"&nametype="+nametype; //这种方法是请求后转入新的页面.
        });

    很简单只是跳转到目标页面了.

2) 嵌入页面, 使用iframe

    .. sourcecode:: js

        $("#generate").click(function(){
                var data = "";
                $.each($("input[name='tabledata']"), function(i, n){
                    data += $(n).val()+","
                });
                var nametype = "";
                $.each($("input[name='nametype']"), function(i, n){
                    nametype += $(n).val()+","
                });
                $("#showchart").append("<iframe src=/chart/?charttype="+$("#charttype").val()+"&rownum="+rownum+"&colnum="+colnum+"&data="+data+"&nametype="+nametype+" width=500 height=300>test</iframe>");
        });

    因为使用了iframe, 那么对应请求过来页面中有js会执行.

3) 动态执行JS, 也就是直接执行请求过来的js

    .. sourcecode:: js

        $("#generate").click(function(){
                var data = "";
                $.each($("input[name='tabledata']"), function(i, n){
                    data += $(n).val()+","
                });
                var nametype = "";
                $.each($("input[name='nametype']"), function(i, n){
                    nametype += $(n).val()+","
                });
                $.ajax({
                    url:"/chart/",
                    type: "POST",
                    data: "charttype="+$("#charttype").val()+"&rownum="+rownum+"&colnum="+colnum+"&data="+data+"&nametype="+nametype,
                    dataType: "script",
                    success: function(data, textStatus){
                        $("#loadimg").hide();
                        //$("#showchart").append(data);
                        alert(data);

                    },
                    beforeSend: function(){
                       $("#loadimg").show();
                    }
                });
        });

    这个在alert中显示出js代码, 但是如果仅仅将data append到对应位置上, 显示浏览器一直在请求状态. 因为js只能在页面加载时执行,像这样请求过来的数据中有js,就不能执行.要执行,只能用document.write()方法来重新加载.

    后来找到动态加载执行js, http://www.phpchina.com/html/70/3870-2182.html
    尝试以下两种方法:

    .. sourcecode:: js

        //一种方式
        $.ajax({
            url:"/chart/",
            type: "POST",
            data: "charttype="+$("#charttype").val()+"&rownum="+rownum+"&colnum="+colnum+"&data="+data+"&nametype="+nametype,
            dataType: "script",
            success: function(data, textStatus){
                $("#loadimg").hide();
                var jsCode = data;
                var jsIframe = document.createElement("iframe");
                jsIframe.style.display = "none";//把jsIframe隐藏起来
                document.body.appendChild(jsIframe);
                with(window.frames[window.frames.length - 1]){
                    document.open();
                    document.write(jsCode); //执行JS代码
                    document.close();
                }
            },
            beforeSend: function(){
               $("#loadimg").show();
            }
        });

        //另一种
        $.ajax({
            url:"/chart/",
            type: "POST",
            data: "charttype="+$("#charttype").val()+"&rownum="+rownum+"&colnum="+colnum+"&data="+data+"&nametype="+nametype,
            dataType: "script",
            success: function(data, textStatus){
                $("#loadimg").hide();
                var script=document.createElement("script");
                script.src=data;
                document.body.appendChild(script);
            },
            beforeSend: function(){
               $("#loadimg").show();
            }
        });

    这两种方法都不对, 都显示一直正在等待请求数据. 问题在哪呢???

4) 使用load可以是形如:

    .. sourcecode:: js

        $("#showchart").load("/chart/", {charttype:$("#charttype").val(), rownum:rownum, colnum:colnum,data:dat, nametype:nametype}, function(data){ alert(data); });

    可以动态加载页面数据

5) 后台处理时, 分开get和post, get请求的是html页面, 而post直接是javascript了.

    .. sourcecode:: python

        def get(self):
            charttype = self.request.get("charttype")
            rownum = int(self.request.get("rownum", 3))
            colnum = int(self.request.get("colnum", 4))
            data = self.request.get("data", '')
            nametype = self.request.get("nametype", '')

            if not charttype:
                self.response.out.write(template.render(os.path.join(os.path.dirname(__file__), 'templates/chart.html'), {}))
                return
            if not data or not nametype:
                self.response.out.write(template.render(os.path.join(os.path.dirname(__file__), 'templates/gen_chart.html'), {"table_string": self._generate_table_string(rownum, colnum), "charttype":charttype, "rownum":rownum, "colnum":colnum}))
                return

            self.response.out.write(template.render(os.path.join(os.path.dirname(__file__), 'templates/show_chart.html'), {"charttype":charttype, "charttypeclass":CHARTCLASS[charttype], "scriptstring":self._generate_script_string(rownum, colnum, data, nametype)}))

        def post(self):
            charttype = self.request.get("charttype")
            rownum = int(self.request.get("rownum", 3))
            colnum = int(self.request.get("colnum", 4))
            data = self.request.get("data", '')
            nametype = self.request.get("nametype", '')

            if not charttype or not data or not nametype:
                self.response.out.write(template.render(os.path.join(os.path.dirname(__file__), 'templates/chart.html'), {}))
                return

            self.response.headers['Content-Type'] = "application/x-javascript"
            scriptstring = '''
            <script type="text/javascript" src="http://www.google.com/jsapi"></script>
            <script type="text/javascript">
              google.load("visualization", "1", {packages:["%s"]});
              google.setOnLoadCallback(drawChart);
              function drawChart() {
                var data = new google.visualization.DataTable();
                %s
                var chart = new google.visualization.%s(document.getElementById('chart_div'));
                chart.draw(data, {width: 400, height: 240, legend: 'bottom', title: 'sometitle'});
              }
            </script>
            ''' % (charttype, self._generate_script_string(rownum, colnum, data, nametype), CHARTCLASS[charttype])
            self.response.out.write(scriptstring)
