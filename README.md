# EDF-格式脑电数据的预处理程序

本程序基于MATLAB实现EDF格式的脑电数据预处理

预处理流程为：

1. 删除不需要的trigger种类脑电信号
1. 删除不需要的通道
1. 全脑平均做reference
1. 选择通道
1. 降采样
1. 频域滤波
1. 分段，trigger前100ms做基线，截取tiger前100ms至后1000ms的数据

用于测试的数据含有12种trigger，其中数值最小的trigger是背景trigger，其他trigger是特定刺激下的脑电信号。<br>本程序根据后期数据分析处理需要，将trigger 1、trigger 3、trigger 5、trigger 7、trigger 9 10、trigger 2 4 6 8分别进行分段，得到数据data_1、data_3、data_5、data_7、data_9_10、data_even。

[数据下载](https://pan.baidu.com/s/1c17U8V2)
