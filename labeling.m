function varargout = labeling(varargin)
% LABELING MATLAB code for labeling.fig
%      LABELING, by itself, creates a new LABELING or raises the existing
%      singleton*.
%
%      H = LABELING returns the handle to a new LABELING or the handle to
%      the existing singleton*.
%
%      LABELING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABELING.M with the given input arguments.
%
%      LABELING('Property','Value',...) creates a new LABELING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before labeling_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to labeling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help labeling

% Last Modified by GUIDE v2.5 07-Jul-2014 12:46:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @labeling_OpeningFcn, ...
                   'gui_OutputFcn',  @labeling_OutputFcn, ...
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


% --- Executes just before labeling is made visible.
function labeling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to labeling (see VARARGIN)
handles = guidata(hObject);

handles.currentKey = 'nil';
handles.player.isplaying = false;
if exist( 'labeling_settings.mat', 'file' )
    load( 'labeling_settings.mat', 'soundsDir' );
    set( handles.soundsDirEdit, 'String', soundsDir );
else
    set( handles.soundsDirEdit, 'String', pwd );
end
handles.soundsDir = get( handles.soundsDirEdit, 'String' );
updateSoundsList( handles );
% Choose default command line output for labeling
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes labeling wait for user response (see UIRESUME)
% uiwait(handles.labelingGuiFig);


% --- Outputs from this function are returned to the command line.
function varargout = labeling_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on key release with focus on labelingGuiFig and none of its controls.
function labelingGuiFig_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to labelingGuiFig (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Interruptible','off');
handles = guidata(hObject);

switch( lower( eventdata.Key ) )
    case 's'
        if handles.player.isplaying
            stopPlayer( handles.player );
        end
    case 'space'
        saveOnoffs( handles );
        set( handles.soundsList,'Value', get( handles.soundsList,'Value' ) + 1 );
        soundsList_Callback( handles.soundsList, [], handles );
        handles = guidata( hObject );
    case 'end'
        handles = pushLabel( handles, 1 );
        handles = popSoundStack( handles );
    case 'return'
        curLen = handles.sEnd - handles.sStart;
        if curLen / handles.fs < handles.minBlockLen  ||  handles.l < 0
            handles = pushLabel( handles, 1 );
        else
            sep = floor( curLen*2/5 ) + randi( floor( curLen/5 ) );
            handles.sStack = [handles.sStack;
                handles.sStart, handles.sStart + sep, 1;
                handles.sStart + sep + 1, handles.sEnd, 1];
        end
        handles = popSoundStack( handles );
    case 'delete'
        handles = pushLabel( handles, -1 );
        handles = popSoundStack( handles );
    case 'home'
        handles.minBlockLen = max( 0.2, handles.minBlockLen * 0.67 );
        handles.shiftLen = handles.shiftLen * 0.67;
        handles.sStack = [1, length(handles.s), 1];
        handles.onsets{end+1} = [];
        handles.offsets{end+1} = [];
        handles = popSoundStack( handles );
end
guidata(hObject,handles);
set(findobj(hObject, 'Type', 'uicontrol'), 'Enable', 'off');
drawnow;
set(findobj(hObject, 'Type', 'uicontrol'), 'Enable', 'on');



% --- Executes on button press in soundsDirButton.
function soundsDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to soundsDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

handles.soundsDir = uigetdir( get( handles.soundsDirEdit, 'String' ));
set( handles.soundsDirEdit, 'String', handles.soundsDir );
guidata(hObject, handles);
soundsDir = handles.soundsDir;
save( 'labeling_settings.mat', 'soundsDir' );
updateSoundsList( handles );
set(findobj(hObject, 'Type', 'uicontrol'), 'Enable', 'off');
drawnow;
set(findobj(hObject, 'Type', 'uicontrol'), 'Enable', 'on');


% --- Executes during object creation, after setting all properties.
function soundsDirEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soundsDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in soundsList.
function soundsList_Callback(hObject, eventdata, handles)
% hObject    handle to soundsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

contents = cellstr(get(hObject,'String'));
selectedSound = regexprep( contents{get(hObject,'Value')}, '<html><b>', '' );
selectedSound = regexprep( selectedSound, '</b></html>', '' );
disp(selectedSound);
[handles.s, handles.fs] = audioread( [handles.soundsDir '\' selectedSound] );
smeans = mean(handles.s);
handles.s = handles.s - repmat( smeans, length(handles.s), 1);
smax = max( max( abs( handles.s ) ) );
handles.s = handles.s ./ smax;
handles.minBlockLen = 0.45;
handles.shiftLen = 0.1;
handles.sStack = [1, length(handles.s), 1];
handles.onsets = [];
handles.offsets = [];
handles.onsets{1} = [];
handles.offsets{1} = [];
handles.onsetsInterp = [];
handles.offsetsInterp = [];
guidata( hObject, handles );
handles = popSoundStack( handles );
guidata( hObject, handles );
plotSound( hObject );
set( handles.textfield, 'String', '' );
set( findobj(hObject, 'Type', 'uicontrol'), 'Enable', 'off' );
drawnow;
set( findobj(hObject, 'Type', 'uicontrol'), 'Enable', 'on' );


% --- Executes during object creation, after setting all properties.
function soundsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soundsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on soundsDirEdit and none of its controls.
function soundsDirEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to soundsDirEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


function soundsDirEdit_Callback(hObject, eventdata, handles)
% hObject    handle to soundsDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

handles.soundsDir = get( hObject, 'String' );
guidata(hObject,handles);
updateSoundsList( handles );
