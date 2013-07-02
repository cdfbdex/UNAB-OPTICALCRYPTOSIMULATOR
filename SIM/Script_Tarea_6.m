CodigoMensaje='7'
Opcion = 1;
n=length(CodigoMensaje); % Longitud del mensaje ingresado en decimal
CodBinario = zeros(n,8); % Vector para almacenar el mensaje en binario 
b = zeros(1,n+1);
t = [0,1:n];
for i=1:n
    b(1,i) = str2double(CodigoMensaje(i)); % Vector con el mensaje en decimal
end;
for i=1:n
    CodBinario2 = dec2bin(str2double(CodigoMensaje(i)));
    lcb = length(CodBinario2);
    rlcb = 8 - lcb;
    for j=1:lcb
        CodBinario(i,rlcb+j) = str2double(CodBinario2(j)); 
    end;     
end;
Binario = '';
for m=1:n
    for k=1:8
        Binario = strcat(Binario,num2str(CodBinario(m,k))); % Vector con el mensaje en binario
    end;
end;
n2 = length(Binario); % Longitud total del mensaje en binario
x = [0,1:n2-1];
a = zeros(1,n2);
for j=1:n2
    a(1,j) = str2double(Binario(j));  %Mensaje binario
end
d = a;
if Opcion == 1
    for i=1:n2
        if a(1,i) == 1
            a(1,i) = 10;
        else
            a(1,i) = -10; 
        end;
    end;
    figure
    stairs(x,a,'linewidth',3);
    figure
    plot(t,b) 
    d 
end;
H=[0 0;0 1];
H0 = H(1,:);
H1 = H(2,:);
MORT = [];
for i=1:n2
    if a(1,i)==-10
        paridad = 1;
        MORT = [MORT H0 paridad];
    else
        paridad = 0;
        MORT = [MORT H1 paridad];
    end;
end;
MORT




        