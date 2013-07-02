function [I a] = Extraer_Canal(Imag, Canal)

G = imread(Imag);
%I = G(:,:,Canal);
I = G(:,:,Canal);
I = OFDM_FUNCTION(Imag, 2048, 1009, 9, 2, 12 );

fprintf('##########################################\n')
fprintf('#******** END of OFDM Simulation ********#\n')
fprintf('##########################################\n\n')
a =2;
