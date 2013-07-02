function [result codort2 time] = libCodOrt2bits(bitstream, typeortog, parity, bit_duration, n_of_sample_b)
%libCodOrt2bits           
%[result codort] = libCodOrt2bits(bitstream, typeortog, parity)
%orthogonal encoding (2 bits) of a binary number.
%typeortog = 1-->orthogonal
    %bit 5 is the parity !!!!
    %00-->0000 + bit parity
    %01-->0101 + bit parity
    %10-->0011 + bit parity
    %11-->0110 + bit parity
%typeortog = 2-->biorthogonal
    %bit 3 is the parity !!!!
    %00-->00 + bit parity
    %01-->01 + bit parity
    %10-->11 + bit parity
    %11-->10 + bit parity

%OUTPUT
%result: if 1 process was succeed, 0 in the other case.
%codort2: orthogonal code

%INPUT
%bitstream: Bit stream signal to modulate signal. Example: bitstream = [1 1 0 0]
%           is a vector !!!!!!!!!!!!!!
%typeortog: type orthogonality: 1-->orthogonal or 2-->biorthogonal
%parity: type parity: 1-->impar (1100 = 0, 1101 = 1) or 2-->par (1100 = 1, 1101 = 0)
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
length_bitstream

one = ones(1,n_of_sample_b);
cero = zeros(1,n_of_sample_b);

%type orthogonality: 1-->orthogonal
if typeortog == 1
    H=[0 0;0 1];
    H2=[H H;H not(H)];
    H_0 = H2(1,:);
    H_1 = H2(2,:);
    H_2 = H2(3,:);
    H_3 = H2(4,:);
    codort = [];
    %type parity: 1-->impar (1100 = 0, 1101 = 1) 
    if parity == 1
       paridad = 1;
    %type parity: 2-->par (1100 = 1, 1101 = 0)   
    else
       paridad = 0;
    end;         
    
    for i=1:2:length_bitstream
        bitstream(i:i+1);
        if bitstream(i:i+1) == [0 0]            
            codort = [codort H_0 paridad];
        elseif bitstream(i:i+1) == [0 1]
            codort = [codort H_1 paridad];
        elseif bitstream(i:i+1) == [1 0]
            codort = [codort H_2 paridad];
        elseif bitstream(i:i+1) == [1 1]
            codort = [codort H_3 paridad];
        end;
    end;
end;

%type orthogonality:  2-->biorthogonal
if typeortog == 2
    H=[0 0;0 1];
    H2=[H; not(H)];
    H_0 = H2(1,:);
    H_1 = H2(2,:);
    H_2 = H2(3,:);
    H_3 = H2(4,:);
    codort = [];
    for i=1:2:length_bitstream
        bitstream(i:i+1);        
        %type parity: 1-->impar (1100 = 0, 1101 = 1) 
        if parity == 1
            if bitstream(i:i+1) == [0 0]
                paridad = 1;
                codort = [codort H_0 paridad];
            elseif bitstream(i:i+1) == [0 1]
                paridad = 0;
                codort = [codort H_1 paridad];
            elseif bitstream(i:i+1) == [1 0]
                paridad = 1;
                codort = [codort H_2 paridad];
            elseif bitstream(i:i+1) == [1 1]
                paridad = 0;
                codort = [codort H_3 paridad];
            end;
        %type parity: 2-->par (1100 = 1, 1101 = 0)
        else            
            if bitstream(i:i+1) == [0 0]
                paridad = 0;
                codort = [codort H_0 paridad];
            elseif bitstream(i:i+1) == [0 1]
                paridad = 1;
                codort = [codort H_1 paridad];
            elseif bitstream(i:i+1) == [1 0]
                paridad = 0;
                codort = [codort H_2 paridad];
            elseif bitstream(i:i+1) == [1 1]
                paridad = 1;
                codort = [codort H_3 paridad];
            end;
        end;
    end;
end;

length_codort = length(codort);
time=0:(bit_duration/n_of_sample_b):(length_codort*bit_duration-bit_duration/n_of_sample_b);
one = ones(1,n_of_sample_b);
cero = zeros(1,n_of_sample_b);
codort2 = [];
for i = 1:1:length(codort)
    if codort(i) == 1
        codort2 = [codort2 one];
    else
        codort2 = [codort2 cero];
    end;
end;
    
    
    

