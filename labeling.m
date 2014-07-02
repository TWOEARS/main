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

% Last Modified by GUIDE v2.5 01-Jul-2014 12:26:58

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

handles.currentKey = 'nil';
handles.player.isplaying = false;
set( handles.soundsDirEdit, 'String', pwd );
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


% --- Executes on key press with focus on labelingGuiFig and none of its controls.
function labelingGuiFig_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to labelingGuiFig (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Interruptible','off');

if ~strcmpi( handles.currentKey, eventdata.Key )
    handles.currentKey = eventdata.Key;
    switch( eventdata.Key )
        case 'l'
            if (handles.player.TotalSamples - handles.player.CurrentSample) / handles.fs < 0.1
                handles.onsets{handles.eventCounter} = [handles.onsets{handles.eventCounter} 1];
            else
                handles.onsets{handles.eventCounter} = [handles.onsets{handles.eventCounter} handles.player.CurrentSample];
            end
            fprintf( 'handles.onsets{%d} = %s\n', handles.eventCounter, mat2str( handles.onsets{handles.eventCounter} ) );
    end
    guidata(hObject,handles);
end

% --- Executes on key release with focus on labelingGuiFig and none of its controls.
function labelingGuiFig_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to labelingGuiFig (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Interruptible','off');

handles.currentKey = 'nil';

switch( eventdata.Key )
    case 's'
        if handles.player.isplaying
            stopPlayer( handles.player );
        end
    case 'space'
        set( handles.soundsList,'Value', get( handles.soundsList,'Value' ) + 1 );
        soundsList_Callback( handles.soundsList, [], handles );
        handles = guidata( hObject );
    case 'l'
        if handles.overrun
            disp( 'overrun' );
            disp( handles.player.TotalSamples );
            handles.offsets{handles.overrunCounter} = [handles.offsets{handles.overrunCounter} handles.player.TotalSamples];
            handles.overrun = false;
            fprintf( 'handles.offsets{%d} = %s\n', handles.overrunCounter, mat2str( handles.offsets{handles.overrunCounter} ) );
        else
            handles.offsets{handles.eventCounter} = [handles.offsets{handles.eventCounter} handles.player.CurrentSample];
            fprintf( 'handles.offsets{%d} = %s\n', handles.eventCounter, mat2str( handles.offsets{handles.eventCounter} ) );
        end
        handles.eventCounter = handles.eventCounter + 1;
        if size( handles.onsets,2 ) < handles.eventCounter
            handles.onsets{handles.eventCounter} = [];
        end
        if size( handles.offsets,2 ) < handles.eventCounter
            handles.offsets{handles.eventCounter} = [];
        end
        guidata(hObject,handles);
        plotSound( hObject );
end
guidata(hObject,handles);


% --- Executes on button press in soundsDirButton.
function soundsDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to soundsDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.soundsDir = uigetdir( get( handles.soundsDirEdit, 'String' ));
set( handles.soundsDirEdit, 'String', handles.soundsDir );
guidata(hObject, handles);
updateSoundsList( handles );


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

contents = cellstr(get(hObject,'String'));
selectedSound = regexprep( contents{get(hObject,'Value')}, '<html><b>', '' );
selectedSound = regexprep( selectedSound, '</b></html>', '' );
disp(selectedSound);
[handles.s, handles.fs] = audioread( [handles.soundsDir '\' selectedSound] );
smeans = mean(handles.s);
handles.s = handles.s - repmat( smeans, length(handles.s), 1);
smax = max( max( abs( handles.s ) ) );
handles.s = handles.s ./ smax;
if handles.player.isplaying
    stopPlayer( handles.player );
end
handles.player = [];
handles.player = audioplayer( handles.s, handles.fs );
handles.eventCounter = 1;
handles.onsets = [];
handles.offsets = [];
handles.onsets{1} = [];
handles.offsets{1} = [];
handles.overrun = false;
handles.overrunCounter = 1;
handles.player.StopFcn = {@playerStopped, hObject};
handles.player.play( );
guidata( hObject, handles );
plotSound( hObject );

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

handles.soundsDir = get( hObject, 'String' );
guidata(hObject,handles);
updateSoundsList( handles );
