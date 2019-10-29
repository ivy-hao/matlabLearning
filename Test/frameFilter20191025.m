clc
clear all
close all

%% signal setting
fs = 16000; %¼������Ƶ��
chennel = 1; %¼������
sampling = 16; %¼��λ��
recordingTime = 5; %¼��ʱ��
t = 0:1/fs:recordingTime-1/fs; %¼����������ʱ��������

recorder = audiorecorder(fs,sampling,chennel); %�ɼ�����

recordblocking(recorder,recordingTime); %��������һ��ʱ��

myrecording = getaudiodata(recorder); %��¼�����ݱ��浽������


%% frame
frameLen = 256; %��֡���ݳ���
overLap = 80; %�Ӵ��ص����ݳ���
xBuffer= buffer(myrecording,frameLen,overLap,'nodelay' ); %��֡
xBufferHamming=xBuffer.*hamming(frameLen); %�Ӻ�����
numframe = size(xBuffer,2); %֡������


%% one frame fft & Filter & dataRecover
fs = 16000;
n = 0:frameLen-1;
yfft = zeros(frameLen,numframe);
for i=1:numframe
   yfft(:,i)= fft(xBufferHamming(:,i),frameLen); %ÿ֡��fft
end
%filter
   filter = ones(1,256); 
   filter(1:16) = 0;
   filter(241:256) = 0;
   figure('name','filter');
   stem(filter);

    mag = abs(yfft); % ÿ֡��Ƶ
    pha = angle(yfft); %ÿ֡��Ƶ
    f = n*fs/frameLen; %ÿ֡Ƶ���������
    magFilter = mag.*filter' ; %ÿ֡��Ƶ�˲�
    aFilter = magFilter.*cos(pha); %ÿ֡Ƶ���˲���ʵ��
    bFilter = magFilter.*sin(pha); %ÿ֡Ƶ���˲�������
    yFilter = aFilter+1i*bFilter; %ÿ֡Ƶ���˲�������
    xFilter = real(ifft(yFilter)); %ÿ֡Ƶ���˲���ʱ������
    
    
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






