Introduce to Jasmine
==============================

:date: 2010-10-17 11:10:07
:tags: Javscript


上次报告中讲到的 Jasmine, 但由于自己讲的太烂 & 没讲清楚, 估计没人在意了. 所以在这再次介绍一下这个工具~



Jasmine 介绍
--------------------

这单词本意是 "茉莉花" 的意思, 小而精致的一种花. 同样, JS 测试框架中的 Jasmine 也是一个小巧工具, 但功能不小巧~

他是一个用于 JS 测试的行为驱动开发(BDD)框架. 独立存在, 不依赖其他 JS 框架.

借一段文档上的代码:

    .. sourcecode:: js

        describe("Jasmine", function() {
          it("makes testing JavaScript awesome!", function() {
            expect(yourCode).toBeLotsBetter();
          });
        });

测试代码可以写成如上类似的样子, 代码看上去很自然语言了, 很易读~



Jasmine 使用
--------------------

Specs: 说明, 使用 it(description, fn) 来描述;

    .. sourcecode:: js

        it('should increment a variable', function () {
              var foo = 0;
              foo++;
        });


他用来说明 fn 中的动作要达到什么样的效果;


Expecations: 期望, 存在于 spec 中, 用来描述某值的期望结果, 使用 expect() + matchers;

    .. sourcecode:: js

        it('should increment a variable', function () {
              var foo = 0;            // set up the world
              foo++;                  // call your application code

              expect(foo).toEqual(1); // passes because foo == 1
        });


Suites: Specs 的集合, 相当于 Test　Case, 使用 describe 语句;

    .. sourcecode:: js

        describe('Calculator', function () {
              it('can add a number', function () {
                ...
              });

              it('has multiply some numbers', function () {
                ...
              });
        });

* Suites 的名字一般为你要测试的模块/组件/应用名字;
* Suites 中的每个 Spec 只执行一次, 一个 Suites, 一个作用域, 里面的 Spec 共享;
* 支持嵌套的 Describes;
* beforeEach(fn)/afterEach(fn), 在每个 spec 执行之前/之后 执行;
* this.after(fn) 在特定的某个 spec 执行之后执行, 但没有 this.before !
* xit()/xdescribe() 设置 spec/describe 不可用.


Matchers: 匹配者

    .. sourcecode:: js

        expect(x).toEqual(y); // compares objects or primitives x and y and passes if they are equivalent
        expect(x).toBe(y);    // compares objects or primitives x and y and passes if they are the same object
        expect(x).toMatch(pattern); // compares x to string or regular expression pattern and passes if they match
        expect(x).toBeDefined();    // passes if x is not undefined
        expect(x).toBeNull();       // passes if x is null
        expect(x).toBeTruthy();     // passes if x evaluates to true
        expect(x).toBeFalsy();      // passes if x evaluates to false
        expect(x).toContain(y);     // passes if array or string x contains y
        expect(x).toBeLessThan(y);  // passes if x is less than y
        expect(x).toBeGreaterThan(y);  // passes if x is greater than y
        expect(fn).toThrow(e);         // passes if function fn throws exception e when executed


* 否定只需加 not

    .. sourcecode:: js
        expect(x).not.toEqual(y);      // compares objects or primitives x and y and passes if they are not equivalent


* Matcher 是可以自定义的. 使用 ``addMatchers(obj)``

    .. sourcecode:: js

        toBeLessThan: function(expected) {
          return this.actual < expected;
        };

        beforeEach(function() {
          this.addMatchers({
            toBeVisible: function() { return this.actual.isVisible(); }
          });
        });


Spies/Asynchronous Specs

* permit many spying, mocking, and faking behaviors. 用于模拟传参, 回调函数, 异步请求/行为监测
* 支持异步测试, 测试 ajax api, 事件回调等, 就是针对在未来某个点上会发生的行为.
* runs() 阻塞执行, 就像是直接调用一样; 多个runs() 共享作用域.
* waits(timeout) 等待多长时间后再执行下面的语句.
* waitsFor(function, optional message, optional timeout) 直到 function 返回 true 才执行下去.

    .. sourcecode:: js

        describe('Spreadsheet', function() {
          it('should calculate the total asynchronously', function () {
            var spreadsheet = new Spreadsheet();
            spreadsheet.fillWith(lotsOfFixureDataValues());
            spreadsheet.asynchronouslyCalculateTotal();

            waitsFor(function() {
              return spreadsheet.calculationIsComplete();
            }, "Spreadsheet calculation never completed", 10000);

            runs(function () {
              expect(spreadsheet.total).toEqual(123456);
            });
          });
        });

* 关于 spies, 偶自己使用时, 有时很奇怪他的行为,,可能是没更好的用. 有待进一步研究. 更多资料参见 http://pivotal.github.com/jasmine/spies.html.

最后, 只要引入 jasmine 所需的css/js就可以让 Test Runner 跑起来

    .. sourcecode:: html

        <link rel="stylesheet" href="../../../tests/jasmine/jasmine.css">
        <script src="../../../tests/jasmine/jasmine.js"></script>
        <script src="../../../tests/jasmine/jasmine-html.js"></script>

        <script src="../../../build/packages/kissy.js"></script>

        <script src="../test.js"></script>

        <script>
            jasmine.getEnv().addReporter(new jasmine.TrivialReporter());
            jasmine.getEnv().execute();
        </script>

打开页面就可以看到对应的结果了. 这样就不用人肉地执行重复的工作了!



其他
--------------------
既然 jasmine 本身不依赖什么, 那么就可以和现有的其他 JS 测试工具结合使用, 比如和 js-test-driver 结合起来, 这样更加自动化.



资料
--------------------

* Jasmine 文档: http://pivotal.github.com/jasmine/index.html
* JQuery 的 jasmine 插件: http://blog.davidpadbury.com/2010/10/11/bdd-testing-of-jquery-plugins-using-jasmine/
* BDD: http://en.wikipedia.org/wiki/Behavior_Driven_Development