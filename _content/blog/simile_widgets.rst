Simile Widgets
===================

:date: 2010-06-25 11:06:14
:tags: Javascript

介绍个生成数据图的开源js库----simileWidgets

* website: http://www.simile-widgets.org/
* Google Code: http://code.google.com/p/simile-widgets/
* timeplot入门: http://www.simile-widgets.org/timeplot/docs/

simile-widgets不比google visualization api差多少, 而且画出的图更加漂亮些. 但是期间会加载很多js文件,,所以反应比较慢.

里面的timeline倒是有loadJSON方法, 但我使用的timeplot居然没实现..所以只能增加loadJSON方法, 可以扩展原来的timePlot, 如下代码, Timeplot的loadJson和Timeplot.DefaultEventSource的loadJSON可以独立起来, 就是如果不想用Timeplot的ajax请求, 自己获得一段json数据, 就可以直接实现Timeplot.DefaultEventSource的loadJSON,, 话说只扩展后者, 这样更加方便.
详细例子可见 http://www.ericmmartin.com/traffic-charts-for-my-commute/

.. sourcecode:: js

    /* Extend Timeplot functions */

    /*
     * Mimic the timeplot.loadText function
     * - Only needed to change eventSource.loadText to eventSource.loadJSON
     */
    Timeplot._Impl.prototype.loadJSON=function(url,separator,eventSource,filter){
        if(this._active){
            var tp=this;

            var fError=function(statusText,status,xmlhttp){
                tp.hideLoadingMessage();
                $('#my-timeplot').empty().html("<span class='error'>Failed to load JSON data from "+url+". Error: "+statusText+"</span");
            };

            var fDone=function(xmlhttp){
                try{
                    if(xmlhttp.responseText.replace(/(\[|\])/g,'').length>0){
                        eventSource.loadJSON(xmlhttp.responseText,separator,url,filter);
                    }
                    else {
                        $('#my-timeplot').empty().html("<span class='error'>No data found</span>");
                    }
                }catch(e){
                    SimileAjax.Debug.exception(e);
                }finally{
                    tp.hideLoadingMessage();
                }
            };

            this.showLoadingMessage();
            window.setTimeout(function(){SimileAjax.XmlHttp.get(url,fError,fDone);},0);
        }
    }

    /*
     * Mimic the eventSource.loadText function
     * - Do not parse all data, only the JSON value when creating an evt
     * - Parse the JSON into an Object
     */
    Timeplot.DefaultEventSource.prototype.loadJSON=function(jsonText,separator,url,filter){
        if(jsonText==null){
            return;
        }

        var data = jsonText.parseJSON(); // 依赖json.js

        this._events.maxValues=new Array();
        var base=this._getBaseURL(url);

        var dateTimeFormat='iso8601';
        var parseDateTimeFunction=this._events.getUnit().getParser(dateTimeFormat);

        var added=false;

        if(filter){
            data=filter(data);
        }

        if(data){
            for(var i=0;i<data.length;i++){
                var row=data[i];
                if(row.date){
                    var evt=new Timeplot.DefaultEventSource.NumericEvent(
                        parseDateTimeFunction(row.date),
                        this._parseJSONValue(row.value,separator)
                    );
                    this._events.add(evt);
                    added=true;
                }
            }
        }

        if(added){
            this._fire('onAddMany',[]);
        }
    }

    /*
     * Turn the JSON value into an array so that it can be correctly processed
     * by Timeplot
     */
    Timeplot.DefaultEventSource.prototype._parseJSONValue=function(value,separator){
        value=value.replace(/\r\n?/g,'\n');
        var pos=0;
        var len=value.length;
        var line=[];
        while(pos<len){
            var nextseparator=value.indexOf(separator,pos);
            var nextnline=value.indexOf('\n',pos);
            if(nextnline<0)nextnline=len;
            if(nextseparator>-1&&nextseparator<nextnline){
                line[line.length]=value.substr(pos,nextseparator-pos);
                pos=nextseparator+1;
            }else{
                line[line.length]=value.substr(pos,nextnline-pos);
                pos=nextnline+1;
                break;
            }
        }
        if(line.length<0)return;
        return line;
    }



用用还是不错的,,,如果自己写就够呛了.^-^


条状bar, 内容空的div, 只设置高度/宽度的话, 设置背景色使其成为一个长条状时, ie6下需要注意, 也要将其font-size设为0, 不然会多出font-size的高度, 虽然里面没有字, 但还是会被撑开了.