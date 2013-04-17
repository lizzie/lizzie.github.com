DOM.style
=======================

:date: 2010-09-15 13:09:44
:tags: Javascript, KISSY


继续上回的 KISSY DOM 源码学习..今天看了 style, attr, 和 data相关.

dom-style.js
-------------------------

http://github.com/kissyteam/kissy/blob/master/src/dom/dom-style.js
http://github.com/kissyteam/kissy/blob/master/src/dom/dom-style-ie.js

DOM.css() 先看setter

    .. sourcecode:: js

        // setter
        else {
            // normalize unsetting
            if (val === null || val === EMPTY) {
                val = EMPTY;
            }
            // number values may need a unit
            else if (!isNaN(new Number(val)) && RE_NEED_UNIT.test(name)) {
                val += DEFAULT_UNIT;
            }

            // ignore negative width and height values
            if ((name === WIDTH || name === HEIGHT) && parseFloat(val) < 0) {
                return;
            }

            S.each(S.query(selector), function(elem) {
                if (elem && elem[STYLE]) {
                    name.set ? name.set(elem, val) : (elem[STYLE][name] = val);
                    if (val === EMPTY) {
                        if (!elem[STYLE].cssText)
                            elem.removeAttribute(STYLE);
                    }
                }
            });
        }

核心代码 ``name.set ? name.set(elem, val) : (elem[STYLE][name] = val);`` , 也就是直接内敛设置元素的style, 前面的name.set判断 是针对 IE下, 一些特殊属性, 如 opacity, 需要特殊的处理, 所以在 style-ie.js 中增加 opacity 的 get/set 函数;

PS: IE下的 opacity 通过 elem.filters.DXImageTransform.Microsoft.Alpha.opacity 或者 elem.filters.alpha.opacity 获取, 而设置时, 利用 elem.currentStyle.filter 中有关 opacity 的值进行设置.
PS: 如果以后还有其他需要特殊处理的 css 属性, 就可以直接通过 类似于opacity 的方式 添加 属性的set和get, 而不用再次修改 style.js 中的代码;

再看getter

    .. sourcecode:: js

        // getter
        if (val === undefined) {
            // supports css selector/Node/NodeList
            var elem = S.get(selector), ret = '';

            if (elem && elem[STYLE]) {
                ret = name.get ? name.get(elem) : elem[STYLE][name];

                // 有 get 的直接用自定义函数的返回值
                if (ret === '' && !name.get) {
                    ret = fixComputedStyle(elem, name, DOM._getComputedStyle(elem, name));
                }
            }

            return ret === undefined ? '' : ret;
        }

* ``ret = name.get ? name.get(elem) : elem[STYLE][name];`` name.get 同样是针对需要特殊处理的 属性,
* 先尝试 取元素内敛的 style, 如果没有, 则使用 getComputedStyle 里计算当前的 CSS 属性值;
* fixComputedStyle, 对 getComputedStyle 返回的值再次处理, 主要针对 css 属性 left/top 的返回值为 auto 时处理, elem 的 position 为 absolute 时, kissy 取 left/top 值为 offsetLeft/offsetTop 减去 margin-left/margin-top 的值; elem 的 position 为 relative 时, 直接取 0;

非 IE 下 获取元素 css 值, 使用的是 document.defaultView.getComputedStyle, IE下则用 elem.currentStyle, 所以 KISSY 针对 IE , 覆盖了 DOM._getComputedStyle , 使用 currentStyle.

* 这里, 如果是 height 和 width, 就直接用DOM.height()/width();
* 如果是数值, 但没有px指定, 则使用 Dean Edwards 上的巧妙方法 (http://erik.eae.net/archives/2007/07/27/18.54.15/#comment-102291), 主要是利用 elem.runtimeStyle, 详细见http://yiminghe.javaeye.com/blog/511589.

还有一些其他的注意点:

* 不同浏览器对 css 属性的命名认识也不一样, webkit 认识 camel-case(有-)的, 其他的只认识camelCase;
* CSS 中 float 和 js 的 float 冲突, 所以浏览器将 CSS 的 float 替代命名, IE 用 styleFloat, 标准浏览器用 cssFloat;
* color获取, 情况也很多, 详见 secrets of the javascrpt p172.


DOM.width()/height()核心函数

    .. sourcecode:: js

        function getWH(selector, name) {
            var elem = S.get(selector),
                which = name === WIDTH ? ['Left', 'Right'] : ['Top', 'Bottom'],
                val = name === WIDTH ? elem.offsetWidth : elem.offsetHeight;

            S.each(which, function(direction) {
                val -= parseFloat(DOM._getComputedStyle(elem, 'padding' + direction)) || 0;
                val -= parseFloat(DOM._getComputedStyle(elem, 'border' + direction + 'Width')) || 0;
            });

            return val;
        }

* 取的是 元素内容宽度, 而 clientWidth()/clientHeight() 是包含 padding 的.
* 取的是offsetWidth/offsetHeight, 减去 padding和border 得到;


DOM.show()/hide()/toggle() 元素显示/隐藏/切换.

* 这里有一个注意的地方, 就是, 元素的 display 值, 再显示的时候, 不是固定设置 block, 而是设置 元素被隐藏之前的值, 当然在隐藏这个元素前会把原来的 display 值保存起来, 这里用到了 DOM.data.


dom-data.js
-------------------------

http://github.com/kissyteam/kissy/blob/master/src/dom/dom-data.js

DOM.data()/DOM.removeData()

分为 winDataCache 和节点上的 dataCache ,

* 如果是设置在 win 上的 data, key 为 expando(dom-data加载时随机生成的字串), cache为 winDataCache, 即 winDataCache[expando][name] = data;
* 如果是设置在 某个节点上 的 data, key 为 node[expando](不存在时生成一个全局唯一的id, S.guid() 方法), cache为dataCache, 即dataCache[node[expando]][name] = data;


dom-attr.js
-------------------------

http://github.com/kissyteam/kissy/blob/master/src/dom/dom-attr.js

// attr getter

* ie7-, css与js冲突的属性, 如, for/class 名字分别为 htmlFor/className;
* mapping 属性, 如 readonly, checked, selected, 直接使用 elem.name 获取;
* 其他用 getAttribute, 但还有一些属性, 在 ie7- 下, 得通过 getAttribute(name, 2) , 就是指定 第2个参数来获取 http://msdn.microsoft.com/en-us/library/ms536429%28VS.85%29.aspx;
* style属性, ie7- 下用 elem.style.cssText;

// attr setter

* style, 通过elem.style.cssText;
* checked 需要 elem.checked = xxx, 通过setAttribute(checked, xxx) 不行;
* 其他用 setAttribute(name, val);

// removeAttr:

* elem.removeAttribute(name);// 为何先得置空, DOM.attr(elem, name, EMPTY)??


// val getter

* 如果是 options 元素, 当没有设定 value 时，标准浏览器 option.value === option.text, ie7- 下，没有设定 value 时，option.value === '', 需要用 el.attributes.value 来判断是否有设定 value;
* 如果是 select 元素, 如果是单选框, 就去 selectedIndex 那个 option 的val, 没有选中返回 null ; 如果是多选框, 则便利判断 option 是否被 selected, 是则返回, 最终返回以 val 数组, 没有选择返回[];
* 如果 radiobox, 如果是webkit浏览器, 没有设置 value时 默认返回 'on';
* 剩余的元素, 统一用 elm.value;


// val setter

    .. sourcecode:: js

        if (nodeNameIs(SELECT, el)) {
            // 强制转换数值为字符串，以保证下面的 inArray 正常工作
            if (S.isNumber(value)) {
                value += EMPTY;
            }

            var vals = S.makeArray(value),
                opts = el.options, opt;

            for (i = 0,len = opts.length; i < len; ++i) {
                opt = opts[i];
                opt.selected = S.inArray(DOM.val(opt), vals);
            }

            if (!vals.length) {
                el.selectedIndex = -1;
            }
        }
        else if (isElementNode(el)) {
            el.value = value;
        }

* select文本框时, 处理比较麻烦, 在设置 val 时, 需要将对应的 options 选中, 即对应的 options 的selected 为 True , selectedIndex 更新, 如果是没有选中(? 单选框的话,,应该不会吧), 设置为-1 .
* 如果是普通 HTMLELement, 直接设置 elem.value = val 即可;

// text setter / getter

* 如果是 HTMLElement, 使用 elem.text = val / 或 getter 是为 '';
* 如果是 TextNode, 使用 elem.nodeValue = val;


attr 和 expando
-------------------------

* elem 上的属性 , elem.id 等价于 elem.getAttribute('id');
* elem 上的 dataname, 给elem.dataname = data, 但不同通过 elem.getAttribute(dataname) 获取;

不过, 上面的data.js中, 并没有把dataname直接加在elem上, 而是另外开辟 dataCache 放置, 或许是为了方便管理这些额外的数据;
PS: secret of javascript 说, elem.id 要比elem.getAttribute('id') 快很多, 尤其是在IE下. 不知道 直接放在 dataCache 里, 性能如何, 字典应该也挺快的吧..


参考资源
-------------------------

* `CSS属性计算值问题 <http://yiminghe.javaeye.com/blog/583699>`_
* `IE 取得css属性的绝对像素值 <http://yiminghe.javaeye.com/blog/511589>`_
* `document.documentElement <https://developer.mozilla.org/en/DOM/document.documentElement>`_, return the element that is the root element of document;
* `document.defaultView <https://developer.mozilla.org/en/DOM/document.defaultView>`_, returns a reference to the default AbstractView for document, or null if none available;
* `elem.ownerDocument <https://developer.mozilla.org/En/DOM/Node.ownerDocument>`_, return the top-level document object for this node, document.ownerDocument 为 null,
* `selectedIndex <https://developer.mozilla.org/en/XUL/Attribute/selectedIndex>`_
