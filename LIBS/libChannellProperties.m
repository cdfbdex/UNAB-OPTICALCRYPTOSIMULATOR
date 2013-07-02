function Channell_Capacity = libChannellProperties(BandWidth, Average_Power_Received, Noise_Power)

Channell_Capacity = BandWidth.*(log2(1 + (Average_Power_Received/Noise_Power)));