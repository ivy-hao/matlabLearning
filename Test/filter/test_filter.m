clc
clear all
close all

%% signal setting (creat a sine signal with multiple frequencies )

F1 = 1000;A1 = 3;
F2 = 3000;A2 = 1;
F3 = 15000;A3 = 0.3;
F4 = 15500;A4 = 0.1;
% ���ѡ�����Ƶ�ʺ��źų��ȣ�85��ʵ��P85
%��1�����ݲ�������fs��2*Fmax,fs��СΪ10000Hz���˴�ѡ��60000Hz
%��2������Ƶ��ֱ��ʷ������˴�ѡ��N=60
% ��Ҫ����F1&F2��Ƶ�ʷ�������С��������Ӧ����N1��fs/��fmin=30000/(3000-1000)=15,
% ��Ҫ����F2&F3��Ƶ�ʷ�������С��������Ӧ����N1��fs/��fmin=30000/(5000-3000)=15,

%�����źŵķ�ֵ��85��ʵ��P42
%A=2*abs��X��i����/N ������㸵��Ҷ�任��ķ�ֵ��������Ҷ�任�����ݵ����й�


fs = 60000; %����Ƶ��
N = 60; %���ݵ���
n = 0:N-1;
t = n/fs;

x = A1*sin(2*pi*F1*t)+A2*sin(2*pi*F2*t)+A3*sin(2*pi*F3*t)+A4*sin(2*pi*F4*t);


%% fft

y = fft(x,N); %fft
f = n*fs/N; %Ƶ�����
mag = abs(y); %fft���Ƶ����
pha = angle(y);%fft����Ƶ����
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
%�˴�������ȥ15K���Ӱ�죬�鿴���15KЧ������ȥ�����һᲨ��������Ƶ�ʵķ�ֵ
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

