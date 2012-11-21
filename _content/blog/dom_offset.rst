DOM.offset
=======================

:date: 2010-09-12 11:09:50
:tags: Javascript, KISSY


DOM中位置/高宽基础
-----------------------------

从外到内, 浏览器支持移步见 http://www.quirksmode.org/dom/w3c_cssom.html:

.. image:: https://cacoo.com/diagrams/dWWGTqryaNfi9MWr-58098.png

screen
-----------------------------

screen.width/height : 屏幕宽高度(同屏幕分辨率), 如1280/1024, 如上图中 a;
screen.availWidth/availHeight: 屏幕可用宽高度, 去除菜单栏,任务栏等的, 如1280/984, 如上图中 b;
screen.colorDepth: 屏幕色深(位), 如32;
screen.pixelDepth: 同上, 但IE不支持, 他与colorDepth的区别在于一些老的X-client允许应用程序自定义颜色语法, 那么他的colorDepth就取决于应用程序自己, pixelDepth则一直是显示器颜色位数;


window
-----------------------------

IE下都为undefined;
window.innerWidth/innerHeight: 浏览器窗口内部宽高, 如1280/899, 如上图中 c 框的宽高;
window.outerWidth/outerHeight: 整个浏览器窗口宽高, 包括任务菜单栏, 如窗口最大化时,1296/1000, 会超过屏幕宽度, 如上图中 d 框的宽高;
window.pageXoffset/pageYoffset: 整个页面被滚动掉的像素数, 当出现滚动条并且被滚动区域的X/Y偏移, 如pageYoffset对应上图中 e 高度;
window.screenX/screenY: 浏览器窗口在屏幕上的位置, 相对于左上角, 可能是负值, opera下不正确, 如上图点f在屏幕上的位置;

另外一些window相关的方法:

1) window.resizeTo(x,y) : 重设窗口宽高;
2) window.moveTo(x, y) : 移动到某位置;
3) window.focuse() : 使窗口获得焦点;
4) window.scroll(x,y)/scrollTo(x, y) : 窗口滚动到指定x,y距离;
5) window.onload = ... : window加载完毕后;


document/element
-----------------------------

document.elementFromPoint(x, y): 获取文档上x,y坐标点对应的元素;
document.documentElement.clientWidth/clientHeight: 文档内容的宽和高;
document.documentElement.scrollTop/scrollLeft: 文档滚动了多少;

elem.getBoundingClientRect(): 获得元素相对于 viewport 的区域, left, top, right, bottom围城的区域, 包含元素边距和边框的;
elem.getClientRects(): 同上类似, 但可以获得这个elem内所有子 box 的区域;
elem.scrollIntoView(): 将elem滚动到可视区域;

elem.clientLeft/clientTop: 元素的内容左上角相对于整个元素左上角位置,(包含边框), 如上图 g处;
elem.clientWidth/clientHeight: 不包含边框边距的内容宽高, 但有包含滚动条, 如上图 h 虚线框;
elem.offsetLeft/offsetTop: 相对于 OffsetParent 的左上角位置, 如上图 i 位置;
elem.offsetParent: 包含这个元素的父元素的位置, 这个父元素的position不能是 static, 如果不幸父元素们都是static, 就用body;
elem.offsetWidth/offsetHeight: 元素的整个宽高, 包含边框, 如上图 j 框宽高;
elem.scrollLeft/scrollTop: 元素滚动了多少像素, 可读写;
elem.scrollWidth/scrollHeight: 内容宽高, 包含被overlfow:hidden掉的内容, 如果没有隐藏掉, 和clientWidth和clientHeight一致;


e
-----------------------------

e.clientX/clientY: 相对于 viewport 的位置, 如上图 k;
e.offsetX/offsetY: 相对于 触发事件的目标元素的位置, 如上图 m;
e.pageX/pageY: 相对于 document 的位置, 如上图 n;
e.screenX/screenY: 相对于 屏幕 位置, 如上图 o;
e.x/y: 同 clientX/clientY;


S.DOM.offset
-----------------------------

再来看 KISSY.DOM 是怎么实现的.

dom-offset.js http://github.com/kissyteam/kissy/blob/master/src/dom/dom-offset.js

DOM.scrollLeft / scrollTop 方法

    .. sourcecode:: js

        S.each(['Left', 'Top'], function(name, i) {
            var method = SCROLL + name;

            DOM[method] = function(elem) {
                var ret = 0, w = getWin(elem), d;

                if (w && (d = w[DOCUMENT])) {
                    ret = w[i ? 'pageYOffset' : 'pageXOffset']
                        || d[DOC_ELEMENT][method]
                        || d[BODY][method]
                }
                else if (isElementNode((elem = S.get(elem)))) {
                    ret = elem[method];
                }
                return ret;
            }
        });

* 如果是 window , 使用的是 window.pageXOffset/pageYOffset, 但IE下是undefined, 所以使用document.documentElement.scrollTop/scrollLeft (strict DOCTYPE) 或者 document.body.scrollTop/scrollLeft ( transitional DOCTYPE), 两者根据 DTD 的不同各自取到有效值, 见 http://javascript.about.com/library/bliebug.htm
* 如果是普通 elem, 则用elem.scrollLeft/scrollTOp;


DOM.docWidth/docHeight, DOM.viewportWidth/viewportHeight, 获取文档/可视区域宽高;

    .. sourcecode:: js

        S.each(['Width', 'Height'], function(name) {
            DOM['doc' + name] = function(refDoc) {
                var d = refDoc || doc;
                return MAX(isStrict ? d[DOC_ELEMENT][SCROLL + name] : d[BODY][SCROLL + name],
                    DOM[VIEWPORT + name](d));
            };

            DOM[VIEWPORT + name] = function(refWin) {
                var prop = 'inner' + name,
                    w = getWin(refWin),
                    d = w[DOCUMENT];
                return (prop in w) ? w[prop] :
                    (isStrict ? d[DOC_ELEMENT][CLIENT + name] : d[BODY][CLIENT + name]);
            }
        });

* 文档宽高, 使用 document.[documentElement|body].scrollWidth/Height , 当文档内容很少, 宽高就取可视区域的宽高;
* 可视区域宽高, 支持window.innerWidth方式的用 window.innerWidth/innerHeight , 其他用document.[documentElement|body].clientWidth/clientHeight;


DOM.getOffset , 获取elem在文档上的位置

    .. sourcecode:: js

        function getOffset(elem) {
            var box, x = 0, y = 0,
                w = getWin(elem[OWNER_DOCUMENT]);

            if (elem[GET_BOUNDING_CLIENT_RECT]) {
                box = elem[GET_BOUNDING_CLIENT_RECT]();

                // 注：jQuery 还考虑减去 docElem.clientLeft/clientTop
                // 但测试发现，这样反而会导致当 html 和 body 有边距/边框样式时，获取的值不正确
                // 此外，ie6 会忽略 html 的 margin 值，幸运地是没有谁会去设置 html 的 margin

                x = box[LEFT];
                y = box[TOP];

                // iphone/ipad/itouch 下的 Safari 获取 getBoundingClientRect 时，已经加入 scrollTop
                if (UA.mobile !== 'apple') {
                    x += DOM[SCROLL_LEFT](w);
                    y += DOM[SCROLL_TOP](w);
                }
            }

            return { left: x, top: y };
        }

* 直接使用 getBoundingClientRect() , 除safari外, 补上 scrollLeft/scrollTop 值.


DOM.setOffset

    .. sourcecode:: js

        function setOffset(elem, offset) {
            // set position first, in-case top/left are set even on static elem
            if (DOM.css(elem, POSITION) === 'static') {
                elem.style[POSITION] = RELATIVE;
            }
            var old = getOffset(elem), ret = { }, current, key;

            for (key in offset) {
                current = PARSEINT(DOM.css(elem, key), 10) || 0;
                ret[key] = current + offset[key] - old[key];
            }
            DOM.css(elem, ret);
        }

* 如果元素的position是static, 将其设置为relative, 因为 static时, left/top不起作用, 详细见CSS布局 http://www.w3.org/TR/CSS2/visuren.html#positioning-scheme
* 设置时, 如果 元素是 absolute 时, 直接可以设置 offset , 但如果是 relative 的话, 那元素的 css left/top 值就得是相对于自身的, 设置offset时, 需要变换计算css的left/top (PS: 这样一来, left和top都有可能是负值)


DOM.scrollIntoView, 将元素滚动到可视区域, 原理及实现及为何不用原生elem.scrollIntoView详见 http://yiminghe.javaeye.com/blog/390732


辅助函数
-----------------------------

    .. sourcecode:: js

        _isElementNode: function(elem) {
            return nodeTypeIs(elem, 1);
        },

        _getWin: function(elem) {
            return (elem && ('scrollTo' in elem) && elem['document']) ?
                elem :
                nodeTypeIs(elem, 9) ?
                    elem.defaultView || elem.parentWindow :
                    elem === undefined ?
                        window : false;
        },

* _isElementNode 用来判断是否是元素节点, 直接取 elem.nodeType, DOM中 不同的节点的nodeType也不同, 对应如下:

    * Node.ELEMENT_NODE == 1
    * Node.ATTRIBUTE_NODE == 2
    * Node.TEXT_NODE == 3
    * Node.CDATA_SECTION_NODE == 4
    * Node.ENTITY_REFERENCE_NODE == 5
    * Node.ENTITY_NODE == 6
    * Node.PROCESSING_INSTRUCTION_NODE == 7
    * Node.COMMENT_NODE == 8
    * Node.DOCUMENT_NODE == 9
    * Node.DOCUMENT_TYPE_NODE == 10
    * Node.DOCUMENT_FRAGMENT_NODE == 11
    * Node.NOTATION_NODE == 12

ps: KISSY 中的 node 的 nodeType 则为 '-ks-Node'

* _getWin 获取当前 window 对象 或 false, 如果 elem 具有 scrollTo 方法且 有 document 那就是 window , 如果 elem 是 DOCUMENT_NODE, 取 defaultView (非IE, https://developer.mozilla.org/en/DOM/document.defaultView) 或 parentWindow (IE, http://msdn.microsoft.com/en-us/library/ms534331(VS.85).aspx);


资源
-----------------------------

* http://www.quirksmode.org/dom/w3c_cssom.html
* http://www.quirksmode.org/blog/archives/2008/02/the_cssom_view.html
* http://www.w3.org/TR/cssom-view/
* http://javascript.about.com/library/bliebug.htm