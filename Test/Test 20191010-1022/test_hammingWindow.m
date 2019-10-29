clc
clear all
close all

toBeWinedData = ones(1,128)';
winedData1 = toBeWinedData(1:64).*hamming(64)
winedData2 = toBeWinedData(33:96).*hamming(64)
winedData3 = toBeWinedData(65:128).*hamming(64)
winedData1 = [winedData1;zeros(1,64)']
winedData2 = [zeros(1,32)';winedData2;zeros(1,32)']
winedData3 = [zeros(1,64)';winedData3]
winedData = winedData1+ winedData2+winedData3
figure('name','hammingWindow')
hold on
stem(toBeWinedData)
stem(winedData)
% stem(winedData1)
% stem(winedData2)
% stem(winedData3)
hold off
figure
subplot(2,2,1)
stem(winedData1)
subplot(2,2,2)
stem(winedData2)
subplot(2,2,3)
stem(winedData3)