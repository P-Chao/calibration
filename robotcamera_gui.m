function varargout = robotcamera_gui(varargin)
% ROBOTCAMERA_GUI MATLAB code for robotcamera_gui.fig
%      ROBOTCAMERA_GUI, by itself, creates a new ROBOTCAMERA_GUI or raises the existing
%      singleton*.
%
%      H = ROBOTCAMERA_GUI returns the handle to a new ROBOTCAMERA_GUI or the handle to
%      the existing singleton*.
%
%      ROBOTCAMERA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTCAMERA_GUI.M with the given input arguments.
%
%      ROBOTCAMERA_GUI('Property','Value',...) creates a new ROBOTCAMERA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before robotcamera_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to robotcamera_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help robotcamera_gui

% Last Modified by GUIDE v2.5 25-Sep-2016 19:18:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @robotcamera_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @robotcamera_gui_OutputFcn, ...
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


% --- Executes just before robotcamera_gui is made visible.
function robotcamera_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to robotcamera_gui (see VARARGIN)

global leftImgs rightImgs leftDir rightDir fileList posDir isrectified;
isrectified = 1;

fileList = [];
posDir = ['./pos/'];
if isrectified
leftDir = ['./leftRectify/'];
rightDir = ['./rightRectify/'];
else
leftDir = ['./left/'];
rightDir = ['./right/'];
end
leftImgs = dir([leftDir '*.bmp']);
rightImgs = dir([rightDir '*.bmp']);

if length(leftImgs) ~= length(rightImgs)
    assert(false);
end

for i = 1:length(leftImgs)
    if(strcmp(leftImgs(i).name, rightImgs(i).name))
        fileList = [fileList; {leftImgs(i).name}];
    end
end
set(handles.filelistbox, 'String', fileList);

% Initialize show area 
axes(handles.axesleft);
im = imread([leftDir leftImgs(1).name]);
imshow(im);

axes(handles.axesright);
im = imread([rightDir rightImgs(1).name]);
imshow(im);

% Choose default command line output for robotcamera_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

imgFileLoad(handles, 0);
% UIWAIT makes robotcamera_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = robotcamera_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function imgFileLoad(handles, s)
global leftImgs leftDir rightDir posDir fileList region gtPath leftShow rightShow;
leftShow = imread([leftDir leftImgs(get(handles.filelistbox, 'Value')).name]);
rightShow = imread([rightDir leftImgs(get(handles.filelistbox, 'Value')).name]);
[pathSrc, name, ext] = fileparts(leftImgs(get(handles.filelistbox, 'Value')).name);
region = [];
gtPath = [posDir name '.txt'];
if(exist(gtPath, 'file'))
    regionFid = fopen(gtPath, 'r');
    pat = '^\w+ (?<leftx>\d+) (?<lefty>\d+) (?<rightx>\d+) (?<righty>\d+) \d+ \d+ \d+ \d+ \d+ \d+ \d+';
    while(~feof(regionFid))
        lineStr = fgetl(regionFid);
        if(lineStr == -1)
            break;
        end
        result = regexp(lineStr, pat, 'names');
        if(~isempty(result))
            region = [str2num(result.leftx), str2num(result.lefty), str2num(result.rightx), str2num(result.righty)];
            region= uint32(region);
        end  
    end
    fclose(regionFid);
else
    regionFid = fopen(gtPath, 'w+');
    fclose(regionFid);
end

if(isempty(region))
    region = [0 0 0 0];
end
set(handles.editLX, 'String', num2str(region(1)));
set(handles.editLY, 'String', num2str(region(2)));
set(handles.editRX, 'String', num2str(region(3)));
set(handles.editRY, 'String', num2str(region(4)));
showRegion(leftShow, rightShow, handles, s);
saveRegion(region);
uicontrol(handles.buttonnext);

% --- Executes on selection change in filelistbox.
function filelistbox_Callback(hObject, eventdata, handles)
% hObject    handle to filelistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filelistbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filelistbox
imgFileLoad(handles, 0);

% --- Executes during object creation, after setting all properties.
function filelistbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filelistbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttongenerate.
function buttongenerate_Callback(hObject, eventdata, handles)
% hObject    handle to buttongenerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global leftImgs fileList posDir isrectified;
%[pathSrc, name, ext] = fileparts(leftImgs(get(handles.filelistbox, 'Value')).name);
filename = [];
for i = 1:length(fileList)
    [pathSrc, name, ext] = fileparts(leftImgs(i).name);
    gtPath = [posDir name '.txt'];
    if(exist(gtPath, 'file'))
        regionFid = fopen(gtPath, 'r');
        pat = '^\w+ (?<leftx>\d+) (?<lefty>\d+) (?<rightx>\d+) (?<righty>\d+) \d+ \d+ \d+ \d+ \d+ \d+ \d+';
        while(~feof(regionFid))
            lineStr = fgetl(regionFid);
            if(lineStr == -1)
                break;
            end
            result = regexp(lineStr, pat, 'names');
            if(~isempty(result))
                region = [str2num(result.leftx), str2num(result.lefty), str2num(result.rightx), str2num(result.righty)];
                region= uint32(region);
            end  
        end
        fclose(regionFid);
    else
        assert(false);
    end
    filename = [filename; name];
    xL(:,i) = [region(1) region(2)]';
    xR(:,i) = [region(3) region(4)]';
end
load('Calib_Results_stereo.mat');
load('Calib_Results_stereo_rectified.mat');
xL = double(xL);
xR = double(xR);
if isrectified
    [XL, XR] = stereo_triangulation(xL,xR,om_new,T_new,...
    fc_left_new,cc_left_new,kc_left_new,alpha_c_left_new,...
    fc_right_new,cc_right_new,kc_right_new,alpha_c_right_new);
else
    [XL, XR] = stereo_triangulation(xL,xR,om,T,...
    fc_left,cc_left,kc_left,alpha_c_left,...
    fc_right,cc_right,kc_right,alpha_c_right);
end
world = xlsread('robot.xlsx')';
world = world(1:3, :);
C(4, :) = ones(1, size(XL,2));
C(1:3, :) = XL;
M = world * pinv(C);%world = M * C


rworld = M * C;
diff = rworld - world;
error.err = sqrt(diff(1,:).*diff(1,:) + diff(2,:).*diff(2,:) + diff(3,:).*diff(3,:));
error.std = std2(diff);
if isrectified
    fid = fopen('camera2world_rectified.dat', 'w+');
    save('camera2world_rectified.mat', 'XL', 'XR', 'xL', 'xR', 'filename', ...
        'world', 'rworld', 'C', 'M', 'error', 'diff');
else
    fid = fopen('camera2world.dat', 'w+');
    save('camera2world.mat', 'XL', 'XR', 'xL', 'xR', 'filename', 'world', ... 
        'rworld', 'C', 'M', 'error', 'diff');
end
fwrite(fid, M', 'single');%world = M * C
fclose(fid);

figure, plot(1:length(error.err),error.err), ylabel('error/mm'), xlabel('sample');

% --- Executes on button press in buttonclear.
function buttonclear_Callback(hObject, eventdata, handles)
% hObject    handle to buttonclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in buttonnext.
function buttonnext_Callback(hObject, eventdata, handles)
% hObject    handle to buttonnext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curr = get(handles.filelistbox, 'Value');
total = size(get(handles.filelistbox, 'String'), 1);
if(curr < total)
    curr = curr + 1;
    set(handles.filelistbox, 'Value', curr);
    imgFileLoad(handles, 1);
end

% --- Executes on button press in buttonprev.
function buttonprev_Callback(hObject, eventdata, handles)
% hObject    handle to buttonprev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curr = get(handles.filelistbox, 'Value');
if(curr > 1)
    curr = curr - 1;
    set(handles.filelistbox, 'Value', curr);
    imgFileLoad(handles, 1);
end


function editLX_Callback(hObject, eventdata, handles)
% hObject    handle to editLX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLX as text
%        str2double(get(hObject,'String')) returns contents of editLX as a double


% --- Executes during object creation, after setting all properties.
function editLX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editLY_Callback(hObject, eventdata, handles)
% hObject    handle to editLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLY as text
%        str2double(get(hObject,'String')) returns contents of editLY as a double


% --- Executes during object creation, after setting all properties.
function editLY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRX_Callback(hObject, eventdata, handles)
% hObject    handle to editRX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRX as text
%        str2double(get(hObject,'String')) returns contents of editRX as a double


% --- Executes during object creation, after setting all properties.
function editRX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRY_Callback(hObject, eventdata, handles)
% hObject    handle to editRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRY as text
%        str2double(get(hObject,'String')) returns contents of editRY as a double


% --- Executes during object creation, after setting all properties.
function editRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function showRegion(leftShow, rightShow, handles, s)
global region;
axes(handles.axesleft);
imshow(leftShow);
axes(handles.axesright);
imshow(rightShow);
if s == 1
left_pt = ginput(1);
region(1) = left_pt(1);
region(2) = left_pt(2);
end
axes(handles.axesleft);
rectangle('Position', [region(1)-3, region(2)-3, 6, 6], 'EdgeColor', 'red');
set(handles.editLX, 'String', num2str(region(1)));
set(handles.editLY, 'String', num2str(region(2)));
if s == 1
right_pt = ginput(1);
region(3) = right_pt(1);
region(4) = right_pt(2);
end
axes(handles.axesright);
rectangle('Position', [region(3)-3, region(4)-3, 6, 6], 'EdgeColor', 'red');
set(handles.editRX, 'String', num2str(region(3)));
set(handles.editRY, 'String', num2str(region(4)));


function saveRegion(region)
global gtPath;
regionFid = fopen(gtPath, 'w');
fprintf(regionFid, '%%btGt version=1\n');
if(regionFid > 0)
    for k = 1:size(region, 1)
        if(region(k, 3) >= 0 && region(k, 4) >= 0)
            region= uint32(region);
            fprintf(regionFid, 'stereo %d %d %d %d 0 0 0 0 0 0 0\n', region(k, 1), region(k, 2), region(k, 3), region(k, 4));
        end
    end
end
fclose(regionFid);


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global region leftShow rightShow;
if(~isempty(region))
    if(strcmp(eventdata.Key, 'a'))
        left = region(1);
        if(left >= 1)
            left = left - 1;
        end
        region(1) = left;
    elseif(strcmp(eventdata.Key, 'd'))
        left = region(1);
        left = left + 1;
        region(1) = left;
    elseif(strcmp(eventdata.Key, 'w'))
        up = region(2);
        if(up >= 1)
            up = up - 1;
        end
        region(2) = up;
    elseif(strcmp(eventdata.Key, 's'))
        up = region(2);
        up = up + 1;
        region(2) = up;
    elseif(strcmp(eventdata.Key, 'leftarrow'))
        left = region(3);
        if(left >= 1)
            left = left - 1;
        end
        region(3) = left;
    elseif(strcmp(eventdata.Key, 'rightarrow'))
        left = region(3);
        left = left + 1;
        region(3) = left;
    elseif(strcmp(eventdata.Key, 'uparrow'))
        up = region(4);
        if(up >= 1)
            up = up - 1;
        end
        region(4) = up;
    elseif(strcmp(eventdata.Key, 'downarrow'))
        up = region(4);
        up = up + 1;
        region(4) = up;
    elseif(strcmp(eventdata.Key, 'escape'))
        region = [0 0 0 0];
        imgFileLoad(handles, 1);
    end
    showRegion(leftShow, rightShow, handles, 0);
    saveRegion(region);
end