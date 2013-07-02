

function [Imagen  Total_Num_Error  Out_Of_Errors  BER  Average_Phase_Error Percent_of_Error Imagen_Encriptada Imagen_Desencriptada t_tx t_rx]...
         = OFDM_FUNCTION2(FileNameImage_Input, Fft_Size, NumCarriers, Amplitude_Clipping, Modulation, SNR,handles )
% *************** MAIN PROGRAM FILE *************** %
% This is the OFDM simulation program's main file.
% It requires a 256-grayscale bitmap file (*.bmp image file) as data source
% and the following 5 script and function m-files to work:
% ofdm_parameters.m, ofdm_base_convert.m, ofdm_modulate.m,
% ofdm_frame_detect.m, ofdm_demod.m
% ####################################################### %
% ************* OFDM SYSTEM INITIALIZATION: ************* %
% **** setting up parameters & obtaining source data **** %
% ####################################################### %
% Turn off exact-match warning to allow case-insensitive input files
%addpath('LIBS');
%warning('off','MATLAB:dispatcher:InexactMatch');
%clear all; % clear all previous data in MATLAB workspace
%close all; % close all previously opened figures and graphs

fprintf('\n\n##########################################\n')
fprintf('#*********** OFDM Simulation ************#\n')
fprintf('##########################################\n\n')
% invoking ofdm_parameters.m script to set OFDM system parameters
ofdm_parameters_func(FileNameImage_Input, Fft_Size, NumCarriers, Amplitude_Clipping, Modulation, SNR );
% save parameters for receiver
load('parametros');
save('ofdm_parameters_funct');
% read data from input file
Im = imread(file_in);
%x = Im(:,:,1);



x = Im;
h = size(x,1)
w = size(x,2)
canales = size(x,3);
Bandera_Criptar = 0;
Bandera_Criptar = handles.Bandera_Encriptar;
if Bandera_Criptar == 1
   Input_Complex = complex(double(x), double(zeros(h, w)));
   Llave_Compleja = handles.Llave;
   Llave_Compleja2 = handles.Llave2;
   
   Encriptado = Encriptador_Optico(Input_Complex, Llave_Compleja);
   Encriptado_Received = Encriptado; 
   Intensidad_Encriptado = uint8(255*((abs(Encriptado))/(max(max(abs(Encriptado))))));
   x_aux = zeros(h,2*w,1, 'double');
   x_aux(:,1:w) = real(Encriptado);
   x_aux(:,w+1:2*w) = imag(Encriptado);
   
   %%VISUALIZING
   xx_aux = x_aux;
   xx_aux(:,1:w) = (255.0/max(max(real(Encriptado)- min(min(real(Encriptado))))))*(real(Encriptado) - min(min(real(Encriptado))));
   xx_aux(:,w+1:2*w) = (255.0/max(max(imag(Encriptado)- min(min(imag(Encriptado))))))*(imag(Encriptado) - min(min(imag(Encriptado))));   
  
   minreal = min(min(real(Encriptado)));
   maxreal= max(max(real(Encriptado)));
   minimag = min(min(imag(Encriptado)));
   maximag= max(max(imag(Encriptado)));

   x = zeros(h,2*w,1, 'double');
   x = xx_aux;
   %imshow(uint8(xx_aux));
end


x_copy = x;



% arrange data read from image for OFDM processing
h = size(x,1)
w = size(x,2)
canales = size(x,3);







if canales == 3
x = zeros(w,h,canales, 'int8');
x(:,:,1) = x_copy(:,:,1)';
x(:,:,2) = x_copy(:,:,2)';
x(:,:,3) = x_copy(:,:,3)';
end

if canales == 1
    x = x';
end



x = reshape(x, 1, w*h*canales);
%x = reshape(x', 1, w*h*canales);
%x = reshape(x, 1, w*h);
baseband_tx = double(x);
% convert original data word size (bits/word) to symbol size (bits/symbol)
% symbol size (bits/symbol) is determined by choice of modulation method
baseband_tx = ofdm_base_convert(baseband_tx, word_size, symb_size);
% save original baseband data for error calculation later
save('err_calc.mat', 'baseband_tx');
% ####################################################### %
% ******************* OFDM TRANSMITTER ****************** %
% ####################################################### %
tic; % start stopwatch
% generate header and trailer (an exact copy of the header)
f = 0.25;
header = sin(0:f*2*pi:f*2*pi*(head_len-1));
f=f/(pi*2/3);
header = header+sin(0:f*2*pi:f*2*pi*(head_len-1));
% arrange data into frames and transmit
frame_guard = zeros(1, symb_period);
time_wave_tx = [];
symb_per_carrier = ceil(length(baseband_tx)/carrier_count);
fig = 1;
if (symb_per_carrier > symb_per_frame) % === multiple frames === %
    power = 0;
    while ~isempty(baseband_tx)
        % number of symbols per frame
        frame_len = min(symb_per_frame*carrier_count,length(baseband_tx));
        frame_data = baseband_tx(1:frame_len);
        % update the yet-to-modulate data
        baseband_tx = baseband_tx((frame_len+1):(length(baseband_tx)));
        % OFDM modulation
        time_signal_tx = ofdm_modulate(frame_data,ifft_size,carriers,...
            conj_carriers, carrier_count, symb_size, guard_time, fig, handles);
        fig = 0; %indicate that ofdm_modulate() has already generated plots
        % add a frame guard to each frame of modulated signal
        time_wave_tx = [time_wave_tx frame_guard time_signal_tx];
        frame_power = var(time_signal_tx);
    end
    % scale the header to match signal level
    power = power + frame_power;
    % The OFDM modulated signal for transmission
    time_wave_tx = [power*header time_wave_tx frame_guard power*header];
else % === single frame === %
    % OFDM modulation
    time_signal_tx = ofdm_modulate(baseband_tx,ifft_size,carriers,...
        conj_carriers, carrier_count, symb_size, guard_time, fig, handles);
    % calculate the signal power to scale the header
    power = var(time_signal_tx);
    % The OFDM modulated signal for transmission
    time_wave_tx = ...
        [power*header frame_guard time_signal_tx frame_guard power*header];
end
% show summary of the OFDM transmission modeling
peak = max(abs(time_wave_tx(head_len+1:length(time_wave_tx)-head_len)));
sig_rms = std(time_wave_tx(head_len+1:length(time_wave_tx)-head_len));
peak_rms_ratio = (20*log10(peak/sig_rms));
fprintf('\nSummary of the OFDM transmission and channel modeling:\n')
fprintf('Peak to RMS power ratio at entrance of channel is: %f dB\n', ...
    peak_rms_ratio)
% ####################################################### %
% **************** COMMUNICATION CHANNEL **************** %
% ####################################################### %
% ===== signal clipping ===== %
clipped_peak = (10^(0-(clipping/20)))*max(abs(time_wave_tx));
time_wave_tx(find(abs(time_wave_tx)>=clipped_peak))...
    = clipped_peak.*time_wave_tx(find(abs(time_wave_tx)>=clipped_peak))...
    ./abs(time_wave_tx(find(abs(time_wave_tx)>=clipped_peak)));
% ===== channel noise ===== %
power = var(time_wave_tx); % Gaussian (AWGN)
SNR_linear = 10^(SNR_dB/10);
noise_factor = sqrt(power/SNR_linear);
noise = randn(1,length(time_wave_tx)) * noise_factor;
time_wave_rx = time_wave_tx + noise;
% show summary of the OFDM channel modeling
peak = max(abs(time_wave_rx(head_len+1:length(time_wave_rx)-head_len)));
sig_rms = std(time_wave_rx(head_len+1:length(time_wave_rx)-head_len));
peak_rms_ratio = (20*log10(peak/sig_rms));
fprintf('Peak to RMS power ratio at exit of channel is: %f dB\n', ...
    peak_rms_ratio)
% Save the signal to be received
save('received.mat', 'time_wave_rx', 'h', 'w');
fprintf('#******** OFDM data transmitted in %f seconds ********#\n\n', toc)
t_tx = toc;
% ####################################################### %
% ********************* OFDM RECEIVER ******************* %
% ####################################################### %
disp('Press any key to let OFDM RECEIVER proceed...')
%pause;
%clear all; % flush all data stored in memory previously
tic; % start stopwatch
% invoking ofdm_parameters.m script to set OFDM system parameters
load('ofdm_parameters_funct');
% receive data
load('received.mat');
time_wave_rx = time_wave_rx.';
end_x = length(time_wave_rx);
start_x = 1;
data = [];
phase = [];
last_frame = 0;
unpad = 0;
if rem(w*h*canales, carrier_count)~=0
    unpad = carrier_count - rem(w*h*canales, carrier_count);
end
num_frame=ceil((h*w*canales)*(word_size/symb_size)/(symb_per_frame*carrier_count));
fig = 0;
for k = 1:num_frame
    if k==1 || k==num_frame || rem(k,max(floor(num_frame/10),1))==0
        fprintf('Demodulating Frame #%d\n',k)
    end
    % pick appropriate trunks of time signal to detect data frame
    if k==1
        time_wave = time_wave_rx(start_x:min(end_x, ...
            (head_len+symb_period*((symb_per_frame+1)/2+1))));
    else
        time_wave = time_wave_rx(start_x:min(end_x, ...
            ((start_x-1) + (symb_period*((symb_per_frame+1)/2+1)))));
    end
    % detect the data frame that only contains the useful information
    frame_start = ofdm_frame_detect(time_wave, symb_period, envelope, start_x);
    if k==num_frame
        last_frame = 1;
        frame_end = min(end_x, (frame_start-1) + symb_period*...
            (1+ceil(rem(w*h*canales,carrier_count*symb_per_frame)/carrier_count)));
    else
        frame_end=min(frame_start-1+(symb_per_frame+1)*symb_period, end_x);
    end
    % take the time signal abstracted from this frame to demodulate
    time_wave = time_wave_rx(frame_start:frame_end);
    % update the label for leftover signal
    start_x = frame_end - symb_period;
    if k==ceil(num_frame/2)
        fig = 1;
    end
    % demodulate the received time signal
    [data_rx, phase_rx] = ofdm_demod...
        (time_wave, ifft_size, carriers, conj_carriers, ...
        guard_time, symb_size, word_size, last_frame, unpad, fig, handles);
    if fig==1
        fig = 0; % indicate that ofdm_demod() has already generated plots
    end
    phase = [phase phase_rx];
    data = [data data_rx];
end
phase_rx = phase; % decoded phase
data_rx = data; % received data
% convert symbol size (bits/symbol) to file word size (bits/byte) as needed
data_out = ofdm_base_convert(data_rx, symb_size, word_size);
fprintf('#********** OFDM data received in %f seconds *********#\n\n', toc)
t_rx = toc;
% ####################################################### %
% ********************** DATA OUTPUT ******************** %
% ####################################################### %
% patch or trim the data to fit a w-by-h image
if length(data_out)>(w*h*canales) % trim extra data
    data_out = data_out(1:(w*h*canales));
elseif length(data_out)<(w*h*canales) % patch a partially missing row
    buff_h = h;
    h = ceil(length(data_out)/w*canales);
    % if one or more rows of pixels are missing, show a message to indicate
    if h~=buff_h
        disp('WARNING: Output image smaller than original')
        disp(' due to data loss in transmission.')
    end
    % to make the patch nearly seamless,
    % make each patched pixel the same color as the one right above it
    if length(data_out)~=(w*h*canales)
        for k=1:(w*h*canales-length(data_out))
            %mend(k)=data_out(length(data_out)-(w*canales)+k);
            %mend(k)=data_out(k);
        end
        mend = zeros(1,w*h*canales-length(data_out));
        data_out = [data_out mend];
    end
end
% format the demodulated data to reconstruct a bitmap image
%data_out = reshape(data_out, w, h, canales)';

if Bandera_Criptar == 1
    data_out_aux = reshape(data_out, w, h, canales);
    data_out_aux = data_out_aux';
    real_aux = data_out_aux(:,1:w/2);
    imag_aux = data_out_aux(:,((w/2)+1):w);
    real_aux = minreal + (((maxreal - minreal)/255.0)*(real_aux)); 
    imag_aux = minimag + (((maximag - minimag)/255.0)*(imag_aux));
    Encriptado_Received = complex(real_aux, imag_aux);
    Desencriptado = Desencriptador_Optico(Encriptado_Received, Llave_Compleja2);
    Encriptado_Received = Desencriptado;
end


data_out = reshape(data_out, w, h, canales);
data_out_copy = data_out;
if canales == 3
data_out = zeros(h,w);    
data_out(:,:,1) = data_out_copy(:,:,1)';
data_out(:,:,2) = data_out_copy(:,:,2)';
data_out(:,:,3) = data_out_copy(:,:,3)';
end

if canales == 1
   data_out = data_out';
end

data_out = uint8(data_out);
% save the output image to a bitmap (*.bmp) file
%imwrite(data_out, file_out, 'bmp');
% ####################################################### %
% ****************** ERROR CALCULATIONS ***************** %
% ####################################################### %
% collect original data before modulation for error calculations
load('err_calc.mat');
fprintf('\n#**************** Summary of Errors ****************#\n')
% Let received and original data match size and calculate data loss rate
if length(data_rx)>length(baseband_tx)
    data_rx = data_rx(1:length(baseband_tx));
    phase_rx = phase_rx(1:length(baseband_tx));
elseif length(data_rx)<length(baseband_tx)
    fprintf('Data loss in this communication = %f%% (%d out of %d)\n', ...
        (length(baseband_tx)-length(data_rx))/length(baseband_tx)*100, ...
        length(baseband_tx)-length(data_rx), length(baseband_tx))
end
% find errors
errors = find(baseband_tx(1:length(data_rx))~=data_rx);
fprintf('Total number of errors = %d (out of %d)\n', ...
    length(errors), length(data_rx))
% Bit Error Rate
fprintf('Bit Error Rate (BER) = %f%%\n',length(errors)/length(data_rx)*100)
% find phase error in degrees and translate to -180 to +180 interval
phase_tx = baseband_tx*360/(2^symb_size);
phase_err = (phase_rx - phase_tx(1:length(phase_rx)));
phase_err(find(phase_err>=180)) = phase_err(find(phase_err>=180))-360;
phase_err(find(phase_err<=-180)) = phase_err(find(phase_err<=-180))+360;
fprintf('Average Phase Error = %f (degree)\n', mean(abs(phase_err)))
% Error pixels
x = ofdm_base_convert(baseband_tx, symb_size, word_size);
x = uint8(x);

% if canales == 3
% x = x(1:(size(data_out,1)*size(data_out,2)*size(data_out,3)));
% end
% 
% if canales == 3
% x = x(1:(size(data_out,1)*size(data_out,2)));    
% end

% data_out(:,:,1) = data_out(:,:,1)';
% data_out(:,:,2) = data_out(:,:,2)';
% data_out(:,:,3) = data_out(:,:,3)';

%y = reshape(data_out', 1, length(x));
y = reshape(data_out, 1, length(x));

err_pix = find(y~=x);
% figure(10); imshow(x_copy);
% figure(9); imshow(data_out);


fprintf('Percent error of pixels of the received image = %f%%\n\n', ...
    length(err_pix)/length(x)*100)
fprintf('##########################################\n')
fprintf('#******** END of OFDM Simulation ********#\n')
fprintf('##########################################\n\n')

%%OUTPUTS
Total_Num_Error = length(errors);
Out_Of_Errors = length(data_rx);
Imagen = data_out;
BER = length(errors)/length(data_rx)*100;
Average_Phase_Error = mean(abs(phase_err));
Percent_of_Error = length(err_pix)/length(x)*100;
if Bandera_Criptar == 1
    Imagen_Encriptada = Encriptado;
    Imagen_Desencriptada = Encriptado_Received;
else
    Imagen_Encriptada = 0;
    Imagen_Desencriptada = 0;    
end
%return