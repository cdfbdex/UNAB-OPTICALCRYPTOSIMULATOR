function [signal_output] = libPhysicalCanal(signal,...
                           Ganancia_Transmisor, Ganancia_Receptor,...
                           Distancia_Entre_Receptor_Emisor,...
                           Longitud_Onda, RuidodB)
%INPUT
%   signal:
%   Ganancia_Transmisor:
%   Ganancia_Receptor:
%   Distancia_Entre_Receptor-Emisor:
%   Longitud_Onda, Ruido_dB
%OUTPUT
%   signal_output:

Atenuacion = (sqrt(Ganancia_Transmisor*Ganancia_Receptor))*(Longitud_Onda/(4*pi*Distancia_Entre_Receptor_Emisor));
SNR = RuidodB;
signal_output = libNoise_and_Attenuation(signal, SNR, Atenuacion);