function [result codort] = libCodOrt1bit(bitstream)
%CodOrt1bit           
%[result codort] = CodOrt1bit(bitstream)
%orthogonal encoding (1 bit) of a binary number.
%odd parity (0 --> 0 0 1)  (1 --> 0 1 0)  bit 3 is the parity !!!!
%bit parity = 1 --> code sent '00' = 0
%bit parity = 0 --> code sent '01' = 1

%OUTPUT
%result: if 1 modulation was succeed, 0 in the other case.
%codort: orthogonal code

%INPUT
%bitstream: Bit stream signal to modulate signal. Example: bitstream = [1 1 0 0]
%           is a vector !!!!!!!!!!!!!!

%%VALIDATIG INPUTS
length_bitstream = 1;
result = 1; %
[filas columnas] = size(bitstream);
if filas > 1 && columnas > 1
   if verbose == 1
       disp('Bitstream must be a vector');
   end
   result = 0; 
else
   length_bitstream = length(bitstream);
end

H=[0 0;0 1];
H0 = H(1,:);
H1 = H(2,:);
codort = [];
for i=1:length_bitstream
    if bitstream(i)==0
        paridad = 1;
        codort = [codort H0 paridad];
    else
        paridad = 0;
        codort = [codort H1 paridad];
    end;
end;
