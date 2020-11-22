function varargout = gui(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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
function gui_OpeningFcn(hObject, eventdata, handles, varargin)

global R
global B
global G
R = []; G = []; B = [];
global imageSize
imageSize = [0,0];
global p
p = 251;
global k
global n
k = 0; n = 0;
global shadowsR
shadowsR = [];
global shadowsG
shadowsG = [];
global shadowsB
shadowsB = [];
global shadowsModR
shadowsModR = [];
global shadowsModG
shadowsModG = [];
global shadowsModB
shadowsModB = [];
global photoName
photoName = '';
global photoPath
photoPath = '';

handles.output = hObject;

guidata(hObject, handles);
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
[File_Name, Path_Name] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'});
if File_Name == 0
    return;
end

global R, global B, global G, global imageSize
global k, global n
k = 0; n = 0;
global shadowsR
shadowsR = [];
global shadowsG
shadowsG = [];
global shadowsB
shadowsB = [];
global shadowsModR
shadowsModR = [];
global shadowsModG
shadowsModG = [];
global shadowsModB
shadowsModB = [];
global photoName, global photoPath;

 set(handles.edit13,'String','');
 set(handles.text13,'String','add shadow 2.');
 set(handles.edit3,'String','');
 set(handles.edit4,'String','');
 set(handles.edit8,'String','');
 axes(handles.axes7);
 cla;
 axes(handles.axes3);
 cla;
 axes(handles.axes6);
 cla;
 
axes(handles.axes2);
imshow([Path_Name,File_Name]);
photoPath = Path_Name; 
[~, name, ~] = fileparts(File_Name);
photoName = name;

global p
[ R, G, B ] = readImage( strcat(Path_Name,File_Name) );
 R = prepare( R, p );
 G = prepare( G, p );
 B = prepare( B, p );
 imageSize = size(R);
 
 set(handles.edit10,'String',int2str(imageSize(1)));
 set(handles.edit12,'String',int2str(imageSize(2)));

 

function edit3_Callback(hObject, eventdata, handles)
global k
global imageSize
pom = get( handles.edit3, 'String');
flag = sum( isstrprop(pom, 'digit') == 0 );

if flag ~= 0
   set(handles.edit3,'String','');
   warndlg('You must enter a number!');
else 
   if imageSize(1) == 0
        set(handles.edit3,'String','');
        warndlg('Select an image first!');
   else
        k = str2double(pom);
        if mod( imageSize(1)*imageSize(2), k ) ~= 0
            k = 0;
            set(handles.edit3,'String','');
            warndlg('The k you selected cannot be applied because of the image size!');
        end
   end
end




function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
global n
global k
pom = get( handles.edit4, 'String');
flag = sum( isstrprop(pom, 'digit') == 0 );

if flag ~= 0
   set(handles.edit4,'String','');
   warndlg('You must enter a number!');
else  
   n = str2double(pom);  
   if n < k      
       set(handles.edit4,'String','');
       warndlg('n the sea should be larger or equal k!');
       n = k;
   end
end


function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton3_Callback(hObject, eventdata, handles)
function pushbutton4_Callback(hObject, eventdata, handles)
global p
global k
global n
global R
global B
global G
global imageSize
global shadowsR
global shadowsB
global shadowsG

if imageSize(1) == 0
    warndlg('Select an image!');
    return;
end

if k == 0
    warndlg('Please select k!');
    return;
end

if n == 0
    warndlg('Please select n!');
    return;
end
set(handles.axes3,'visible','on');

tic
shadowsR = encrypt( R, k, n, p );
shadowsG = encrypt( G, k, n, p );
shadowsB = encrypt( B, k, n, p );
kraj = toc;

shadowSize = size(shadowsR);


blankSpace = ones( shadowSize(1), 30, 3 ) * 240;
outputImage = [];
global photoName, global photoPath
for i = 1:n
    RGB = cat(3, uint8(shadowsR(:,:,i)), uint8(shadowsG(:,:,i)), uint8(shadowsB(:,:,i))); 
    
    fileName = strcat(photoPath, photoName, 'shadow',int2str(i),'.png');
    imwrite(RGB, fileName, 'png');
    outputImage = [outputImage, RGB, blankSpace];
end

axes(handles.axes3);
imshow(outputImage);
set(handles.text13,'String',strcat('Generated shadow generation by method 1. Elapsed time:',int2str(kraj)));


function pushbutton5_Callback(hObject, eventdata, handles)
global p
global k
global n
global R
global B
global G
global imageSize
global shadowsModR
global shadowsModB
global shadowsModG

if imageSize(1) == 0
    warndlg('Choose a picture!');
    return;
end

if k == 0
    warndlg('Please select k!');
    return;
end

if n == 0
    warndlg('Please select n!');
    return;
end

set(handles.axes6,'visible','on')
x = 1:n;
tic;
shadowsModR = encryptMod( R, k, n, p, x );
shadowsModG = encryptMod( G, k, n, p, x );
shadowsModB = encryptMod( B, k, n, p, x );
kraj = toc;

shadowSize = size(shadowsModR);


blankSpace = ones( shadowSize(1), 30, 3 ) * 240;

outputImageMod = [];
global photoName, global photoPath
for i = 1:n    
    RGBMod = cat(3, uint8(shadowsModR(:,:,i)), uint8(shadowsModG(:,:,i)), uint8(shadowsModB(:,:,i)));  
    
    fileName = strcat(photoPath, photoName, 'senkaMod',int2str(i),'.png');
    imwrite(RGBMod, fileName, 'png');
    outputImageMod = [outputImageMod, RGBMod, blankSpace];
end

axes(handles.axes6);
imshow(outputImageMod);

set(handles.text13,'String',strcat('Generated shadow generation by method 2. Elapsed time:',int2str(kraj)));


function pushbutton8_Callback(hObject, eventdata, handles)
function pushbutton7_Callback(hObject, eventdata, handles)


function edit7_Callback(hObject, eventdata, handles)
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton6_Callback(hObject, eventdata, handles)
function edit8_Callback(hObject, eventdata, handles)
global n

pom = get( handles.edit8, 'String');

for i = 1:length(pom)
    if isstrprop(pom(i), 'digit') == 1
        indeks = str2double(pom(i));
        if indeks > n
            set(handles.edit8,'String',pom(1:i-1));
            warndlg('Index out of bounds!');
            return;
        end
    else
        if pom(i) ~= ' '
             set(handles.edit8,'String',pom(1:i-1));
             warndlg('Bad sign!');
             return;
        end
    end
end


function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton10_Callback(hObject, eventdata, handles)
global shadowsR
global shadowsB
global shadowsG
global imageSize
global p

imageSize(1) = str2double(get( handles.edit10, 'String'));
imageSize(2) = str2double(get( handles.edit12, 'String'));

if isnan(imageSize(1))
     warndlg('Enter the image size ');
     return;
end


indeksi = [];
pom = get( handles.edit8, 'String');

for i = 1:length(pom)         
        if pom(i) ~= ' '
            indeksi = [indeksi str2double(pom(i))];
        end
end

x = [];
pom = get( handles.edit13, 'String');

for i = 1:length(pom)         
        if pom(i) ~= ' '
           x = [x str2double(pom(i))];
        end
end


tic;
[ originalR ] = decrypt( shadowsR(:,:,indeksi), x, p, imageSize );
[ originalG ] = decrypt( shadowsG(:,:,indeksi), x, p, imageSize );
[ originalB ] = decrypt( shadowsB(:,:,indeksi), x, p, imageSize );
kraj = toc;

axes(handles.axes7);
RGB = cat(3, uint8(originalR), uint8(originalG), uint8(originalB)); 
imshow(RGB) 
set(handles.text13,'String',strcat('Reconstruction performed by method 1. Elapsed time:', int2str(kraj)));
global photoPath, global photoName
fileName = strcat(photoPath, photoName, 'Reconstruction','.png');
imwrite(RGB, fileName, 'png');
function pushbutton11_Callback(hObject, eventdata, handles)
global shadowsModR
global shadowsModB
global shadowsModG
global imageSize
global p

imageSize(1) = str2double(get( handles.edit10, 'String'));
imageSize(2) = str2double(get( handles.edit12, 'String'));

if isnan(imageSize(1))
     warndlg('Enter image size!');
     return;
end


indeksi = [];
pom = get( handles.edit8, 'String');

for i = 1:length(pom)         
        if pom(i) ~= ' '
            indeksi = [indeksi str2double(pom(i))];
        end
end

x = [];
pom = get( handles.edit13, 'String');

for i = 1:length(pom)         
        if pom(i) ~= ' '
           x = [x str2double(pom(i))];
        end
end

tic
[ originalR ] = decryptMod( shadowsModR(:,:,indeksi), x, p, imageSize );
[ originalG ] = decryptMod( shadowsModG(:,:,indeksi), x, p, imageSize );
[ originalB ] = decryptMod( shadowsModB(:,:,indeksi), x, p, imageSize );
kraj = toc;

axes(handles.axes7);
RGB = cat(3, uint8(originalR), uint8(originalG), uint8(originalB)); 
imshow(RGB) 

set(handles.text13,'String',strcat('Generated shadow generation by method 2. Elapsed time:', int2str(kraj)));

global photoPath, global photoName
fileName = strcat(photoPath, photoName, 'Reconstruction mod','.png');
imwrite(RGB, fileName, 'png');



function edit10_Callback(hObject, eventdata, handles)
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
pom = get( handles.edit8, 'String');

for i = 1:length(pom)
    if isstrprop(pom(i), 'digit') == 1
        return
    else
        if pom(i) ~= ' '
             set(handles.edit8,'String',pom(1:i-1));
             warndlg('Bad sign!');
             return;
        end
    end
end


function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton12_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'},'MultiSelect','on');
numfiles = size(FileName,2);

if FileName(1) == 0
    return;
end
 set(handles.text13,'String','Shadows added.');
 set(handles.edit3,'String','');
 set(handles.edit4,'String','');
 set(handles.edit8,'String','');
 set(handles.edit10,'String','');
 set(handles.edit12,'String','');
 set(handles.edit13,'String','');
 axes(handles.axes7);
 cla;
 axes(handles.axes3);
 cla;
 axes(handles.axes6);
 cla;
 axes(handles.axes2);
 cla;

global R, global B, global G, global imageSize
global k, global n
imageSize = [0 0];
k = 0; n = 0;
global shadowsR
shadowsR = [];
global shadowsG
shadowsG = [];
global shadowsB
shadowsB = [];
global shadowsModR
shadowsModR = [];
global shadowsModG
shadowsModG = [];
global shadowsModB
shadowsModB = [];
global photoName, global photoPath;
photoName = 'oldSharesReconstruction';


[ R, G, B ] = readImage( strcat(PathName,FileName{1}) );
shadowSize = size(R);
shadowsR = ones(shadowSize(1),shadowSize(2),numfiles) * 113;
shadowsG = ones(shadowSize(1),shadowSize(2),numfiles) * 213;
shadowsB = ones(shadowSize(1),shadowSize(2),numfiles) * 113;
shadowsR(:,:,1) = R;
shadowsG(:,:,1) = G;
shadowsB(:,:,1) = B;
for ii = 2:numfiles  
    [ R, G, B ] = readImage( strcat(PathName,FileName{ii}) );
    shadowsR(:,:,ii) = R;
    shadowsG(:,:,ii) = G;
    shadowsB(:,:,ii) = B;
end  
R = []; G = []; B = [];
blankSpace = ones( shadowSize(1), 30, 3 ) * 240;
n = numfiles;
outputImage = [];
for i = 1:n
    RGB = cat(3, uint8(shadowsR(:,:,i)), uint8(shadowsG(:,:,i)), uint8(shadowsB(:,:,i)));    
    outputImage = [outputImage, RGB, blankSpace];
end

axes(handles.axes3);
imshow(outputImage);

function pushbutton13_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'},'MultiSelect','on');

numfiles = size(FileName,2);

if numfiles == 0
    return;
end

 set(handles.text13,'String','Shadows added.');
 set(handles.edit3,'String','');
 set(handles.edit4,'String','');
 set(handles.edit8,'String','');
 set(handles.edit10,'String','');
 set(handles.edit12,'String','');
 set(handles.edit13,'String','');
 axes(handles.axes7);
 cla;
 axes(handles.axes3);
 cla;
 axes(handles.axes6);
 cla;
 axes(handles.axes2);
 cla;

global R, global B, global G, global imageSize
global k, global n
imageSize = [0 0];
k = 0; n = 0;
global shadowsR
shadowsR = [];
global shadowsG
shadowsG = [];
global shadowsB
shadowsB = [];
global shadowsModR
global shadowsModG
global shadowsModB
global photoName, global photoPath;
photoName = 'oldSharesReconstruction';
photoPath = PathName;

[ R, G, B ] = readImage( strcat(PathName,FileName{1}) );
shadowSize = size(R);
shadowsModR = ones(shadowSize(1),shadowSize(2),numfiles) * 113;
shadowsModG = ones(shadowSize(1),shadowSize(2),numfiles) * 213;
shadowsModB = ones(shadowSize(1),shadowSize(2),numfiles) * 113;
shadowsModR(:,:,1) = R;
shadowsModG(:,:,1) = G;
shadowsModB(:,:,1) = B;
for ii = 2:numfiles  
    [ R, G, B ] = readImage( strcat(PathName,FileName{ii}) );
    shadowsModR(:,:,ii) = R;
    shadowsModG(:,:,ii) = G;
    shadowsModB(:,:,ii) = B;
end  

blankSpace = ones( shadowSize(1), 30, 3 ) * 240;

n = numfiles;
outputImage = [];
for i = 1:n
    RGB = cat(3, uint8(shadowsModR(:,:,i)), uint8(shadowsModG(:,:,i)), uint8(shadowsModB(:,:,i)));    
    outputImage = [outputImage, RGB, blankSpace];
end
R = []; G = []; B = [];
axes(handles.axes6);
imshow(outputImage);
