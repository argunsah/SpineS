function handles = load_interleaved_singleTime_2Channel_Stack(handles)

set(handles.statusWin,'String',sprintf(...
    'Select a single channel wingle time Z-Stack to be analyzed.'));

D1 = uipickfiles;
handles.stackSize = 1;
 
% Results folder Name selection
prompt = {'Enter the directory name to save results or leave blank :'};
name = 'Directory Name';
numlines = 1;
defaultSize = {''};
 
folderName = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
 
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

handles.foldername    = folderName;
handles.MIPfoldername = fullfile(folderName,'MIP');
handles.Segfoldername = fullfile(folderName,'Segmentation');
handles.volumesFolder = fullfile(folderName,'Volumes');
handles.ThreeDfolder  = fullfile(folderName,'3DStacks','Raw');
handles.neckFolder    = fullfile(folderName,'Neck');
 
handles = createFolders(handles);

stackSize = size(D1,2);
 
% Load default BitDepth Value
bitDepthValue = str2double(get(handles.bitDepth,'string'));
 
s = 1;
rTemp = bfopen(D1{s});
zSize = size(rTemp{1,1},1);

z_interleaved = 1;
z_last = zSize/2;

for z = 1:2:zSize
    
    Icube(:,:,z_interleaved)  = imresize(rTemp{1,1}{z,1}, 2, 'bicubic', 'Antialiasing', true);
    Icube2(:,:,z_interleaved) = imresize(rTemp{1,1}{z+1,1}, 2, 'bicubic', 'Antialiasing', true);

    temp = Icube(:,:,z_interleaved);
    temp2 = Icube2(:,:,z_interleaved);

    if str2double(get(handles.bitDepth,'string')) ~= 8
        temp = uint8((double(temp) / ((2^str2double(get(handles.bitDepth,'string')))-1)) * ((2^8)-1)); % BitDepth Adaptation nbits to 8bits
        temp2 = uint8((double(temp2) / ((2^str2double(get(handles.bitDepth,'string')))-1)) * ((2^8)-1)); % BitDepth Adaptation nbits to 8bits    
    end
    Icropped(:,:,z) = padarray(temp,[handles.padValue,handles.padValue]);
    Icropped2(:,:,z) = padarray(temp2,[handles.padValue,handles.padValue]);
 
    imwrite(temp, fullfile(handles.foldername,'3DStacks','Registered','registered_1.tif'),'WriteMode','append','Compression','none');
    imwrite(temp2, fullfile(handles.foldername,'3DStacks','Registered','registered_1_ch2.tif'),'WriteMode','append','Compression','none');
    
    z_interleaved = z_interleaved + 1;
end
 
save(fullfile(handles.foldername,'3DStacks','Raw',sprintf('raw_%d.mat',s)),'Icube');
save(fullfile(handles.foldername,'3DStacks','Raw',sprintf('raw_%d_ch2.mat',s)),'Icube2');

[MIPimage, SNRimage, SumImage] = calculateMIP(Icube);
MIPimage = uint8((double(MIPimage) / ((2^str2double(get(handles.bitDepth,'string')))-1)) * ((2^8)-1)); % BitDepth Adaptation nbits to 8bits
 
imwrite(MIPimage, fullfile(handles.MIPfoldername,sprintf('MIP_%d.png',s)));
    
tempSumCube(:,:,1) = SumImage;
    
imwrite(MIPimage, fullfile(handles.MIPfoldername,sprintf('MIPcropped_%d.png', s)));
 
set(handles.statusWin,'String',sprintf('MIP Completed'));
 
firstTimePoint = MIPimage;
 
axes(handles.axes1);
imshow(firstTimePoint, []);
 
handles.firstMIP = firstTimePoint;

handles.timePoint = 1;
handles.Flags.importStack = 1;
handles.twoChannelData = 1;
 