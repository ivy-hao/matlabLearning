clc
clear all
close all

%% signal setting (creat a sine signal with multiple frequencies )

F1 = 1000;A1 = 3;
F2 = 3000;A2 = 1;
F3 = 15000;A3 = 0.3;
F4 = 15500;A4 = 0.1;
% 如何选择采样频率和信号长度：85个实例P85
%（1）根据采样定理fs》2*Fmax,fs最小为10000Hz，此处选用60000Hz
%（2）根据频域分辨率分析，此处选用N=60
% 若要区分F1&F2的频率分量，最小采样长度应满足N1》fs/Δfmin=30000/(3000-1000)=15,
% 若要区分F2&F3的频率分量，最小采样长度应满足N1》fs/Δfmin=30000/(5000-3000)=15,

%正弦信号的幅值：85个实例P42
%A=2*abs（X（i））/N ，与各点傅里叶变换后的幅值和做傅里叶变换的数据点数有关


fs = 60000; %采样频率
N = 60; %数据点数
n = 0:N-1;
t = n/fs;

x = A1*sin(2*pi*F1*t)+A2*sin(2*pi*F2*t)+A3*sin(2*pi*F3*t)+A4*sin(2*pi*F4*t);


%% fft

y = fft(x,N); %fft
f = n*fs/N; %频域横轴
mag = abs(y); %fft后幅频数据
pha = angle(y);%fft后相频数据
figure('name','fft');
subplot(2,1,1)
stem(f,mag)
subplot(2,1,2)
stem(f,pha)
%% ifft
a = mag.*cos(pha);
b = mag.*sin(pha);
yi = a+1i*b;
xifft = real(ifft(yi));
figure('name','x&xifft');
hold on 
plot(t,x)
plot(t,xifft)
hold off


%% filter
%此处设置滤去15K点的影响，查看结果15K效果被滤去，并且会波及到附近频率的幅值
filter = ones(1,60);
filter(16) = 0;
filter(46) = 0;
magFilter = mag .* filter;
figure('name','filter');
stem(filter)

%% Filter ifft
aFilter = magFilter.*cos(pha);
bFilter = magFilter.*sin(pha);
yFilter = aFilter+1i*bFilter;
xFilter = real(ifft(yFilter));
figure('name','x&xFilter');
hold on
plot(t,x)
plot(t,xFilter)
hold off

