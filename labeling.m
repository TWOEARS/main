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

handles.reactionTime = 0.25;
handles.preLabel = true;

handles.currentKey = 'nil';
handles.saveAndStopKey = 's';
handles.stopKey = 'escape';
handles.saveAndProceedKey = 'space';
handles.onlyEventKey = 'end';
handles.eventIncludedKey = 'return';
handles.noEventKey = 'delete';
handles.newLabelingRoundKey = 'home';
handles.preLabelKey = 'l';
handles.stopPreLabelingKey = 'backspace';
handles.energyProceedKey = 'pageup';
handles.gen0HelpTxt = 'Click on a sound in the list to start playback and labeling.';
handles.genHelpTxt = sprintf( [ ...
    'Press "%s" to stop playback, "%s" to stop and save; ' ...
    '"%s" to save and proceed to the next sound.'], ...
    handles.stopKey, handles.saveAndStopKey, handles.saveAndProceedKey );
handles.phase1aHelpTxt = sprintf( [
    'Phase 1: Press "%s" while hearing the event. Press "%s" to proceed to phase 2.\n'], ...
    handles.preLabelKey, handles.stopPreLabelingKey );
handles.phase1bHelpTxt = sprintf( [
    'Phase 1: Press "%s" while hearing the event. ' ...
    'Press "%s" to proceed to phase 2 ("%s": based on energy).\n'], ...
    handles.preLabelKey, handles.stopPreLabelingKey, handles.energyProceedKey );
handles.phase2HelpTxt = sprintf( [
    'Phase 2: Press "%s" if what you hear includes the event, "%s" if it is only the event, ' ...
    'and "%s" if it doesn´t include the event.\n'], ...
    handles.eventIncludedKey, handles.onlyEventKey, handles.noEventKey );
handles.gen2HelpTxt = sprintf( [
    '"%s" starts an additional round of labeling for this sound.\n'], ...
    handles.newLabelingRoundKey );
set( handles.helpText, 'String', handles.gen0HelpTxt );

if exist( 'labeling_settings.mat', 'file' )
    load( 'labeling_settings.mat', 'soundsDir' );
    set( handles.soundsDirEdit, 'String', soundsDir );
else
    set( handles.soundsDirEdit, 'String', pwd );
end
handles.soundsDir = get( handles.soundsDirEdit, 'String' );
handles.phase = 0;
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
if handles.preLabel
    handles = guidata(hObject);
    set(hObject,'Interruptible','off');
    
    if ~strcmpi( handles.currentKey, eventdata.Key )
        handles.currentKey = eventdata.Key;
        switch( eventdata.Key )
            case handles.preLabelKey
                if isfield( handles, 'player' ) && isa( handles.player, 'audioplayer' ) && isplaying( handles.player )
                    if (handles.player.TotalSamples - handles.player.CurrentSample) / handles.fs < 0.1
                        handles.onsetsPre{end} = [handles.onsetsPre{end} 1];
                    else
                        handles.onsetsPre{end} = [handles.onsetsPre{end} max(1, handles.player.CurrentSample - 3 * handles.reactionTime * handles.fs)];
                    end
                end
        end
        guidata(hObject,handles);
    end
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
        if isfield( handles, 'player' ) && isa( handles.player, 'audioplayer' ) && isplaying( handles.player )
            stopPlayer( handles );
        end
        set( handles.statusText, 'String', 'Playback stopped' );
    case handles.stopKey
        if isfield( handles, 'player' ) && isa( handles.player, 'audioplayer' ) && isplaying( handles.player )
            stopPlayer( handles );
        end
        set( handles.statusText, 'String', 'Playback stopped' );
    case handles.saveAndProceedKey
        saveOnoffs( handles );
        if get( handles.soundsList,'Value' ) < length( get( handles.soundsList, 'String' ) )
            set( handles.soundsList,'Value', get( handles.soundsList,'Value' ) + 1 );
            soundsList_Callback( handles.soundsList, [], handles );
        end
        handles = guidata( hObject );
    case handles.newLabelingRoundKey
        if ~isfield( handles, 'player' ) || ~isa( handles.player, 'audioplayer' ) || ~isplaying( handles.player )
            handles.minBlockLen = max( 0.1, handles.minBlockLen * 0.5 );
            handles.shiftLen = max( 0.02, handles.shiftLen * 0.5 );
            handles = changePhaseTo( 1, handles );
            handles = popSoundStack( handles );
        end
end
if handles.phase == 1
    switch( lower( eventdata.Key ) )
        case handles.preLabelKey
            if isfield( handles, 'player' ) && isa( handles.player, 'audioplayer' ) && isplaying( handles.player ) && ~isempty( handles.onsetsPre{1} )
                set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.phase1aHelpTxt]) );
                if handles.overrun
                    handles.offsetsPre{end} = [handles.offsetsPre{end} handles.player.TotalSamples];
                    handles.overrun = false;
                else
                    if handles.player.CurrentSample == 1
                        handles.offsetsPre{end} = [handles.offsetsPre{end} handles.player.TotalSamples];
                    else
                        handles.offsetsPre{end} = [handles.offsetsPre{end} max(1, handles.player.CurrentSample - handles.reactionTime * handles.fs)];
                    end
                end
                onsetsPre = sort( [handles.onsetsPre{:}] );
                offsetsPre = sort( [handles.offsetsPre{:}] );
                onoffsPre = [[onsetsPre; ones(1,length(onsetsPre))] [offsetsPre; -1* ones(1,length(offsetsPre))]];
                onoffsPre = sortrows( onoffsPre', [1,-2] );
                handles.onsetsPre = [];
                handles.onsetsPre{1} = onoffsPre(1,1);
                handles.offsetsPre = [];
                for i = 2:size( onoffsPre, 1 )
                    if onoffsPre(i,2) == 1
                        if onoffsPre(i-1,2) == -1
                            handles.onsetsPre{end+1} = [];
                        end
                        handles.onsetsPre{end} = [handles.onsetsPre{end} onoffsPre(i,1)];
                    else % onoffsPre(i,2) == -1
                        if onoffsPre(i-1,2) == 1
                            handles.offsetsPre{end+1} = [];
                        end
                        handles.offsetsPre{end} = [handles.offsetsPre{end} onoffsPre(i,1)];
                    end
                end
                tout = [sprintf( 'onsetsPre: %s\n', mat2str( double(int64(100*(cellfun(@median, handles.onsetsPre) ./ handles.fs)))/100 ) ),  sprintf( 'offsetsPre: %s\n', mat2str( double(int64(100*(cellfun(@median, handles.offsetsPre) ./ handles.fs)))/100 ) )];
                set( handles.textfield, 'String', tout );
                guidata( hObject,handles );
                plotSound( hObject );
            end
        case handles.stopPreLabelingKey
            handles.energyProceed = false;
            handles = changePhaseTo( 2, handles );
            handles = popSoundStack( handles );
        case handles.energyProceedKey
            if isempty( handles.onsetsPre{1} )
                handles.energyProceed = true;
                handles = changePhaseTo( 2, handles );
                handles = popSoundStack( handles );
            end
    end
elseif handles.phase > 1
    if isfield( handles, 'player' ) && isa( handles.player, 'audioplayer' ) && isplaying( handles.player )
        switch( lower( eventdata.Key ) )
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
        end
        end
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

if isfield( handles, 'onsetsInterp' )
    if ~isequal(handles.onsetsInterp, handles.savedOnsets) || ~isequal(handles.offsetsInterp, handles.savedOffsets)
        saveOrNot = questdlg( 'Save labels before starting new playback?', ...
            'Save?', ...
            'Yes', 'No', 'Yes' );
        switch saveOrNot
            case 'Yes'
                saveOnoffs( handles );
            case 'No'
        end
    end
end

set(hObject,'Interruptible','off');
set( findobj(hObject, 'Type', 'uicontrol'), 'Enable', 'off' );
if isfield( handles, 'player' ) && isa( handles.player, 'audioplayer' ) && isplaying( handles.player )
    stopPlayer( handles );
    delete( handles.player );
    handles = rmfield( handles, 'player' );
end

set( handles.statusText, 'String', 'LOADING' );
drawnow;
contents = cellstr(get(hObject,'String'));
selectedSound = regexprep( contents{get(hObject,'Value')}, '<html><b>', '' );
selectedSound = regexprep( selectedSound, '</b></html>', '' );
handles.soundfile = selectedSound;
[handles.s, handles.fs] = audioread( [handles.soundsDir '\' selectedSound] );
smeans = mean(handles.s);
handles.s = handles.s - repmat( smeans, length(handles.s), 1);
smax = max( max( abs( handles.s ) ) );
handles.s = handles.s ./ smax;
[handles.senv, handles.fsenv] = ampenv( handles.s, handles.fs );

handles.minBlockLen = 0.5;
handles.shiftLen = 0.1;
handles.onsets = [];
handles.offsets = [];
handles.onsetsInterp = [];
handles.offsetsInterp = [];
handles.savedOnsets = [];
handles.savedOffsets = [];

handles = changePhaseTo( 1, handles );
handles = openAnnots( handles );

guidata( hObject, handles );
handles = popSoundStack( handles );
guidata( hObject, handles );

set( findobj(hObject, 'Type', 'uicontrol'), 'Enable', 'on' );
set(hObject,'Interruptible','on');

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
