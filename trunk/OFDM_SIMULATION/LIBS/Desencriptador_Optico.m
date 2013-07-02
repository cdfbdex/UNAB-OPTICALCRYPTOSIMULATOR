function Desencriptado = Desencriptador_Optico(Imagen_Encriptada, Llave_Compleja)

Imagen_Desencriptada_Compleja =  fft2(conj(Imagen_Encriptada));
Imagen_Desencriptada_Compleja = Imagen_Desencriptada_Compleja.*Llave_Compleja;
Desencriptado = fft2(Imagen_Desencriptada_Compleja);