数据流获取频繁项集
=========================

:date: 2008-10-15 11:10:17
:tags: Python, Datamining

描述：

    - 对于数据流（x1, x2, x3, ...）在任一时刻t检查出频繁项，这里频繁项是指密度大于s/(1-Y)的数据项, 密度实际上是乘上衰减系数了的频率.
    - 密度计算: 当t=0时, D(x, t)=0; 否则, D(x, t)=D(x, t-1)*λ + δ(x, t), 其中, δ(x, t) = 1 if xt == x, else δ(x, t) = 0; λ即为衰减系数, 0<λ<1
    - 从数据流中找出频繁项的基本思想:
    - 数据项不断的到来时, 算法在t时刻接收到一个数据项x,就在窗口Windows中查找与x的相关记录, 如果存在, 设为(x, D(x), ts), 则将D(x)加1, 同时ts更新为当前的t表示最新x出现的位置; 如果窗口中不存在x, 则需要创建一条新的记录, (x, 1, t)插入其中, 如果窗口大小超过一定数值, 就得删去其中密度最小的记录, 设为(x', D(x'), ts'), 删去的同时要将原有记录的密度值减去D(x').
    - 存储空间O(m), 接收数据时的处理时间O(m), 查询也是O(m), m为窗口大小
    - 计算出来每项的D(x)会很小, 而且每加入一个x, 都要更新整个窗口

改进:

    增加两个变量Δd和Δt, 分别用在:

    1) 原来要将原有记录的密度减去D(x')不是频繁的对原有的记录进行减操作, 设立Δd累加总共需要减去的值, 在以后需要调整时一下子减去这个Δd.
    2) 原来的原有记录D(x)得乘以λ, 同样为了避免频繁乘, 设立Δt为当前时间t, 在之后的时刻中加1, 而之后的实际密度为(D(x)-Δd)*(λ**Δt)
    3) 在新建某一元素时, 计数开始为1, 但后来不断变化, 变为1/(λ**Δt)

    这样, 就可不是很频繁的进行更新操作.

    但是, 因为λ设为0~1之间的小数, 所以计算出来的1/(λ**Δt)和D(x)值都非常大...


代码：

.. sourcecode:: python

    ## 文件名：streamfrequence.py
    #!/usr/bin/python
    #coding:utf-8

    """数据流中的频繁项
    需要更新密度D(x)和最近出现位置,在t时刻找出频繁项
    """

    try:
        import cPickle as pickle
    except:
        import pickle
    import collections

    Y = 0.98 # 衰减系数
    E = 0.001 # 误差系数
    WINDOWSIZE = long(1.0/E)
    S = 0.005 # 支持度
    DX = 10000 # 更新阈值, 超过这个数就更新窗口中记录
    TLIST = [19999, 39999, 59999, 79999, 99999] # 检查点列表
    Support = S/(1-Y)

    def get_zipf_data():
        return pickle.load(open("zipf.data"))

    def do_main():
        """主算法
        读取一个数据,更新密度和最近出现位置,在固定窗口大小中,将TLIST时刻的窗口状态保存
        """
        t = -1
        windows = {}  #{数据项:[密度,出现位置]}
        result = {}      #{时刻t:[频繁项]}

        for ch in get_zipf_data():
            t += 1
            if windows.has_key(ch):
                # 窗口中已有ch,则直接更新这个,其他不做
                windows[ch][0] += 1
                windows[ch][1] = t
            else:
                # 如果不存在,则需要加入,加入新的记录,后考虑窗口是否已满,满的话要删除密度值最小的一个
                windows[ch] = [1, t]
                if len(windows.keys()) > WINDOWSIZE:
                    # 找出当前窗口中密度最小的一个
                    min = windows[ch][0]
                    min_key = ch
                    for x in windows:
                        if windows[x][0] < min:
                            min_key = x
                            min = windows[x][0]
                    # 删除, 并将所有项减去该密度
                    min_item = windows.pop(min_key)
                    for x in windows:
                        windows[x][0] -= min_item[0]

            # 更新窗口中所有记录的密度值
            for x in windows:
                windows[x][0] *= Y

            # 时刻t的窗口状态,并获取频繁项
            if t in TLIST:
                result[t] = []
                for x in windows:
                    current = E/(1-Y)*(Y**(t-windows[x][1]))
                    if windows[x][0]+current >= Support:
                        result[t].append(x) ###??"%d" %

        pickle.dump(result, open('result', 'w'))
        #print result

其改进算法

.. sourcecode:: python

    def do_main_improve():
        """主算法 改进
        读取一个数据,更新密度和最近出现位置,在固定窗口大小中,将TLIST时刻的窗口状态保存
        """
        t = -1
        deltad = 0
        deltat = 0
        windows = {}  #{数据项:[密度,出现位置]}
        result = {}      #{时刻t:[频繁项]}

        for ch in get_zipf_data():
            t += 1
            if windows.has_key(ch):
                # 窗口中已有ch,则直接更新这个,其他不做
                windows[ch][0] += Y**(-deltat)  # 这里改为D(X)+Y**-deltat
                windows[ch][1] = t
            else:
                # 如果不存在,则需要加入,加入新的记录,后考虑窗口是否已满,满的话要删除密度值最小的一个
                windows[ch] = [Y**(-deltat), t]  # 这里改为Y**(-deltat)
                #print 'new', windows[ch][0]
                if len(windows.keys()) > WINDOWSIZE:
                    # 找出当前窗口中密度最小的一个, python字典中主要是没有顺序, 所以用冒泡排序不能.
                    min = windows[ch][0]
                    min_key = ch
                    for x in windows:
                        if windows[x][0] < min:
                            min_key = x
                            min = windows[x][0]
                    # 删除, 并将累计deltad
                    min_item = windows.pop(min_key)
                    # 改进之处
                    deltad += min_item[0]

            deltat += 1
            flag = 0
            for x in windows:
                if windows[x][0] > DX:
                    flag = 1
                    #print t
            if flag:
                # 更新窗口中所有记录的密度值
                for x in windows:
                    windows[x][0] = (windows[x][0]-deltad)*(Y**deltat)
                deltat = 0
                deltad = 0

            # 时刻t的窗口状态,并获取频繁项
            if t in TLIST:
                result[t] = []
                #print windows
                for x in windows:
                    current = E/(1-Y)*(Y**(t-windows[x][1]))
                    w = (windows[x][0] - deltad)*(Y**deltat)
                    if w+current >= Support:
                        result[t].append(x) ###??"%d" %
        pickle.dump(result, open('result_improve', 'w'))

实际数据流中频繁项获取的算法

.. sourcecode:: python

    def do_fact():
        """计算实际数据流中的
        """
        result = {}
        windows = collections.defaultdict(lambda: 0)  # {数据:密度}
        data = get_zipf_data()
        t = -1
        for ch in data:
            t += 1
            windows[ch] += 1
            for x in windows:
                # 更新窗口中原有记录的密度值
                #if x != ch:
                windows[x] *= Y

            # 保存当前时刻t的窗口状态,并计算频繁项, 将时刻t的P'集合保留下来
            if t in TLIST:
                result[t] = []
                for x in windows:
                    current = S*(1-Y**t)/(1-Y)
                    if windows[x] > current:
                        result[t].append(x)
        pickle.dump(result, open('result_fact', 'w'))


测试：

    实际数据流中的频繁项(P')和非频繁项(N') 与 算法结果中找到正确的频繁项(TP),错误的频繁项(FP),正确的非频繁项(TN),错误的非频繁项(FN)之间的两个衡量标准:

    1) recall = TP/P'
    2) precision = TP/(FP+TP) = TP/P

    测试10000随机数据

        .. sourcecode:: bash

            $ python streamfrequence.py
            算法1 {9999: (1.0, 0.95238095238095233), 7999: (1.0, 0.97560975609756095), 3999: (1.0, 1.0), 5999: (1.0, 1.0), 1999: (1.0, 0.95121951219512191)}
            算法2 {9999: (1.0, 0.95238095238095233), 7999: (1.0, 0.97560975609756095), 3999: (1.0, 1.0), 5999: (1.0, 1.0), 1999: (1.0, 0.95121951219512191)}


    测试100000随机数据
        .. sourcecode:: bash

            $ python streamfrequence.py
            算法1 {59999: (1.0, 0.95348837209302328), 39999: (1.0, 0.97297297297297303), 99999: (1.0, 0.95238095238095233), 79999: (1.0, 0.96969696969696972), 19999: (1.0, 0.9555555555555556)}
            算法2 {59999: (1.0, 0.95348837209302328), 39999: (1.0, 0.97297297297297303), 99999: (1.0, 0.95238095238095233), 79999: (1.0, 0.96969696969696972), 19999: (1.0, 0.9555555555555556)}


    看到,得到召回率普遍为1,而精度接近1,,,结果比较理想, 接下来要对实际数据集上测试.