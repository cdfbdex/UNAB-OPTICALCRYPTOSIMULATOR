function varargout = OFDM_GUIDE(varargin)
% OFDM_GUIDE M-archivo for OFDM_GUIDE.fig
%      OFDM_GUIDE, by itself, creates a new OFDM_GUIDE or raises the existing
%      singleton*.
%
%      H = OFDM_GUIDE returns the handle to a new OFDM_GUIDE or the handle to
%      the existing singleton*.
%
%      OFDM_GUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OFDM_GUIDE.M with the given input arguments.
%
%      OFDM_GUIDE('Property','Value',...) creates a new OFDM_GUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OFDM_GUIDE_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OFDM_GUIDE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OFDM_GUIDE

% Last Modified by GUIDE v2.5 12-Jun-2013 13:44:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OFDM_GUIDE_OpeningFcn, ...
                   'gui_OutputFcn',  @OFDM_GUIDE_OutputFcn, ...
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


% --- Executes just before OFDM_GUIDE is made visible.
function OFDM_GUIDE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OFDM_GUIDE (see VARARGIN)

% Choose default command line output for OFDM_GUIDE
handles.output = hObject;
handles.Bandera_Encriptar = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OFDM_GUIDE wait for user response (see UIRESUME)
% uiwait(handles.figure1);
addpath('../FINAL-PROYECT/LIBS');
addpath('../IMAGES');
Image_Black = imread('IMAGE_BLACK.png');

axes(handles.Ejes_Imagen_Entrada);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Imagen_Salida);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Mag_PSK);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Fase_Modulada);
axis off;
imshow(Image_Black);
axes(handles.Ejes_OFDM_TIME_SIGNAL);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Samples_OFDM);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Mag_OFDM_Received);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Fase_Spectrum);
axis off;
imshow(Image_Black);
axes(handles.Ejes_Received_Fase);
axis off;
imshow(Image_Black);



axes(handles.Ejes_Imagen_Salida);
axis off;
axes(handles.Ejes_Imagen_Entrada);
axis off;
addpath('LIBS');
set(handles.Boton_Cargar_Llave, 'Enable','off');
set(handles.Boton_Llave_2, 'Enable','off');     

% --- Outputs from this function are returned to the command line.
function varargout = OFDM_GUIDE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Boton_Cargar_Imagen.
function Boton_Cargar_Imagen_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Imagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName Path]=uigetfile({'*.jpg;*.bmp'},'Abrir Imagen'); 
if isequal(FileName,0) 
    return
else
 Input_Image=imread(strcat(Path,FileName)); 
 axes(handles.Ejes_Imagen_Entrada);
 imshow(Input_Image); 
 set(handles.Boton_Simular,'Enable','on');
 handles.direccion=strcat(Path,FileName);
 handles.Input_I = Input_Image; 
 [Alto Ancho Canales] = size(Input_Image);
 String_Text_Tamano = sprintf('Alto: %d',Alto);
 set(handles.Text_Tamano,'String',String_Text_Tamano);
 set(handles.Text_Ancho_Entrada,'String',strcat('Ancho: ', num2str(Ancho)));
 String_Text_Canales = sprintf('Canales: %d',Canales);
 set(handles.Text_Canales,'String',String_Text_Canales);
 tipo_dato = class(Input_Image);
 String_Text_DB = sprintf('Profundidad Bit: %s',tipo_dato);
 set(handles.Text_DB,'String',String_Text_DB);
 
 
 
end
guidata(hObject,handles) 

% --- Executes on button press in Boton_Guardar_Imagen.
function Boton_Guardar_Imagen_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Guardar_Imagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_out, pathname_out] = uiputfile( {'*.jpg';'*.png';'*.bmp';'*.*'},'Guardar Imagen');
imwrite(handles.Imagen_Salida, strcat(pathname_out, file_out));

% --------------------------------------------------------------------
function Archivo_Callback(hObject, eventdata, handles)
% hObject    handle to Archivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Boton_Simular.
function Boton_Simular_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Simular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Limpiar_Graficos(handles);
%handles.Bandera_Encriptar = 0;


IFFT_Size = str2num(get(handles.Edit_IFFT_Size,'String'));
Num_Carriers = str2num(get(handles.Edit_NumCarriers,'String'));
Clipping = str2num(get(handles.Edit_Clipping,'String'));
SNR = str2num(get(handles.Edit_SNR,'String'));
Modulation = get(handles.Menu_Modulation,'Value');
Valor_Enetero_Modulation = 1;
if Modulation == 1
    Valor_Enetero_Modulation = 1;
end

if Modulation == 2
    Valor_Enetero_Modulation = 2;
end

if Modulation == 3
    Valor_Enetero_Modulation = 4;
end

if Modulation == 4
    Valor_Enetero_Modulation = 8;
end

if isequal(handles.direccion,0)
    disp('Fail!');
    return
else
    [Out_Image Total_Num_Error  Out_Of_Errors  BER  Average_Phase_Error Percent_of_Error Imagen_Encriptada Imagen_Desencriptada t_tx t_rx]...
        = OFDM_FUNCTION2(handles.direccion, IFFT_Size, Num_Carriers, Clipping, Valor_Enetero_Modulation, SNR,handles ); 
    axes(handles.Ejes_Imagen_Salida);
    
    if handles.Bandera_Encriptar == 1
        imshow(uint8(255*((abs(Imagen_Desencriptada))/(max(max(abs(Imagen_Desencriptada)))))));
        disp('CON ENCRIPTACION');
        Im_In = double(imread(handles.direccion));
        Im_Out = 255*((abs(Imagen_Desencriptada))/(max(max(abs(Imagen_Desencriptada)))));
        Out_Image = uint8(Im_Out);
        [Alto Ancho] = size(Im_In);
        MSE = (1.0/(Alto*Ancho))*sum(sum((Im_In-Im_Out).^2));
        SNR_InOut = 10*log10((sum(sum(Im_In.^2)))/(MSE*Alto*Ancho));
        set(handles.Edit_MSE, 'String', num2str(MSE));
        set(handles.Edit_SNRIO, 'String', num2str(SNR_InOut));
        
    else
        Im_In = double(imread(handles.direccion));
        Im_Out = double(Out_Image);
        [Alto Ancho] = size(Im_In);
        MSE = (1.0/(Alto*Ancho))*sum(sum((Im_In-Im_Out).^2));
        SNR_InOut = 10*log10((sum(sum(Im_In.^2)))/(MSE*Alto*Ancho));
        set(handles.Edit_MSE, 'String', num2str(MSE));
        set(handles.Edit_SNRIO, 'String', num2str(SNR_InOut));        
        imshow(Out_Image);
        disp('SIN ENCRIPTACION');
    end 
    
    set(handles.Boton_Guardar_Imagen, 'Enable', 'on');
    set(handles.Boton_Restaurar,'Enable','on');
    set(handles.Boton_Guardar_Imagen, 'Enable', 'on');

end
handles.Imagen_Salida = Out_Image;
handles.Total_Error = Total_Num_Error;
handles.Out_Error = Out_Of_Errors;
handles.Bit_Error_Rate = BER;
handles.APE = Average_Phase_Error;
handles.EPE = Percent_of_Error;
handles.ENCRIPT = Imagen_Encriptada;
handles.DESENCRIPT = Imagen_Desencriptada;

String_Text_NUMERROR = sprintf('%0.5g',Total_Num_Error);
set(handles.Text_NUMERROR,'String',String_Text_NUMERROR);

String_Text_BER = sprintf('%0.5g',BER);
set(handles.Text_BER,'String',String_Text_BER);

% String_Text_EPF = sprintf('%0.5g',Average_Phase_Error);
% set(handles.Text_EPF,'String',String_Text_EPF);
% 
% String_Text_PE = sprintf('%0.5g',Percent_of_Error);
% set(handles.Text_PE,'String',String_Text_PE);

String_Text_EPF = sprintf('%0.5g',t_tx);
set(handles.Text_EPF,'String',String_Text_EPF);

String_Text_PE = sprintf('%0.5g',t_rx);
set(handles.Text_PE,'String',String_Text_PE);


guidata(hObject,handles)


% --------------------------------------------------------------------
function Herramientas_Callback(hObject, eventdata, handles)
% hObject    handle to Herramientas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Edit_IFFT_Size_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_IFFT_Size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_IFFT_Size as text
%        str2double(get(hObject,'String')) returns contents of Edit_IFFT_Size as a double


% --- Executes during object creation, after setting all properties.
function Edit_IFFT_Size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_IFFT_Size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_NumCarriers_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_NumCarriers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_NumCarriers as text
%        str2double(get(hObject,'String')) returns contents of Edit_NumCarriers as a double


% --- Executes during object creation, after setting all properties.
function Edit_NumCarriers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_NumCarriers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Clipping_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Clipping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Clipping as text
%        str2double(get(hObject,'String')) returns contents of Edit_Clipping as a double


% --- Executes during object creation, after setting all properties.
function Edit_Clipping_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Clipping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Menu_Modulation.
function Menu_Modulation_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Modulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Menu_Modulation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Menu_Modulation


% --- Executes during object creation, after setting all properties.
function Menu_Modulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu_Modulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_SNR_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_SNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_SNR as text
%        str2double(get(hObject,'String')) returns contents of Edit_SNR as a double


% --- Executes during object creation, after setting all properties.
function Edit_SNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_SNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function Text_NUMERROR_Callback(hObject, eventdata, handles)
% hObject    handle to Text_NUMERROR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Text_NUMERROR as text
%        str2double(get(hObject,'String')) returns contents of Text_NUMERROR as a double


% --- Executes during object creation, after setting all properties.
function Text_NUMERROR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Text_NUMERROR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Text_BER_Callback(hObject, eventdata, handles)
% hObject    handle to Text_BER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Text_BER as text
%        str2double(get(hObject,'String')) returns contents of Text_BER as a double


% --- Executes during object creation, after setting all properties.
function Text_BER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Text_BER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Text_EPF_Callback(hObject, eventdata, handles)
% hObject    handle to Text_EPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Text_EPF as text
%        str2double(get(hObject,'String')) returns contents of Text_EPF as a double


% --- Executes during object creation, after setting all properties.
function Text_EPF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Text_EPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Text_PE_Callback(hObject, eventdata, handles)
% hObject    handle to Text_PE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Text_PE as text
%        str2double(get(hObject,'String')) returns contents of Text_PE as a double


% --- Executes during object creation, after setting all properties.
function Text_PE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Text_PE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Boton_Restaurar.
function Boton_Restaurar_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Restaurar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Edit_IFFT_Size, 'String', '2048');
set(handles.Edit_NumCarriers, 'String', '1009');
set(handles.Edit_Clipping, 'String', '9');
set(handles.Edit_SNR, 'String', '12');
set(handles.Menu_Modulation,'Value',1);


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Limpiar_Graficos(handles)
set(handles.Boton_Restaurar,'Enable','off');
set(handles.Boton_Guardar_Imagen, 'Enable', 'off');
cla(handles.Ejes_Imagen_Salida);
cla(handles.Ejes_Mag_PSK);
cla(handles.Ejes_Fase_Modulada);
cla(handles.Ejes_OFDM_TIME_SIGNAL);
cla(handles.Ejes_Samples_OFDM);
cla(handles.Ejes_Mag_OFDM_Received);
cla(handles.Ejes_Fase_Spectrum);
cla(handles.Ejes_Received_Fase);
set(handles.Text_NUMERROR,'String','');
set(handles.Text_BER,'String','');
set(handles.Text_EPF,'String','');
set(handles.Text_PE,'String','');
set(handles.Edit_MSE,'String','');
set(handles.Edit_SNRIO,'String','');


% --- Executes on button press in Select_Encriptar.
function Select_Encriptar_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Encriptar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = get(handles.Select_Encriptar,'Value');
handles.Bandera_Encriptar = valor;
guidata(hObject, handles);

if valor == 1
    set(handles.Boton_Cargar_Llave, 'Enable','on');
    set(handles.Boton_Llave_2, 'Enable','on');    
else
    set(handles.Boton_Cargar_Llave, 'Enable','off');
    set(handles.Boton_Llave_2, 'Enable','off');  
    set(handles.Text_Alto_Enc, 'String','Alto:');
    set(handles.Text_Ancho_Enc, 'String','Ancho:');
    set(handles.Text_Alto_Dec, 'String','Alto:');
    set(handles.Text_Ancho_Dec, 'String','Ancho:');   
    set(handles.Text_Name_Dec, 'String','Nombre Archivo');   
    set(handles.Text_Name_Enc, 'String','Nombre Archivo');   
end
% Hint: get(hObject,'Value') returns toggle state of Select_Encriptar


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
        handles.Llave = Im_Complex;
        handles.Llave_Distribucion_Fase = Im_Fas_Distribution;
        [Alto Ancho] = size(Im_Fas_Distribution);
        text = strcat('Alto: ', num2str(Alto));
        set(handles.Text_Alto_Enc, 'String', text);
        text = strcat('Ancho: ', num2str(Ancho));
        set(handles.Text_Ancho_Enc, 'String', text);
        set(handles.Text_Name_Enc, 'String', filename );
        
        guidata(hObject, handles);
    else
    end
end




% --- Executes on button press in Boton_Llave_2.
function Boton_Llave_2_Callback(hObject, eventdata, handles)
% hObject    handle to Boton_Llave_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat', 'Cargar archivo:');
if length(filename) == 1 && length(pathname) == 1
else
    ruta = strcat(pathname, filename);
    load(ruta);
    if exist('Im_Complex') == 1 && exist('Im_Fas_Distribution') == 1
        handles.Llave2 = Im_Complex;
        handles.Llave_Distribucion_Fase2 = Im_Fas_Distribution;
        [Alto Ancho] = size(Im_Fas_Distribution);
        text = strcat('Alto: ', num2str(Alto));
        set(handles.Text_Alto_Dec, 'String', text);
        text = strcat('Ancho: ', num2str(Ancho));
        set(handles.Text_Ancho_Dec, 'String', text);
        set(handles.Text_Name_Dec, 'String', filename );
        guidata(hObject, handles);
    else
    end
end





function Edit_MSE_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_MSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_MSE as text
%        str2double(get(hObject,'String')) returns contents of Edit_MSE as a double


% --- Executes during object creation, after setting all properties.
function Edit_MSE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_MSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_SNRIO_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_SNRIO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_SNRIO as text
%        str2double(get(hObject,'String')) returns contents of Edit_SNRIO as a double


% --- Executes during object creation, after setting all properties.
function Edit_SNRIO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_SNRIO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function Boton_Guardar_Imagen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Guardar_Imagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/saveasimage.png', 'png'), 1.1));



% --- Executes during object creation, after setting all properties.
function Boton_Simular_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Simular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/simulate.jpg', 'jpg'), 0.17));



% --- Executes during object creation, after setting all properties.
function Boton_Restaurar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Restaurar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/restore.jpg', 'jpg'), 0.17));



% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Llave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Llave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/encrypt.jpg', 'jpg'), 0.4));



% --- Executes during object creation, after setting all properties.
function Boton_Llave_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Llave_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/decrypt.jpg', 'jpg'), 0.3));



% --- Executes during object creation, after setting all properties.
function Boton_Cargar_Imagen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Boton_Cargar_Imagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'CData', imresize(imread('../IMAGES/open.png', 'png'), 1.0));

