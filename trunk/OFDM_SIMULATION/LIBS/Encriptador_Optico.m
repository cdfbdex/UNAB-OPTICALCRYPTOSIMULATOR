function Encriptado = Encriptador_Optico(Imagen_Compleja, Llave_Compleja)

TF_Imagen_Compleja =fftshift(fft2(Imagen_Compleja));
Imagen_Encriptada_Compleja =  TF_Imagen_Compleja.*Llave_Compleja;
Encriptado = fft2(Imagen_Encriptada_Compleja);