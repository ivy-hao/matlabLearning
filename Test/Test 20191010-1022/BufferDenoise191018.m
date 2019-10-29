clc
clear all
close all

%% setting disign
Fs = 16000;
nBits = 16;
nChannels = 1;
recordingTime = 5;
t = 1/Fs:1/Fs:recordingTime;


%% audio recorder

recorder = audiorecorder(Fs,nBits,nChannels);
recordblocking(recorder,recordingTime);
myRecording = getaudiodata(recorder) ;


%% filter design (buttford)
fs = 16000;
bit = 512;
Wp = [500 3000]/(fs/2);
Ws = [300 5000]/(fs/2);
Rp = 3;
Rs = 20;

[N,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(N,Wn);
[z,p,k] = butter(N,Wn);
sos = zp2sos(z,p,k);
figure('name','tf');
freqz(sos,bit,fs);
set(gca,'xscale','log');

%% Direct filtering

directFiltering = filter(b,a,myRecording);

%% fft

delta_fs = fs/length(myRecording);
Y_myRecording = fft(myRecording);
Y_myRecording = fftshift(Y_myRecording);
Y_directFiltering = fft(directFiltering);
Y_directFiltering = fftshift(Y_directFiltering);


%% buffer & filtering

frameLength = 256;
overLap = 80;
y_buffer = buffer(myRecording,frameLength,overLap,'nodelay');
numFrame = size(y_buffer,2);
y_buffer_window = y_buffer.*hamming(frameLength);

toBeWinData = ones((frameLength-overLap)*(numFrame-1)+frameLength,numFrame);

for i = 1:numFrame
    toBeWinData(:,i)=[zeros(1,(i-1)*(frameLength-overLap))';y_buffer_window(:,i);zeros((numFrame-i)*(frameLength-overLap),1)];
end
dataRecover = sum(toBeWinData,2);

bufferFiltering = filter(b,a,dataRecover);
bufferFiltering = bufferFiltering(1:length(myRecording));
Y_bufferFiltering = fft(bufferFiltering);
Y_bufferFiltering = fftshift(Y_bufferFiltering);




%% figure

figure('name','filter effect contrast')
hold on
plot(t,myRecording,'r')
plot(t,directFiltering,'g')
plot(t,bufferFiltering,'b')
hold off

figure('name','filter effect fft contrast');
hold on
plot([-fs/2:delta_fs:fs/2-delta_fs],abs(Y_myRecording),'r')
plot([-fs/2:delta_fs:fs/2-delta_fs],abs(Y_directFiltering),'g')
plot([-fs/2:delta_fs:fs/2-delta_fs],abs(Y_bufferFiltering),'b')
hold off

figure('name','filter effect spectrogram contrast')
subplot(3,1,1)
spectrogram(myRecording,frameLength,overLap,frameLength,fs,'yaxis')
subplot(3,1,2)
spectrogram(directFiltering,frameLength,overLap,frameLength,fs,'yaxis')
subplot(3,1,3)
spectrogram(bufferFiltering,frameLength,overLap,frameLength,fs,'yaxis')

%% sound playback
sound(myRecording,Fs);
pause(5);
sound(directFiltering,Fs);
pause(5);
sound(bufferFiltering,Fs);

%% audiowave
audiowrite("myRecording191018.wav",myRecording,Fs);
audiowrite("direcrFiltering191018.wav",myRecording,Fs);
audiowrite("bufferFiltering191018.wav",myRecording,Fs);
