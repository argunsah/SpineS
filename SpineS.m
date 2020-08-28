function varargout = SpineS(varargin)
 
% SpineS MATLAB code for SpineS.fig
%      SpineS, by itself, creates a new SpineS or ra ises the existing
%      singleton*.
%
%      H = SpineS returns the handle to a new SpineS or the handle to
%      the existing singleton*.
%
%      SpineS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SpineS.M with the given input arguments.
%
%      SpineS('Property','Value',...) creates a new SpineS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the SpineS before SpineS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpineS_OpeningFcn via varargin.
%
%      *See SpineS Options on GUIDE's Tools menu.  Choose "SpineS allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
 
% Edit the above text to modify the response to help SpineS
 
% Last Modified by GUIDE v2.5 30-Mar-2020 17:04:43
 
% Main Developers
% Ali Ozgur Argunsah, Champalimaud Neuroscience Programme, 2011-2016
% Ali Ozgur Argunsah, University of Zurich, 2016-2020
% Ertunc Erdil, Sabanci University, 2012-2016
% Devrim Unay, Bahcesehir University, 2011-2016
% Muhammad Usman Ghani, Sabanci University, 2015-2016

% DEPENDENCIES AND RELATED COPYRIGHT INFORMATION:

% xlwrite:
% Copyright (c) 2013, Alec de Zegher
% All rights reserved.
% https://ch.mathworks.com/matlabcentral/fileexchange/38591-xlwrite-generate-xls-x-files-without-excel-on-mac-linux-win

% skeleton:
% Nicholas R. Howe, http://www.cs.smith.edu/~nhowe/research/code/

% jermanEnhancementFilter:
% BSD 3-Clause License
% Base code: Copyright (c) 2009, Dirk-Jan Kroon 
% Upgraded code: Copyright (c) 2017, Tim Jerman
% All rights reserved.
% https://github.com/timjerman/JermanEnhancementFilter/blob/master/LICENSE

% fastMarch:
% Copyright (c) 2009, Gabriel Peyre
% All rights reserved.
% https://ch.mathworks.com/matlabcentral/fileexchange/6110-toolbox-fast-marching

% bioformats:
% GNU General Public License v2.0
% https://github.com/ome/bio-formats-matlab/blob/master/LICENSE.txt

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SpineS_OpeningFcn, ...
    'gui_OutputFcn',  @SpineS_OutputFcn, ...
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
 
% --- Executes just before SpineS is made visible.
 
function SpineS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpineS (see VARARGIN)
 
% Choose default command line output for SpineS
handles.output                      = hObject;
handles.timePoint                   = 1;
handles.padValue                    = 35;
handles.callCount                   = 0;
handles.spineCounter                = 0;
handles.angle                       = 0;
handles.x_pts                       = [];
handles.y_pts                       = [];
handles.stack                       = [];
handles.text10                      = [];

% Initialize Flags
handles.Flags.importStack           = 0;
handles.Flags.importTwoD            = 0;
handles.Flags.PCcalculateMIP        = 0;
handles.Flags.importPCS             = 0;
 
handles.Flags.calculateMIP          = 0;
handles.Flags.adaptiveMIP           = 0;
handles.Flags.times                 = 0;
handles.Flags.setResultsFolder      = 0;
 
handles.Flags.selectROI             = 0;
handles.Flags.importSpine           = 0;
handles.Flags.setSpineAngle         = 0;
handles.Flags.rectSelect            = 0;
 
% Filter Flags
handles.Flags.Filter                = 0;
handles.Flags.medianFilter          = 0;
handles.Flags.CANDLEFilter          = 0;
 
% Segmentation Flags
handles.Flags.segRegMI              = 0;
handles.Flags.segRegSIFT            = 0;
handles.Flags.autoSegmented         = 0;
handles.Flags.manuallySegmented     = 0;
handles.Flags.excludeSpines         = 0;

% Volume Flags
handles.Flags.manualIntensity       = 0;
handles.Flags.autoIntensity         = 0;
handles.Flags.manualFWHM            = 0;
handles.Flags.autoFWHM              = 0;
 
% Neck Flags
handles.Flags.autoNeckLegth         = 0;

% Registration Flags
handles.Flags.globalRegistration    = 0;
 
% Dendrite
handles.CropMask = [];
 
% Default Values for Image Info
% These can either be modified here permanently depending on the specs of the
% microscope you are using or on the SpineS GUI
handles.xyPixelSizeValue = '0.1038';%'0.0306';%'0.0386';%'0.138';

% '0.1367';%'0.0193';%'0.0193';%'0.0193';%'0.09';%'0.0193';%'0.0660'; '0.0306';  % micrometer
% handles.xyPixelSizeValue = '0.0660';%'0.0660';   % micrometer
handles.zSpacingValue    = '0.43';%'0.408';
% .3;%0.23;%'0.3';%'0.3';%'0.23';     % micrometer
% handles.zSpacingValue    = '0.23';%'0.23';       % micrometer
handles.bitDepthValue    = '16';
% '12';%'16';%'12';%'12';%'16'; '8';        % bits
% handles.bitDepthValue    = '16';%'16';      % bits

% Set the String
set(handles.xyPixelSize,'String',handles.xyPixelSizeValue);
set(handles.zSpacing   ,'String',handles.zSpacingValue);
set(handles.bitDepth   ,'String',handles.bitDepthValue);
 
handles.xPixelSizeVal = str2double(handles.xyPixelSizeValue);
handles.zSpacingVal   = str2double(handles.zSpacingValue);
handles.bitDepthVal   = str2double(handles.bitDepthValue);
%_____________________________________________________________________________
 
% Warnings OFF
warning('off','all');
 
% Directories and Dependencies
workingDir          = pwd;
handles.workingDir  = workingDir;
 
fastMarchDir        = 'fastMarch';
excelWriteDir       = 'xlwrite';
bfOpenMicroscopyDir = 'bfmatlab';
skeletonDir         = 'Skeleton';
jermanFilterDir     = 'JermanFilt';

addpath(workingDir); 
addpath(fullfile(workingDir,fastMarchDir));
addpath(fullfile(workingDir,fastMarchDir,'functions'));
addpath(fullfile(workingDir,fastMarchDir,'shortestpath'));
addpath(fullfile(workingDir,excelWriteDir));
addpath(fullfile(workingDir,excelWriteDir,'poi_library'));
addpath(fullfile(workingDir,bfOpenMicroscopyDir));
addpath(fullfile(workingDir,skeletonDir));
addpath(fullfile(workingDir,jermanFilterDir));

% UIWAIT makes SpineS wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.dataLoadText     , 'BackgroundColor', 'red');
set(handles.croppedText      , 'BackgroundColor', 'red');
set(handles.spineSelectText  , 'BackgroundColor', 'red');
set(handles.filteredText     , 'BackgroundColor', 'red');
set(handles.segmentedText    , 'BackgroundColor', 'red');
set(handles.neckComputedText , 'BackgroundColor', 'red');

guidata(hObject, handles);
 
% --- Outputs from this function are returned to the command line.
function varargout = SpineS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function dendCrop_Callback(hObject, eventdata, handles)
% hObject    handle to dendCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
cropIm            = imread(fullfile(handles.MIPfoldername,'MIP_average.png'));
handles.cropImFig = figure; imshow(cropIm,[]);
 
h           = impoly;
position    = wait(h); 
   
x1          = min(position(:, 1));
x2          = max(position(:, 1));
y1          = min(position(:, 2));
y2          = max(position(:, 2));
 
CropMask    = createMask(h);
 
handles.CropMask = double(CropMask);
close(handles.cropImFig);
 
set(handles.croppedText, 'BackgroundColor', 'green');
guidata(hObject, handles);

% --------------------------------------------------------------------
function ImportUsingBioformats_Callback(hObject, eventdata, handles)
% hObject    handle to ImportUsingBioformats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.statusWin,'String',sprintf(...
    'Select files to be analyzed.\n Each file should contain Z-Stacks. The software will load all images folder by folder and display 2D projected image of the first time point.\nImage files should be in tif format.'));

D1                    = uipickfiles;
handles.stackSize     = length(D1);
handles.pathRawStacks = D1;

% Results folder Name selection
prompt                = {'Enter the directory name to save results or leave blank :'};
name                  = 'Directory Name';
numlines              = 1;
defaultSize           = {''};
 
folderName            = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
 
if isempty(folderName)
    if ismac
        st = regexp(D1{1}, '/', 'split');
        folderName = fullfile('/',st{1:end-1},sprintf('%s%s','results',datestr(now,30))); % Date Format (ISO 8601)  'yyyymmddTHHMMSS'
    else
        st = regexp(D1{1}, '\', 'split');
        folderName = fullfile(st{1:end-1},sprintf('%s%s','results',datestr(now,30))); % Date Format (ISO 8601)  'yyyymmddTHHMMSS'
    end
else
    [status, msg, msgId] = mkdir(folderName);
    while(~isempty(msg))
        prompt = {'Folder exists. Enter a new folder name'};
        folderName = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
        [status, msg, msgId] = mkdir(folderName);
    end
end
 
handles.Flags.setResultsFolder = 1;
set(handles.edit8,'String',sprintf('%s',folderName));
 
% Create Folders into the Results Folder
mkdir(folderName,'MIP');
mkdir(folderName,'3DStacks');
mkdir(fullfile(folderName,'3DStacks'),'Raw');
mkdir(fullfile(folderName,'3DStacks'),'Registered');
 
mkdir(folderName,'Segmentation');
mkdir(fullfile(folderName,'Segmentation'),'Manual');
mkdir(fullfile(folderName,'Segmentation'),'Automatic');
 
mkdir(folderName,'Volumes');
mkdir(fullfile(folderName,'Volumes'),'Intensity');
mkdir(fullfile(folderName,'Volumes','Intensity'),'Manual');
mkdir(fullfile(folderName,'Volumes','Intensity'),'Automatic');
mkdir(fullfile(folderName,'Volumes'),'FWHM');
mkdir(fullfile(folderName,'Volumes','FWHM'),'Manual');
mkdir(fullfile(folderName,'Volumes','FWHM'),'Automatic');
 
mkdir(folderName,'Neck');
 
handles.foldername    = folderName;
handles.MIPfoldername = fullfile(folderName,'MIP');
handles.Segfoldername = fullfile(folderName,'Segmentation');
handles.volumesFolder = fullfile(folderName,'Volumes');
handles.ThreeDfolder  = fullfile(folderName,'3DStacks','Raw');
handles.neckFolder    = fullfile(folderName,'Neck');

set(handles.statusWin,'String',sprintf('Dataset imported! Stack Size : %d',handles.stackSize));
set(handles.text10,'String',sprintf('numTimes:%d',handles.stackSize));
 
stackSize     = size(D1,2);
 
% Load default BitDepth Value
bitDepthValue = handles.bitDepth; %str2double(get(handles.bitDepth,'string'));
bitdepth      = str2double(get(handles.bitDepth,'String'));
h_MIP         = waitbar(0, 'Maximum Intensity Projection and Registration in Progress...');

shiftX(1)     = 0;
shiftY(1)     = 0;

for i = 1:handles.stackSize   

    waitbar(i/handles.stackSize,h_MIP);
    
    rTemp = bfopen(D1{i});
    zSize = size(rTemp{1,1},1);
    
    for z = 1:zSize       
        Icube(:,:,z) = rTemp{1,1}{z,1};
    end
    
    if i == 1
        icubeOne = Icube;
        save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('raw_%d.mat',i)),'Icube');
    end
    
    if i > 1
        [Icube, shiftY(i), shiftX(i)] = registerAndCrop(Icube,icubeOne);
        save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('raw_%d.mat',i)),'Icube');
    end
end

shiftVec = [shiftY; shiftX];

save(fullfile(handles.foldername,'3DStacks','Registered','shift.mat'),'shiftVec');

maxx = max(shiftX);
minx = min(shiftX);
maxy = max(shiftY);
miny = min(shiftY);

for i = 1:handles.stackSize
     load(fullfile(handles.foldername,'3DStacks','Registered',sprintf('raw_%d.mat', i)));
     
     IcubeCropped  = padarray(cropAfterCircularShift3D(Icube,maxx,maxy,minx,miny),[handles.padValue,handles.padValue],round(median(Icube(:))/2),'both');
     
     save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('reg_%d.mat',i)),'IcubeCropped');
     
     [MIPimage, Zimage, SUMimage] = calculateMIP(IcubeCropped);
     
     MIPimage     = uint8(double(MIPimage) / ((2^bitdepth)-1) * 255); % BitDepth Adaptation nbits to 8bits
     ZimageMapped = uint8(double(Zimage)/size(Icube,3)*255);
     
     % Save MIP, Z and SUM images
     imwrite(MIPimage    , fullfile(handles.MIPfoldername,sprintf('MIP_%d.png',i)));
     imwrite(ZimageMapped, fullfile(handles.MIPfoldername,sprintf('Zmax_%d.png',i))); 
     
     save(fullfile(handles.MIPfoldername,sprintf('Z_%d.mat',i)),'Zimage');
     save(fullfile(handles.MIPfoldername,sprintf('SUM_%d.mat',i)),'SUMimage');
     
     if i == 1
         averageMIP = uint8(zeros(size(MIPimage)));
     end
     
     averageMIP = averageMIP + MIPimage/handles.stackSize;
end

imwrite(averageMIP, fullfile(handles.MIPfoldername,'MIP_average.png'));

delete(h_MIP); 

firstTimePoint = max(icubeOne,[],3);

axes(handles.axes1);
imshow(firstTimePoint, []);
  
handles.firstMIP = firstTimePoint;
set(handles.statusWin,'String',sprintf('MIP Completed'));
 
handles.timePoint         = 1;
handles.Flags.importStack = 1;

% handles = statusUpdate(handles, hObject);
set(handles.dataLoadText, 'BackgroundColor', 'green');
guidata(hObject, handles);

% --------------------------------------------------------------------
function importStack_Callback(hObject, eventdata, handles)
% hObject    handle to importStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
set(handles.statusWin,'String',sprintf(...
    'Select folders to be analyzed.\n Each folder should contain z-Stacks fot 1 time point. \n The software will load all images folder by folder and display 2D projected image of the first time point.\nImage files should be in tif format.'));
 
% Chose Directories to be analyzed
D1                    = uipickfiles; % uipickfiles written by Douglas M. Schwarz
handles.stackSize     = length(D1);
handles.pathRawStacks = D1;
 
set(handles.statusWin,'String',sprintf(...
    'Set the folder name to save results.\n If you do not specify a certain folder, program is going to create a Results folder with current date and time.'));
 
% Results folder Name selection
prompt      = {'Enter the directory name to save results or leave blank :'};
name        = 'Directory Name';
numlines    = 1;
defaultSize = {''};
folderName  = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
 
if isempty(folderName)
    if ismac
        s = regexp(D1{1}, '/', 'split');
        folderName = fullfile('/',s{1:end-1},sprintf('%s%s','results',datestr(now,30))); % Date Format (ISO 8601)  'yyyymmddTHHMMSS'
    else
        s = regexp(D1{1}, '\', 'split');
        folderName = fullfile(s{1:end-1},sprintf('%s%s','results',datestr(now,30))); % Date Format (ISO 8601)  'yyyymmddTHHMMSS'
    end
else
    [status, msg, msgId] = mkdir(folderName);
    while(~isempty(msg))
        prompt = {'Folder exists. Enter a new folder name'};
        folderName = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
        [status, msg, msgId] = mkdir(folderName);
    end
end
 
handles.Flags.setResultsFolder = 1;
set(handles.edit8,'String',sprintf('%s',folderName));
 
% Create Folders into the Results Folder
mkdir(folderName,'MIP');
mkdir(folderName,'3DStacks');
mkdir(fullfile(folderName,'3DStacks'),'Raw');
mkdir(fullfile(folderName,'3DStacks'),'Registered');
mkdir(fullfile(folderName,'3DStacks'),'Cropped');
 
mkdir(folderName,'Segmentation');
mkdir(fullfile(folderName,'Segmentation'),'Manual');
mkdir(fullfile(folderName,'Segmentation'),'Automatic');
 
mkdir(folderName,'Volumes');
mkdir(fullfile(folderName,'Volumes'),'Intensity');
mkdir(fullfile(folderName,'Volumes','Intensity'),'Manual');
mkdir(fullfile(folderName,'Volumes','Intensity'),'Automatic');
mkdir(fullfile(folderName,'Volumes'),'FWHM');
mkdir(fullfile(folderName,'Volumes','FWHM'),'Manual');
mkdir(fullfile(folderName,'Volumes','FWHM'),'Automatic');

mkdir(folderName,'Neck');
handles.foldername    = folderName;
handles.MIPfoldername = fullfile(folderName,'MIP');
handles.Segfoldername = fullfile(folderName,'Segmentation');
handles.volumesFolder = fullfile(folderName,'Volumes');
handles.ThreeDfolder  = fullfile(folderName,'3DStacks','Raw');
handles.neckFolder    = fullfile(folderName,'Neck');

handles.stackSize     = length(D1);
 
stackSize             = size(D1,2);
handles.stackSize     = stackSize;
 
% Load default BitDepth Value
bitdepth              = str2double(get(handles.bitDepth,'String'));
h_MIP                 = waitbar(0, 'Maximum Intensity Projection and Registration in Progress...');

shiftX(1) = 0;
shiftY(1) = 0;

for i = 1:handles.stackSize

    waitbar(i/handles.stackSize,h_MIP);
    
    % Read tif image series and write in raw folder
    Icube = importRawStack(handles.pathRawStacks{i}, handles, hObject, i);
    
    if i == 1
        icubeOne = Icube;
        save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('raw_%d.mat',i)),'Icube');
    end
    
    if i > 1
        [Icube,shiftY(i),shiftX(i)] = registerAndCrop(Icube,icubeOne);
        save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('raw_%d.mat',i)),'Icube');
    end
end

shiftVec = [shiftY;shiftX];

save(fullfile(handles.foldername,'3DStacks','Registered','shift.mat'),'shiftVec');

maxx = max(shiftX);
minx = min(shiftX);
maxy = max(shiftY);
miny = min(shiftY);

for i = 1:handles.stackSize
     load(fullfile(handles.foldername,'3DStacks','Registered',sprintf('raw_%d.mat', i)));
     IcubeCropped  = padarray(cropAfterCircularShift3D(Icube,maxx,maxy,minx,miny),[handles.padValue,handles.padValue],round(median(Icube(:))/2),'both');
     save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('reg_%d.mat',i)),'IcubeCropped');
     
     [MIPimage, Zimage, SUMimage] = calculateMIP(IcubeCropped);
     
     MIPimage     = uint8(double(MIPimage) / ((2^bitdepth)-1) * 255); % BitDepth Adaptation nbits to 8bits
     ZimageMapped = uint8(double(Zimage)/size(Icube,3)*255);
     
     % Save MIP, Z and SUM images
     imwrite(MIPimage, fullfile(handles.MIPfoldername,sprintf('MIP_%d.png',i)));
     imwrite(ZimageMapped, fullfile(handles.MIPfoldername,sprintf('Zmax_%d.png',i))); 
     
     save(fullfile(handles.MIPfoldername,sprintf('Z_%d.mat',i)),'Zimage');
     save(fullfile(handles.MIPfoldername,sprintf('SUM_%d.mat',i)),'SUMimage');
     
     if i == 1
         averageMIP = uint8(zeros(size(MIPimage)));
     end
     averageMIP = averageMIP + MIPimage/handles.stackSize;
end

imwrite(averageMIP, fullfile(handles.MIPfoldername,'MIP_average.png'));

delete(h_MIP); 

firstTimePoint = max(icubeOne,[],3);

axes(handles.axes1);
imshow(firstTimePoint, []);
  
handles.firstMIP = firstTimePoint;
set(handles.statusWin,'String',sprintf('MIP Completed'));
 
handles.timePoint         = 1;
handles.Flags.importStack = 1;

set(handles.statusWin,'String',sprintf('Dataset imported! Stack Size : %d',handles.stackSize));
set(handles.text10,'String',sprintf('numTimes:%d',handles.stackSize));

% handles = statusUpdate(handles, hObject); 
set(handles.dataLoadText, 'BackgroundColor', 'green');
guidata(hObject, handles);

% --------------------------------------------------------------------
function pointSelection_ClickedCallback(hObject, eventdata, handles)
 
% hObject    handle to pointSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folderName                = handles.MIPfoldername; 
handles.newSpineSelectFig = figure; 

imMIP                     = imread(fullfile(folderName,sprintf('%s%s','MIP_1','.png')));
handles.firstMIP          = imMIP;
        
imshow(handles.firstMIP,[]); set(gcf,'Position',get(0,'Screensize'));

starting_number = 1;

if handles.Flags.selectROI == 1
    hold on; plot(handles.x_pts,handles.y_pts,'r.');
    starting_number = size(handles.y_pts);
end
 
[x_pts, y_pts] = getpts_SpineS(handles.newSpineSelectFig);
handles.x_pts  = [handles.x_pts; x_pts];
handles.y_pts  = [handles.y_pts; y_pts];
 
close(handles.newSpineSelectFig);
 
cla reset

handles.annotationsfigure = figure;
imshow(handles.firstMIP,[]);

for ns = 1:size(handles.y_pts)
    x  = handles.x_pts(ns);
    y  = handles.y_pts(ns);
    text(x,y,sprintf('%s',num2str(ns)),'Color','red','FontSize',8);
    hold on;
end

saveas(handles.annotationsfigure, fullfile(handles.MIPfoldername,sprintf('spineLabels.png')), 'png');

close(gcf)
cla reset

axes(handles.axes1);
cla(handles.axes1);
imshow(handles.firstMIP,[]);
 
% Scale Spine ROI wrt Pixel sizes
xyS         = get(handles.xyPixelSize, 'string');
xPixelSize  = str2double(xyS);
rectSize    = ceil(5/xPixelSize); % Default Rect size = 5um 
% Change this value to make the spine window size 
 
for timeCount = 1:handles.stackSize
    
    if handles.Flags.selectROI == 0
        firstSpineNumber = 1;
    else
        firstSpineNumber = handles.spineCounter + 1;    
    end
    
    lastSpineNumber = length(handles.x_pts);
 
    for sp_x = firstSpineNumber:lastSpineNumber
        
        % Get position of rectangular area
        % Recursive Function to Find ROI window size: rectSizeFind, if
        % Spine at the edges
        
        newRectSize = rectSizeFind(handles.x_pts(sp_x),handles.y_pts(sp_x),...
            size(handles.firstMIP,1),size(handles.firstMIP,2),rectSize);
 
        p1 = handles.x_pts(sp_x) - floor(newRectSize/2);
        p2 = handles.y_pts(sp_x) - floor(newRectSize/2);
 
        xMin    = floor(p1);
        yMin    = floor(p2);
        width   = floor(newRectSize);
        height  = floor(newRectSize);
 
        handles.xMinTemp    = xMin;
        handles.yMinTemp    = yMin;
        handles.heightTemp  = height;
        handles.widthTemp   = width;
 
        imMIP = imread(fullfile(folderName,sprintf('%s%d%s','MIP_',timeCount,'.png')));
        im3D  = load(fullfile(handles.foldername,'3DStacks','Registered',sprintf('reg_%d.mat',timeCount)));
        
        if timeCount == 1
            handles.firstMIP = imMIP;
        end
        
        handles.imroi = imMIP(yMin:(yMin+height),xMin:(xMin+width));
 
        handles.spinePositions(sp_x,timeCount).angle  = handles.angle;
        handles.spinePositions(sp_x,timeCount).xMin   = handles.xMinTemp;
        handles.spinePositions(sp_x,timeCount).yMin   = handles.yMinTemp;
        handles.spinePositions(sp_x,timeCount).height = handles.heightTemp;
        handles.spinePositions(sp_x,timeCount).width  = handles.widthTemp;
 
        handles.ROIlist{sp_x,timeCount}   = handles.imroi;
        handles.ROIlist3D{sp_x,timeCount} = double(im3D.IcubeCropped(yMin:(yMin+height),xMin:(xMin+width),:));
        
        if timeCount == 1
 
            list = get(handles.listbox3,'String');
 
            if sp_x < 10
                set(handles.listbox3,'String',[list; sprintf('spine 0%d', sp_x)]);
            else
                set(handles.listbox3,'String',[list; sprintf('spine %d', sp_x)]);
            end
   
            handles.Flags.addSpine   = 1;
            handles.Flags.rectSelect = 0;
            handles.Flags.selectROI  = 0;
 
            set(handles.text10,'String',sprintf('numTimes:%d, \n numSpines:%d',handles.stackSize,sp_x));
        end  
    end
end
 
axes(handles.axes2);
imshow(handles.imroi,[]);      
 
axes(handles.axes1);
cla(handles.axes1)
imshow(handles.firstMIP,[]);
            
handles.angle           = 0; % Reset angle to zero
handles.Flags.selectROI = 1;
handles.spineCounter    = sp_x;
 
% handles = statusUpdate(handles, hObject); 
set(handles.spineSelectText, 'BackgroundColor', 'green');
guidata(hObject, handles);
 
function medianFilter_Callback(hObject, eventdata, handles)
% hObject    handle to medianFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
if (handles.Flags.selectROI ~= 1)
    warndlg('Select Spines First')
else
    prompt      = {'Enter the median filter size :'};
    name        = 'Filter Size';
    numlines    = 1;
    defaultSize = {'9'};
    
    handles.filterSize = str2num(cell2mat(inputdlg(prompt,name,numlines,defaultSize)));
    
    h_MIP         = waitbar(0, 'Median Filtering and Dendrite Extraction is in Progress...');
    
    % Call from the directory Saved
    for k = 1:handles.stackSize
        
        waitbar(k/handles.stackSize,h_MIP);

        fileName3D      = fullfile(handles.foldername,'3DStacks','Registered',sprintf('%s%d%s','reg_',k,'.mat'));
        Icube3D         = load(fileName3D);
        Icube           = Icube3D.IcubeCropped;        
        fileName        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','MIP_',k,'.png'));
        fileNameZ       = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','Z_',k,'.mat'));
        
        im              = imread(fileName);
        Zimage          = load(fileNameZ);   
        imFilt          = medfilt2(im,[handles.filterSize handles.filterSize]);
        
        imwrite(imFilt, fullfile(handles.MIPfoldername,sprintf('MIP_filtered_%d.png',k)));
        
        smoothingParam  = 15;
        
        xyS             = get(handles.xyPixelSize, 'string');
        xPixelSize      = str2double(xyS);
        rectSize        = ceil(5/xPixelSize);
      
        [new_dend,meanSL,D,dendSkel] = robustDendriteBoundary(Icube,...
            imFilt, Zimage, double(handles.CropMask),handles.padValue,smoothingParam,handles.filterSize,xPixelSize);
        
        location    = handles.MIPfoldername;
          
        % Adding this
        % makes it nicer but now always work
        ac_val      = round(10*(0.0193/xPixelSize)); 
        
        if ac_val == 0
            ac_val = 1;
        end
        
        new_dend2   = activecontour(double(im),new_dend,ac_val  ,'Chan-Vese','ContractionBias',.3,'SmoothFactor',2.5); 
        new_dend3   = activecontour(double(im),new_dend,ac_val*5,'Chan-Vese','ContractionBias',.3,'SmoothFactor',2.5); 
        
        sd1         = double(sum(new_dend(:)));
        sd2         = double(sum(new_dend2(:)));
        sd3         = double(sum(new_dend3(:)));
        
        if sd3 > sd1/2
            new_dend = new_dend2 & new_dend3;
        end  

        imwrite(new_dend, fullfile(handles.MIPfoldername,sprintf('segmentedDendrite_%d.png',k)));
        imwrite(dendSkel, fullfile(handles.MIPfoldername,sprintf('segmentedDendriteSkel_%d.png',k)));
        
        imwrite(new_dend, fullfile(handles.MIPfoldername,sprintf('segmentedDendrite_%d_Original.png',k)));
        imwrite(dendSkel, fullfile(handles.MIPfoldername,sprintf('segmentedDendriteSkel_%d_Original.png',k)));
                
        dendPiece{k}            = new_dend;    
        skelPiece{k}            = dendSkel;
        skelmeanSL{k}           = meanSL;
        new_dend                = double(new_dend);
        new_dend(new_dend==0)   = nan;

        tempVal                 = new_dend.*double(squeeze(im));
        tempValAll              = tempVal(:);

        dendMeanVal(k)          = nanmean(tempValAll);
        dendMaxVal(k)           = nanmax(tempValAll);
        dendNormVal(k)          = nanmedian(tempValAll);
        dendMinVal(k)           = nanmin(tempValAll);
    
        handles.ROIdend{k}      = new_dend; %imread(fullfile(folderName,sprintf('%s%d%s','segmentedDendrite_',k,'.png')));  
        handles.skelmeanSL      = skelmeanSL;
    end
    
    folderName = handles.MIPfoldername;

    for timeCount = 1:handles.stackSize

        imFiltered = imread(fullfile(folderName,...
            sprintf('%s%d%s','MIP_filtered_',timeCount,'.png')));

        handles.ROIdend{timeCount} = imread(fullfile(folderName,...
            sprintf('%s%d%s','segmentedDendrite_',timeCount,'.png')));

        if timeCount == 1
            handles.firstMIP = imFiltered;
        end

        for sp_x = 1:handles.spineCounter
            xMinTemp   = handles.spinePositions(sp_x,timeCount).xMin;
            yMinTemp   = handles.spinePositions(sp_x,timeCount).yMin;
            heightTemp = handles.spinePositions(sp_x,timeCount).height;
            widthTemp  = handles.spinePositions(sp_x,timeCount).width;

            imroi      = imFiltered(yMinTemp:(yMinTemp+heightTemp),xMinTemp:(xMinTemp+widthTemp));
            dendroi    = dendPiece{timeCount}(yMinTemp:(yMinTemp+heightTemp),xMinTemp:(xMinTemp+widthTemp));
            skelroi    = skelPiece{timeCount}(yMinTemp:(yMinTemp+heightTemp),xMinTemp:(xMinTemp+widthTemp));

            handles.ROIlist{sp_x,timeCount} = imroi;
            handles.dendROIlist{sp_x,timeCount} = dendroi;
            handles.skelROIlist{sp_x,timeCount} = skelroi;
        end
    end

delete(h_MIP); 

handles.dendNormVal = dendNormVal;
handles.dendMinVal  = dendMinVal;
handles.dendMaxVal  = dendMaxVal;
handles.dendMeanVal = dendMeanVal;

save(fullfile(handles.foldername,'Volumes','dendNormVal.mat'),'dendNormVal');
save(fullfile(handles.foldername,'Volumes','dendMinVal.mat') ,'dendMinVal');
save(fullfile(handles.foldername,'Volumes','dendMaxVal.mat') ,'dendMaxVal');
save(fullfile(handles.foldername,'Volumes','dendMeanVal.mat'),'dendMeanVal');

handles.Flags.medianFilter = 1;

% handles = statusUpdate(handles, hObject);
set(handles.filteredText, 'BackgroundColor', 'green');
guidata(hObject, handles);
end

% --- Executes on slider movement.
function rotateSpine_Callback(hObject, eventdata, handles)
% hObject    handle to rotateSpine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 
angle = get(hObject,'Value');
 
if handles.Flags.autoSegmented == 1
    sp = get(handles.listbox3,'Value');     % Spine Number
    tp = handles.timePoint;
    
    clear handles.axes2 % Time Point
    hold off;
    axes(handles.axes2);
    img         = imread(fullfile(handles.foldername,'Segmentation','Automatic',sprintf('spine%d',sp),sprintf('ROI_%d.png',tp)));
    rotated_roi = imrotate(img,angle);
else
    axes(handles.axes2);
    img = handles.imroi;
    rotated_roi = imrotate(img,angle);
end
 
axes(handles.axes2);
imshow(rotated_roi, []);
handles.angle = angle;
 
handles.Flags.setSpineAngle = 1;

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --- Executes on button press in updateAngle.
function updateAngle_Callback(hObject, eventdata, handles)
% hObject    handle to updateAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% if handles.Flags.autoSegmented == 0
%     warndlg('This button is only valid when spine stacks imported');
% else
 
angle         = handles.angle;                    % Read Angle Information
spnum         = get(handles.listbox3,'Value');    % Spine Number
tp            = handles.timePoint;                % Time Point
 
handles.imroi = handles.ROIlist{spnum,tp};
img           = handles.imroi;
rotated_roi   = imrotate(img,angle);

for tu = tp:handles.stackSize
    handles.spinePositions(spnum,tu).angle = angle;
end
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% end
 
% --- Executes on button press in deleteSpine.
function deleteSpine_Callback(hObject, eventdata, handles)
% hObject    handle to deleteSpine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
set(handles.text10,'String',sprintf('numTimes:%d',handles.stackSize));
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3

angle   = handles.angle;                    % Read Angle Information
sn      = get(handles.listbox3,'Value');    % Spine Number
tp      = handles.timePoint;                % Time Point

if handles.Flags.autoSegmented == 1
    
    imName                  = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_roi_k_10_',tp,'.png'));
    img                     = imread(imName);
    
    imName_Full             = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_k_10_',tp,'.png'));
    img_Full                = imread(imName_Full);
 
    imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
    img_Full_dend           = imread(imName_Full_dend);

    rotated_roi             = imrotate(img,handles.spinePositions(sn,tp).angle);
 
    cla(handles.axes2,'reset');

    axes(handles.axes2);
    imshow(rotated_roi,[]);
 
    img_Full_dend           = bwperim(img_Full_dend);
    
    axes(handles.axes1);
    C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(img_Full_dend),'blend','Scaling','joint');
    imshow(C,[]);

    if handles.Flags.autoNeckLegth == 1
        try 
            compositeImage = combineROIandNeck(img,handles.neckPath{sn,tp},handles.justNeck3D{sn,tp});
            rotated_roi    = imrotate(compositeImage,handles.spinePositions(sn,tp).angle);

            axes(handles.axes2);
            imshow(rotated_roi,[]);
        catch
            rotated_roi = imrotate(img,handles.spinePositions(sn,tp).angle);
            axes(handles.axes2);
            imshow(rotated_roi,[]);
        end
    end
end

set(handles.testTime,'String',tp);

try
    updateSpineProperties(handles,sn,tp);
catch
end

%% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function segmentationRegistrationSIFT_Callback(hObject, eventdata, handles)
% hObject    handle to segmentationRegistrationSIFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
if(handles.spineCounter < 1)
    warndlg('Select Spines First');
elseif (handles.Flags.medianFilter == 0)
        warndlg('Run Pre-Processing First');
else
        errSpines  = 0;
        folderName = handles.MIPfoldername;
        imageFixed = imread(fullfile(folderName,'MIP_filtered_1.png'));

        for i = 1:handles.spineCounter

            mkdir(fullfile(handles.Segfoldername,'Automatic'), sprintf('spine%d', i));
            [segmentedROI,segmentedROI_2, segmentedROI_3, Ix,Iy] = imsegmWaterShed(handles.ROIlist{i}, handles.skelROIlist{i,1}, handles.dendROIlist{i,1});
 
            spineHead = detectDendriteSpine(segmentedROI);

            if Ix < 200
                spineHead = imresize(spineHead,[Ix Iy],'nearest');
            end

            xyS         = get(handles.xyPixelSize, 'string');
            xPixelSize  = str2double(xyS);

            stats = graphBased(handles.ROIlist{i,1}, spineHead, 10, imageFixed, handles.spinePositions(i,1).xMin, ...
                handles.spinePositions(i,1).yMin, handles.spinePositions(i,1).height,...
                handles.spinePositions(i,1).width,fullfile(handles.Segfoldername,...
                'Automatic'), i, 1, handles.spinePositions(i).angle, handles.dendROIlist{i,1}, xPixelSize);

            imRoi{i} = zeros(size(imageFixed));
            
            imRoi{i}(handles.spinePositions(i,1).yMin:(handles.spinePositions(i,1).yMin...
                + handles.spinePositions(i,1).height),...
                handles.spinePositions(i,1).xMin:(handles.spinePositions(i,1).xMin...
                + handles.spinePositions(i,1).width)) = 255;

            imRoi{i} = imbinarize(imRoi{i}, graythresh(imRoi{i}));
        end

        segCounter = 1;
        tic

        if handles.stackSize == 1

            imageFixed        = imread(fullfile(folderName,'MIP_filtered_1.png'));
            imageMoving       = imageFixed;
            handles.dendPiece = imread(fullfile(folderName,'segmentedDendrite_1.png'));
            
            [handles.ROIlist(:,1) imRoi roiCoords] =...
                registrationSIFTbased(imageFixed, imageMoving, imRoi, handles.ROIlist(:,1), handles.spineCounter,handles.dendPiece);

            for j = 1:handles.spineCounter
                handles.spinePositions(j,1).xMin   = roiCoords{j}(1);
                handles.spinePositions(j,1).yMin   = roiCoords{j}(2);
                handles.spinePositions(j,1).height = roiCoords{j}(3);
                handles.spinePositions(j,1).width  = roiCoords{j}(4);

                xMin(j)    = roiCoords{j}(1);
                yMin(j)    = roiCoords{j}(2);
                height(j)  = roiCoords{j}(3);
                width(j)   = roiCoords{j}(4);
                roiList{j} = handles.ROIlist{j,1};

                if isempty(handles.spinePositions(j,1).angle)
                    angle(j) = 0;
                else
                    angle(j) = handles.spinePositions(j,1).angle;
                end

                segFolderName = handles.Segfoldername;
            end

            roiDend{j} = handles.ROIdend{1};

            for j = 1:handles.spineCounter %parfor to for

                [segmentedROI,segmentedROI_2, segmentedROI_3, Ix,Iy] = imsegmWaterShed(roiList{1,j}, handles.skelROIlist{j,1}, handles.dendROIlist{j,1});
                
                spineHead = detectDendriteSpine(segmentedROI);
           
                if Ix < 200
                    spineHead = imresize(spineHead,[Ix Iy],'nearest');
                end

                try % I added this because of empty image problem, Ali - May, 2014.
                    xyS         = get(handles.xyPixelSize, 'string');
                    xPixelSize  = str2double(xyS);
                    
                    stats = graphBased(roiList{1,j}, spineHead, 10, imageFixed, ...
                        xMin(j), yMin(j), height(j), width(j),...
                        fullfile(segFolderName,'Automatic'), j, 1, angle(j), handles.dendROIlist{j,i}, xPixelSize);
                catch turtle
                        errSpines(1,j) = 1;
                end
                segCounter = segCounter + 1;
            end
            set(handles.statusWin,'String',sprintf('Segmentation ENDED!'));
        else
            
            h_MIP = waitbar(0, 'Spine Segmentation is in Progress...');

            for i = 1:handles.stackSize

                waitbar(i/handles.stackSize,h_MIP);

                imageFixed        = imread(fullfile(folderName,sprintf('MIP_filtered_%d.png',i)));
                imageMoving       = imread(fullfile(folderName,'MIP_filtered_1.png'));
                handles.dendPiece = imread(fullfile(folderName,sprintf('segmentedDendrite_%d.png',i)));
                
                [handles.ROIlist(:,i) imRoi roiCoords] =...
                    registrationSIFTbased(imageFixed, imageMoving, imRoi, handles.ROIlist(:,1), handles.spineCounter,handles.dendPiece);

                for j = 1:handles.spineCounter
                    handles.spinePositions(j,i).xMin = roiCoords{j}(1);
                    handles.spinePositions(j,i).yMin = roiCoords{j}(2);
                    handles.spinePositions(j,i).height = roiCoords{j}(3);
                    handles.spinePositions(j,i).width = roiCoords{j}(4);

                    xMin(j)         = roiCoords{j}(1);
                    yMin(j)         = roiCoords{j}(2);
                    height(j)       = roiCoords{j}(3);
                    width(j)        = roiCoords{j}(4);
                    roiList{j}      = handles.ROIlist{j,i};
                    angle(j)        = handles.spinePositions(j,i).angle;
                    segFolderName   = handles.Segfoldername;
                end
                
                for j = 1:handles.spineCounter %parfor to for
                    
                    [segmentedROI,segmentedROI_2, segmentedROI_3, Ix,Iy] = imsegmWaterShed(roiList{1,j}, handles.skelROIlist{j,i}, handles.dendROIlist{j,i});

                    spineHead = detectDendriteSpine(segmentedROI);
                  
                    if Ix < 200
                        spineHead = imresize(spineHead,[Ix Iy],'nearest');
                    end

                    try % I added this because of empty image problem, Ali - May, 2014.
                        xyS         = get(handles.xyPixelSize, 'string');
                        xPixelSize  = str2double(xyS);
                        
                        stats = graphBased(roiList{1,j}, spineHead, 10, imageFixed, ...
                            xMin(j), yMin(j),...
                            height(j), width(j),...
                            fullfile(segFolderName,'Automatic'), j, i, angle(j), handles.dendROIlist{j,i}, xPixelSize);                        
                    catch turtle
                            errSpines(i,j) = 1;
                            set(handles.statusWin,'String',sprintf('Error in Spine #%d',j));
                    end
                    segCounter = segCounter + 1;
                end

                if i < handles.stackSize
                    set(handles.statusWin,'String',sprintf('Last Segmented, Time Point : %d; Spine Number : %d',i,j));
                else
                    set(handles.statusWin,'String',sprintf('Segmentation ENDED!'));
                end
            end
        end

        toc
        % Error Check - handles.errSpines is an input dor
        % computeVolumeWithCurveFitting function
        if sum(sum(errSpines)) == 0
            handles.errSpines = nan;
        else
            handles.errSpines = errSpines;
        end
end

delete(h_MIP);

handles.Flags.segRegSIFT    = 1;
handles.Flags.autoSegmented = 1;
handles.stats               = stats;

set(handles.segmentedText, 'BackgroundColor', 'green');

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
         
% --------------------------------------------------------------------
function intensityVolumeCalculation_Callback(hObject, eventdata, handles)
% hObject    handle to intensityVolumeCalculation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Flags.autoSegmented == 0
    warndlg('Perform Segmentation First');
elseif handles.Flags.times == 0
    warndlg('Set Times Points First');
elseif handles.Flags.excludeSpines == 0
    warndlg('Run Exclude Spines Script');
else
    computeVolumeWithCurveFitting(handles.foldername, handles.stackSize, handles.spineCounter,handles.spinePositions,handles.dendNormVal)

    load(fullfile(handles.foldername,'Volumes','Intensity','Automatic','auto_IntensityVolumes.mat'));
    load(fullfile(handles.foldername,'Volumes','Intensity','Automatic','auto_IntensityVolumes_MIP.mat'));
    load(fullfile(handles.foldername,'Volumes','nanPositionsFull.mat'));        
    load(fullfile(handles.foldername,'Volumes','times.mat'));

    auto_IntensityVolumes       = auto_IntensityVolumes.*nanPositionsFull;
    auto_MIPSpineVolumes        = auto_IntensityVolumes_MIP.*nanPositionsFull;

    auto_normIntensityVolumes   = auto_IntensityVolumes./repmat(nanmean(auto_IntensityVolumes(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
    auto_normMIPSpineVolumes    = auto_MIPSpineVolumes./repmat(nanmean(auto_MIPSpineVolumes(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);

    save(fullfile(handles.foldername,'Volumes','Intensity','Automatic','auto_normIntensityVolumes.mat'),'auto_normIntensityVolumes');
    save(fullfile(handles.foldername,'Volumes','Intensity','Automatic','auto_normMIPSpineVolumes.mat'),'auto_normMIPSpineVolumes');

    figure,      
    tms          = times.images-times.stimulus;
    meanControls = nanmean(auto_normIntensityVolumes,1);
    stdControls  = nanstd(auto_normIntensityVolumes,1)./sqrt(repmat(size(auto_normIntensityVolumes,1),1,size(auto_normIntensityVolumes,2))-sum(isnan(auto_normIntensityVolumes)));
    
    errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
    title('Integrated Flor. Intensity (Norm to Baseline after norm to dend');
    ylabel('Norm. Volume'); xlabel('Time'); set(gca,'FontSize',12);
    saveas(gcf, fullfile(handles.foldername,'Volumes','Integ_Flor_Intensity_Norm.eps'), 'epsc');
    close(gcf);
    
    figure,      
    tms          = times.images-times.stimulus;
    plot(tms,auto_normMIPSpineVolumes'.*nanPositionsFull','LineWidth',1,'Color','k');
    title('All Spines'); ylabel('Norm. Volume'); xlabel('Time'); set(gca,'FontSize',16);
    saveas(gcf, fullfile(handles.foldername,'Volumes','All_Spines_Integ_Flor_Intensity_Norm.eps'), 'epsc');
    close(gcf);
    
    figure,      
    tms          = times.images-times.stimulus;
    meanControls = nanmean(auto_normMIPSpineVolumes,1);
    stdControls  = nanstd(auto_normMIPSpineVolumes,1)./sqrt(repmat(size(auto_normMIPSpineVolumes,1),1,size(auto_normMIPSpineVolumes,2))-sum(isnan(auto_normMIPSpineVolumes)));
    
    errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
    title('MIP Integrated Flor. Intensity (Norm to Baseline after norm to dend');
    ylabel('Norm. Volume'); xlabel('Time'); set(gca,'FontSize',12);
    saveas(gcf, fullfile(handles.foldername,'Volumes','MIP_Flor_Intensity_Norm.eps'), 'epsc');
    close(gcf);
    
    filePathSegmentations = fullfile(handles.foldername,'Segmentation','Automatic');

    figure; 
    for tp = 1:handles.stackSize
        spineHead = [];
        rgb_im    = [];
        for sp = 1:handles.spineCounter
            temp = imread(fullfile(filePathSegmentations,sprintf('spine%d',sp),sprintf('binary_k_%d_%d.png', 10, tp)));
            if isnan(nanPositionsFull(sp,tp))
                spineHead(:,:,sp) = zeros(size(temp));
            else
                spineHead(:,:,sp) = temp;
            end
        end
        dend_temp  = imread(fullfile(handles.foldername,'MIP',sprintf('segmentedDendrite_%d.png',tp)));
        all_spines = max(spineHead,[],3);
        
        rgb_im(:,:,1) = all_spines;
        rgb_im(:,:,2) = 0;
        rgb_im(:,:,3) = dend_temp;
        
        h = imshow(rgb_im,[]);
        saveas(h, fullfile(handles.foldername,sprintf('%s_%d%s','Segmented_Spines_All',tp,'.eps')), 'epsc');
    end
    close(gcf);


    
    cd(handles.workingDir);
    handles.Flags.autoIntensity = 1;

    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end
 
% --------------------------------------------------------------------
function showSegmentations_Callback(hObject, eventdata, handles)
% hObject    handle to showSegmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
prompt          = {'Enter the k value: [1 to 10]'};
name            = 'k = ';
numlines        = 1;
defaultValue    = {'10'};
 
k = str2double(cell2mat(inputdlg(prompt,name,numlines,defaultValue)));
 
numSpine = handles.spineCounter;
numTime  = handles.stackSize;
 
fileFolder = fullfile(handles.Segfoldername,'Automatic');
 
rot    = 'Rotated';
t      = 1;
factor = 100;
 
imBig = zeros(numSpine*factor,numTime*factor);
 
for i = 1:numSpine
    dirNameprefix = sprintf('%s%d','spine',i);
    
    for j = 1:numTime
        
        filenameprefix =  sprintf('%s%d%s%d%s','border_roi_k_',k,'_',j,'.png');
        
        fileNames{t} = fullfile(fileFolder,dirNameprefix,filenameprefix);
        im = imread(fileNames{t});
        newim = imresize(im, [factor factor]);
        
        imBig((100*i-100)+1:100*i,(100*j-100)+1:100*j) = newim;
        
        t = t + 1;
    end
end
 
spMul = mod(numSpine,4);
spExt = rem(numSpine,4);
 
timeMul = mod(numTime,6);
timeExt = rem(numTime,6);
 
extLoopSpine = 0;
if spExt>0
    extLoopSpine = 1;
end
 
extLoopTime = 0;
if timeExt>0
    extLoopTime = 1;
end
 
bigHandle = figure;
set(bigHandle, 'Units', 'Normalized'); % First change to normalized units.
set(bigHandle, 'OuterPosition', [.1, .1, .85, .85]); % [xLeft, yBottom, width, height]

nanPositions = ones(numSpine,numTime);
x_total = [];
y_total = [];
 
for spx = 1:(floor(numSpine/4)+extLoopSpine)
    
    rangeSp = ((spx-1)*400+1):spx*400;
    %     [rangeSp(1) rangeSp(end)]
    if spx > (floor(numSpine/4))
        rangeSp = ((spx-1)*400+1):(((spx-1)*400)+spExt*100)
        %     [rangeSp(1) rangeSp(end)]
    end
    
    for tpx = 1:(floor(numTime/6)+extLoopTime)
        
        rangeTp = ((tpx-1)*600+1):tpx*600;
        %    [rangeTp(1) rangeTp(end)]
        
        if tpx > (floor(numTime/6))
            rangeTp = ((tpx-1)*600+1):(((tpx-1)*600)+timeExt*100)
            %       [rangeTp(1) rangeTp(end)]
        end
        
        imshow(imBig(rangeSp,rangeTp),[]);
        
        set(bigHandle, 'Units', 'Normalized'); % First change to normalized units.
        set(bigHandle, 'OuterPosition', [.1, .1, .85, .85]); % [xLeft, yBottom, width, height]

        title(sprintf('%s%d','Segmentation Results for parameter k = ',k),'FontSize',16,'interpreter','latex');
        %ylabel('Spines','FontSize',20,'interpreter','latex');
        %xlabel('Time','FontSize',20,'interpreter','latex');
        
        time_len_for_text = (rangeTp(end)-rangeTp(1)+1)/100;
        spine_len_for_text = (rangeSp(end)-rangeSp(1)+1)/100;
        
        switch time_len_for_text
            case 1
                text('units','pixels','position',[18 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
            case 2
                text('units','pixels','position',[18 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[118 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
            case 3
                text('units','pixels','position',[18 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[118 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
                text('units','pixels','position',[218 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+3))
            case 4
                text('units','pixels','position',[18 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[118 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
                text('units','pixels','position',[218 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+3))
                text('units','pixels','position',[318 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+4))
            case 5
                text('units','pixels','position',[18 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[118 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
                text('units','pixels','position',[218 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+3))
                text('units','pixels','position',[318 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+4))
                text('units','pixels','position',[418 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+5))
            case 6
                text('units','pixels','position',[18 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[118 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
                text('units','pixels','position',[218 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+3))
                text('units','pixels','position',[318 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+4))
                text('units','pixels','position',[418 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+5))
                text('units','pixels','position',[518 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+6))
        end
        
        
        switch spine_len_for_text
            case 1
                text('units','pixels','position',[-50 50],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+1))
            case 2
                text('units','pixels','position',[-50 150],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+1))
                text('units','pixels','position',[-50 50],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+2))
            case 3
                text('units','pixels','position',[-50 250],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+1))
                text('units','pixels','position',[-50 150],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+2))
                text('units','pixels','position',[-50 50],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+3))
            case 4
                text('units','pixels','position',[-50 350],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+1))
                text('units','pixels','position',[-50 250],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+2))
                text('units','pixels','position',[-50 150],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+3))
                text('units','pixels','position',[-50 50],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+4))
        end
        
        [y, x] = getpts(bigHandle);
        
        y_inds = ceil(y/factor);
        x_inds = ceil(x/factor);
        
        for nanCount = 1:length(y_inds)
            nanPositions(x_inds(nanCount)+(4*spx-4),y_inds(nanCount)+(6*tpx-6)) = nan;
        end
        
        clf(bigHandle,'reset');
        
        x_total = [x_total (x+(spx-1)*4*factor)']
        y_total = [y_total (y+(tpx-1)*6*factor)']
    end
end

close(bigHandle);

handles = correctBadSegmentations(hObject,handles,y_total',x_total',factor,k);
% handles = statusUpdate(handles, hObject); 

guidata(hObject, handles);


% % --------------------------------------------------------------------
function excludeSpines_Callback(hObject, eventdata, handles)
% hObject    handle to excludeSpines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
prompt       = {'Enter the k value: [1 to 10]'};
name         = 'k = ';
numlines     = 1;
defaultValue = {'10'};
k            = str2double(cell2mat(inputdlg(prompt,name,numlines,defaultValue)));

numSpine     = handles.spineCounter;
numTime      = handles.stackSize;
 
fileFolder   = fullfile(handles.Segfoldername,'Automatic');
 
rot          = 'Rotated';
t            = 1;
factor       = 300;
 
imBig        = zeros(numSpine*factor,numTime*factor);
 
for i = 1:numSpine
    dirNameprefix = sprintf('%s%d','spine',i);
    for j = 1:numTime
        filenameprefix = sprintf('%s%d%s%d%s','border_roi_k_',k,'_',j,'.png');
        fileNames{t}   = fullfile(fileFolder,dirNameprefix,filenameprefix);
        im             = imread(fileNames{t});
        newim          = imresize(im, [factor factor]);
        
        imBig((factor*i-factor)+1:factor*i,(factor*j-factor)+1:factor*j) = newim;
        t = t + 1;
    end
end
 
spMul   = mod(numSpine,4);
spExt   = rem(numSpine,4);

timeMul = mod(numTime,6);
timeExt = rem(numTime,6);
 
extLoopSpine = 0;
if spExt>0
    extLoopSpine = 1;
end
 
extLoopTime = 0;
if timeExt>0
    extLoopTime = 1;
end
 
bigHandle    = figure;
nanPositions = ones(numSpine,numTime);
x_total      = [];
y_total      = [];
 
for spx = 1:(floor(numSpine/4)+extLoopSpine)
    
    rangeSp = ((spx-1)*(4*factor)+1):spx*(4*factor);

    if spx > (floor(numSpine/4))
        rangeSp = ((spx-1)*(4*factor)+1):(((spx-1)*(4*factor))+spExt*(factor));
    end
    
    for tpx = 1:(floor(numTime/6)+extLoopTime)
        
        rangeTp = ((tpx-1)*(6*factor)+1):tpx*(6*factor);
        
        if tpx > (floor(numTime/6))
            rangeTp = ((tpx-1)*(6*factor)+1):(((tpx-1)*(6*factor))+timeExt*(factor));
        end
        
        imshow(imBig(rangeSp,rangeTp),[]);
        drawnow;
        
        title(sprintf('%s%d','Segmentation Results for parameter k = ',k),'FontSize',16,'interpreter','latex');
        %ylabel('Spines','FontSize',20,'interpreter','latex');
        %xlabel('Time','FontSize',20,'interpreter','latex');
        
        time_len_for_text  = (rangeTp(end)-rangeTp(1)+1)/(factor);
        spine_len_for_text = (rangeSp(end)-rangeSp(1)+1)/(factor);
        
         switch time_len_for_text
            case 1
                text('units','pixels','position',[50 -10] ,'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
            case 2
                text('units','pixels','position',[50 -10] ,'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[200 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
            case 3
                text('units','pixels','position',[50 -10] ,'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[200 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
                text('units','pixels','position',[350 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+3))
            case 4
                text('units','pixels','position',[50 -10] ,'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[200 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
                text('units','pixels','position',[350 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+3))
                text('units','pixels','position',[500 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+4))
            case 5
                text('units','pixels','position',[50 -10] ,'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[200 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
                text('units','pixels','position',[350 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+3))
                text('units','pixels','position',[500 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+4))
                text('units','pixels','position',[650 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+5))
            case 6
                text('units','pixels','position',[50 -10] ,'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+1))
                text('units','pixels','position',[200 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+2))
                text('units','pixels','position',[350 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+3))
                text('units','pixels','position',[500 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+4))
                text('units','pixels','position',[650 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+5))
                text('units','pixels','position',[800 -10],'fontsize',16,'interpreter','latex','string',sprintf('Time %d',6*(tpx-1)+6))
        end
        
        switch spine_len_for_text
            case 1
                text('units','pixels','position',[-50 50] ,'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+1))
            case 2
                text('units','pixels','position',[-50 200],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+1))
                text('units','pixels','position',[-50 50] ,'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+2))
            case 3
                text('units','pixels','position',[-50 350],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+1))
                text('units','pixels','position',[-50 200],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+2))
                text('units','pixels','position',[-50 50] ,'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+3))
            case 4
                text('units','pixels','position',[-50 500],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+1))
                text('units','pixels','position',[-50 350],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+2))
                text('units','pixels','position',[-50 200],'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+3))
                text('units','pixels','position',[-50 50] ,'fontsize',16,'interpreter','latex','string',sprintf('Sp %d',4*(spx-1)+4))
        end
        
        [y, x] = getpts(bigHandle);
        y_inds = ceil(y/factor);
        x_inds = ceil(x/factor);
        
        for nanCount = 1:length(y_inds)
            nanPositions(x_inds(nanCount)+(4*spx-4),y_inds(nanCount)+(6*tpx-6)) = nan;
        end
        
        clf(bigHandle,'reset');
        
        x_total = [x_total (x+(spx-1)*4*factor)'];
        y_total = [y_total (y+(tpx-1)*6*factor)'];
    end
end
 
save(fullfile(handles.foldername,'Volumes','nanPositions.mat'),'nanPositions');
 
close(bigHandle);
 
prompt           = {'Exclude Spines:'};
dlg_title        = 'Do you want to exclude any spines?';
num_lines        = 1;
def              = {''};
excSp            = str2num(cell2mat(inputdlg(prompt,dlg_title,num_lines,def)));

nanPositionsFull = nanPositions;
 
for sp = 1:length(excSp)
    nanPositionsFull(excSp(sp),:) = nan;
end
 
save(fullfile(handles.foldername,'Volumes','nanPositionsFull.mat'),'nanPositionsFull');

handles.Flags.excludeSpines = 1;

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
 

% --------------------------------------------------------------------
function intensityVolumeCalculationManual_Callback(hObject, eventdata, handles)
 
if handles.Flags.manuallySegmented == 0
    warndlg('Perform Segmentation First');
elseif handles.Flags.times == 0
    warndlg('Set Times Points First');
else
    computeVolumeUsingManualSegmentations(handles);
    
    load(fullfile(handles.foldername,'Volumes','Intensity','Manual','manual_IntensityVolumes.mat'));
    load(fullfile(handles.foldername,'Volumes','Intensity','Manual','manual_sumSpineVolumes.mat'));
    
    manual_IntensityVolumes     = manual_IntensityVolumes;
    manual_normIntensityVolumes = manual_IntensityVolumes./repmat(nanmean(manual_IntensityVolumes(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
    
    save(fullfile(handles.foldername,'Volumes','Intensity','Manual','manual_normIntensityVolumes.mat'),'manual_normIntensityVolumes');
    
    manual_sumSpineVolumes      = manual_sumSpineVolumes;
    manual_normSumSpineVolumes  = manual_sumSpineVolumes./repmat(nanmean(manual_sumSpineVolumes(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
    
    save(fullfile(handles.foldername,'Volumes','Intensity','Manual','manual_normIntensityVolumes.mat'),'manual_normIntensityVolumes');
    save(fullfile(handles.foldername,'Volumes','Intensity','Manual','manual_normSumSpineVolumes.mat'),'manual_normSumSpineVolumes');
    
    times = handles.times;
    
    plotExperimentResults(times.images,manual_normIntensityVolumes(1,:),manual_normIntensityVolumes(2:end,:),handles.foldername,'(Intensity)');
    plotExperimentResults(times.images,manual_normSumSpineVolumes(1,:),manual_normSumSpineVolumes(2:end,:),handles.foldername,'(Intensity)');
    
    cd(handles.workingDir);
    
    handles.Flags.manualIntensity = 1;
    
    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end
 
 
% --------------------------------------------------------------------
function importExperiment_Callback(hObject, eventdata, handles)
% hObject    handle to importExperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
    warndlg('This is not active yet');
% 
% fn = uipickfiles;
% load(fn{1});
%  
% handles = guidata(gcf);
%  
% handles.output = hObject;
%  
% guidata(hObject, handles);
%  
% axes(handles.axes2);
% imshow(handles.imroi,[])
%  
% list = [];
%  
% for i = 1:handles.spineCounter
%     list = get(handles.listbox3,'string');
%     if i < 10
%         set(handles.listbox3,'string',[list; sprintf('spine 0%d', i)]);
%     else
%         set(handles.listbox3,'string',[list; sprintf('spine %d', i)]);
%     end
% end
% %% handles = statusUpdate(handles, hObject); 
% guidata(hObject, handles);
 
 
% --------------------------------------------------------------------
function importStudy_Callback(hObject, eventdata, handles)
% hObject    handle to importStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    warndlg('This is not active yet');

% set(handles.statusWin,'String',sprintf('%s','Select Spine_<Data>.mat file to load a study'));
% 
% importFile = uipickfiles;
% load(importFile{1});
% 
% list = [];
%  
% for i = 1:handles.spineCounter
% %     list = get(handles.listbox3,'string');
%     if i < 10
%         set(handles.listbox3,'string',[list; sprintf('spine 0%d', i)]);
%     else
%         set(handles.listbox3,'string',[list; sprintf('spine %d', i)]);
%     end
% end
%  
% %     axes(handles.axes1);
% %     cla(handles.axes1)
% %     imshow(handles.firstMIP,[]);
% %
% handles.Flags.addSpine = 1;
%  
% MIPcroppedNameTag = fullfile(fullfile(handles.foldername,'MIP'),'MIP_');
% handles.stackSize = length(dir(sprintf('%s%s',MIPcroppedNameTag,'*')));
%  
% for ind = 1:handles.stackSize
%     im(:,:,ind) = imread(sprintf('%s%d%s',MIPcroppedNameTag,ind,'.png'));
% end
% %  
% % [handles.averageImage handles.varImage] = meanAndVariance(im);
% % handles.averageImage = uint8(handles.averageImage);
% %  
% clear tempImCube;
% handles.firstMIP = imread(sprintf('%s%d%s',MIPcroppedNameTag,1,'.png'));
%  
% axes(handles.axes1);
% imshow(handles.firstMIP,[]);
%  
% % dendpiece = SkeletonAndDendPerim_DU(handles.averageImage);
% %
% % handles.dendPiece = dendpiece;
% % handles.potentialDendPointsForVolumeNorm = dendpiece;
% % handles.errSpines = nan;
%  
% % handles = statusUpdate(handles, hObject); 
% guidata(hObject, handles);
%  
%  
% % --------------------------------------------------------------------
% % hObject    handle to FWHM (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%  
%  
% %if(handles.statusFlags(5) == 0)
% %    warndlg('Press the ROI button then choose a rectangular spine region');
% %else
% % Get position of rectangular area
%  
% sp = get(handles.listbox3,'Value');    % Spine Number
% t = handles.timePoint;                  % Time Point
% handles.imroi = handles.ROIlist{sp,t};
%  
% img = handles.imroi;
% rotated_roi = imrotate(img,handles.spinePositions(sp,t).angle);
%  
% axes(handles.axes2);
% imshow(rotated_roi,[]);
%  
% % set(gca, 'units','normalized', 'outerposition',[0.2 0.3 .5 .2]);
%  
% set(handles.textSpine,'String',sp);
% % set(gca, 'units','normalized', 'outerposition',[0.2 0.3 .5 .2]);
%  
% fwhmIm = getimage;
%  
% handles.fwhmRect = imrect;
%  
% pos = getPosition(handles.fwhmRect);
%  
% xMin = floor(pos(1));
% yMin = floor(pos(2));
% width = floor(pos(3));
% height = floor(pos(4));
%  
% clear pos;
% clear fwhmRegion;
% clear fwhmVal;
% clear handles.imrect;
%  
% fwhmRegion = fwhmIm(yMin:(yMin+height),xMin:(xMin+width));
% axes(handles.axes3);
% imshow(fwhmRegion,[]);
%  
% % find maximum fwhm
% xx = 1:size(fwhmRegion,2);
%  
% for fwhm_i = 1:(height+1)
%     y = double(fwhmRegion(fwhm_i,:));
%     [fitted_y(:,fwhm_i),goodness(fwhm_i),fwhmVal(fwhm_i)] = gaussFit1d_Ali_3(xx,y,1);
% end
%  
% [fwhmValue,ind] = max(fwhmVal((goodness>0.95)&(fwhmVal<size(fwhmRegion,2))));
% set(handles.status,'String', sprintf('%d',fwhmValue));
%  
% axes(handles.axes4);
% plot(1:(width+1),double(fwhmRegion(ind,:))/double(max(fwhmRegion(ind,:))),'.');
% hold on
% plot(xx,fitted_y(:,ind),'r');
% hold off
% axis tight;
%  
% sn = get(handles.listbox3,'Value');
% tp = handles.timePoint;
%  
% handles.fwhmValueManual(sn,tp) = max(fwhmValue);
%  
% cd(handles.workingDir);
% % handles = statusUpdate(handles, hObject); 
% guidata(hObject, handles);
 
% --------------------------------------------------------------------
function fwhmManual_Callback(hObject, eventdata, handles)
% hObject    handle to fwhmManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
if handles.Flags.manualFWHM == 0
    warning('Perform Manual FWHM Measurements First')
elseif handles.Flags.times == 0
    warndlg('Set Times Points First');
else
    
    manual_FWHMValues  = handles.fwhmValueManual;
    manual_FWHMVolumes = 4/3*pi*(manual_FWHMValues/2).^3;
    
    manual_FWHMValuesRealSize  = str2double(handles.xyPixelSizeValue)*manual_FWHMValues;
    manual_FWHMVolumesRealSize = 4/3*pi*(manual_FWHMValuesRealSize/2).^3;
        
    save(fullfile(handles.foldername,'Volumes','FWHM','Manual','manual_FWHMValues.mat'), 'manual_FWHMValues')
    save(fullfile(handles.foldername,'Volumes','FWHM','Manual','manual_FWHMVolumes.mat'), 'manual_FWHMVolumes')
    
    save(fullfile(handles.foldername,'Volumes','FWHM','Manual','manual_FWHMValuesRealSize.mat'), 'manual_FWHMValuesRealSize')
    save(fullfile(handles.foldername,'Volumes','FWHM','Manual','manual_FWHMVolumesRealSize.mat'), 'manual_FWHMVolumesRealSize')
    
    manual_normFWHMVolumes = manual_FWHMVolumes./repmat(nanmean(manual_FWHMVolumes(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
 
    save(fullfile(handles.foldername,'Volumes','FWHM','Manual','manual_normFWHMVolumes.mat'), 'manual_normFWHMVolumes');
    
    tms = handles.times.images - handles.times.stimulus;

    figure,      
    meanControls = nanmean(manual_FWHMValuesRealSize,1);
    stdControls = nanstd(manual_FWHMValuesRealSize,1)./sqrt(repmat(size(manual_FWHMValuesRealSize,1),1,size(manual_FWHMValuesRealSize,2))-sum(isnan(manual_FWHMValuesRealSize)));
    errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
    title('FWHM manual (Head Width)');
    
    figure,      
    meanControls = nanmean(manual_FWHMVolumesRealSize,1);
    stdControls = nanstd(manual_FWHMVolumesRealSize,1)./sqrt(repmat(size(manual_FWHMVolumesRealSize,1),1,size(manual_FWHMVolumesRealSize,2))-sum(isnan(manual_FWHMVolumesRealSize)));
    errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
    title('FWHM manual (Real Size)');
    
    figure,      
    meanControls = nanmean(manual_normFWHMVolumes,1);
    stdControls = nanstd(manual_normFWHMVolumes,1)./sqrt(repmat(size(manual_normFWHMVolumes,1),1,size(manual_normFWHMVolumes,2))-sum(isnan(manual_normFWHMVolumes)));
    errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
    title('FWHM manual (Normalized)');
end
 
cd(handles.workingDir);
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function fwhmAuto_Callback(hObject, eventdata, handles)
% hObject    handle to fwhmAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
if handles.Flags.autoSegmented == 0
    warndlg('Perform Segmentation First');
elseif handles.Flags.times == 0
    warndlg('Set Times Points First');
else
    
    lastBaselinePoint = handles.lastBaselinePoint;
    automaticFWHMestimation(handles.foldername, handles.stackSize, handles.spineCounter,handles.potentialDendPointsForVolumeNorm,handles.spinePositions,str2double(handles.xyPixelSizeValue));
    
    % Automatic FWHM Results
    load(fullfile(handles.foldername,'Volumes','FWHM','Automatic','auto_FWHMVolumes.mat'));
    load(fullfile(handles.foldername,'Volumes','FWHM','Automatic','auto_FWHMValues.mat'));
    load(fullfile(handles.foldername,'Volumes','FWHM','Automatic','auto_FWHMVolumesRealSize.mat'));
    load(fullfile(handles.foldername,'Volumes','FWHM','Automatic','auto_FWHMValuesRealSize.mat'));
    
    load(fullfile(handles.foldername,'Volumes','nanPositionsFull.mat'));
    load(fullfile(handles.foldername,'Volumes','times.mat'));
    
    auto_FWHMValues              = auto_FWHMValues.*nanPositionsFull;
    auto_FWHMVolumes             = auto_FWHMVolumes.*nanPositionsFull;
    auto_FWHMValuesRealSize      = auto_FWHMValuesRealSize.*nanPositionsFull;
    auto_FWHMVolumesRealSize     = auto_FWHMVolumesRealSize.*nanPositionsFull;
    
    auto_normFWHMVolumes         = auto_FWHMVolumes./repmat(mean(auto_FWHMVolumes(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
    auto_normFWHMValues          = auto_FWHMValues./repmat(mean(auto_FWHMValues(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
    auto_normFWHMVolumesRealSize = auto_FWHMVolumesRealSize./repmat(mean(auto_FWHMVolumesRealSize(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
    auto_normFWHMValuesRealSize  = auto_FWHMValuesRealSize./repmat(mean(auto_FWHMValuesRealSize(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
    
    save(fullfile(handles.foldername,'Volumes','FWHM','Automatic','auto_normFWHMVolumes.mat'),'auto_normFWHMVolumes');
    save(fullfile(handles.foldername,'Volumes','FWHM','Automatic','auto_normFWHMValues.mat'),'auto_normFWHMValues');
    save(fullfile(handles.foldername,'Volumes','FWHM','Automatic','auto_normFWHMVolumesRealSize.mat'),'auto_normFWHMVolumesRealSize');
    save(fullfile(handles.foldername,'Volumes','FWHM','Automatic','auto_normFWHMValuesRealSize.mat'),'auto_normFWHMValuesRealSize');
    
    plotExperimentResults(times.images-times.stimulus,auto_normFWHMVolumes(1,:),auto_normFWHMVolumes(2:end,:),handles.foldername,'Auto FWHM');
    
    cd(handles.workingDir);
    
    handles.Flags.autoFWHMVolume = 1;
    
    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end
 
% --- Executes on button press in saveImageInBox.
function nextTime_Callback(hObject, eventdata, handles)
% hObject    handle to saveImageInBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
if handles.Flags.autoSegmented == 1
 
    cla(handles.axes2,'reset');
    
    if handles.timePoint==handles.stackSize
        handles.timePoint = handles.timePoint;
    else
        handles.timePoint = handles.timePoint + 1;
    end
 
    sn                      = get(handles.listbox3,'Value');
    tp                      = handles.timePoint;
 
    imName                  = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_roi_k_10_',tp,'.png'));
    img                     = imread(imName);

    imName_Full             = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_k_10_',tp,'.png'));
    img_Full                = imread(imName_Full);
 
    imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
    img_Full_dend           = imread(imName_Full_dend);

    rotated_roi             = imrotate(img,handles.spinePositions(sn,tp).angle);
 
    axes(handles.axes2);
    imshow(rotated_roi,[]);
 
    img_Full_dend           = bwperim(img_Full_dend);
    
    axes(handles.axes1);
    C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(img_Full_dend),'blend','Scaling','joint');
    imshow(C,[]);

    set(handles.testTime,'String',tp);
 
    if handles.Flags.autoNeckLegth == 1
        try 
            compositeImage = combineROIandNeck(img,handles.neckPath{sn,tp},handles.justNeck3D{sn,tp});
            rotated_roi    = imrotate(compositeImage,handles.spinePositions(sn,tp).angle);

            axes(handles.axes2);
            imshow(rotated_roi,[]);
            
            updateSpineProperties(handles,sn,tp);
        catch
        end
    end
    
    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end
 
% --- Executes on button press in previousTime.
function previousTime_Callback(hObject, eventdata, handles)
% hObject    handle to previousTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
if handles.Flags.autoSegmented == 1
 
    cla(handles.axes2,'reset');
    
    if handles.timePoint==1
        handles.timePoint = 1;
    else
        handles.timePoint = handles.timePoint - 1;
    end
 
    sn                      = get(handles.listbox3,'Value');
    tp                      = handles.timePoint;
 
    imName                  = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_roi_k_10_',tp,'.png'));
    img                     = imread(imName);
    
    imName_Full             = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_k_10_',tp,'.png'));
    img_Full                = imread(imName_Full);
 
    imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
    img_Full_dend           = imread(imName_Full_dend);

    rotated_roi             = imrotate(img,handles.spinePositions(sn,tp).angle);
 
    axes(handles.axes2);
    imshow(rotated_roi,[]);
 
    img_Full_dend           = bwperim(img_Full_dend);
    
    axes(handles.axes1);
    C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(img_Full_dend),'blend','Scaling','joint');
    imshow(C,[]);
 
    set(handles.testTime,'String',tp);
 
    if handles.Flags.autoNeckLegth == 1 
        try
            compositeImage = combineROIandNeck(img,handles.neckPath{sn,tp},handles.justNeck3D{sn,tp});
            rotated_roi    = imrotate(compositeImage,handles.spinePositions(sn,tp).angle);
 
            axes(handles.axes2);
            imshow(rotated_roi,[]);
            
            updateSpineProperties(handles,sn,tp);
        catch
        end
    end
 
    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function FWHM_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to FWHM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
%if(handles.statusFlags(5) == 0)
%    warndlg('Press the ROI button then choose a rectangular spine region');
%else
% Get position of rectangular area
 
sp              = get(handles.listbox3,'Value');    % Spine Number
t               = handles.timePoint;                  % Time Point
handles.imroi   = handles.ROIlist{sp,t};
img             = handles.imroi;
rotated_roi     = imrotate(img,handles.spinePositions(sp,t).angle);
 
axes(handles.axes2);
imshow(rotated_roi,[]);
 
% set(gca, 'units','normalized', 'outerposition',[0.2 0.3 .5 .2]);

fwhmIm           = getimage;
handles.fwhmRect = imrect;
pos              = getPosition(handles.fwhmRect);
 
xMin   = floor(pos(1));
yMin   = floor(pos(2));
width  = floor(pos(3));
height = floor(pos(4));
 
clear pos;
clear fwhmRegion;
clear fwhmVal;
clear handles.imrect;
 
fwhmRegion = fwhmIm(yMin:(yMin+height),xMin:(xMin+width));

xx = 1:size(fwhmRegion,2);
 
for fwhm_i = 1:(height+1)
    y = double(fwhmRegion(fwhm_i,:));
    [fitted_y(fwhm_i,:),goodness(fwhm_i),fwhmVal(fwhm_i)] = gaussFit1d_Ali_3(xx,y,1);
end
 
[fwhmValue,ind] = max(fwhmVal((goodness>0.95)&(fwhmVal<size(fwhmRegion,2))))

%set(handles.statusWin,'String', sprintf('%d',fwhmValue));
 
axes(handles.axes4);

plot(1:(width+1),double(fwhmRegion(ind,:))/double(max(fwhmRegion(ind,:))));
hold on
plot(xx,fitted_y(ind,:),'r');
hold off
axis tight;
 
sn = get(handles.listbox3,'Value');
tp = handles.timePoint;
 
 
handles.fwhmValueManual(sn,tp) = fwhmValue;
allfwhm = handles.fwhmValueManual;
xySize  = str2double(handles.xyPixelSizeValue);
handles.fwhmValueManualRealSize(sn,tp) = fwhmValue*xySize; % pixel * micrometer
 
set(handles.fwhmPixelValue,'String',fwhmValue);
set(handles.fwhmRealValue,'String',fwhmValue*xySize);
 
handles.Flags.manualFWHM = 1;
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function manualSegmentation_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to manualSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load(fullfile(handles.foldername,'3DStacks','Raw',sprintf('raw_%d.mat',handles.timePoint)));

h_ms = figure;
imagesc(medfilt2(max(Icube,[],3),[handles.filterSize handles.filterSize]));
% axes(handles.axes2);

[handles.SegMask,SP(:,2),SP(:,1)] = roipoly;
% plot(SP(:,2),SP(:,1),'r.-');

close(h_ms);

sn = get(handles.listbox3,'Value');
tp = handles.timePoint;
 
imwrite(handles.SegMask, fullfile(handles.foldername,'Segmentation','Manual',sprintf('Manual_Seg_Time_%d_Spine_%d.png',tp,sn)),'png');
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --- Executes on button press in saveImageInBox.
function saveImageInBox_Callback(hObject, eventdata, handles)
% hObject    handle to saveImageInBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --- Executes on button press in saveManualSegmentation.
function saveManualSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to saveManualSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
if isdir(fullfile(handles.foldername,'Segmentation','Manual')) == 0
    mkdir(fullfile(handles.foldername,'Segmentation','Manual'));
end
 
sn      = get(handles.listbox3,'Value');
tp      = handles.timePoint;

imName  = fullfile(handles.foldername,'Segmentation','Manual',sprintf('%s%d%s%d%s','spine_',sn,'_',tp,'.png'));
 
imwrite(handles.SegMask,imName);
 
handles.Flags.manuallySegmented = 1;
 
cd(handles.workingDir);

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function clearStudy_Callback(hObject, eventdata, handles)
% hObject    handle to clearStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
clearvars -global -except handles;
handles.output       = hObject;
handles.callCount    = 0;
handles.stack        = [];
handles.spineCounter = 0;
handles.angle        = 0;
 
% Initialize Flags
handles.Flags.importStack           = 0;
handles.Flags.importTwoD            = 0;
handles.Flags.calculateMIP          = 0;
handles.Flags.medianFilter          = 0;
handles.Flags.selectROI             = 0;
handles.Flags.importSpine           = 0;
handles.Flags.setSpineAngle         = 0;
handles.Flags.segRegMI              = 0;
handles.Flags.segRegSIFT            = 0;
handles.Flags.intensityVolumeCalc   = 0;
handles.Flags.FWHMvolumeCalc        = 0;
 
blackIm = zeros(1024,1024);

axes(handles.axes1);
imshow(blackIm, []);
axes(handles.axes2);
% imshow(blackIm, []);
% axes(handles.axes3);
imshow(blackIm, []);
axes(handles.axes4);
imshow(blackIm, []);

set(handles.dataLoadText     , 'BackgroundColor', 'red');
set(handles.croppedText      , 'BackgroundColor', 'red');
set(handles.spineSelectText  , 'BackgroundColor', 'red');
set(handles.filteredText     , 'BackgroundColor', 'red');

set(handles.segmentedText    , 'BackgroundColor', 'red');
set(handles.neckComputedText , 'BackgroundColor', 'red');


% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function preProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to preProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function segmentationMain_Callback(hObject, eventdata, handles)
% hObject    handle to segmentationMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function volumeCalculation_Callback(hObject, eventdata, handles)
% hObject    handle to volumeCalculation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function zProjection_Callback(hObject, eventdata, handles)
% hObject    handle to zProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function filterStack_Callback(hObject, eventdata, handles)
% hObject    handle to filterStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
% --- Executes during object creation, after setting all properties.
function rotateSpine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotateSpine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 
% % --- Executes on button press in saveImageInBox.
% function nextTime_Callback(hObject, eventdata, handles)
% % hObject    handle to saveImageInBox (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
 
% --- Executes on button press in previousSpine.
function previousSpine_Callback(hObject, eventdata, handles)
% hObject    handle to previousSpine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function exportImages_Callback(hObject, eventdata, handles)
% hObject    handle to exportImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function postProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to postProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function semiAutoVolume_Callback(hObject, eventdata, handles)
% hObject    handle to semiAutoVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function importPhotoConversionStack_Callback(hObject, eventdata, handles)
% hObject    handle to importPhotoConversionStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function adaptiveMedianFilter_Callback(hObject, eventdata, handles)
% hObject    handle to adaptiveMedianFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function adaptiveMIP_Callback(hObject, eventdata, handles)
% hObject    handle to adaptiveMIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --- Executes on button press in saveImageFWHM.
function saveImageFWHM_Callback(hObject, eventdata, handles)
% hObject    handle to saveImageFWHM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function results_Callback(hObject, eventdata, handles)
% hObject    handle to results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
delete(handles.output)
clear all
close all
clc

% --------------------------------------------------------------------
function saveStudy_Callback(hObject, eventdata, handles)
% hObject    handle to saveStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
cd(handles.foldername);
save ExportedData.mat
opts.filename = fullfile(handles.foldername,'ExportedData.mat');
uiremember(opts);
cd(handles.workingDir);
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function filteredMIP_Callback(hObject, eventdata, handles)
% hObject    handle to filteredMIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
 
% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
function bitDepth_Callback(hObject, eventdata, handles)
% hObject    handle to bitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of bitDepth as text
%        str2double(get(hObject,'String')) returns contents of bitDepth as a double
 
% --- Executes during object creation, after setting all properties.
function bitDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bitDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
% --------------------------------------------------------------------
function reviewSegmentations_Callback(hObject, eventdata, handles)
% hObject    handle to reviewSegmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function setImageTimes_Callback(hObject, eventdata, handles)
% hObject    handle to setImageTimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
prompt          = {'Image Times:','Stimulus Time:','Number of Baseline Images:'};
dlg_title       = 'Input';
num_lines       = 1;
def             = {'','',''};
answer          = inputdlg(prompt,dlg_title,num_lines,def);
 
times.images    = str2num(answer{1});
times.stimulus  = str2num(answer{2});
 
if isempty(str2num(answer{3}))
    handles.lastBaselinePoint = sum(times.images<times.stimulus);
    times.numBaselines        = handles.lastBaselinePoint;
else
    handles.lastBaselinePoint = str2num(answer{3});
    times.numBaselines        = handles.lastBaselinePoint;
end
 
handles.times = times;
 
save(fullfile(handles.foldername,'Volumes','times.mat'),'times');
 
handles.Flags.times = 1;
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function setResultsFolder_Callback(hObject, eventdata, handles)
% hObject    handle to setResultsFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
if ismac
    s = regexp(D1{1}, '/', 'split');
else
    s = regexp(D1{1}, '\', 'split');
end
 
folderName = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
 
[status, msg, msgId] = mkdir(folderName);
 
while(~isempty(msg))
    prompt               = {'Folder exists. Enter a new folder name'};
    folderName           = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
    [status, msg, msgId] = mkdir(folderName);
end
 
folderName           = fullfile(s{1:end-1},sprintf('%s%s','results',datestr(now,30))); % Date Format (ISO 8601)  'yyyymmddTHHMMSS'
[status, msg, msgId] = mkdir(folderName);
 
set(handles.edit8,'String',sprintf('%s',folderName));
handles.Flags.setResultsFolder = 1;
 
function zSpacing_Callback(hObject, eventdata, handles)
% hObject    handle to zSpacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of zSpacing as text
%        str2double(get(hObject,'String')) returns contents of zSpacing as a double
 
% --- Executes during object creation, after setting all properties.
function zSpacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zSpacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
function xyPixelSize_Callback(hObject, eventdata, handles)
% hObject    handle to xyPixelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of xyPixelSize as text
%        str2double(get(hObject,'String')) returns contents of xyPixelSize as a double
 
 
% --- Executes during object creation, after setting all properties.
function xyPixelSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xyPixelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
function fwhmPixelValue_Callback(hObject, eventdata, handles)
% hObject    handle to fwhmPixelValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of fwhmPixelValue as text
%        str2double(get(hObject,'String')) returns contents of fwhmPixelValue as a double
 
 
% --- Executes during object creation, after setting all properties.
function fwhmPixelValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fwhmPixelValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
function fwhmRealValue_Callback(hObject, eventdata, handles)
% hObject    handle to fwhmRealValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of fwhmRealValue as text
%        str2double(get(hObject,'String')) returns contents of fwhmRealValue as a double
 

% --- Executes during object creation, after setting all properties.
function fwhmRealValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fwhmRealValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%  

% --------------------------------------------------------------------
function NeckLength_Callback(hObject, eventdata, handles)
% hObject    handle to NeckLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
% --------------------------------------------------------------------
function measureSpineNeckLenght_Callback(hObject, eventdata, handles)
% hObject    handle to measureSpineNeckLenght (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
handles.neckPath   = cell(handles.spineCounter,handles.stackSize);
handles.justNeck3D = cell(handles.spineCounter,handles.stackSize);


for t = 1:handles.stackSize
        seg_Dend     = imread(fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',t,'.png')));
        dend_skel    = imread(fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendriteSkel_',t,'.png')));  
        dend_perim   = bwmorph(seg_Dend,'remove');
        imgname      = fullfile(handles.foldername,'3DStacks','Registered',sprintf('reg_%d.mat', t));

        load(imgname);

        stack_unfilt = IcubeCropped;

        h_neck       = waitbar(0, sprintf('%s %d','Neck Path and Length Computation in Progress for Time Point:',t));
        
        for spine_num = 1:handles.spineCounter
            
            waitbar(spine_num/handles.spineCounter,h_neck);
            set(handles.statusWin,'String',sprintf('Spine Neck Computation in Progress, Time Point : %d; Spine Number : %d',t,spine_num));

            try               
                filteredImage         = imread(fullfile(handles.foldername,'MIP',sprintf('%s%d%s','MIP_filtered_',t,'.png')));
                spine_image           = imread(fullfile(handles.Segfoldername,'Automatic', sprintf('spine%d', spine_num),sprintf('ROI_%d%s',t,'.png')));
                spine_segment_big     = imread(fullfile(handles.Segfoldername,'Automatic', sprintf('spine%d', spine_num),sprintf('binary_k_3_%d%s',t,'.png')));
                spine_segment_small   = imread(fullfile(handles.Segfoldername,'Automatic', sprintf('spine%d', spine_num),sprintf('binary_roi_k_3_%d%s',t,'.png')));
                spine_segment_k       = imread(fullfile(handles.Segfoldername,'Automatic', sprintf('spine%d', spine_num),sprintf('binary_roi_k_8_%d%s',t,'.png')));

                % find spine center
                [BW_small,L_small]    = bwlabeln(spine_segment_small);
                s_small               = regionprops(BW_small, 'centroid');
                centroids_small       = cat(1, s_small.Centroid);
                CX_small              = round(centroids_small(1,2));
                CY_small              = round(centroids_small(1,1));

                [BW_big,L_big]        = bwlabeln(spine_segment_big);
                s_big                 = regionprops(BW_big, 'centroid');
                centroids_big         = cat(1, s_big.Centroid);
                CX_big                = round(centroids_big(1,2));
                CY_big                = round(centroids_big(1,1));

                %% show spine center
                % cut 3D spine stack from big stack
                angle               = handles.spinePositions(spine_num,t).angle;
                xMin                = handles.spinePositions(spine_num,t).xMin;
                yMin                = handles.spinePositions(spine_num,t).yMin;
                height              = handles.spinePositions(spine_num,t).height;
                width               = handles.spinePositions(spine_num,t).width;

                spineStack          = double(stack_unfilt(yMin:(yMin+height),xMin:(xMin+width),:));
                [spine2d,spine2dZ]  = max(spineStack,[],3);

                seg_Dend_ROI        = seg_Dend(yMin:(yMin+height),xMin:(xMin+width));
                seg_Dend_ROI_perim  = bwmorph(seg_Dend_ROI,'remove');    
                seg_Dend_ROI_skel   = bwmorph(seg_Dend_ROI,'skel',Inf);

                % Find Skel Points and Find Closest ones to candidates
                [skel_y,skel_x]     = find(seg_Dend_ROI_skel);

                handles.neckBasePoint{spine_num,t} = ...
                    findClosestPointOnDendriteToSpineCenter(spineStack,spine2d, seg_Dend_ROI_skel, centroids_small);

                handles.neckBasePoint{spine_num,t}
                % Refine Neck Base Point

                % find spine center in Z direction
                z_profile   = double(squeeze(spineStack(CY_small,CX_small,:)));
                z_profile_1 = double(squeeze(spineStack(CY_small+0,CX_small+1,:)));
                z_profile_2 = double(squeeze(spineStack(CY_small+0,CX_small-1,:)));
                z_profile_3 = double(squeeze(spineStack(CY_small+1,CX_small+0,:)));
                z_profile_4 = double(squeeze(spineStack(CY_small-1,CX_small+0,:)));
                
                [val,CZ]  = max(smooth((z_profile+z_profile_1+z_profile_2+z_profile_3+z_profile_4)/5));

                spineHeadCenterSourcePoint3D = double([CX_small,CY_small,CZ]');

                tempPoint = refineNeckBasePointLocation(spineStack,spineHeadCenterSourcePoint3D,...
                    handles.neckBasePoint{spine_num,t},seg_Dend_ROI);

                [temp, dist] = knnsearch([skel_y,skel_x],[tempPoint(1),tempPoint(2)],'dist','euclidean','k',1);

                spineNeckBaseAtSkeletonCenter         = unique([skel_x(temp),skel_y(temp)], 'rows');
                handles.neckBasePoint{spine_num,t}(1) = spineNeckBaseAtSkeletonCenter(2);
                handles.neckBasePoint{spine_num,t}(2) = spineNeckBaseAtSkeletonCenter(1);

                SourcePoint3D   = spineHeadCenterSourcePoint3D;

                handles.neckBasePoint{spine_num,t}

                xyS          = get(handles.xyPixelSize, 'string');

                xPixelSize   = str2double(xyS);
                zPixelSize   = handles.zSpacingVal;

                v1           = vesselness3D(spineStack, [4*xPixelSize 8*xPixelSize], [xPixelSize;xPixelSize;zPixelSize], 1, true);
                b1           = blobness3D(spineStack  , [4*xPixelSize 8*xPixelSize], [xPixelSize;xPixelSize;zPixelSize], 1, true);
                temp         = (val*v1 + val*b1 + spineStack)/3;

                ShortestLine = [];
                ShortestLine = findShorttestPath(temp, SourcePoint3D, handles.neckBasePoint{spine_num,t});

                clear path;
                clear pathlengths;
                clear nd;
                clear norm_diff_path_int;

                path     = ShortestLine;
                path_int = [];

                for pt = 1:length(path)
                    pt_idx = round(path(pt,:,:));
                    pix    = spineStack(pt_idx(1),pt_idx(2),pt_idx(3));
                    if pix < 0  % Control for Negative
                        pix = 0;
                    end
                    path_int(pt) = double(abs(pix));
                end

                path(:,1) = path(:,1)*str2double(handles.xyPixelSizeValue);
                path(:,2) = path(:,2)*str2double(handles.xyPixelSizeValue);
                path(:,3) = path(:,3)*str2double(handles.zSpacingValue);

                % Path Smoothness
                diff_path           = diff(path);
                D                   = diff(path,1,1);
                len                 = trace(sqrt(D*D.'));
                pathlengths         = len;
                actualnecklengths   = pathlengths;
                diff_path           = sum(abs(diff_path));
                nd                  = norm(diff_path,1);

                % Derivative of Path intensities
                diff_path_int       = diff(path_int);
                norm_diff_path_int  = norm(diff_path_int,1);
                nd                  = nd ./ max(nd);

                % path_int = path_int./max(path_int);
                norm_diff_path_int  = norm_diff_path_int ./ max(norm_diff_path_int);
                pathlengths         = pathlengths ./ max(pathlengths);
                int_length          = norm_diff_path_int + pathlengths + nd;

                ShortestLineFinal   = [];
                ShortestLineFinal   = ShortestLine;

                %% Show Neck Length Computation Results
                spine_segment_k_binary  = logical(spine_segment_k);
                ROI_head_and_dend       = (spine_segment_k_binary | seg_Dend_ROI);
                ROI_head_and_dend_temp  = ROI_head_and_dend;

                for neckPoints = 1:length(ShortestLineFinal(:,1))
                    ROI_head_and_dend(round(ShortestLineFinal(neckPoints,1)),round(ShortestLineFinal(neckPoints,2))) = 1;
                end

                justNeck    = [];
                justNeck    = logical(double(ROI_head_and_dend) - double(ROI_head_and_dend_temp));

                A = justNeck;
                B = spine_segment_k_binary;
                C = seg_Dend_ROI;

                compositeImage = cat(3, B+A, A, C+A);   
                
                figure, imshow(imresize(compositeImage,1),[]);
                set(gca,'YDir','normal');
                axis off;
                export_fig(fullfile(handles.foldername,'Neck',sprintf('spineNeck_%d_%d.png',spine_num,t)));
                close;
    
                linearIndexes = find(justNeck);

                clear xy;
                clear yRow;
                clear xCol;
                clear distances;
                clear index1;
                clear index2;
                clear x1;
                clear x2;
                clear y1;
                clear y2;
                clear justNeck3D;
                
                for k = 1 : length(linearIndexes)
                    [yRow(k), xCol(k)] = ind2sub(size(justNeck), linearIndexes(k));
                end

                xy = [xCol', yRow'];

                distances = pdist2(xy, xy);

                % Find the max distance
                maxDistance = max(distances(:));
                % Find the indexes where it occurs
                [index1, index2] = find(distances == maxDistance);
                % Extract the x,y of the indexes.
                x1 = xy(index1(1), 1);
                y1 = xy(index1(1), 2);
                x2 = xy(index2(1), 1);
                y2 = xy(index2(1), 2);

                idxnew1     = knnsearch([ShortestLineFinal(:,2),ShortestLineFinal(:,1)],[x1 y1]);
                idxnew2     = knnsearch([ShortestLineFinal(:,2),ShortestLineFinal(:,1)],[x2 y2]);

                justNeck3D  = ShortestLineFinal(min([idxnew1 idxnew2]):max([idxnew1 idxnew2]),:);

                compositeImage = combineROIandNeck(spine_image,ShortestLineFinal,justNeck3D);

                handles.neckPath{spine_num,t}   = ShortestLineFinal;
                handles.justNeck3D{spine_num,t} = [];
                handles.justNeck3D{spine_num,t} = justNeck3D;
                
                if ischar(handles.zSpacingValue)            
                    Path_microMeter = ShortestLineFinal.*[ones(1,size(ShortestLineFinal,1))*str2double(handles.xyPixelSizeValue);...
                        ones(1,size(ShortestLineFinal,1))*str2double(handles.xyPixelSizeValue);...
                        ones(1,size(ShortestLineFinal,1))*str2double(handles.zSpacingValue)]';

                    Path_microMeter_justNeck = justNeck3D.*[ones(1,size(justNeck3D,1))*str2double(handles.xyPixelSizeValue);...
                        ones(1,size(justNeck3D,1))*str2double(handles.xyPixelSizeValue);...
                        ones(1,size(justNeck3D,1))*str2double(handles.zSpacingValue)]';
                else            
                    Path_microMeter = ShortestLineFinal.*[ones(1,size(ShortestLineFinal,1))*str2double(handles.xyPixelSizeValue);...
                    ones(1,size(ShortestLineFinal,1))*str2double(handles.xyPixelSizeValue);...
                    ones(1,size(ShortestLineFinal,1))*double(handles.zSpacingValue)]';

                    Path_microMeter_justNeck = justNeck3D.*[ones(1,size(justNeck3D,1))*str2double(handles.xyPixelSizeValue);...
                    ones(1,size(justNeck3D,1))*str2double(handles.xyPixelSizeValue);...
                    ones(1,size(justNeck3D,1))*double(handles.zSpacingValue)]';
                end

                D            = diff(Path_microMeter,1,1);
                D_justNeck   = diff(Path_microMeter_justNeck,1,1);

                len          = trace(sqrt(D*D.'));
                len_justNeck = trace(sqrt(D_justNeck*D_justNeck.'));

                handles.neckPath{spine_num,t}                    = ShortestLineFinal;
                handles.neckLenMicroMeters(spine_num,t)          = len;
                handles.neckLenMicroMeters_justNeck(spine_num,t) = len_justNeck;

                set(handles.statusWin,'String',sprintf('Last Computed Spine Neck, Time Point : %d; Spine Number : %d',t,spine_num));
            catch
                set(handles.statusWin,'String',sprintf('PROBLEM:, Time Point : %d; Spine Number : %d',t,spine_num));
                handles.neckLenMicroMeters_justNeck(spine_num,t) = nan;
            end
            
        end
        
        delete(h_neck);
end

delete(h_neck);

handles.Flags.autoNeckLegth = 1;

cd(handles.workingDir);

set(handles.neckComputedText, 'BackgroundColor', 'green');

% handles = statusUpdate(handles, hObject); 

guidata(hObject, handles);
 
% --------------------------------------------------------------------
function exportStudy_Callback(hObject, eventdata, handles)
% hObject    handle to exportStudy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Flags.importStack == 1  
    str = get(handles.edit8,'String');
    if ismac
        s = regexp(str, '/', 'split');
    else
        s = regexp(str, '\', 'split');
    end
    save(fullfile(handles.foldername,sprintf('%s%s%s','SpineS_',s{end},'.mat')),'handles'); 
end

guidata(hObject, handles);

% --- Executes on button press in correctSegmentation.
function correctSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to correctSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
sn              = get(handles.listbox3,'Value');
tp              = handles.timePoint;
 
imName          = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','ROI_',tp,'.png'));
img_correct     = imread(imName);

imName          = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_roi_k_10_',tp,'.png'));
img             = imread(imName);
    
segimName       = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','binary_roi_k_10_',tp,'.png'));
seg_img_correct = imread(segimName);
 
imageFixedName  = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','MIP_Filtered_',tp,'.png'));
imageFixed      = imread(imageFixedName);

figure;
imagesc(img_correct);

seg_im_perim            = bwperim(seg_img_correct, 8);
[B,L]                   = bwboundaries(seg_im_perim,'noholes');
[y,x]                   = find(double(seg_im_perim)==1); % burdan x y coordinatlarini bulayim dedim
 
x_y_downsample_indeces  = floor(1:(length(B{1})/10):length(B{1})); % burdan cok nokta cikiyor, bunlarin sayisini azaltayim dedim
h_new                   = impoly(gca, [B{1}(x_y_downsample_indeces, 2), B{1}(x_y_downsample_indeces, 1)]); % burdan o noktalari bana gostersin, bende degistireyim dedm
position                = wait(h_new);

setColor(h_new,'yellow');   

handles.SegMask = createMask(h_new);

close(gcf);
 
if isdir(fullfile(handles.foldername,'Segmentation','Manual')) == 0
    mkdir(fullfile(handles.foldername,'Segmentation','Manual'));
end
 
imName = fullfile(handles.foldername,'Segmentation','Manual',sprintf('%s%d%s%d%s','spine_',sn,'_',tp,'.png'));
imwrite(handles.SegMask,imName);
 
xMin            = handles.spinePositions(sn,tp).xMin;
yMin            = handles.spinePositions(sn,tp).yMin;
height          = handles.spinePositions(sn,tp).height;
width           = handles.spinePositions(sn,tp).width;
 
angle(sn)       = handles.spinePositions(sn).angle;
segFolderName   = handles.Segfoldername;
 
SegMask         = handles.SegMask;

xyS             = get(handles.xyPixelSize, 'string');
xPixelSize      = str2double(xyS);

graphBasedManual(img_correct, 255*double(SegMask), 10, imageFixed, ...
                    xMin, yMin,height, width,...
                    fullfile(segFolderName,'Automatic'), sn, tp, angle(sn), handles.dendROIlist{sn,tp}, xPixelSize);
% 
% stats = graphBased(handles.ROIlist{i,1}, spineHead, 10, imageFixed, handles.spinePositions(i,1).xMin, ...
% handles.spinePositions(i,1).yMin, handles.spinePositions(i,1).height,...
% handles.spinePositions(i,1).width,fullfile(handles.Segfoldername,...
% 'Automatic'), i, 1, handles.spinePositions(i).angle, handles.dendROIlist{i,1}, xPixelSize);
             
handles.Flags.excludeSpines = 1;

cd(handles.workingDir);
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --- Executes on button press in correctNeck.
function correctNeck_Callback(hObject, eventdata, handles)
% hObject    handle to correctNeck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

spine_num           = get(handles.listbox3,'Value');
t                   = handles.timePoint;

seg_Dend            = imread(fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',t,'.png')));
dend_skel           = imread(fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendriteSkel_',t,'.png')));
dend_perim          = bwmorph(seg_Dend,'remove');

%read 3d unfiltered but registered stack
imgname             = fullfile(handles.foldername,'3DStacks','Registered',sprintf('reg_%d.mat', t));
load(imgname);

stack_unfilt        = IcubeCropped;

spine_segment_big   = imread(fullfile(handles.Segfoldername,'Automatic', sprintf('spine%d', spine_num),sprintf('binary_k_3_%d%s',t,'.png')));
spine_segment_small = imread(fullfile(handles.Segfoldername,'Automatic', sprintf('spine%d', spine_num),sprintf('binary_roi_k_3_%d%s',t,'.png')));
spine_segment_k     = imread(fullfile(handles.Segfoldername,'Automatic', sprintf('spine%d', spine_num),sprintf('binary_roi_k_8_%d%s',t,'.png')));

% find spine center
[BW_small,L_small]  = bwlabeln(spine_segment_small);
s_small             = regionprops(BW_small, 'centroid');
centroids_small     = cat(1, s_small.Centroid);
CX_small            = round(centroids_small(1,2));
CY_small            = round(centroids_small(1,1));

[BW_big,L_big]      = bwlabeln(spine_segment_big);
s_big               = regionprops(BW_big, 'centroid');
centroids_big       = cat(1, s_big.Centroid);
CX_big              = round(centroids_big(1,2));
CY_big              = round(centroids_big(1,1));

% cut 3D spine stack from big stack
angle               = handles.spinePositions(spine_num,t).angle;
xMin                = handles.spinePositions(spine_num,t).xMin;
yMin                = handles.spinePositions(spine_num,t).yMin;
height              = handles.spinePositions(spine_num,t).height;
width               = handles.spinePositions(spine_num,t).width;

spineStack          = double(stack_unfilt(yMin:(yMin+height),xMin:(xMin+width),:));

seg_Dend_ROI        = seg_Dend(yMin:(yMin+height),xMin:(xMin+width));
seg_Dend_ROI_perim  = bwmorph(seg_Dend_ROI,'remove');    
seg_Dend_ROI_skel   = bwmorph(seg_Dend_ROI,'skel',Inf);

handles.newSpineNectCorrect = figure;
figure(handles.newSpineNectCorrect);
imagesc(max(spineStack,[],3));
 
[new_x, new_y]  = getpts_SpineS(handles.newSpineNectCorrect)

for i = 1:length(new_x)
    z_profile_bp(:,i) = double(squeeze(spineStack(floor(new_y(i)),floor(new_x(i)),:)));  
    [val(i),new_z(i)] = max(smooth(squeeze(z_profile_bp(:,i))));
end

close(handles.newSpineNectCorrect);

% find spine center in Z direction
z_profile   = double(squeeze(spineStack(CY_small,CX_small,:)));
z_profile_1 = double(squeeze(spineStack(CY_small+0,CX_small+1,:)));
z_profile_2 = double(squeeze(spineStack(CY_small+0,CX_small-1,:)));
z_profile_3 = double(squeeze(spineStack(CY_small+1,CX_small+0,:)));
z_profile_4 = double(squeeze(spineStack(CY_small-1,CX_small+0,:)));

[val,CZ]    = max(smooth((z_profile+z_profile_1+z_profile_2+z_profile_3+z_profile_4)/5));

SourcePoint3D       = double([CY_small,CX_small,CZ]');
StartPoint          = [new_y(end),new_x(end),new_z(end)]';
StartPointAll       = [new_y,new_x,new_z']';

handles.neckBasePoint{spine_num,t} = StartPointAll;

strel_val           = round(size(spineStack,1)/20);
se                  = strel('ball',strel_val,strel_val);
erodedI             = imerode(double(spineStack),se);

%%
%SourcePoint3D   = spineHeadCenterSourcePoint3D;

handles.neckBasePoint{spine_num,t};

xyS          = get(handles.xyPixelSize, 'string');

xPixelSize   = str2double(xyS);
zPixelSize   = handles.zSpacingVal;

v1           = vesselness3D(spineStack, [4*xPixelSize 8*xPixelSize], [xPixelSize;xPixelSize;zPixelSize], 1, true);
b1           = blobness3D(spineStack  , [4*xPixelSize 8*xPixelSize], [xPixelSize;xPixelSize;zPixelSize], 1, true);
temp         = (val*v1 + val*b1 + spineStack)/3;

ShortestLine = [];
ShortestLine = findShorttestPathManual(temp, SourcePoint3D, handles.neckBasePoint{spine_num,t});

clear path;
clear pathlengths;
clear nd;
clear norm_diff_path_int;

path     = ShortestLine;
path_int = [];

for pt = 1:length(path)
    pt_idx = round(path(pt,:,:));
    pix    = spineStack(pt_idx(1),pt_idx(2),pt_idx(3));
    if pix < 0  % Control for Negative
        pix = 0;
    end
    path_int(pt) = double(abs(pix));
end

path(:,1) = path(:,1)*str2double(handles.xyPixelSizeValue);
path(:,2) = path(:,2)*str2double(handles.xyPixelSizeValue);
path(:,3) = path(:,3)*str2double(handles.zSpacingValue);

% Path Smoothness
diff_path           = diff(path);
D                   = diff(path,1,1);
len                 = trace(sqrt(D*D.'));
pathlengths         = len;
actualnecklengths   = pathlengths;
diff_path           = sum(abs(diff_path));
nd                  = norm(diff_path,1);

% Derivative of Path intensities
diff_path_int       = diff(path_int);
norm_diff_path_int  = norm(diff_path_int,1);
nd                  = nd ./ max(nd);

% path_int = path_int./max(path_int);
norm_diff_path_int  = norm_diff_path_int ./ max(norm_diff_path_int);
pathlengths         = pathlengths ./ max(pathlengths);
int_length          = norm_diff_path_int + pathlengths + nd;

ShortestLineFinal   = [];
ShortestLineFinal   = ShortestLine;

%%
clear path;
clear pathlengths;
clear nd;
clear norm_diff_path_int;

path     = ShortestLine;
path_int = [];

for pt = 1:length(path)
    pt_idx = round(path(pt,:,:));
    pix    = spineStack(pt_idx(1),pt_idx(2),pt_idx(3));
    if pix < 0  % Control for Negative
        pix = 0;
    end
    path_int(pt) = double(abs(pix));
end

path(:,1) = path(:,1)*str2double(handles.xyPixelSizeValue);
path(:,2) = path(:,2)*str2double(handles.xyPixelSizeValue);
path(:,3) = path(:,3)*str2double(handles.zSpacingValue);

% Path Smoothness
diff_path           = diff(path);
D                   = diff(path,1,1);
len                 = trace(sqrt(D*D.'));
pathlengths         = len;
actualnecklengths   = pathlengths;
diff_path           = sum(abs(diff_path));
nd                  = norm(diff_path,1);

% Derivative of Path intensities
diff_path_int       = diff(path_int);
norm_diff_path_int  = norm(diff_path_int,1);
nd                  = nd ./ max(nd);

% path_int = path_int./max(path_int);
norm_diff_path_int  = norm_diff_path_int ./ max(norm_diff_path_int);
pathlengths         = pathlengths ./ max(pathlengths);
int_length          = norm_diff_path_int + pathlengths + nd;

ShortestLineFinal   = [];
ShortestLineFinal   = ShortestLine;

%% Show Neck Length Computation Results
spine_segment_k_binary  = logical(spine_segment_k);
ROI_head_and_dend       = (spine_segment_k_binary | seg_Dend_ROI);
ROI_head_and_dend_temp  = ROI_head_and_dend;

for neckPoints = 1:length(ShortestLineFinal(:,1))
    ROI_head_and_dend(round(ShortestLineFinal(neckPoints,1)),round(ShortestLineFinal(neckPoints,2))) = 1;
end

justNeck    = [];
justNeck    = logical(double(ROI_head_and_dend) - double(ROI_head_and_dend_temp));


A = justNeck;
B = spine_segment_k_binary;
C = seg_Dend_ROI;

compositeImage = cat(3, B+A, A, C+A);   

figure, imshow(imresize(compositeImage,1),[]);
set(gca,'YDir','normal');
axis off;
export_fig(fullfile(handles.foldername,'Neck',sprintf('spineNeck_%d_%d.png',spine_num,t)));
close;
%%
%%
linearIndexes = find(justNeck);

clear xy;
clear yRow;
clear xCol;
clear distances;
clear index1;
clear index2;
clear x1;
clear x2;
clear y1;
clear y2;
clear justNeck3D;

for k = 1 : length(linearIndexes)
    [yRow(k), xCol(k)] = ind2sub(size(justNeck), linearIndexes(k));
end

xy = [xCol', yRow'];

distances = pdist2(xy, xy);

% Find the max distance
maxDistance = max(distances(:));
% Find the indexes where it occurs
[index1, index2] = find(distances == maxDistance);
% Extract the x,y of the indexes.
x1 = xy(index1(1), 1);
y1 = xy(index1(1), 2);
x2 = xy(index2(1), 1);
y2 = xy(index2(1), 2);

idxnew1     = knnsearch([ShortestLineFinal(:,2),ShortestLineFinal(:,1)],[x1 y1]);
idxnew2     = knnsearch([ShortestLineFinal(:,2),ShortestLineFinal(:,1)],[x2 y2]);

justNeck3D  = ShortestLineFinal(min([idxnew1 idxnew2]):max([idxnew1 idxnew2]),:);

handles.neckPath{spine_num,t}   = ShortestLineFinal;
handles.justNeck3D{spine_num,t} = [];
handles.justNeck3D{spine_num,t} = justNeck3D;

if ischar(handles.zSpacingValue)            
    Path_microMeter = ShortestLineFinal.*[ones(1,size(ShortestLineFinal,1))*str2double(handles.xyPixelSizeValue);...
        ones(1,size(ShortestLineFinal,1))*str2double(handles.xyPixelSizeValue);...
        ones(1,size(ShortestLineFinal,1))*str2double(handles.zSpacingValue)]';

    Path_microMeter_justNeck = justNeck3D.*[ones(1,size(justNeck3D,1))*str2double(handles.xyPixelSizeValue);...
        ones(1,size(justNeck3D,1))*str2double(handles.xyPixelSizeValue);...
        ones(1,size(justNeck3D,1))*str2double(handles.zSpacingValue)]';
else            
    Path_microMeter = ShortestLineFinal.*[ones(1,size(ShortestLineFinal,1))*str2double(handles.xyPixelSizeValue);...
    ones(1,size(ShortestLineFinal,1))*str2double(handles.xyPixelSizeValue);...
    ones(1,size(ShortestLineFinal,1))*double(handles.zSpacingValue)]';

    Path_microMeter_justNeck = justNeck3D.*[ones(1,size(justNeck3D,1))*str2double(handles.xyPixelSizeValue);...
    ones(1,size(justNeck3D,1))*str2double(handles.xyPixelSizeValue);...
    ones(1,size(justNeck3D,1))*double(handles.zSpacingValue)]';
end

D            = diff(Path_microMeter,1,1);
D_justNeck   = diff(Path_microMeter_justNeck,1,1);

len          = trace(sqrt(D*D.'));
len_justNeck = trace(sqrt(D_justNeck*D_justNeck.'));



handles.neckPath{spine_num,t}                    = ShortestLineFinal;

handles.neckLenMicroMeters(spine_num,t)          = len;
handles.neckLenMicroMeters_justNeck(spine_num,t) = len_justNeck;

guidata(hObject, handles);

set(handles.statusWin,'String',sprintf('Fixed Spine Neck, Time Point : %d; Spine Number : %d',t,spine_num));

handles.Flags.autoNeckLegth = 1;
 
cd(handles.workingDir);

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function SingleTime_Callback(hObject, eventdata, handles)
% hObject    handle to SingleTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function TimesSeries_Callback(hObject, eventdata, handles)
% hObject    handle to TimesSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function singleChannelData_Callback(hObject, eventdata, handles)
% hObject    handle to singleChannelData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = load_singleTime_1Channel_Stack(handles);
% handles = statusUpdate(handles, hObject); 

guidata(hObject, handles);

% --------------------------------------------------------------------
function dendMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to dendMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function markDendEndPoints_Callback(hObject, eventdata, handles)
% hObject    handle to markDendEndPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.CropMask)
    handles.CropMask = logical(ones(size(bw1)));
end
   
handles.dendSkeletonSelectFig = figure;

imshow(handles.firstMIP,[]);
[x_pts, y_pts] = getpts_SpineS(handles.dendSkeletonSelectFig);
 
close(handles.dendSkeletonSelectFig);
 
SourcePoint3D = [y_pts(1); x_pts(1)];
StartPoint    = [y_pts(2); x_pts(2)];

for t = 1:handles.stackSize
    imgname    = fullfile(handles.foldername,'3DStacks','Registered',sprintf('registered_%d.tif', t));
    info       = imfinfo(imgname);
    num_images = numel(info);

    clear stack_unfilt;
    for z_slice_num = 1:num_images
        stack_unfilt(:,:,z_slice_num) = imread(imgname, z_slice_num);
    end

    [tempx,tempy] = sort(stack_unfilt,3);

    x3im = squeeze(tempx(:,:,end-2));
    y3im = squeeze(tempy(:,:,end));
    
    figure;
    imshow(y3im,[]);
    
    figure;
    imagesc(y3im);
    
    L   = watershed(y3im);
    rgb = label2rgb(L,'jet',[.5 .5 .5]);
    figure, imshow(rgb,'InitialMagnification','fit');
        
    cmask   = handles.CropMask;
    T       = graydist(x3im, ((cmask==0)));
    T       = T + eps;
    T       = 1./T;
    figure, imagesc(double(T));
    
    [ShortestLines] = shortestpath(double(T),StartPoint,SourcePoint3D,5);

    
    bw1crop = (double(x3im).*double(cmask));

    figure; imshow(x3im,[]);
    figure; imshow(bw1,[]);

    level    = graythresh(bw1crop);
    bw1      = imbinarize(bw1crop,level);
    
    bw1_thin = bwmorph(bw1,'thin','Inf');
    bw1_skel = bwmorph(bw1,'skel','Inf');
    maxIm    = double(max(x3im(:)));
    bwlast   = (double(bw1)+0.5*double(bw1_thin)+0.5*double(bw1_skel))+eps;
    
    DistanceMap3D        = msfm(double(bwlast), SourcePoint3D,true,true);
    [ShortestLines,flag] = shortestpath(DistanceMap3D,StartPoint,SourcePoint3D,5);

    figure, imshow(bwlast,[]);
    hold on;
    plot(ShortestLines(:,2),ShortestLines(:,1),'m');
end

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function markSpineStartingPositions_Callback(hObject, eventdata, handles)
% hObject    handle to markSpineStartingPositions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --- Executes during object deletion, before destroying properties.
function pointSelection_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to pointSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function twoChannelData_Callback(hObject, eventdata, handles)
% hObject    handle to twoChannelData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% --------------------------------------------------------------------
function Interleaved_2D_Callback(hObject, eventdata, handles)
% hObject    handle to Interleaved_2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = load_interleaved_singleTime_2Channel_Stack(handles);

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 
% --------------------------------------------------------------------
function Stacked_2D_Callback(hObject, eventdata, handles)
% hObject    handle to Stacked_2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = load_stacked_singleTime_2Channel_Stack(handles);

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);

% --------------------------------------------------------------------
function Interleaved_3D_Callback(hObject, eventdata, handles)
% hObject    handle to Interleaved_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = load_interleaved_singleTime_2Channel_Stack_3D(handles);

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);
 

% --------------------------------------------------------------------
function Stacked_3D_Callback(hObject, eventdata, handles)
% hObject    handle to Stacked_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = load_stacked_singleTime_2Channel_Stack_3D(handles);

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);

% --------------------------------------------------------------------
function quantifySpineNeckResults_Callback(hObject, eventdata, handles)
% hObject    handle to quantifySpineNeckResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Flags.autoNeckLegth == 1
    
    load(fullfile(handles.foldername,'Volumes','nanPositionsFull.mat'));        
    load(fullfile(handles.foldername,'Volumes','times.mat'));

    auto_neckLen        = handles.neckLenMicroMeters_justNeck.*nanPositionsFull;
    auto_normneckLen    = auto_neckLen./repmat(nanmean(auto_neckLen(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);

    figure,      
    tms                 = times.images-times.stimulus;
    meanControls        = nanmean(auto_neckLen,1);
    stdControls         = nanstd(auto_neckLen,1)./sqrt(repmat(size(auto_neckLen,1),1,size(auto_neckLen,2))-sum(isnan(auto_neckLen)));
    
    errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
    title('Neck Length');

    figure,      
    tms          = times.images-times.stimulus;
    plot(tms,auto_neckLen'.*nanPositionsFull','LineWidth',1,'Color','k');
    title('All Spines Necks'); ylabel('Neck Length'); xlabel('Time'); set(gca,'FontSize',16);
    saveas(gcf, fullfile(handles.foldername,'Neck','All_Spines_Neck_Len.eps'), 'epsc');
    close(gcf);
    
    figure,      
    tms                 = times.images-times.stimulus;
    meanControls        = nanmean(auto_normneckLen,1);
    stdControls         = nanstd(auto_normneckLen,1)./sqrt(repmat(size(auto_normneckLen,1),1,size(auto_normneckLen,2))-sum(isnan(auto_normneckLen)));
    
    errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
    title('Normalized Neck Length');

%     auto_neckPath_justNeck           = handles.neckPath_justNeck;
    auto_neckLenMicroMeters_justNeck = handles.neckLenMicroMeters_justNeck;
    auto_neckBasePoint_justNeck      = handles.neckBasePoint;

%     save(fullfile(handles.foldername,'Neck','auto_neckPath.mat'),'auto_neckPath');
    save(fullfile(handles.foldername,'Neck','auto_neckLenMicroMeters_justNeck.mat'),'auto_neckLenMicroMeters_justNeck');
%     save(fullfile(handles.foldername,'Neck','auto_neckBasePoint.mat'),'auto_neckBasePoint');
    
%     save(fullfile(handles.foldername,'Neck','auto_neckLen.mat'),'auto_neckLen');
%     save(fullfile(handles.foldername,'Neck','auto_normneckLen_justNeck.mat'),'auto_normneckLen_justNeck');
end


% --------------------------------------------------------------------
function exportExcel_Callback(hObject, eventdata, handles)
% hObject    handle to exportExcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Results to Export
 
javaaddpath('xlwrite/poi_library/poi-3.8-20120326.jar');
javaaddpath('xlwrite/poi_library/poi-ooxml-3.8-20120326.jar');
javaaddpath('xlwrite/poi_library/poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('xlwrite/poi_library/xmlbeans-2.3.0.jar');
javaaddpath('xlwrite/poi_library/dom4j-1.6.1.jar');
javaaddpath('xlwrite/poi_library/stax-api-1.0.1.jar');
 
% Result Folders
 
resultFolders    = {'FWHM','Intensity'};
resultSubFolders = {'Automatic','Manual'};
 
% Define an xls name
fileName         = 'Volumes.xlsx';
startRange       = 'B3';
 
k = 1;
for fn = 1:2
    for sfn = 1:2
        files = dir(fullfile(handles.foldername,'Volumes',resultFolders{fn},resultSubFolders{sfn},'*.mat'));
        for nf = 1:length(files)
            load(fullfile(handles.foldername,'Volumes',resultFolders{fn},resultSubFolders{sfn},files(nf).name));
            s = regexp(files(nf).name, '\.', 'split');
            if length(size(eval(s{1})))==2
                sheetName{k} = s{1};
                xlsData{k}   = eval(s{1});
                xlwrite(fullfile(handles.foldername,'Volumes','Volumes.xls'), xlsData{k},sheetName{k},startRange);
                k = k + 1;
            end
        end
    end
end

% NECK EXPORT
% Result Folders
 
resultFolders = {'Neck'};
fileName      = 'Neck.xlsx';
startRange    = 'B3';
 
k = 1;
files = dir(fullfile(handles.foldername,'Neck','*.mat'));

for nf = 1:length(files)

    load(fullfile(handles.foldername,resultFolders{nf},files(nf).name));

    s = regexp(files(nf).name, '\.', 'split');

    if length(size(eval(s{1})))==2
        sheetName_neck{k} = s{1};
        xlsData_neck{k} = eval(s{1});

        xlwrite(fullfile(handles.foldername,'Neck','Neck.xls'), xlsData_neck{k},sheetName_neck{k},startRange);
        k = k + 1;
    end
end


% --------------------------------------------------------------------
function helpBook_Callback(hObject, eventdata, handles)
% hObject    handle to helpBook (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

help_file_name = 'Help.pdf';
open(help_file_name);

%winopen('filename.pdf')

% --------------------------------------------------------------------
function aboutUs_Callback(hObject, eventdata, handles)
% hObject    handle to aboutUs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Please Check: http://spines.sabanciuniv.edu/');
url = 'http://spines.sabanciuniv.edu/';
web(url);

% --------------------------------------------------------------------
function helpMe_Callback(hObject, eventdata, handles)
% hObject    handle to helpMe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SingleChannelData_TS_Callback(hObject, eventdata, handles)
% hObject    handle to SingleChannelData_TS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TwoChannelData_TS_Callback(hObject, eventdata, handles)
% hObject    handle to TwoChannelData_TS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function manualSegmentationTool_Callback(hObject, eventdata, handles)
% hObject    handle to manualSegmentationTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in manualFWHMGUI.
function pushbuttonFWHM_Callback(hObject, eventdata, handles)
% hObject    handle to manualFWHMGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
sp              = get(handles.listbox3,'Value');    % Spine Number
t               = handles.timePoint;                  % Time Point
handles.imroi   = handles.ROIlist{sp,t};
 
img             = handles.imroi;
rotated_roi     = imrotate(img,handles.spinePositions(sp,t).angle);
 
axes(handles.axes2);
imshow(rotated_roi,[]);
 
% set(gca, 'units','normalized', 'outerposition',[0.2 0.3 .5 .2]);
 
set(handles.textSpine,'String',sp);
% set(gca, 'units','normalized', 'outerposition',[0.2 0.3 .5 .2]);
 
fwhmIm           = getimage;
handles.fwhmRect = imrect;
 
pos    = getPosition(handles.fwhmRect);
 
xMin   = floor(pos(1));
yMin   = floor(pos(2));
width  = floor(pos(3));
height = floor(pos(4));
 
clear pos;
clear fwhmRegion;
clear fwhmVal;
clear handles.imrect;
 
fwhmRegion = fwhmIm(yMin:(yMin+height),xMin:(xMin+width));

% axes(handles.axes3);
% imshow(fwhmRegion,[]);
 
% find maximum fwhm
xx = 1:size(fwhmRegion,2);
 
for fwhm_i = 1:(height+1)
    y = double(fwhmRegion(fwhm_i,:));
    [fitted_y(fwhm_i,:),goodness(fwhm_i),fwhmVal(fwhm_i)] = gaussFit1d_Ali_3(xx,y,1);
end
 
[fwhmValue,ind] = max(fwhmVal((goodness>0.95)&(fwhmVal<size(fwhmRegion,2))))

set(handles.status,'String', sprintf('%d',fwhmValue));
 
axes(handles.axes4);
plot(1:(width+1),double(fwhmRegion(ind,:))/double(max(fwhmRegion(ind,:))));
hold on
plot(xx,fitted_y(ind,:),'r');
hold off
axis tight;
 
sn = get(handles.listbox3,'Value');
tp = handles.timePoint;
 
handles.fwhmValueManual(sn,tp) = fwhmValue;
allfwhm = handles.fwhmValueManual;
allfwhm
xySize = str2double(handles.xyPixelSizeValue);
handles.fwhmValueManualRealSize(sn,tp) = fwhmValue*xySize; % pixel * micrometer
 
set(handles.fwhmPixelValue,'String',fwhmValue);
set(handles.fwhmRealValue,'String',fwhmValue*xySize);
 
handles.Flags.manualFWHM = 1;
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);


% --- Executes on button press in showChannelTwo.
function showChannelTwo_Callback(hObject, eventdata, handles)
% hObject    handle to showChannelTwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showChannelTwo

% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);


% --- Executes on button press in manualFWHMGUI.
function manualFWHMGUI_Callback(hObject, eventdata, handles)
% hObject    handle to manualFWHMGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sp              = get(handles.listbox3,'Value');    % Spine Number
t               = handles.timePoint;                  % Time Point
handles.imroi   = handles.ROIlist{sp,t};
img             = handles.imroi;
rotated_roi     = imrotate(img,handles.spinePositions(sp,t).angle);
 
axes(handles.axes2);
imshow(rotated_roi,[]);
 
% set(gca, 'units','normalized', 'outerposition',[0.2 0.3 .5 .2]);
 
%set(handles.textSpine,'String',sp);
% set(gca, 'units','normalized', 'outerposition',[0.2 0.3 .5 .2]);
 
fwhmIm           = getimage;
handles.fwhmRect = imrect;
pos              = getPosition(handles.fwhmRect);
 
xMin   = floor(pos(1));
yMin   = floor(pos(2));
width  = floor(pos(3));
height = floor(pos(4));
 
clear pos;
clear fwhmRegion;
clear fwhmVal;
clear handles.imrect;
 
fwhmRegion = fwhmIm(yMin:(yMin+height),xMin:(xMin+width));
% axes(handles.axes3);
% imshow(fwhmRegion,[]);
%  
% find maximum fwhm
xx = 1:size(fwhmRegion,2);
 
for fwhm_i = 1:(height+1)
    y = double(fwhmRegion(fwhm_i,:));
    [fitted_y(fwhm_i,:),goodness(fwhm_i),fwhmVal(fwhm_i)] = gaussFit1d_Ali_3(xx,y,1);
end
 
[fwhmValue,ind] = max(fwhmVal((goodness>0.95)&(fwhmVal<size(fwhmRegion,2))))

%set(handles.status,'String', sprintf('%d',fwhmValue));
 
axes(handles.axes4);

plot(1:(width+1),double(fwhmRegion(ind,:))/double(max(fwhmRegion(ind,:))));
hold on
plot(xx,fitted_y(ind,:),'r');
hold off
axis tight;
 
sn = get(handles.listbox3,'Value');
tp = handles.timePoint;
 
 
handles.fwhmValueManual(sn,tp) = fwhmValue;
allfwhm = handles.fwhmValueManual
xySize  = str2double(handles.xyPixelSizeValue);
handles.fwhmValueManualRealSize(sn,tp) = fwhmValue*xySize; % pixel * micrometer
 
set(handles.FWHMSizeTextChange,'String',fwhmValue*xySize);
 
handles.Flags.manualFWHM = 1;
 
% handles = statusUpdate(handles, hObject); 
guidata(hObject, handles);


function spineSizeTextChange_Callback(hObject, eventdata, handles)
% hObject    handle to spineSizeTextChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spineSizeTextChange as text
%        str2double(get(hObject,'String')) returns contents of spineSizeTextChange as a double


% --- Executes during object creation, after setting all properties.
function spineSizeTextChange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spineSizeTextChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FWHMSizeTextChange_Callback(hObject, eventdata, handles)
% hObject    handle to FWHMSizeTextChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FWHMSizeTextChange as text
%        str2double(get(hObject,'String')) returns contents of FWHMSizeTextChange as a double


% --- Executes during object creation, after setting all properties.
function FWHMSizeTextChange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FWHMSizeTextChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NeckLengthTextChange_Callback(hObject, eventdata, handles)
% hObject    handle to NeckLengthTextChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NeckLengthTextChange as text
%        str2double(get(hObject,'String')) returns contents of NeckLengthTextChange as a double


% --- Executes during object creation, after setting all properties.
function NeckLengthTextChange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NeckLengthTextChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spineDensityTextChange_Callback(hObject, eventdata, handles)
% hObject    handle to spineDensityTextChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spineDensityTextChange as text
%        str2double(get(hObject,'String')) returns contents of spineDensityTextChange as a double


% --- Executes during object creation, after setting all properties.
function spineDensityTextChange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spineDensityTextChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in previousTimeDend.
function previousTimeDend_Callback(hObject, eventdata, handles)
% hObject    handle to previousTimeDend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Flags.medianFilter == 1
 
    cla(handles.axes1,'reset');
    
    if handles.timePoint==1
        handles.timePoint = 1;
    else
        handles.timePoint = handles.timePoint - 1;
    end
 
    sn                      = get(handles.listbox3,'Value');
    tp                      = handles.timePoint;
 
    imName_Full             = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','MIP_Filtered_',tp,'.png'));
    img_Full                = imread(imName_Full);
 
    imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
    img_Full_dend           = imread(imName_Full_dend);
    
    img_Full_dend           = bwperim(img_Full_dend);
    
    axes(handles.axes1);
    C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(img_Full_dend),'blend','Scaling','joint');
    imshow(C,[]);

    set(handles.textDendriteTime,'String', sprintf('%d',handles.timePoint));
    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end

% --- Executes on button press in nextTimeDend.
function nextTimeDend_Callback(hObject, eventdata, handles)
% hObject    handle to nextTimeDend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Flags.medianFilter == 1
 
    cla(handles.axes1,'reset');
    
    if handles.timePoint==handles.stackSize
        handles.timePoint = handles.timePoint;
    else
        handles.timePoint = handles.timePoint + 1;
    end
 
    sn                      = get(handles.listbox3,'Value');
    tp                      = handles.timePoint;
 
    imName_Full             = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','MIP_Filtered_',tp,'.png'));
    img_Full                = imread(imName_Full);
 
    imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
    img_Full_dend           = imread(imName_Full_dend);
    
    img_Full_dend           = bwperim(img_Full_dend);
    
    axes(handles.axes1);
    C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(img_Full_dend),'blend','Scaling','joint');
    imshow(C,[]);

    set(handles.textDendriteTime,'String', sprintf('%d',handles.timePoint));
    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end


% --- Executes on button press in correctDendriteSeg.
function correctDendriteSeg_Callback(hObject, eventdata, handles)
% hObject    handle to correctDendriteSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sn                      = get(handles.listbox3,'Value');
tp                      = handles.timePoint;
 
imName_Full             = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','MIP_Filtered_',tp,'.png'));
img_Full                = imread(imName_Full);

imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
seg_img_correct         = imread(imName_Full_dend);

figure;
imshow(img_Full,[]);

seg_im_perim            = bwperim(seg_img_correct, 8);
[B,L]                   = bwboundaries(seg_im_perim,'noholes');
[y,x]                   = find(double(seg_im_perim)==1); % burdan x y coordinatlarini bulayim dedim

% xPixelSize
xyPixelSize             = str2double(handles.xyPixelSizeValue);
numScale                = round((sqrt(xyPixelSize))*1000);
x_y_downsample_indeces  = floor(1:(length(B{1})/numScale):length(B{1})); % burdan cok nokta cikiyor, bunlarin sayisini azaltayim dedim
h_new                   = impoly(gca, [B{1}(x_y_downsample_indeces, 2), B{1}(x_y_downsample_indeces, 1)]); % burdan o noktalari bana gostersin, bende degistireyim dedm
position                = wait(h_new);

setColor(h_new,'yellow');   


handles.SegMask         = createMask(h_new);

close(gcf);
 
imwrite(handles.SegMask, fullfile(handles.MIPfoldername,sprintf('segmentedDendrite_%d.png',tp)));

imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
seg_img_correct         = imread(imName_Full_dend);
bw_perim                = bwperim(seg_img_correct, 8);

axes(handles.axes1);
C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(bw_perim),'blend','Scaling','joint');
imshow(C,[]);

guidata(hObject, handles);


% --- Executes on button press in enlargeDendrite.
function enlargeDendrite_Callback(hObject, eventdata, handles)
% hObject    handle to enlargeDendrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sn                      = get(handles.listbox3,'Value');
tp                      = handles.timePoint;
 
imName_Full             = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','MIP_Filtered_',tp,'.png'));
img_Full                = imread(imName_Full);

imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
seg_img_correct         = imread(imName_Full_dend);

xyS                     = get(handles.xyPixelSize, 'string');
xPixelSize              = str2double(xyS);

ac_val                  = round(10*(0.0193/xPixelSize));

bw                      = activecontour(double(img_Full), seg_img_correct, ac_val, 'Chan-Vese','ContractionBias',-1,'SmoothFactor',1);
bw_perim                = bwperim(bw, 8);

imwrite(bw, fullfile(handles.MIPfoldername,sprintf('segmentedDendrite_%d.png',tp)));

% imwrite(dendSkel, fullfile(handles.MIPfoldername,sprintf('segmentedDendriteSkel_%d.png',tp)));

%%
axes(handles.axes1);
C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(bw_perim),'blend','Scaling','joint');
imshow(C,[]);

guidata(hObject, handles);


% --- Executes on button press in shrinkDendrite.
function shrinkDendrite_Callback(hObject, eventdata, handles)
% hObject    handle to shrinkDendrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


sn                      = get(handles.listbox3,'Value');
tp                      = handles.timePoint;
 
imName_Full             = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','MIP_Filtered_',tp,'.png'));
img_Full                = imread(imName_Full);

imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
seg_img_correct         = imread(imName_Full_dend);

xyS                     = get(handles.xyPixelSize, 'string');
xPixelSize              = str2double(xyS);

ac_val                  = round(10*(0.0193/xPixelSize));

bw                      = activecontour(double(img_Full), seg_img_correct, ac_val, 'Chan-Vese','ContractionBias',1,'SmoothFactor',1);
bw_perim                = bwperim(bw, 8);

imwrite(bw, fullfile(handles.MIPfoldername,sprintf('segmentedDendrite_%d.png',tp)));

% imwrite(dendSkel, fullfile(handles.MIPfoldername,sprintf('segmentedDendriteSkel_%d.png',tp)));

%%
axes(handles.axes1);
C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(bw_perim),'blend','Scaling','joint');
imshow(C,[]);

guidata(hObject, handles);


% --- Executes on button press in firstTime.
function firstTime_Callback(hObject, eventdata, handles)
% hObject    handle to firstTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Flags.autoSegmented == 1
 
    cla(handles.axes2,'reset');
    
    handles.timePoint = 1;
 
    sn                      = get(handles.listbox3,'Value');
    tp                      = handles.timePoint;
 
    imName                  = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_roi_k_10_',tp,'.png'));
    img                     = imread(imName);

    imName_Full             = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_k_10_',tp,'.png'));
    img_Full                = imread(imName_Full);
 
    imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
    img_Full_dend           = imread(imName_Full_dend);

    rotated_roi             = imrotate(img,handles.spinePositions(sn,tp).angle);
 
    axes(handles.axes2);
    imshow(rotated_roi,[]);
 
    img_Full_dend           = bwperim(img_Full_dend);
    
    axes(handles.axes1);
    C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(img_Full_dend),'blend','Scaling','joint');
    imshow(C,[]);

    set(handles.testTime,'String',tp);
 
    if handles.Flags.autoNeckLegth == 1
        try 
            compositeImage = combineROIandNeck(img,handles.neckPath{sn,tp},handles.justNeck3D{sn,tp});
            rotated_roi    = imrotate(compositeImage,handles.spinePositions(sn,tp).angle);

            axes(handles.axes2);
            imshow(rotated_roi,[]);
            
            updateSpineProperties(handles,sn,tp);
        catch
        end
    end
    
    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end
 

% --- Executes on button press in endTime.
function endTime_Callback(hObject, eventdata, handles)
% hObject    handle to endTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.Flags.autoSegmented == 1
 
    cla(handles.axes2,'reset');
    
    handles.timePoint = handles.stackSize;

    sn                      = get(handles.listbox3,'Value');
    tp                      = handles.timePoint;
 
    imName                  = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_roi_k_10_',tp,'.png'));
    img                     = imread(imName);
    
    imName_Full             = fullfile(handles.foldername,'Segmentation','Automatic',sprintf('%s%d','spine',sn),sprintf('%s%d%s','border_k_10_',tp,'.png'));
    img_Full                = imread(imName_Full);
 
    imName_Full_dend        = fullfile(handles.foldername,'MIP',sprintf('%s%d%s','segmentedDendrite_',tp,'.png'));
    img_Full_dend           = imread(imName_Full_dend);

    rotated_roi             = imrotate(img,handles.spinePositions(sn,tp).angle);
 
    axes(handles.axes2);
    imshow(rotated_roi,[]);
 
    img_Full_dend           = bwperim(img_Full_dend);
    
    axes(handles.axes1);
    C = imfuse(double(img_Full),(max(double(img_Full(:)))/2)*double(img_Full_dend),'blend','Scaling','joint');
    imshow(C,[]);
 
    set(handles.testTime,'String',tp);
 
    if handles.Flags.autoNeckLegth == 1 
        try
            compositeImage = combineROIandNeck(img,handles.neckPath{sn,tp},handles.justNeck3D{sn,tp});
            rotated_roi    = imrotate(compositeImage,handles.spinePositions(sn,tp).angle);
 
            axes(handles.axes2);
            imshow(rotated_roi,[]);
            
            updateSpineProperties(handles,sn,tp);
        catch
        end
    end
 
    % handles = statusUpdate(handles, hObject); 
    guidata(hObject, handles);
end


