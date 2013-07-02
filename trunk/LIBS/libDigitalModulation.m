function [modulated_signal time singal0 signal1] = libDigitalModulation(bitstream, modulation_type, Frequency1, Frequency2, Num_Muestras, Amplitud)

%INPUT
%   bitstream:
%   modulation_type:
%   Frequency1:
%   Frequency2:
%   Num_Muestras: 
%   Amplitud

%OUTPUT
%   modulated_signal:
%   time:
%   signal0:
%   signal1:

f1= Frequency1;f2=Frequency2;
b = bitstream;
n = length(bitstream);
if f2 > f1
    t=0:1/Num_Muestras:(1/f1)-(1/Num_Muestras);
    time_aux = 0:1/Num_Muestras:((n)/f1)-(1/Num_Muestras);
else
    t=0:1/Num_Muestras:(1/f2)-(1/Num_Muestras);
    time_aux = 0:1/Num_Muestras:((n)/f2)-(1/Num_Muestras);    
end

time = time_aux;

alto = ones(1,length(t));
bajo = zeros(1,length(t));
%ASK
sa1=sin(2*pi*f1*t); %amplitude signal for 1
E1=sum(sa1.^2);
sa1=sa1/sqrt(E1); %unit energy 
sa0=0*sin(2*pi*f1*t); %amplitude signal for 0
%FSK
sf0=sin(2*pi*f1*t); %signal for 0 of frecuency1
E=sum(sf0.^2);
sf0=sf0/sqrt(E);
sf1=sin(2*pi*f2*t); %signal for 1 of frecuency2
E=sum(sf1.^2);
sf1=sf1/sqrt(E);
%PSK
sp0=-sin(2*pi*f1*t)/sqrt(E1);
sp1=sin(2*pi*f1*t)/sqrt(E1);

%MODULATION
senal=[];
ask=[];psk=[];fsk=[];
for i=1:n
    if b(i)==1
        ask=[ask sa1];
        psk=[psk sp1];
        fsk=[fsk sf1];
        senal = [senal alto];
    else
        ask=[ask sa0];
        psk=[psk sp0];
        fsk=[fsk sf0];
        senal = [senal bajo];
    end
end

if modulation_type == 1 %ASK MODULATION
    singal0 = sa0;
    signal1 = sa1;
    modulated_signal = Amplitud*ask;
end

if modulation_type == 2 %FSK MODULATION
    singal0 = sf0;
    signal1 = sf1;
    modulated_signal = Amplitud*fsk;    
end

if modulation_type == 3 %PSK MODULATION
    singal0 = sp0;
    signal1 = sp1;
    modulated_signal = Amplitud*psk;    
end
