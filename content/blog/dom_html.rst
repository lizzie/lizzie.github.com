DOM.html
=======================

:date: 2010-09-24 09:09:00
:tags: Javascript, KISSY


KISSY DOM系列之三, 有关 html 内容的设置

dom-create.js
------------------------

http://github.com/kissyteam/kissy/blob/master/src/dom/dom-create.js

dom.create() 创建 DOM 元素

    .. sourcecode:: js

        create: function(html, props, ownerDoc) {
            if (nodeTypeIs(html, 1) || nodeTypeIs(html, 3)) return cloneNode(html);
            if (isKSNode(html)) return cloneNode(html[0]);
            if (!(html = S.trim(html))) return null;

            var ret = null, creators = DOM._creators,
                m, tag = DIV, k, nodes;

            // 简单 tag, 比如 DOM.create('<p>')
            if ((m = RE_SIMPLE_TAG.exec(html))) {
                ret = (ownerDoc || doc).createElement(m[1]);
            }
            // 复杂情况，比如 DOM.create('<img src="sprite.png" />')
            else {
                if ((m = RE_TAG.exec(html)) && (k = m[1]) && S.isFunction(creators[(k = k.toLowerCase())])) {
                    tag = k;
                }

                nodes = creators[tag](html, ownerDoc).childNodes;

                if (nodes.length === 1) {
                    // return single node, breaking parentNode ref from "fragment"
                    ret = nodes[0][PARENT_NODE].removeChild(nodes[0]);
                }
                else {
                    // return multiple nodes as a fragment
                    ret = nl2frag(nodes, ownerDoc || doc);
                }
            }

            return attachProps(ret, props);
        },


* 如果是文本或元素节点, 直接克隆返回, 使用 elem.cloneNode(true) , ie<8时还需设置innerHTML;
* 如果是 kissy 的 Node, 返回 克隆这个node 对应的 element;
* 简单的html, 比如只有标签的, 使用 doc.createElement(xxx);
* 比较复杂的html, 通过创建一个父元素(一般为div)包裹这些html, 获得这个父元素的所有孩子节点 nodelist (分开处理一个孩子或多个孩子), 还得将 nodelist 转换成 fragment 返回;
* 如果有属性设置, 通过 DOM.attr 设置, 所以支持 DOM.create('tag', {text:'xxxx', title:'xxx', css:{color: 'white'}});
* 还有如 table, thead, th, tfoot, 等元素, 需要特殊处理;


dom.html() 获取/设置元素内的内容
// getter
* 取 elm.innerHTML
// setter ----> setHTML(elem, val, loadScripts, callback);

    .. sourcecode:: js

        function setHTML(elem, html, loadScripts, callback) {
            if (!loadScripts) {
                setHTMLSimple(elem, html);
                S.isFunction(callback) && callback();
                return;
            }

            var id = S.guid('ks-tmp-'),
                re_script = new RegExp(RE_SCRIPT); // 防止

            html += '<span id="' + id + '"></span>';

            // 确保脚本执行时，相关联的 DOM 元素已经准备好
            S.available(id, function() {
                var hd = S.get('head'),
                    match, attrs, srcMatch, charsetMatch,
                    t, s, text;

                re_script.lastIndex = 0;
                while ((match = re_script.exec(html))) {
                    attrs = match[1];
                    srcMatch = attrs ? attrs.match(RE_SCRIPT_SRC) : false;
                    // script via src
                    if (srcMatch && srcMatch[2]) {
                        s = doc.createElement('script');
                        s.src = srcMatch[2];
                        // set charset
                        if ((charsetMatch = attrs.match(RE_SCRIPT_CHARSET)) && charsetMatch[2]) {
                            s.charset = charsetMatch[2];
                        }
                        s.async = true; // make sure async in gecko
                        hd.appendChild(s);
                    }
                    // inline script
                    else if ((text = match[2]) && text.length > 0) {
                        S.globalEval(text);
                    }
                }

                // 删除探测节点
                (t = doc.getElementById(id)) && DOM.remove(t);

                // 回调
                S.isFunction(callback) && callback();
            });

            setHTMLSimple(elem, html);
        }

* 通过 elm.innerHTML 设置, 但一些特殊元素 table/tr/td 等在IE下, innerHTML 是只读属性, 不能通过它来设置, 而是先 removeChild, 然后再 appendChild;
* 如果包含 script 脚本, 首先确保在 DOM ready 后执行(通过创建一个临时节点来判断是否 ready ), 若是脚本文件插入到 head 末尾, 且设置其 async 为 true, 即异步加载, 不阻塞浏览器, 若是内联脚本, 使用 S.globalEval(text) 立即执行该脚本;


dom.remove()

* el.parentNode.removeChild(el);
* 是否需要删除expando和event, 如 jQuery 的处理?


dom-inseartion.js
-------------------------------

http://github.com/kissyteam/kissy/blob/master/src/dom/dom-insertion.js

* appendChild, removeChild, replaceChild 直接用原生的方法;
* 添加 insertBefore/insertAfter 方法, 实现时转换成父元素的 insertBefore 来, 只是被参照的元素不同.


dom-traversal.js
-------------------------------

http://github.com/kissyteam/kissy/blob/master/src/dom/dom-traversal.js

DOM 的遍历

parent()/next()/prev() 这种只取单个元素的方法, ---> nth(elem, filter, direction, extraFilter)

* 获取 elem 满足 filter 的第一个 parentNode, nextSibling, previousSibling 元素.
* filter 为数字时, 表示深度, 从0开始, 0 表示当前 elem;

siblings()/children() 这类取一批元素的方法, ---> getSiblings(selector, filter, parent)

* 获取 elem 满足条件的所有siblings
* 利用 parentNode.firstChild 和 next.nextSibling , siblings() 取 elem.parentNode 的 孩子 且不是 elem 的元素.

contains() 判断一个节点(contained)是否在另外一个节点(container)内

    .. sourcecode:: js

        contains: function(container, contained) {
            var ret = false;

            if ((container = S.get(container)) && (contained = S.get(contained))) {
                if (container.contains) {
                    return container.contains(contained);
                }
                else if (container.compareDocumentPosition) {
                    return !!(container.compareDocumentPosition(contained) & 16);
                }
                else {
                    while (!ret && (contained = contained.parentNode)) {
                        ret = contained == container;
                    }
                }
            }

            return ret;
        }


* 最容易想到的方法, 判断 contained.parentNode 是否为 container, 如果不是, 再次判断parentNode.parentNode,依次下去, ps: document.parentNode 为 null;
* Firefox, Opera 支持 compareDocumentPosition , 就可以直接使用该方法, 具体见下链接;
* 如果对象已经包含 contains 方法, 则用他的 contains 方法;


dom-class.js
-------------------------------

http://github.com/kissyteam/kissy/blob/master/src/dom/dom-class.js

hasClass()/addClass()/removeClass() 处理 elem.className
replaceClass() 先删removeClass()后加addClass()
toggleClass() 有某个 cls, 则removClass, 没有则addClass()

* 这几个方法大多用到 batch(selector, value, fn, resultIsBool) 方法, 用于批量操作, 对符合条件的一批元素进行.


selector.js
-------------------------------

http://github.com/kissyteam/kissy/blob/master/src/dom/selector.js

终于到 selector 了. 可谓是 DOM 的核心了. 所以留到最后.
S.get()/S.query()/S.filter()/S.test() ---> query()
优先级及先后处理顺序#id, cls, tag, 先出现的作为 context;

* #id ----> getElementById;
* #id .cls | #id tag.cls | .cls | tag.cls ----> getElementsByClassName or querySelectorAll or getElementsByTagName 自个儿判断;

    .. sourcecode:: js

        // query .cls
            function getElementsByClassName(cls, tag, context) {
                var els = context.getElementsByClassName(cls),
                    ret = els, i = 0, j = 0, len = els.length, el;

                if (tag && tag !== ANY) {
                    ret = [];
                    tag = tag.toUpperCase();
                    for (; i < len; ++i) {
                        el = els[i];
                        if (el.tagName === tag) {
                            ret[j++] = el;
                        }
                    }
                }
                return ret;
            }
            if (!doc.getElementsByClassName) {
                // 降级使用 querySelectorAll
                if (doc.querySelectorAll) {
                    getElementsByClassName = function(cls, tag, context) {
                        return context.querySelectorAll((tag ? tag : '') + '.' + cls);
                    }
                }
                // 降级到普通方法
                else {
                    getElementsByClassName = function(cls, tag, context) {
                        var els = context.getElementsByTagName(tag || ANY),
                            ret = [], i = 0, j = 0, len = els.length, el, t;

                        cls = SPACE + cls + SPACE;
                        for (; i < len; ++i) {
                            el = els[i];
                            t = el.className;
                            if (t && (SPACE + t + SPACE).indexOf(cls) > -1) {
                                ret[j++] = el;
                            }
                        }
                        return ret;
                    }
                }
            }

* 这里的 getElementsByClassName 方法, 处理比较复杂,
* 传入 S.Node or S.NodeList, 会转成 DOM Node 返回;
* filter, 过滤满足条件的元素, 在 query 基础上;
* S.query('.x').each(fn, context) 等价于 S.each(S.query('.x'), fn, context)
* S.ExternalSelector 额外的选择器, 比如 sizzle.


node.js/nodelist.js
-------------------------------

http://github.com/kissyteam/kissy/blob/master/src/node

代替 DOM 原生的 Node, KISSY 的 Node/NodeList, 以支持链式操作.

* S.one()/S.all()
* node.getDOMNode(), nodelist.item(idx), .getDOMNodes(), .each(fn, context), 貌似没啥好说的.

node-attach.js
-------------------------------

给 Node/NodeList, 添加一些 DOM 中实现的方法.

* .one/.all, 同S.one/S.all;
* .append/.appendTo, 追加html/添加到父节点的末尾上;
* 核心: attach/normalGetterSetter, 用于将 Node/NodeList 的方法 转移到 DOM 方法实现.


相关资源链接
-------------------------------

* `compareDocumentPosition: Compares the position of the current node against another node in any other document. <https://developer.mozilla.org/en/DOM/Node.compareDocumentPosition>`_

* DOM.contains(): http://ejohn.org/blog/comparing-document-position/ 和 http://www.quirksmode.org/blog/archives/2006/01/contains_for_mo.html
