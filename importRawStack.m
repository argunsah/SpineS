function Icube = importRawStack(D1, handles, hObject, i)

% importRawStack function takes the directory name of the Image Stack and
% reads all the images in the stack and returns a cell structure. Each
% element of the cell are 3D matrices and represents the imagestack
% corresponding that time point.

% i: stack id
% Ali Ozgur Argunsah, IGC and CCU, Lisbon.
% Last Update : November, 2013.

set(handles.statusWin,'String','Loading stacks...');

%[folder,name,ext] = fileparts(D1);

Icube = [];
D2 = dir(fullfile(D1, '*.ti*'));

% Read each image, form a 3D image cube

set(handles.statusWin,'String',sprintf('%s%d','Time Point:',i));

for k=1:length(D2)
    I = imread(fullfile(D1,D2(k).name));
%     Icube(:,:,k) = I;
    Icube(:,:,k) = medfilt2(I,[3 3]);

    fprintf('%d ',k);
end
    
fprintf('\n');
  
guidata(hObject, handles);