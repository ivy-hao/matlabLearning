clc
clear all
close all

%% signal setting
fs = 16000; %录音采样频率
chennel = 1; %录音声道
sampling = 16; %录音位数
recordingTime = 5; %录音时间
t = 0:1/fs:recordingTime-1/fs; %录音到的数据时间间隔设置

recorder = audiorecorder(fs,sampling,chennel); %采集声音

recordblocking(recorder,recordingTime); %声音保持一段时间

myrecording = getaudiodata(recorder); %将录音数据保存到数列中


%% frame
frameLen = 256; %分帧数据长度
overLap = 80; %加窗重叠数据长度
xBuffer= buffer(myrecording,frameLen,overLap,'nodelay' ); %分帧
xBufferHamming=xBuffer.*hamming(frameLen); %加海明窗
numframe = size(xBuffer,2); %帧的数量


%% one frame fft & Filter & dataRecover
fs = 16000;
n = 0:frameLen-1;
yfft = zeros(frameLen,numframe);
for i=1:numframe
   yfft(:,i)= fft(xBufferHamming(:,i),frameLen); %每帧做fft
end
%filter
   filter = ones(1,256); 
   filter(1:16) = 0;
   filter(241:256) = 0;
   figure('name','filter');
   stem(filter);

    mag = abs(yfft); % 每帧幅频
    pha = angle(yfft); %每帧相频
    f = n*fs/frameLen; %每帧频域横轴设置
    magFilter = mag.*filter' ; %每帧幅频滤波
    aFilter = magFilter.*cos(pha); %每帧频域滤波后实轴
    bFilter = magFilter.*sin(pha); %每帧频域滤波后虚轴
    yFilter = aFilter+1i*bFilter; %每帧频域滤波后数据
    xFilter = real(ifft(yFilter)); %每帧频域滤波后时域数据
    
    
 %dataRecover  
 xFrame = ones(((numframe-1)*(frameLen-overLap)+frameLen),numframe);
for i = 1:numframe
    xFrame(:,i)=[zeros(1,(i-1)*(frameLen-overLap))';xFilter(:,i);zeros((numframe-i)*(frameLen-overLap),1)];
   
end

filterData = sum(xFrame,2);
filterData = filterData(1:length(myrecording));
%% figure
figure('name','myrecording & filterData');
hold on
plot(t,myrecording,'r')
plot(t,filterData,'b')
hold off

%% fft
yfft_myrecording = abs(fft(myrecording));
yfft_filterData = abs(fft(filterData));

figure('name','fft');
hold on
plot(yfft_myrecording,'r');
plot(yfft_filterData,'b');
hold off

%% audio wirte
audiowrite("myrecording191025.wav",myrecording,fs);
audiowrite("filterData191025.wav",filterData,fs);






