
clc
clear all
close all

%% parameter setting

fs = 16000;
chennel = 1;
sampling = 16;
frameLen = 512;
overLap = 0.5*frameLen;

%% buttord fiter setting

wp = [400 3000];
ws = [20 5000];
Rp = 5;
Rs = 40;
[N,Wn] = buttord(wp,ws,Rp,Rs,'s');
fprintf('N=%4d\n',N);
[zb,pb,kb] = butter(N,2*pi*Wn,'s');
[bb,ab] = zp2tf(zb,pb,kb);
W = 0:100:16000*pi; 
figure('name','Laplace')
freqs(bb,ab,W);

Fs=16000; T=1/Fs;                  
[bb,ab]=impinvar(bb,ab,Fs);
figure('name','z')
freqz(bb,ab,160,16000)
set(gca,'xscale','log')



%% audiorecorder

recorder = audiorecorder(fs,sampling,chennel);

recordblocking(recorder,5);

myrecording = getaudiodata(recorder);

% audioArray = buffer(myrecording,frameLen,overLap);
y1 = fft(myrecording);
y1 = fftshift(y1);
derta_fs = fs/length(myrecording);


%% noise reduction

denoiserecording = filter(bb,ab,myrecording);

figure('name','denoise recording')
hold on
plot(myrecording,'r');
plot(denoiserecording,'b');
hold off
y2 = fft(denoiserecording);
y2 = fftshift(y2);

figure('name','contrast in freq domin');
hold on
plot([-fs/2:derta_fs:fs/2-derta_fs],abs(y1),'r');
plot([-fs/2:derta_fs:fs/2-derta_fs],abs(y2));
ylim([0,500]);
hold off

%% sound playback

sound(myrecording,16000);
pause(5);
sound(denoiserecording,16000);

%% figure plot

figure('name','recorder 5s data');
subplot(2,2,1)
plot(myrecording);
subplot(2,2,2)
spectrogram(myrecording,frameLen,0,frameLen,fs,'yaxis');

subplot(2,2,3)
plot(denoiserecording);
subplot(2,2,4)
spectrogram(denoiserecording,frameLen,0,frameLen,fs,'yaxis');

%% audio write

audiowrite("myrecording191011.wav",myrecording,fs);
audiowrite("denoiseRecording191011.wav",denoiserecording,fs);

