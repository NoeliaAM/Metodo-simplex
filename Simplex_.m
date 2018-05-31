function varargout = Simplex(varargin)
% SIMPLEX MATLAB code for Simplex.fig
%      SIMPLEX, by itself, creates a new SIMPLEX or raises the existing
%      singleton*.
%
%      H = SIMPLEX returns the handle to a new SIMPLEX or the handle to
%      the existing singleton*.
%
%      SIMPLEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLEX.M with the given input arguments.
%
%      SIMPLEX('Property','Value',...) creates a new SIMPLEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Simplex_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simplex_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Simplex

% Last Modified by GUIDE v2.5 22-Mar-2018 00:41:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simplex_OpeningFcn, ...
                   'gui_OutputFcn',  @Simplex_OutputFcn, ...
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


% --- Executes just before Simplex is made visible.
function Simplex_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simplex (see VARARGIN)

% Choose default command line output for Simplex
handles.output = hObject;

handles.numVar=2;%variables a utilizar
handles.numRest=2;%restricciones del ejercicio
handles.tipo=1;% 1=max 2=min

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Simplex wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Simplex_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pmVar.
function pmVar_Callback(hObject, eventdata, handles)
handles.numVar=get(hObject,'Value')+1;
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns pmVar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmVar


% --- Executes during object creation, after setting all properties.
function pmVar_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',{2,3,4,5});


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pmRest.
function pmRest_Callback(hObject, eventdata, handles)
handles.numRest=get(hObject,'Value')+1;
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns pmRest contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmRest


% --- Executes during object creation, after setting all properties.
function pmRest_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',{2,3,4,5});

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pmTipo.
function pmTipo_Callback(hObject, eventdata, handles)
handles.tipo=get(hObject,'Value');
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns pmTipo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pmTipo


% --- Executes during object creation, after setting all properties.
function pmTipo_CreateFcn(hObject, eventdata, handles)
set(hObject,'String',{'Maximizar','Minimizar'});

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in botCrear.
function botCrear_Callback(hObject, eventdata, handles)
columnas={''};
filas={''};
for i=1:handles.numVar
    columnas(i)={sprintf('x%d',i)};
end
orden=size(columnas);
columnas(orden(2)+1)={'Sol.'};
letra='a';
for i=1:handles.numRest
    filas(i)={sprintf('S%d',i)};
    letra=letra+1;
end
orden=size(filas);filas(orden(2)+1)={'Z'};%******************************************
set(handles.tablaDatos,'ColumnWidth',{30});

%se rellena la tabla
set(handles.tablaDatos,'RowName',filas);
set(handles.tablaDatos,'ColumnName',columnas);
set(handles.tablaDatos,'ColumnEditable',true);
set(handles.tablaDatos,'ColumnFormat',{'numeric'});
set(handles.tablaDatos,'Data',zeros(handles.numRest+1,handles.numVar+1));

% --- Executes on button press in botResolver.
function botResolver_Callback(hObject, eventdata, handles)%Creacion de la tabla
simplex=get(handles.tablaDatos,'Data');
set(handles.ayuda, 'Visible', 'off'); %Ocultamos las instrucciones
verifica = handles.numVar; %Verificamos si solamente hay dos variables
if (verifica == 2)
    set(handles.axes1,'Visible','on');
    asd = get(handles.tablaDatos,'Data');
    axes(handles.axes1);
    hold on;
    for h = 1:handles.numRest
        g1 = asd(h, 1);
        g2 = asd(h,2);
        g3 = asd(h,3);
        plot([g3/g1 0], [0 g3/g2]); %   Graficamos si hay dos variables
    end
    hold off;
end
simplex=[[simplex(:,1:handles.numVar),[eye(handles.numRest);zeros(1,handles.numRest)]],simplex(:,handles.numVar+1)];
cambio=size(simplex);
b=(zeros(1,handles.numVar)); 
tipo=1; % Comprobar que tipo de funcon
if handles.tipo==2
    tipo=-1;
end
while mean((simplex(cambio(1),:)*tipo)>=0)~=1 %Comienza el ciclo para resolver
    disp(simplex);
    
    if handles.tipo==1
        [~,y]=min(simplex(cambio(1),1:cambio(2)-1));% Comprobacion del mas negatico
    else [~,y]=max(simplex(cambio(1),1:cambio(2)-1));% Comprobacion del mas positvo
    end
    x=1; % Guarda la poscion del povote
    pivote=simplex(1,cambio(2))/simplex(1,y); %Busca el pivote para dividir
    for i=2:(cambio(1)-1)    % Comienza a dividir
        if simplex(i,y)>0
            aux=simplex(i,cambio(2))/simplex(i,y);
            if pivote<0 || aux<pivote %Comprobar el menos negativo
                pivote=aux;x=i;
            end
        end
    end
    b(y)=x;	%Posicion de las variables
    simplex(x,:)=simplex(x,:)/simplex(x,y); %Se divide la fila por el elmento pivote
 
 
 for i=1:cambio(1) %Nuevos valores
     if i~=x % Mintras que no sea la fila con la que se trabaja
         aux=(0);%Se remplaza la fila completa en la mtraiz principal
         for j=1:cambio(2);
             aux(j)=simplex(i,j)-simplex(i,y)*simplex(x,j);
         end
         simplex(i,:)=aux;
     end
 end
end

disp(simplex);
disp(b);
conta = 0;
for i=1:handles.numVar % Verifica si hay solucion o no
    if (b(i) == 0)
        conta = conta +1; % Revisa si todos los resultados concuerdan
    end
end
if (conta == handles.numVar)
    aux='Sin Solución';
else
    aux='Solución';
end

for i=1:handles.numVar
    if b(i)~=0
    aux=sprintf('%s\n x%d =%.f',aux,i,simplex(b(i),cambio(2)));
  else
        aux=sprintf('%s\n x%d = %.f',aux,i,0);
    end
 end

aux=sprintf('%s\n Z =%.f',aux,simplex(cambio(1),cambio(2))); % Se imprime el resultado
set(handles.salida,'Visible', 'on', 'Max', 10, 'String', aux);



% --- Executes during object creation, after setting all properties.
function tablaDatos_CreateFcn(hObject, eventdata, handles)
set(hObject,'ColumnName',{});
set(hObject,'RowName',{});
set(hObject,'Data',[]);


% --- Executes when entered data in editable cell(s) in tablaDatos.
function tablaDatos_CellEditCallback(hObject, eventdata, handles)
i=get(hObject,'Data');
if isnan(i(eventdata.Indices(1),eventdata.Indices(2)))i(eventdata.Indices(1),eventdata.Indices(2))=0;
    set(hObject,'Data',i);
end 



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function salida_Callback(hObject, eventdata, handles)
% hObject    handle to salida (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of salida as text
%        str2double(get(hObject,'String')) returns contents of salida as a double


% --- Executes during object creation, after setting all properties.
function salida_CreateFcn(hObject, eventdata, handles)
% hObject    handle to salida (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ayuda_Callback(hObject, eventdata, handles)
% hObject    handle to ayuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ayuda as text
%        str2double(get(hObject,'String')) returns contents of ayuda as a double


% --- Executes during object creation, after setting all properties.
function ayuda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ayuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
