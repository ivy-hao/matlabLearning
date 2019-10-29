
clc
clear all
close all

%% parameter setting

fs = 16000;
chennel = 1;
sampling = 16;
frameLen = 512;
overLap = 0.5*frameLen;

%% buttord fiter setting 1 £º

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
[bb1,ab1]=impinvar(bb,ab,Fs);
figure('name','z')
freqz(bb1,ab1,160,16000)
set(gca,'xscale','log')
%% buttord fiter setting 2 £º

wp = [400/(Fs/2) 3000/(Fs/2)];
ws = [20/(Fs/2) 5000/(Fs/2)];
Rp = 5;
Rs = 40;
[N,Wn] = buttord(wp,ws,Rp,Rs);
fprintf('N=%4d\n',N);
[bb2,ab2] = butter(N,Wn);
Fs=16000;
W = 0:100:16000*pi; 
figure('name','z')
freqz(bb2,ab2,160,16000)
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

denoiserecording1 = filter(bb1,ab1,myrecording);
denoiserecording2 = filter(bb2,ab2,myrecording);

figure('name','denoise recording')
hold on
plot(myrecording,'r');
plot(denoiserecording1,'b');
plot(denoiserecording2,'y');
hold off
y2 = fft(denoiserecording1);
y2 = fftshift(y2);
y3 = fft(denoiserecording2);
y3 = fftshift(y3);

figure('name','contrast in freq domin');
hold on
plot([-fs/2:derta_fs:fs/2-derta_fs],abs(y1),'r');
plot([-fs/2:derta_fs:fs/2-derta_fs],abs(y2),'b');
plot([-fs/2:derta_fs:fs/2-derta_fs],abs(y3),'y');

ylim([0,500]);
hold off

%% sound playback

sound(myrecording,16000);
pause(5);
sound(denoiserecording1,16000);
pause(5);
sound(denoiserecording2,16000);


%% figure plot

figure('name','recorder 5s data');
subplot(3,2,1)
plot(myrecording);
subplot(3,2,2)
spectrogram(myrecording,frameLen,0,frameLen,fs,'yaxis');

subplot(3,2,3)
plot(denoiserecording1);
subplot(3,2,4)
spectrogram(denoiserecording1,frameLen,0,frameLen,fs,'yaxis');

subplot(3,2,5)
plot(denoiserecording2);
subplot(3,2,6)
spectrogram(denoiserecording2,frameLen,0,frameLen,fs,'yaxis');





%% audio write

audiowrite("myrecording191011.wav",myrecording,fs);
audiowrite("denoiseRecording1_191011.wav",denoiserecording1,fs);
audiowrite("denoiseRecording2_191011.wav",denoiserecording2,fs);
