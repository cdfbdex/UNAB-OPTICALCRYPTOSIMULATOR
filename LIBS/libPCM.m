
function [result pcm time signal_one signal_zero] = libPCM(bitstream, type_pcm, bit_duration, n_of_sample_b, Vmax, Vmin, verbose)

%libPCM           
%[result pcm time signal_one signal_zero] = libPCM(bitstream, type_pcm,
%                           bit_duration,n_of_sample_b, Vmax, Vmin,
%                           verbose)
%Pulse Code Modulation library is a set of functions to perform
%most of the pulse code modulation explaint and taken from Digital
%Communication Book by Bernard Sklare.

%OUTPUT
%result: if 1 modulation was succeed, 0 in the other case.
%pcm: Pulse code modulated signal.
%signal_one: signal for ones used to represent this value
%signal_zero: signal for zeros used to represent this value

%INPUT
%bitstream: Bit stream signal to modulate signal. Example: '10100010100'
%type_pcm: Type of pulse code modulation (by a number).
%OPTIONS:
%1: NRZ-L,
%2: NRZ-M,
%3: NRZ-S,
%4: Unipolar-RZ,
%5: Bipolar-RZ,
%6: RZ-AMI
%7: BI-PHI-L
%8: BI-PHI-M
%9: BI-PHI-S
%10: Dicode RZ
%11: Dicode NRZ
%12: Delay Modulation
%
%
%bit_duration: Duration in seconds of every bit of the stream. It must be
%              greater than cero.
%n_of_sample_b: Number of samples per bit. It must be grater than 2.
%Vmax:  maximum output  voltage of signal
%Vmin: minimum output of signal.
%verbose: Print information about specifical troubles if exist.

%example
%[reult pcm time signal_one signal_zero]=libPCM([1 0 1 0 0 0 1 0 1 0 1 1 0],10,1,10,5,-5,0);
%plot(pcm, 'linewidth', 3);


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


senal_for_one = Vmax*ones(1,n_of_sample_b);
senal_for_cero = Vmin*ones(1,n_of_sample_b);


time=0:(bit_duration/n_of_sample_b):(length_bitstream*bit_duration-bit_duration/n_of_sample_b);
pcm = [];


%%1 NRZ-L
if type_pcm == 1
   for i=1:length_bitstream
       if bitstream(i) == 0
          pcm = [pcm senal_for_cero]; 
       end
       
       if bitstream(i) == 1
          pcm = [pcm senal_for_one];           
       end
   end
signal_one=senal_for_one;
signal_zero=senal_for_cero;
end

%%2 NRZ-M
if type_pcm == 2
   for i=1:length_bitstream
       if i == 1   %evaluation of first value
          if bitstream(i) == 1  %if 1st value is 1? then...
             pcm = [pcm senal_for_one];
          else
             pcm = [pcm senal_for_cero];
          end
       else
          last_value = 0;
          if pcm(length(pcm)) == Vmax  %if last value of pcm[] is Vmax, then...
              last_value = 1;
          else
              last_value = 0;
          end
          
          if bitstream(i) == 1
             if last_value == 1
                 pcm = [pcm senal_for_cero];
             else
                 pcm = [pcm senal_for_one];
             end
                 
          else
             if last_value == 1
                 pcm = [pcm senal_for_one];
             else
                 pcm = [pcm senal_for_cero];
             end
              
          end
           
       end       
   end
signal_one=[];
signal_zero=[];
end

%%3 NRZ-S
if type_pcm == 3
   for i=1:length_bitstream
       if i == 1
          if bitstream(i) == 1
             pcm = [pcm senal_for_cero];
          else
             pcm = [pcm senal_for_one];
          end
       else
          last_value = 0;
          if pcm(length(pcm)) == Vmax
              last_value = 1;
          else
              last_value = 0;
          end
          
          if bitstream(i) == 0
             if last_value == 1
                 pcm = [pcm senal_for_cero];
             else
                 pcm = [pcm senal_for_one];
             end
                 
          else
             if last_value == 1
                 pcm = [pcm senal_for_one];
             else
                 pcm = [pcm senal_for_cero];
             end
              
          end
           
       end       
   end
signal_one=[];
signal_zero=[];
end

%%4 UNIPOLAR-RZ
if type_pcm == 4
half_signal_one = [Vmax*ones(1, n_of_sample_b/2) Vmin*ones(1, n_of_sample_b/2)];    
   for i=1:length_bitstream
       if bitstream(i) == 1
          pcm = [pcm half_signal_one];
       else
          pcm = [pcm senal_for_cero];
       end
   end
signal_one=half_signal_one;
signal_zero=senal_for_cero;
end

%%5 BIPOLAR-RZ
if type_pcm == 5
half_signal_one = [Vmax*ones(1, n_of_sample_b/2) zeros(1, n_of_sample_b/2)];    
half_signal_cero = [Vmin*ones(1, n_of_sample_b/2) zeros(1, n_of_sample_b/2)];
   for i=1:length_bitstream
       if bitstream(i) == 1
          pcm = [pcm half_signal_one];
       else
          pcm = [pcm half_signal_cero];
       end
   end
signal_one=half_signal_one;
signal_zero=half_signal_cero;
end
   
%%6 RZ-AMI
if type_pcm == 6
half_signal_cero = [zeros(1, n_of_sample_b)]; 
   for i=1:length_bitstream
       if bitstream(i) == 1
          pcm = [pcm [zeros(1, ceil(n_of_sample_b/4)) Vmax*ones(1, n_of_sample_b/2) zeros(1, floor(n_of_sample_b/4))]];
          %rounding is done throught ceil for up and floor for down to
          %prevent non 4th order division numbers
          Vmax=Vmax*(-1); %para poder alternar la polaridad del Vmax, tocó generar el vector en cada ciclo...
       else
          pcm = [pcm half_signal_cero];
       end
   end
signal_one=[];
signal_zero=half_signal_cero;
end

%%7 BI-?-L
if type_pcm == 7
half_signal_one = [Vmax*ones(1, n_of_sample_b/2) Vmin*ones(1, n_of_sample_b/2)];    
half_signal_cero = [Vmin*ones(1, n_of_sample_b/2) Vmax*ones(1, n_of_sample_b/2)];
   for i=1:length_bitstream
       if bitstream(i) == 1
          pcm = [pcm half_signal_one];
       else
          pcm = [pcm half_signal_cero];
       end
   end
signal_one=half_signal_one;
signal_zero=half_signal_cero;
end

%%8 BI-?-M
if type_pcm == 8
half_signal_one = [Vmin*ones(1, n_of_sample_b/2) Vmax*ones(1, n_of_sample_b/2)];
Vzero=Vmax;
   for i=1:length_bitstream
       if bitstream(i) == 1
           if i>1
            if bitstream(i-1) == 0
                half_signal_one=half_signal_one*(-1);
            end
           end
           pcm = [pcm half_signal_one];
           
           else 
              Vzero=Vzero*(-1);   %Vzero, logic voltage
              pcm = [pcm Vzero*ones(1, n_of_sample_b)];
           
           end
   end
signal_one=[];
signal_zero=[];
end
   
%%9 BI-?-S
if type_pcm == 9
half_signal_one = [Vmax*ones(1, n_of_sample_b/2) Vmin*ones(1, n_of_sample_b/2)];
Vzero=Vmax;

   for i=1:length_bitstream
       if bitstream(i) == 0
              pcm = [pcm half_signal_one];
       else 
              Vzero=Vzero*(-1);   %Vzero, logic voltage
              pcm = [pcm Vzero*ones(1, n_of_sample_b)];
           
           end
   end
signal_one=[];
signal_zero=half_signal_one;
end

%%10 Dicode RZ
if type_pcm == 10
half_signal_one = [Vmin*ones(1, n_of_sample_b/2) zeros(1, n_of_sample_b/2)];
half_signal_cero = [Vmax*ones(1, n_of_sample_b/2) zeros(1, n_of_sample_b/2)];
signal_cero=zeros(1, n_of_sample_b);

   for i=1:length_bitstream
       if bitstream(i) == 1
           if i>1
                if bitstream(i-1) == 1
                pcm = [pcm signal_cero];
                else
                pcm = [pcm half_signal_one];
                end
           else
               pcm = [pcm half_signal_one];
           end
           
       else
            if i>1
                if bitstream(i-1) == 0
                pcm = [pcm signal_cero];
                else
                pcm = [pcm half_signal_cero];
                end
            else
                pcm = [pcm half_signal_cero];

            end
           
           end
   end
signal_one=[];
signal_zero=[];    
end

%%11 Dicode NRZ
if type_pcm == 11
half_signal_one = Vmin*ones(1, n_of_sample_b);
signal_cero=zeros(1, n_of_sample_b);

   for i=1:length_bitstream
       if bitstream(i) == 1
           if i>1
                if bitstream(i-1) == 1
                pcm = [pcm signal_cero];
                else
                pcm = [pcm half_signal_one];
                end
           else
               pcm = [pcm half_signal_one];
           end
           
       else
            if i>1
                if bitstream(i-1) == 0
                pcm = [pcm signal_cero];
                else
                pcm = [pcm -half_signal_one];
                end
            else
                pcm = [pcm -half_signal_one];

            end
           
           end
   end
signal_one=[];
signal_zero=[];
end


%%12 Delay Modulation
Vzero=Vmax;
if type_pcm == 12
half_signal_one = [Vmax*ones(1, n_of_sample_b/2) Vmin*ones(1, n_of_sample_b/2)];

   for i=1:length_bitstream
       if bitstream(i) == 1
              pcm = [pcm half_signal_one];
              half_signal_one=half_signal_one*(-1);
              Vzero=Vmax;
              
       else
              Vzero=Vzero*(-1);   %Vzero, logic voltage
              pcm = [pcm Vzero*ones(1, n_of_sample_b)];
           
        end
   end
signal_one=[];
signal_zero=[];   
end


end




   

