
clc
clear all
close all

%% parameter setting

fs = 16000;
chennel = 1;
sampling = 16;
frameLen = 256;
overLap = 80;
recordingTime = 5;
timeaxis = 0:1/fs:recordingTime-1/fs;

%% audiorecorder

recorder = audiorecorder(fs,sampling,chennel);

recordblocking(recorder,recordingTime);

myrecording = getaudiodata(recorder);

% audioArray = buffer(myrecording,frameLen,overLap);

%% sound playback

sound(myrecording,16000);

%% figure plot

figure('name','recorder 5s data');
subplot(2,1,1)
plot(timeaxis,myrecording);
subplot(2,1,2)
spectrogram(myrecording,frameLen,overLap,frameLen,fs,'yaxis');
