function [Image_Complex Distribucion_Fase] = Mascara_Aleatoria(Fila, Columna, Tipo_Distribucion)

Distribucion_Fase = 2*pi*rand([Fila, Columna]);
Image_Complex = complex(cos(Distribucion_Fase),sin(Distribucion_Fase));