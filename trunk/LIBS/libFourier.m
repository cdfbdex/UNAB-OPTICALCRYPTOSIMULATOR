function [Y f] = libFourier(signal,Fs)

T = 1/Fs;                     % Sample time
L = length(signal);           % Length of signal
t = (0:L-1)*T;                % Time vector

y = signal;
Y = fft(y,L);
f = Fs/2*linspace(0,1,L/2+1);