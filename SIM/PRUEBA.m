% %% Setup 
% % Define parameters. 
% M = 16; % Size of signal constellation 
% k = log2(M); % Number of bits per symbol 
% n = 3e4; % Number of bits to process = 30,000 
% Fd=1;Fs=1; %Input message sampling frequency, output message sampling frequency 
% nsamp = 1; % Oversampling rate 
% %% Signal Source 
% % Create a binary data stream as a column vector. 
% x = randint(n,1); % Random binary data stream 
% % Plot first 40 bits in a stem plot. 
% stem(x(1:40),'filled'); 
% title('Random Bits'); 
% xlabel('Bit Index'); ylabel('Binary Value');




%% Bit-to-Symbol Mapping 
% Convert the bits in x into k-bit symbols. 
xsym = bi2de(reshape(x,k,length(x)/k).','left-msb'); 
%% Stem Plot of Symbols 
% Plot first 10 symbols in a stem plot. 
figure; % Create new figure window. 
stem(xsym(1:10)); 
title('Random Symbols'); 
xlabel('Symbol Index'); ylabel('Integer Value'); 





%y2=[1 0 1 0 1 1 1 0];
% y3=zeros(length(y2),10);
% t3=0:1/80:1/80*9;
% t2=0:7;
% 
% for k=1:length(y2)
%     if(y2(k)==1)
%         y3(k,:)=y2(k)*sin(t3);
%     else
%         y3(k,:)=y2(k)+sin(t3+pi);
%     end
% end







%axes(handles.axes3);
%plot(t2,y3);