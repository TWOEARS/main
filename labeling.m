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

handles.reactionTime = 0.2;

handles.currentKey = 'nil';
handles.saveAndStopKey = 's';
handles.stopKey = 'escape';
handles.saveAndProceedKey = 'space';
handles.onlyEventKey = 'end';
handles.eventIncludedKey = 'return';
handles.noEventKey = 'delete';
handles.newLabelingRoundKey = 'home';
handles.preLabelKey = 'l';
helpTxt = sprintf( ['Press "%s" to stop playback, "%s" to stop and save; "%s" to save and proceed to the next sound.\n'...
    'Press "%s" if what you hear includes the event, "%s" if it is only the event, and "%s" if it doesn´t include the event.\n'...
    '"%s" starts another round of labeling for this sound.\n'...
    'Press "%s" for live labeling.'], ...
    handles.stopKey, handles.saveAndStopKey, handles.saveAndProceedKey, ...
    handles.eventIncludedKey, handles.onlyEventKey, handles.noEventKey, ...
    handles.newLabelingRoundKey, ...
    handles.preLabelKey );
set( handles.helpText, 'String', helpTxt );

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


% --- Executes on key press with focus on labelingGuiFig and none of its controls.
function labelingGuiFig_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to labelingGuiFig (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
set(hObject,'Interruptible','off');

if ~strcmpi( handles.currentKey, eventdata.Key )
    handles.currentKey = eventdata.Key;
    switch( eventdata.Key )
        case handles.preLabelKey
            if (handles.player.TotalSamples - handles.player.CurrentSample) / handles.fs < 0.1
                handles.onsetsPre{handles.eventCounter} = [handles.onsetsPre{handles.eventCounter} 1];
            else
                handles.onsetsPre{handles.eventCounter} = [handles.onsetsPre{handles.eventCounter} max(1, handles.player.CurrentSample - handles.reactionTime * handles.fs)];
            end
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
handles = guidata(hObject);
handles.currentKey = 'nil';

switch( lower( eventdata.Key ) )
    case handles.saveAndStopKey
        saveOnoffs( handles );
        if handles.player.isplaying
            stopPlayer( handles.player );
        end
    case handles.stopKey
        if handles.player.isplaying
            stopPlayer( handles.player );
        end
    case handles.saveAndProceedKey
        saveOnoffs( handles );
        set( handles.soundsList,'Value', get( handles.soundsList,'Value' ) + 1 );
        soundsList_Callback( handles.soundsList, [], handles );
        handles = guidata( hObject );
    case handles.preLabelKey
        if handles.overrun
            handles.offsetsPre{handles.overrunCounter} = [handles.offsetsPre{handles.overrunCounter} handles.player.TotalSamples];
            handles.overrun = false;
        else
            if handles.player.CurrentSample == 1
                handles.offsetsPre{handles.eventCounter} = [handles.offsetsPre{handles.eventCounter} handles.player.TotalSamples];
            else
                handles.offsetsPre{handles.eventCounter} = [handles.offsetsPre{handles.eventCounter} max(1, handles.player.CurrentSample - handles.reactionTime * handles.fs)];
            end
            handles.eventCounter = handles.eventCounter + 1;
            if size( handles.onsetsPre,2 ) < handles.eventCounter
                handles.onsetsPre{handles.eventCounter} = [];
            end
            if size( handles.offsetsPre,2 ) < handles.eventCounter
                handles.offsetsPre{handles.eventCounter} = [];
            end
            tout = [sprintf( 'onsetsPre: %s\n', mat2str( double(int64(100*(cellfun(@median, handles.onsetsPre) ./ handles.fs)))/100 ) ),  sprintf( 'offsetsPre: %s\n', mat2str( double(int64(100*(cellfun(@median, handles.offsetsPre) ./ handles.fs)))/100 ) )];
            set( handles.textfield, 'String', tout );
        end
        guidata( hObject,handles );
        plotSound( hObject );
    case handles.onlyEventKey
        handles = pushLabel( handles, 1 );
        handles = popSoundStack( handles );
    case handles.eventIncludedKey
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
    case handles.noEventKey
        handles = pushLabel( handles, -1 );
        handles = popSoundStack( handles );
    case handles.newLabelingRoundKey
        handles.minBlockLen = max( 0.1, handles.minBlockLen * 0.67 );
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
handles.onsetsPre = [];
handles.offsetsPre = [];
handles.onsetsPre{1} = [];
handles.offsetsPre{1} = [];
handles.eventCounter = 1;
handles.overrun = false;
handles.overrunCounter = 1;
handles = openAnnots( handles );
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
