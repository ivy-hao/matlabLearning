clc
clear all
close all

%% signal setting (creat a sine signal with multiple frequencies )

F1 = 1000;A1 = 1;
F2 = 3000;A2 = 3;
F3 = 5000;A3 = 5;

fs = 30000; %采样频率
N = 30; %数据点数
n = 0:N-1
t = n/fs;

x = A1*sin(2*pi*F1*t)+A2*sin(2*pi*F2*t)+A3*sin(2*pi*F3*t);

%% fft

y = fft(x,N); %fft
% yfftshift = fftshift(y);

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
xifft = ifft(yi);

figure('name','x&xifft');
hold on 
plot(t,x)
plot(t,xifft)
hold off