Karmic Koala
===================

:date: 2009-11-12 02:11:17
:tags: Tools


安装ubuntu9.10, 本以为一个上午就能搞定, 但后来反反复复的弄了好久才ok.

前两天好不容易下载好desktop的iso镜像. 直接采用wubi安装. 到最后一步安装引导时出错. 导致无法进入系统.

后来找了张ubuntu5.04光盘重新进入 安装grub. 后来发现原来是双硬盘, hd0和hd1, 我把windows和ubuntu都安装在hd1的分区上, 而grub安装时是在hd0, 这样如果从hd0启动,就无法找到两个系统, 而如果是hd1启动, 又没有引导程序.
问题这样, 只能将另一硬盘卸掉再安装系统.

折腾了大半天, 终于安装好, grub1.97版也ok, 成功进入.
安装语言包, 设置源(http://www.ubuntuhome.com/ubuntu-9-10-yuan.html 取了里面的交大源, 速度算快了).

安装些其他软件

    - ibus输入发实在是可恶. 去掉换成scim.
    - amark播放器, 还是自带的播放器, 好多解码器都没有安装. 只能一个一个来.
    - im把原来的pidgin换成了empathy, 这个比pidgin更简陋. 于是替换之.
    - 打印, samba安装, 设置打印机
    - ubuntu-restricted-extras, 里面包含rar解压工具, truetype, jre, adobeflash播放器等.
    - gnash播放器,sudo apt-get purge flashplugin-installer nspluginwrapper, sudo apt-get install mozilla-plugin-gnash
    - compiz那些特效,,,这些就算了吧...
    - banshee, 另一个播放器, amark是kde下, 安装时安装了一大堆kde的东西, 决定卸掉, 尝试banshee
    - chrome, sudo apt-get install chromium-browser http://ulyssesonline.com/2009/11/02/install-google-chrome-on-ubuntu-9-10/
    - solang, 一个图片管理工具
    - inkscape, 矢量图编辑
    - blender, 3d图形
    - deluge, bt工具
    - gwibber, 微博客户端
    - virtualbox-3.0, 虚拟机, 尝试装个windows
    - 还有很多东西,可参考(http://blog.thesilentnumber.me/2009/09/top-things-to-do-after-installing.html )

这样就差不多了. 其他的用到再装...