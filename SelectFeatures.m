function varargout = SelectFeatures(varargin)
%
%-------------------------------------------
% by Giacomo Benvenuti
% <giacomox@gmail.com>
% Repository
% https://github.com/giacomox/RetinoMapModel
%-------------------------------------------

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SelectFeatures_OpeningFcn, ...
                   'gui_OutputFcn',  @SelectFeatures_OutputFcn, ...
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


% --- Executes just before SelectFeatures is made visible.
function SelectFeatures_OpeningFcn(obj, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SelectFeatures (see VARARGIN)
data = guidata(obj);
if nargin >0 
handles.Img1 = varargin{1};
axes(data.axes1)
imshow(imadjust(handles.Img1))
end
if nargin >1 
handles.Img2 = varargin{2};
axes(data.axes2)
imshow(imadjust(handles.Img2))
end

% Choose default command line output for SelectFeatures
handles.output = obj;

handles.Features_anchors = [];
% Update handles structure
guidata(obj, handles);

% UIWAIT makes SelectFeatures wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SelectFeatures_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure

varargout{1} = handles;
%delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(obj, eventdata, handles)
data = guidata(obj);
% RESET selections
if ~isempty(handles.Features_anchors)
handles.Features_anchors = [];
axes(data.axes1);imshow(imadjust(handles.Img1));
axes(data.axes2);imshow(imadjust(handles.Img2));
end

col = 'rgb';
for i = 1:3
data.text2.String='Select a feature in Img A...' ;
[x,y] = ginput(1);
F(:,1,i) = [x,y];
hold on 
scatter(x,y,60,['+' col(i)])
data.text2.String='Cool!' ;
pause (.5)

data.text2.String='Select the same feature in Img B...' ;
axes(data.axes2);
[x,y] = ginput(1);
F(:,2,i) = [x,y];
hold on 
scatter(x,y,60,['+' col(i)])
data.text2.String='Cool!' ;
pause (.5)
end
handles.Features_anchors = F;
Selected_Points = F;
 % Update handles structure
 guidata(obj, handles);

% --- Executes on button press in submit.
function submit_Callback(obj, eventdata, handles)
data = guidata(obj);
axes(data.axes1);imshow(imadjust(handles.Img1));
axes(data.axes2);imshow(imadjust(handles.Img2));
I = handles.Img1 ;
J = handles.Img2;
fixpoints = squeeze(data.Features_anchors(:,1,:))';
movingpoints = squeeze(data.Features_anchors(:,2,:))';

tform= fitgeotrans(movingpoints, fixpoints,'NonreflectiveSimilarity');

Jr = imwarp(J,tform,'OutputView', imref2d(size(I)));

u = [0 1]; 
v = [0 0]; 
[x, y] = transformPointsForward(tform, u, v); 
dx = x(2) - x(1); 
dy = y(2) - y(1); 
angle = (180/pi) * atan2(dy, dx) ;
scale = 1 / sqrt(dx^2 + dy^2);

clear x y h
Trans_Param.XOFF = tform.T(3,1) ; 
Trans_Param.YOFF= tform.T(3,2) ; 
Trans_Param.Scaling = scale;
Trans_Param.Rotation = angle;

axes(data.axes1);
% Create square
h = patch('XData',[Trans_Param.XOFF Trans_Param.XOFF ...
    Trans_Param.XOFF+ 504./Trans_Param.Scaling,Trans_Param.XOFF+504./Trans_Param.Scaling],...
    'YData',[Trans_Param.YOFF Trans_Param.YOFF+504./Trans_Param.Scaling ...
    Trans_Param.YOFF+504./Trans_Param.Scaling Trans_Param.YOFF],...
    'FaceColor','none','EdgeColor','g','LineWidth',2);
rotate(h, [0 0 1],Trans_Param.Rotation,[Trans_Param.XOFF,Trans_Param.YOFF,0]);

%----------------------
axes(data.axes2); cla
MaSk = roipoly(I,h.Vertices(:,1),h.Vertices(:,2));
tm =I ;
[row col] = find(MaSk==1) ;
tm2= I(min(row):max(row),min(col):max(col));
tm2 = imresize(tm2, size(J));
tm2 = imadjust(tm2); J2 = imadjust(J);

%imshowpair(tm3,J2,'blend')
imshow(J2); hold on
handles.NewImage = tm2;
[x,y] = Segmentation(tm2,5);
h=scatter(x,y,'.')
h.MarkerEdgeColor = 'r';
h.MarkerFaceColor = 'none';
handles.Hcontour = h;
handles.Trans_Param =Trans_Param;

Trans_Param_GUI = Trans_Param;

Retino_Mask = min(row):max(row),min(col):max(col);
% Update handles structure
  guidata(obj, handles);

% --- Executes on button press in load_imageA.
function load_imageA_Callback(obj, eventdata, handles)
 % Load and dispaly ImgA
 
 % Load objects data
 data = guidata(obj);
 [Fn , pathh] = uigetfile('.bmp', 'Select image A');
 [I map] = imread([pathh Fn]);
 handles.Img1  = ind2gray(I,map);
 axes(data.axes1);
 imshow(imadjust(handles.Img1));
 % Update handles structure
 guidata(obj, handles);


% --- Executes on button press in load_imageB.
function load_imageB_Callback(obj, eventdata, handles)
% Load and dispaly ImgB
 
% Load objects data
data = guidata(obj);
[Fn , pathh] = uigetfile('.bmp', 'Select image B');
[I map] = imread([pathh Fn]);
handles.Img2  = ind2gray(I,map);
axes(data.axes2);
imshow(imadjust(handles.Img2));
% Update handles structure
guidata(obj, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
else
% The GUI is no longer waiting, just close it
delete(hObject);
end

function [x y] = Segmentation(I,Segm_Smooth)
Segm_type = 'zerocross';
Segm_Param = 0.000000005;
BW = edge(I, Segm_type , Segm_Param);
f = 1/9*ones(5);
BW2 = filter2(f,BW);
BW3 = im2bw(BW2);
BW4 = imfill(BW3,'holes');
BW5 = abs(BW4-1);
f = 1/9*ones(round(Segm_Smooth));
BW6 = filter2(f,BW5);
BW7 = imbinarize(BW6,0.1);
Mask = BW7;
[contour_mask h] = contour(Mask,[1 1]);
delete(h);
 x = contour_mask(1,:);
 y = contour_mask(2,:);


% --- Executes on slider movement.
function Control_segmentation_Callback(hObject, eventdata, handles)

Segm_Smooth=get(hObject,'Value') ;
delete(handles.Hcontour);
I = handles.NewImage;
[x y] = Segmentation(I,Segm_Smooth)
h=scatter(x,y,10,'.')
h.MarkerEdgeColor = 'r';
h.MarkerFaceColor = 'none';

handles.Hcontour = h;
%handles.Trans_Param =Trans_Param;
guidata(hObject, handles);
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Control_segmentation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Control_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
