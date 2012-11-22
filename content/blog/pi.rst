计算pi(级数方法)
==================

:date: 2008-10-29 14:10:18
:tags: Datamining

描述：

    从计算来说，用蒙特卡洛法计算值确实粗糙，我们一般用更好的方法来计算。比如说级数的方法,本质上是利用pi的一个迭代公式.

代码：

    .. sourcecode:: c

        //计算pi的更好方法,级数方法
        #include <iostream.h>
        #include <iomanip.h>

        int main()
        {
            double sum = 0.0, f = 1;

            for (int i = 1; ; i += 2)
            {
                sum += f/i;
                if (1.0/i <= 1e-14) break;
                f = -f;
            }
            cout<<"The PI is "<<setprecision(15)<<4*sum<<endl;
        }

    实验结果:

    ::

        time ./pi_ad
        The PI is 3.14159265079399

        real    1m8.378s
        user    0m34.478s
        sys    0m0.384s

    这个速度要比前面那个快多了...

    .. sourcecode:: java

        //java实现
        public class CalculatePI_Ad
        {
           public static void main(String[] args)
           {
              double sum = 0.0, f = 1;
              for (int i = 1; ; i +=2)
              {
                 sum += f / i;
                 if (1.0 / i <= 1e-15)
                    break;
                 f = -f;
              }
              sum *= 4;
              System.out.println("The PI is " + sum);
              System.out.println("The PI in Math class is " + Math.PI);
           }
        }
