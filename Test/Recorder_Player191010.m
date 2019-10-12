
clc
clear all
close all

%% parameter setting

fs = 16000;
chennel = 1;
sampling = 16;
frameLen = 256;
overLap = 80;

%% audiorecorder

recorder = audiorecorder(fs,sampling,chennel);

recordblocking(recorder,5);

myrecording = getaudiodata(recorder);

% audioArray = buffer(myrecording,frameLen,overLap);

%% sound playback

sound(myrecording,16000);

%% figure plot

figure('name','recorder 5s data');
subplot(2,1,1)
plot(myrecording);
subplot(2,1,2)
spectrogram(myrecording,frameLen,0,frameLen,fs,'yaxis');
