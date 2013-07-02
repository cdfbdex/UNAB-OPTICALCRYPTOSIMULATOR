function varargout = Generador_Fase(varargin)
% GENERADOR_FASE M-file for Generador_Fase.fig
%      GENERADOR_FASE, by itself, creates a new GENERADOR_FASE or raises the existing
%      singleton*.
%
%      H = GENERADOR_FASE returns the handle to a new GENERADOR_FASE or the handle to
%      the existing singleton*.
%
%      GENERADOR_FASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERADOR_FASE.M with the given input arguments.
%
%      GENERADOR_FASE('Property','Value',...) creates a new GENERADOR_FASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Generador_Fase_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Generador_Fase_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Generador_Fase

% Last Modified by GUIDE v2.5 11-Jun-2013 20:30:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Generador_Fase_OpeningFcn, ...
                   'gui_OutputFcn',  @Generador_Fase_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Generador_Fase is made visible.
function Generador_Fase_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Generador_Fase (see VARARGIN)

% Choose default command line output for Generador_Fase
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
addpath('../LIBS');
addpath('../OFDM_SIMULATION/LIBS');
addpath('../IMAGES');

Image_Black = uint8(255*zeros(480,640));
Image_Black = imread('IMAGE_BLACK.png');

axes(handles.Ejes_Mascara);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Imagen_Input);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Magnitud);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Imagen_Parte_Magnitud);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Imagen_Parte_Fase);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Real_Imaginaria);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Encript);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Llave);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Decriptada);
axis off;
imshow(Image_Black);





axes(handles.Ejes_Distribucion_Fase);
axis off;
imshow(Image_Black);
set(handles.Boton_Cargar_Mascara,'Enable','off'); 
set(handles.Boton_Guardar_Fase,'Enable','off');
set(handles.Panel_Cargar, 'BorderType', 'beveledin');
set(handles.Panel_Generar, 'BorderType', 'beveledout');
Paleta = zeros(256,20);
[alto ancho] = size(Paleta);
for i = 1: alto
    Paleta(i,:)=256-i;
end
axes(handles.Ejes_Paleta);
axis off;
imshow(uint8(Paleta));

%Boton_Generar_Fase_Callback(hObject, eventdata, handles);
% UIWAIT makes Generador_Fase wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Generador_Fase_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Boton_Generar_Fase.
function Boton_Generar_Fase_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Generar_Fase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

F = str2num(get(handles.Edit_Ancho,'String'));
C = str2num(get(handles.Edit_Alto,'String'));
Fila = C;
Columna = F;
Tipo_Distribucion = 1;
[Image_Complex Distribucion_Fase] = Mascara_Aleatoria(Fila, Columna, Tipo_Distribucion);
axes(handles.Ejes_Distribucion_Fase);
%%%VISUALIZING
imshow(uint8(255*Distribucion_Fase/(2*pi)));
handles.Image_Complejo= Image_Complex;
handles.Image_Fase_Distribution = Distribucion_Fase;
set(handles.Boton_Guardar_Fase,'Enable','on');
guidata(hObject, handles);





% --- Executes on button press in Boton_Guardar_Fase.
function Boton_Guardar_Fase_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Guardar_Fase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.mat', 'Guardar como:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    Im_Complex = handles.Image_Complejo;
    Im_Fas_Distribution = handles.Image_Fase_Distribution;
    save(ruta, 'Im_Complex', 'Im_Fas_Distribution');
end
    
% --- Executes during object creation, after setting all properties.
function Menu_Distribuciones_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu_Distribuciones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function Edit_Ancho_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Ancho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Ancho as text
%        str2double(get(hObject,'String')) returns contents of Edit_Ancho as a double


% --- Executes during object creation, after setting all properties.
function Edit_Ancho_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Ancho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Alto_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Alto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Alto as text
%        str2double(get(hObject,'String')) returns contents of Edit_Alto as a double


% --- Executes during object creation, after setting all properties.
function Edit_Alto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Alto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Boton_Cargar_Mascara.
function Boton_Cargar_Mascara_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Mascara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Cargar archivo:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    load(ruta);
    if exist('Im_Complex') == 1 && exist('Im_Fas_Distribution') == 1
        handles.Image_Complejo = Im_Complex;
        handles.Image_Fase_Distribution = Im_Fas_Distribution;
        [Alto Ancho] = size(Im_Fas_Distribution);
        axes(handles.Ejes_Distribucion_Fase);
        imshow(uint8(255*Im_Fas_Distribution/(2*pi)));
        set(handles.Boton_Guardar_Fase,'Enable','on');
        set(handles.Edit_Alto,'String',num2str(Alto));
        set(handles.Edit_Ancho,'String',num2str(Ancho));
        handles.Image_Complejo = Im_Complex;
        handles.Image_Fase_Distribution = Im_Fas_Distribution;
        guidata(hObject, handles);
        
    else
        set(handles.Boton_Guardar_Fase,'Enable','off');
        axes(handles.Ejes_Distribucion_Fase);
        title('NO MASK');
        cla;
    end
end



% --- Executes on selection change in Menu_Distribuciones.
function Menu_Distribuciones_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Distribuciones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Menu_Distribuciones contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Menu_Distribuciones


% --- Executes on button press in Seleccionar_Habilitar.
function Seleccionar_Habilitar_Callback(hObject, eventdata, handles)
% hObject    handle to Seleccionar_Habilitar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = get(handles.Seleccionar_Habilitar,'Value');
if valor == 1
    set(handles.Boton_Cargar_Mascara,'Enable','on');
    set(handles.Boton_Generar_Fase,'Enable','off'); 
    set(handles.Edit_Ancho,'Enable','off');
    set(handles.Edit_Alto,'Enable','off');
    set(handles.Menu_Distribuciones,'Enable','off');
    set(handles.Panel_Cargar, 'BorderType', 'beveledout');
    set(handles.Panel_Generar, 'BorderType', 'beveledin');    
else
    set(handles.Boton_Cargar_Mascara,'Enable','off');
    set(handles.Boton_Generar_Fase,'Enable','on'); 
    set(handles.Edit_Ancho,'Enable','on');
    set(handles.Edit_Alto,'Enable','on');    
    set(handles.Menu_Distribuciones,'Enable','on');
    set(handles.Panel_Cargar, 'BorderType', 'beveledin');
    set(handles.Panel_Generar, 'BorderType', 'beveledout');
end

% Hint: get(hObject,'Value') returns toggle state of Seleccionar_Habilitar




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Boton_Cargar_Imagen.
function Boton_Cargar_Imagen_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Imagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.*', 'Cargar archivo:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    axes(handles.Ejes_Imagen_Input);
    I = imread(ruta);
    [Alto Ancho Canales] = size(I);
    imshow(uint8(I));
    
        
    [Alto Ancho Canales] = size(I);
    set(handles.Text_Alto_Image_Entrada,'String',strcat('Alto: ', num2str(Alto)));
    set(handles.Text_Ancho_Imagen_Entrada,'String',strcat('Ancho: ', num2str(Ancho)));

    handles.Imagen_Input = I;
    guidata(hObject, handles);
end


% --- Executes on button press in Boton_Encriptar.
function Boton_Encriptar_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Encriptar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Input = handles.Imagen_Input;
[Alto Ancho Canales] = size(Input);
if Canales > 1
    Input_Gray = rgb2gray(Input);
else
    Input_Gray = Input;
end

Input_Complex = complex(double(Input_Gray), double(zeros(Alto, Ancho)));
Imagen_Compleja = Input_Complex;

Im_Complex = handles.Image_Complejo;
Im_Fas_Distribution = handles.Image_Fase_Distribution;
Llave_Compleja = Im_Complex;
Encriptado = Encriptador_Optico(Imagen_Compleja, Llave_Compleja);
Distri_Fase_Encriptado = angle(Encriptado) + pi;
%axes(handles.Ejes_Encriptada);
%imshow(uint8((255/(2*pi))*Distri_Fase_Encriptado));
axes(handles.Ejes_Magnitud);
imshow(uint8(255*((abs(Encriptado))/(max(max(abs(Encriptado)))))));


handles.Imagen_Encriptada_Compleja = Encriptado;
handles.Imagen_Encriptada_Fase = Distri_Fase_Encriptado;
guidata(hObject, handles);

% --- Executes on button press in Boton_Encriptada.
function Boton_Encriptada_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Encriptada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.mat', 'Guardar como:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    Im_Complex = handles.Imagen_Encriptada_Compleja;
    Im_Fas_Distribution = handles.Imagen_Encriptada_Fase;
    save(ruta, 'Im_Complex', 'Im_Fas_Distribution');
end
%Encriptado = Encriptador_Optico(Imagen_Compleja, Llave_Compleja);

% --- Executes on button press in Boton_Cargar_Mascara2.
function Boton_Cargar_Mascara2_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Mascara2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Cargar archivo:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    load(ruta);
    if exist('Im_Complex') == 1 && exist('Im_Fas_Distribution') == 1
        handles.Image_Complejo = Im_Complex;
        handles.Image_Fase_Distribution = Im_Fas_Distribution;
        Distribucion_Fase = Im_Fas_Distribution;
        axes(handles.Ejes_Mascara);
        imshow(uint8(255*Im_Fas_Distribution/(2*pi)));
        
        [Alto Ancho Canales] = size(Distribucion_Fase);
        set(handles.Text_Alto_Llave_Encript,'String',strcat('Alto: ', num2str(Alto)));
        set(handles.Text_Ancho_Llave_Encript,'String',strcat('Ancho: ', num2str(Ancho)));
        
%         set(handles.Boton_Guardar_Fase,'Enable','on');
%         handles.Image_Complejo = Im_Complex;
%         handles.Image_Fase_Distribution = Im_Fas_Distribution;
        guidata(hObject, handles);
    else
        %set(handles.Boton_Guardar_Fase,'Enable','off');
        axes(handles.Ejes_Mascara);
        title('NO KEY FOR ENCRIPTION');
        cla;
    end
end



% --- Executes on button press in Boton_Cargar_Actual.
function Boton_Cargar_Actual_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Actual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Image_Complex = handles.Image_Complejo;
Distribucion_Fase = handles.Image_Fase_Distribution;
[Alto Ancho Canales] = size(Distribucion_Fase);
set(handles.Text_Alto_Llave_Encript,'String',strcat('Alto: ', num2str(Alto)));
set(handles.Text_Ancho_Llave_Encript,'String',strcat('Ancho: ', num2str(Ancho)));
axes(handles.Ejes_Mascara);
%%%VISUALIZING
imshow(uint8(255*Distribucion_Fase/(2*pi)));


% --- Executes on button press in Boton_Actual_Imagen_Encriptada.
function Boton_Actual_Imagen_Encriptada_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Actual_Imagen_Encriptada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Encript = handles.Imagen_Encriptada_Compleja;

Distribucion_Fase = angle(Encript);
[Alto Ancho Canales] = size(Distribucion_Fase);
set(handles.Text_Alto_Imagen_Para_Decriptar,'String',strcat('Alto: ', num2str(Alto)));
set(handles.Text_Ancho_Imagen_Para_Desencriptar,'String',strcat('Ancho: ', num2str(Ancho)));

axes(handles.Ejes_Encript);
imshow(uint8(255*((abs(Encript))/(max(max(abs(Encript)))))));


% --- Executes on button press in Boton_Cargar_Imagen_Encriptada.
function Boton_Cargar_Imagen_Encriptada_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Imagen_Encriptada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Cargar archivo:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    load(ruta);
    if exist('Im_Complex') == 1 && exist('Im_Fas_Distribution') == 1
        handles.Imagen_Encriptada_Compleja = Im_Complex;
        Encript = Im_Complex;
        handles.Imagen_Encriptada_Fase = Im_Fas_Distribution;
        axes(handles.Ejes_Encript);
        imshow(uint8(255*((abs(Encript))/(max(max(abs(Encript)))))));

        Distribucion_Fase = angle(Encript);
        [Alto Ancho Canales] = size(Distribucion_Fase);
        set(handles.Text_Alto_Imagen_Para_Decriptar,'String',strcat('Alto: ', num2str(Alto)));
        set(handles.Text_Ancho_Imagen_Para_Desencriptar,'String',strcat('Ancho: ', num2str(Ancho)));

        %set(handles.Boton_Guardar_Fase,'Enable','on');
        guidata(hObject, handles);
    else
        %set(handles.Boton_Guardar_Fase,'Enable','off');
        axes(handles.Ejes_Encript);
        title('NO IMAGE FOR DECRIPTION');
        cla;
    end
end


% --- Executes on button press in Boton_Actual_Llave.
function Boton_Actual_Llave_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Actual_Llave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Llave = handles.Image_Complejo;
axes(handles.Ejes_Llave);
imshow(uint8((255/(2*pi))*(angle(Llave)+pi)));
Distribucion_Fase = angle(Llave);
[Alto Ancho Canales] = size(Distribucion_Fase);
set(handles.Text_Alto_Llave_Para_Desencriptar,'String',strcat('Alto: ', num2str(Alto)));
set(handles.Text_Ancho_llave_Para_Desencritpar,'String',strcat('Ancho: ', num2str(Ancho)));



% --- Executes on button press in Boton_Cargar_Llave.
function Boton_Cargar_Llave_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Llave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Cargar archivo:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    load(ruta);
    if exist('Im_Complex') == 1 && exist('Im_Fas_Distribution') == 1
        handles.Image_Complejo = Im_Complex;
        handles.Image_Fase_Distribution = Im_Fas_Distribution;
        Distribucion_Fase = Im_Fas_Distribution;
        axes(handles.Ejes_Llave);
        imshow(uint8(255*Im_Fas_Distribution/(2*pi)));
        %set(handles.Boton_Guardar_Fase,'Enable','on');
        
        [Alto Ancho Canales] = size(Distribucion_Fase);
        set(handles.Text_Alto_Llave_Para_Desencriptar,'String',strcat('Alto: ', num2str(Alto)));
        set(handles.Text_Ancho_llave_Para_Desencritpar,'String',strcat('Ancho: ', num2str(Ancho)));
        
        
        handles.Image_Complejo = Im_Complex;
        handles.Image_Fase_Distribution = Im_Fas_Distribution;
        guidata(hObject, handles);
    else
        %set(handles.Boton_Guardar_Fase,'Enable','off');
        axes(handles.Ejes_Llave);
        %title('NO KEY FOR DECRIPTION');
        cla;
    end
end


% --- Executes on button press in Boton_Desencriptar.
function Boton_Desencriptar_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Desencriptar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Llave = handles.Image_Complejo;
Encript = handles.Imagen_Encriptada_Compleja;
Desencriptado = Desencriptador_Optico(Encript, Llave);
axes(handles.Ejes_Decriptada);
imshow(uint8(255*((abs(Desencriptado))/(max(max(abs(Desencriptado)))))));
handles.Intensidad_Desencriptada = uint8(255*((abs(Desencriptado))/(max(max(abs(Desencriptado))))));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Ejes_Mascara_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ejes_Mascara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Ejes_Mascara




% --- Executes on button press in Boton_Cargar_Compleja.
function Boton_Cargar_Compleja_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Compleja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Cargar archivo:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    load(ruta);
    if exist('Im_Complex') == 1 && exist('Im_Fas_Distribution') == 1
        %handles.Imagen_Encriptada_Compleja = Im_Complex;
        Encript = Im_Complex;
        Fase = Im_Fas_Distribution;
        axes(handles.Ejes_Imagen_Parte_Magnitud);
        imshow(uint8(255*((abs(Encript))/(max(max(abs(Encript)))))));
        axes(handles.Ejes_Imagen_Parte_Fase);        
        imshow(uint8(255*Fase/(2*pi)));
        axes(handles.Ejes_Real_Imaginaria); 
        [h w c] = size(Fase);
        Imagen_Real_Imaginaria = zeros(h,2*w);
        Imagen_Real_Imaginaria(:,1:w) = real(Encript);
        Imagen_Real_Imaginaria(:,w+1:2*w) = imag(Encript);
        imshow(uint8(255*((abs(Imagen_Real_Imaginaria))/(max(max(abs(Imagen_Real_Imaginaria)))))));
        
        [Alto Ancho Canales] = size(Fase);
        set(handles.Text_Alto_Visualizar,'String',strcat('Alto: ', num2str(Alto)));
        set(handles.Text_Ancho_Visualizar,'String',strcat('Ancho: ', num2str(Ancho)));
        
        %set(handles.Boton_Guardar_Fase,'Enable','on');
        %guidata(hObject, handles);
    else
        %set(handles.Boton_Guardar_Fase,'Enable','off');
        axes(handles.Ejes_Encript);
        title('NO HAY IFNORMACION');
        cla;
    end
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Boton_Guardar_Como.
function Boton_Guardar_Como_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Guardar_Como (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.*','Guardar como...');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    ruta = strcat(ruta, '.png');
    
    I = handles.Intensidad_Desencriptada;
    imwrite(I,ruta,'png');
end




% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Actual_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Actual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/update.png', 'png'), 0.5));



% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Mascara2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Mascara2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/open.png', 'png'), 0.9));



% --- Executes during object creation, after setting all properties.
function Boton_Encriptar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Encriptar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/encrypt.jpg', 'jpg'), 0.5));



% --- Executes during object creation, after setting all properties.
function Boton_Encriptada_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Encriptada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/save.png', 'png'), 1.0));



% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Imagen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Imagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/open.png', 'png'), 0.9));






% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/forward2.jpg', 'jpg'), 0.9));






% --- Executes during object deletion, before destroying properties.
function Boton_Cargar_Compleja_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Compleja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Compleja_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Compleja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/open.png', 'png'), 1.2));



% --- Executes during object creation, after setting all properties.
function Boton_Desencriptar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Desencriptar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/decrypt.jpg', 'jpg'), 0.4));



% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/forward2.jpg', 'jpg'), 0.9));




% --- Executes during object creation, after setting all properties.
function Boton_Actual_Imagen_Encriptada_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Actual_Imagen_Encriptada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/update.png', 'png'), 0.5));




% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Imagen_Encriptada_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Imagen_Encriptada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/open.png', 'png'), 0.9));




% --- Executes during object creation, after setting all properties.
function Boton_Actual_Llave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Actual_Llave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/update.png', 'png'), 0.5));




% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Llave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Llave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/open.png', 'png'), 0.9));



% --- Executes during object creation, after setting all properties.
function Boton_Guardar_Como_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Guardar_Como (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/saveasimage.png', 'png'), 0.9));



% --- Executes during object creation, after setting all properties.
function Boton_Guardar_Fase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Guardar_Fase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/save.png', 'png'), 1.0));



% --- Executes during object creation, after setting all properties.
function Boton_Generar_Fase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Generar_Fase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/generarllave.png', 'png'), 0.15));



% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Mascara_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Mascara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/openllave.png', 'png'), 0.8));

