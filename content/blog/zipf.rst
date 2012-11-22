采用蒙特卡罗方法生成zipf分布随机数据
===========================================================

:date: 2008-10-29 14:10:50
:tags: Datamining

描述：

    齐普夫定律（Zipf's Law）：一个词在一个有相当长度的语篇中的等级序号（该词在按出现次数排列的词表中的位置，他称之为rank，简称r）与该词的出现次数（他称为 frequency，简称f）的乘积几乎是一个常数（constant，简称C）。用公式表示，就是 r × f = C 。

代码：

    .. sourcecode:: c

        #include <iostream.h>
        #include <stdlib.h>
        #include <math.h>

        const int R = 2000;  //数据元素, 有R个不同的频率, 数值越大,对应频率越小,逐渐趋于0
        const double A = 1.25;  //定义参数A>1的浮点数, 后来测试小于1的,似乎也可以
        const double C = 1.0;  //这个C是不重要的,一般取1, 可以看到下面计算中分子分母可以约掉这个C

        double pf[R]; //值为0~1之间, 是单个f(r)的累加值

        void generate()
        {
            double sum = 0.0;
            for (int i = 0; i < R; i++)
            {
                sum += C/pow((double)(i+2), A);  //位置为i的频率,一共有r个(即秩), 累加求和
            }

            for (int i = 0; i < R; i++)
            {
                if (i == 0)
                    pf[i] = C/pow((double)(i+2), A)/sum;
                else
                    pf[i] = pf[i-1] + C/pow((double)(i+2), A)/sum;
            }
        }

        void pick(int n)
        {
            srand(time(00));
            //产生n个数
            for (int i = 0; i < n; i++)
            {
                int index = 0;
                double data = (double)rand()/RAND_MAX;  //生成一个0~1的数
                while (data > pf[index])   //找索引,直到找到一个比他小的值,那么对应的index就是随机数了
                    index++;
                printf("%d ", index);
            }
            printf("%s", "\n");
        }

        int main()
        {
            generate();
            pick(1000);

            return 1;
        }


