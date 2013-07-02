function [signal2] = libNoise_and_Attenuation(signal, S_N, AttFactor)

% descripción

% [signal2] = libNoise_and_Attenuation([signal], S_N, AttFactor)
% 
% Noise and Attenuation signal funtion adds noise and attenuates
% the signal with a S_N ratio, and a attenuation factor respectively.
% 
% OUTPUT
% [signal2]: noised and attenuated signal vector.
% 
% INPUT
% [signal]: is the signal to be noised and attenuated.
% S_N: is the signal to noise ratio.
% AttFactor: is the attenuation factor can be defined from 0 and above, prefe
% rible 0<AttFactor<1.



signal2 = awgn(signal, S_N , 'measured');
signal2 = AttFactor*signal2;





