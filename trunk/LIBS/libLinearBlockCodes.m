function [result linearcode sindrome time] = libLinearBlockCodes(bitstream, bit_duration, n_of_sample_b)
%libLinearBlockCodes           
%[result linearcode sindrome time] = libLinearBlockCodes(bitstream, bit_duration, n_of_sample_b)
%Linear block codes (8,4) of a binary number.

%OUTPUT
%result: if 1 process was succeed, 0 in the other case.
%linearcode: Linear Block Code
%sindrome: Syndrome S = rH' => 0

%INPUT
%bitstream: Bit stream signal to modulate signal. Example: bitstream = [1 1 0 0]
%           is a vector !!!!!!!!!!!!!!
%bit_duration: Duration in seconds of every bit of the stream. It must be
%              greater than cero.
%n_of_sample_b: Number of samples per bit. It must be grater than 2.

%%VALIDATIG INPUTS
result = 1; %
[filas columnas] = size(bitstream);
if filas > 1 && columnas > 1
   if verbose == 1
       disp('Bitstream must be a vector');
   end
   result = 0; 
else
   length_bitstream = length(bitstream);
end;

one = ones(1,n_of_sample_b);
cero = zeros(1,n_of_sample_b);

n = 8;
k = 4;
p = 2;
u = [1 0 1 0]
In = eye(n);
Ik = eye(k);
Ink = eye(n-k);

P = [0 0 0 1;0 1 1 0;1 1 0 0;1 1 1 0];

G = [P Ik];

linearcode2 = [];
sindrome = [];

for i=1:4:length_bitstream
    u = bitstream(i:i+3);    
    CL = mod(u*G,p);
    H = mod([Ink P'],p);
    S = mod(CL*H',p);
    linearcode2 = [linearcode2 CL]
    sindrome = [sindrome S]
    if S == [0 0 0 0]
        result = 1;
    else
        result = 0;
    end;
end;

length_cod = length(linearcode2);
time=0:(bit_duration/n_of_sample_b):(length_cod*bit_duration-bit_duration/n_of_sample_b);
one = ones(1,n_of_sample_b);
cero = zeros(1,n_of_sample_b);
linearcode = [];
for i = 1:1:length(linearcode2)
    if linearcode2(i) == 1
        linearcode = [linearcode one];
    else
        linearcode = [linearcode cero];
    end;
end;
    
    
    

