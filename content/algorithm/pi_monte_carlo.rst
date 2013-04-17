计算pi(蒙特卡罗方法)
=========================

:date: 2008-10-29 14:10:51
:tags: Datamining

描述：

    用该方法计算π（pi）的基本思路是：根据圆面积的公式： s=πR^2 ,当R=1时，S=π。

    由于圆的方程是：x^2+y^2=1,因此1/4圆面积为x轴、y轴和上述方程所包围的部分。 如果在1*1的正方形中均匀地落入随机点，则落入1/4圆中的点的概率就是1/4圆的面积。其4倍，就是圆面积。由于半径为1，该面积的值为π的值。

代码：

    C实现

    .. sourcecode:: c

        //使用Monte Carlo计算pi值
        #include <iostream.h>
        #include <time.h>
        #include <iomanip.h>

        const long N=2000000000;  //定义随机点数

        int main()
        {
            int n = 0;      //统计落入1/4单位圆内的点数
            double x, y;  //坐标

            srand(time(00));

            for (int i = 1; i <= N; i++)
            {
                x = (double)rand()/RAND_MAX; //随机产生x,y坐标,在0~1之间
                y = (double)rand()/RAND_MAX;

                if (x*x + y*y <= 1.0) n++;
            }

            cout<<"The PI is "<<setprecision(15)<<4*(double)n/N<<endl;
            return 1;
        }

    测试结果

    .. sourcecode:: bash

        $ time ./pi
        The PI is 3.141627052

        real    3m58.385s
        user    3m36.050s
        sys    0m1.584s

    实验结果和实际相差很大的话，可以通过扩大随机测试值来获得更精确的结果。

    注：实验中可以应用“iomanip.h”中的setprecision(int);来设置输出精度。

    java实现

    .. sourcecode:: java

        public class CalculatePI
        {
           public static final int N = 2000000000;
           public static void main(String[] args)
           {
              double x, y;
              int n = 0;
              for (int i = 0; i < N; i++)
              {
                 x = Math.random();
                 y = Math.random();

                 if (x * x + y * y <= 1)
                    n++;
              }
              System.out.println("The PI is " + 4*(double)n/N);
           }
        }
