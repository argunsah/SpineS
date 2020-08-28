function handles = createFolders(handles)

% Create Folders into the Results Folder
mkdir(handles.foldername,'MIP');
mkdir(handles.foldername,'3DStacks');
mkdir(fullfile(handles.foldername,'3DStacks'),'Raw');
mkdir(fullfile(handles.foldername,'3DStacks'),'Registered');
 
mkdir(handles.foldername,'Segmentation');
mkdir(fullfile(handles.foldername,'Segmentation'),'Manual');
mkdir(fullfile(handles.foldername,'Segmentation'),'Automatic');
 
mkdir(handles.foldername,'Volumes');
mkdir(fullfile(handles.foldername,'Volumes'),'Intensity');
mkdir(fullfile(handles.foldername,'Volumes','Intensity'),'Manual');
mkdir(fullfile(handles.foldername,'Volumes','Intensity'),'Automatic');
mkdir(fullfile(handles.foldername,'Volumes'),'FWHM');
mkdir(fullfile(handles.foldername,'Volumes','FWHM'),'Manual');
mkdir(fullfile(handles.foldername,'Volumes','FWHM'),'Automatic');
 
mkdir(handles.foldername,'Neck');