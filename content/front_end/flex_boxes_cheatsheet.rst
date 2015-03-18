Flex Boxes Cheatsheet
=====================================================

:date: 2015-03-18 22:25:59
:tags: CSS

> 一页纸能概括的内容不需要描述那么长篇。

CSS3 flexible boxes  https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Flexible_boxes

::

  display: flex | inline-flex

  ## 子元素在父元素中按照什么方式排列
  align-content: flex-start
  align-content: flex-end
  align-content: center
  align-content: space-between
  align-content: space-around
  align-content: stretch <- 默认

  ## 子元素在父元素中按照什么方式排列，但剩余的间距会被分掉
  align-items: flex-start
  align-items: flex-end
  align-items: center
  align-items: baseline
  align-items: stretch <- 默认

  ## 同上，但是定义在子元素上的。
  align-self: auto <- 默认 依据父元素的设定，如果没设则为 stretch
  align-self: flex-start
  align-self: flex-end
  align-self: center
  align-self: baseline
  align-self: stretch


  ## flex 为 flex-grow flex-shrink flex-basis 的简写

  flex: none /* value 'none' case */
  flex: <'flex-grow'> /* One value syntax, variation 1 */
  flex: <'flex-basis'> /* One value syntax, variation 2 */
  flex: <'flex-grow'> <'flex-basis'> /* Two values syntax, variation 1 */
  flex: <'flex-grow'> <'flex-shrink'> /* Two values syntax, variation 2 */
  flex: <'flex-grow'> <'flex-shrink'> <'flex-basis'> /* Three values syntax */

  ## flex-basis 子元素在 main-axis 上的size
  flex-basis: 10em /* <'width'> */
  flex-basis: 3px /* <'width'> */
  flex-basis: auto /* <'width'> */
  flex-basis: content  /* 目前都不支持 */

  ## flex-grow 子元素在剩余空间内如何填满
  flex-grow: 3

  ## flex-shrink
  flex-shrink: 3


  ## flex-direction  子元素在父元素内如何排列
  flex-direction: row
  flex-direction: row-reverse
  flex-direction: column
  flex-direction: column-reverse

  ## flex-wrap 子元素在父元素内是否换行
  flex-wrap: nowrap
  flex-wrap: wrap
  flex-wrap: wrap-reverse

  ## flex-flow flex-direction 和 flex-wrap 的简写，指明子元素在父元素内如何排列


  ## justify-content 父元素怎么划分子元素见的空间
  justify-content: flex-start
  justify-content: flex-end
  justify-content: center
  justify-content: space-between
  justify-content: space-around

  ## order 子元素在父元素中的先后顺序
  order: 5 默认为0. 统一order的多个子元素按照html中的书写顺序来觉得展示的顺序


更多请看例子吧。所有属性不同值的不同效果。

.. raw:: html

    <iframe src="/test/flex.html" width="1000px" height="800px"></iframe>
