N = 100; % Number of samples per bit

bitstream = [1 0 1 0 0];
bits = ['1','0','1','0','0']
[result pcm time s1 s0] = libPCM(bitstream, 1, 1, N, 1, 0, 0);

signal1 = ones(1,N);
signal0 = zeros(1,N);
% signal1 = s1;
% signal0 = s0;

color0='r';color1='b';



r = libNoise_and_Attenuation(pcm,50,1);
% Run matched filters
y1=filter(signal1(N:-1:1),1,r);
y0=filter(signal0(N:-1:1),1,r);

t = 0:length(r)-1;
figure(1); plot(pcm,'linewidth',2);
figure(2); plot(r,'linewidth',2);
figure(3); plot(t,y0,color0,t,y1,color1);



a = axis;
for n=1:length(bits)
	if y1(n*N)> y0(n*N)
		h = text(n*N-10,.75*a(4),'1');
		set(h,'fontsize',16);set(h,'color',color1);
		if bits(n) == '0'
			set(h,'fontweight','bold');
		end
	else 
		h = text(n*N-10,.75*a(4),'0');
		set(h,'fontsize',16);set(h,'color',color0);
		if bits(n) == '1'
			set(h,'fontweight','bold');
		end
	end
end
for n=N*[1:length(bits)],h=line([n n],a(3:4));set(h,'linestyle','--');end
h=title('Matched Filter Output');set(h,'fontsize',18);

