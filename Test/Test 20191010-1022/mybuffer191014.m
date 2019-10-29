clc
clear all
close all

%% paramters setting
fs = 16000;
chennel = 1;
sampling = 16;
frameLen = 256;
overLap = 80;

%% audiorecorder

recorder = audiorecorder(fs,sampling,chennel);

recordblocking(recorder,5);

myrecording = getaudiodata(recorder);

%% buffer

y = buffer(myrecording,frameLen,overLap,'nodelay' );

y=y.*hamming(frameLen);
numframe = size(y,2);

yAppend = ones(((numframe-1)*(frameLen-overLap)+frameLen),numframe);
for i = 1:numframe
    yAppend(:,i)=[zeros(1,(i-1)*(frameLen-overLap))';y(:,i);zeros((numframe-i)*(frameLen-overLap),1)];
    
end

dataRecover = sum(yAppend,2);

figure('name','comparison')
hold on
plot(myrecording)
plot(dataRecover)
hold off

sound(myrecording,fs);
pause(5);
sound(dataRecover,fs);

