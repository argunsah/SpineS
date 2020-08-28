function handles = statusUpdate(handles, hObject)

% Updates Status Textbox
% statusFlags: 
% 1 - StackLoaded, 2 - MIP, 3 - Filtered, 4 - Registered, 5 - NumofSpines

% Ali Ozgur Argunsah, IGC.
% Last Update : March, 2012.

% This should be modified

set(handles.status,'String',...
    sprintf('Stack Loaded : %d, MIP : %d, Filtered: %d, Segmented: %d, ',...
    handles.Flags.importStack,...
    handles.Flags.calculateMIP,...
    handles.Flags.medianFilter,...
    handles.Flags.autoSegmented...
    ));

guidata(hObject, handles);



