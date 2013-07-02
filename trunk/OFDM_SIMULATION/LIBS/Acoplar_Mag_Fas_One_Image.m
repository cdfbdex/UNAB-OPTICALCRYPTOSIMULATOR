function Imagen_Double = Acoplar_Mag_Fas_One_Image(Imagen_Compleja)

Magnitud = abs(Imagen_Compleja);
Fase = angle(Imagen_Compleja);

Imagen_Double = [];
Imagen_Double = [Magnitud Fase];