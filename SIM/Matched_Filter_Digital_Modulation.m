addpath('../LIBS');
b = [1 0 1 1 1 0 1 0 1 0 0 0];
n = length(b);

modulation_type = 3; %1:ASK, 2:FSK and 3:PSK.
Frequency1 = 1;
Frequency2 = 2;
Num_Muestras = 100;
Amplitud = 400;
Umbral = 0.5*Amplitud; %Use 0.5 for ASK and FSK; 0.0 for PSK;

[modulated_signal time singal0 signal1] = libDigitalModulation(b, modulation_type, Frequency1, Frequency2, Num_Muestras,Amplitud);
[result pcm time2] = libPCM(b, 1, 1/Frequency1, Num_Muestras, 1, 0, 0);

figure(1);
plot(time2,pcm, 'LineWidth',4);
title('Bit Stream NRL-Z Coding');

figure(2);
plot(time, modulated_signal);
title('Modulated Singal');
length(time)
length(modulated_signal)

signal_noisy = libNoise_and_Attenuation(modulated_signal, 2, 1);
figure(3);
plot(time, signal_noisy);
title('Modulated Signal + Noise');

%DETECTION
A=[];
for i=1:n
    if sum(signal1.*signal_noisy(1+Num_Muestras*(i-1):Num_Muestras*i))>Umbral
        A=[A 1];
    else
        A=[A 0];
    end
end


[result pcm2 time3] = libPCM(A, 1, 1/Frequency1, Num_Muestras, 1, 0, 0);
figure(4);
plot(time3, pcm2, 'LineWidth',4);
title('Output Bit Stream NRL-Z Coding');

Num_Muestras=1;
color0='r';color1='b';
a = axis;
A=[];
for i=1:n
    if sum(signal1.*signal_noisy(1+Num_Muestras*(i-1):Num_Muestras*i))>Umbral
        A=[A 1];
		h = text(i*Num_Muestras-10,.75*a(4),'1');
		set(h,'fontsize',16);set(h,'color',color1);
		if b(i) == 0
			set(h,'fontweight','bold');
		end        
    else
        A=[A 0];
		h = text(i*Num_Muestras-10,.75*a(4),'0');
		set(h,'fontsize',16);set(h,'color',color0);
		if b(i) == 1
			set(h,'fontweight','bold');
		end        
    end
end
for i=Num_Muestras*[1:length(b)],h=line([i i],a(3:4));set(h,'linestyle','--');end