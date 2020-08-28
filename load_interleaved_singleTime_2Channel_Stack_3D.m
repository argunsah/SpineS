function handles = load_interleaved_singleTime_2Channel_Stack_3D(handles)

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
 
stackSize = size(D1,2);
 
% Load default BitDepth Value
bitDepthValue = handles.bitDepth; %str2double(get(handles.bitDepth,'string'));
bitdepth      = str2double(get(handles.bitDepth,'String'));

h_MIP         = waitbar(0, 'Maximum Intensity Projection and Registration in Progress...');

shiftX(1)     = 0;
shiftY(1)     = 0;

for i = 1:handles.stackSize   

    waitbar(i/handles.stackSize,h_MIP);
    
    [multiCube,info] = load_bioformats_initial(D1{i});
    
    zSize = size(multiCube,3);
    
    Icube = squeeze(multiCube(:,:,:,1));
    
    if i == 1
        icubeOne = Icube;
        save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('raw_%d.mat',i)),'Icube');
    end
    
    if i > 1
        [Icube, shiftY(i), shiftX(i)] = registerAndCropMultiChannel(Icube,icubeOne);
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
     
     IcubeCropped  = padarray(cropAfterCircularShift3D(Icube,maxx,maxy,minx,miny),[handles.padValue,handles.padValue],0,'both');
     
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

set(handles.dataLoadText, 'BackgroundColor', 'green');

handles = statusUpdate(handles, hObject);
guidata(hObject, handles);

%%
set(handles.statusWin,'String',sprintf(...
    'Select a single channel wingle time Z-Stack to be analyzed.'));

D1 = uipickfiles;
handles.stackSize = size(D1,2);
 
% Results folder Name selection
prompt      = {'Enter the directory name to save results or leave blank :'};
name        = 'Directory Name';
numlines    = 1;
defaultSize = {''};
 
folderName  = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
 
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
 
handles   = createFolders(handles);

stackSize = handles.stackSize;
 
% Load default BitDepth Value
bitDepthValue = str2double(get(handles.bitDepth,'string'));

prompt      = {'Which channel is for Structure?:'};
name        = 'Channel Number';
numlines    = 1;
defaultSize = {''};
 
structure_Channel     = cell2mat(inputdlg(prompt,name,numlines,defaultSize));
structure_Channel_num = str2num(structure_Channel);

for s = 1:stackSize;
    rTemp = bfopen(D1{s});
    zSize = size(rTemp{1,1},1);

     if size(rTemp{1,1}{1,1},1) < 256
         imresPar = round(256 / size(rTemp{1,1}{1,1},1));
         handles.xyPixelSizeValue = num2str(str2double(handles.xyPixelSizeValue))/imresPar;
         handles.xyPixelSize = handles.xyPixelSizeValue;
     else
         imresPar = 1;
     end
         
    z_interleaved = 1;
    z_last = zSize/2;

    for z = 1:2:zSize

        if structure_Channel_num == 1
            Icube(:,:,z_interleaved)  = medfilt2(imresize(rTemp{1,1}{z,1}, imresPar, 'bicubic', 'Antialiasing', true),[3 3]);
            Icube2(:,:,z_interleaved) = medfilt2(imresize(rTemp{1,1}{z+1,1}, imresPar, 'bicubic', 'Antialiasing', true),[3 3]);
        else 
            Icube2(:,:,z_interleaved) = medfilt2(imresize(rTemp{1,1}{z,1}, imresPar, 'bicubic', 'Antialiasing', true),[3 3]);
            Icube(:,:,z_interleaved)  = medfilt2(imresize(rTemp{1,1}{z+1,1}, imresPar, 'bicubic', 'Antialiasing', true),[3 3]);
        end
        
        z_interleaved = z_interleaved + 1;
    end

        save(fullfile(handles.foldername,'3DStacks','Raw',sprintf('raw_%d.mat',s)),'Icube');
        save(fullfile(handles.foldername,'3DStacks','Raw',sprintf('raw_%d_ch2.mat',s)),'Icube2');

        [MIPimage, SNRimage, SumImage]    = calculateMIP(Icube);
        [MIPimage2, SNRimage2, SumImage2] = calculateMIP(Icube2);

        if str2double(get(handles.bitDepth,'string')) ~= 8
            MIPimage  = uint8((double(MIPimage) / ((2^str2double(get(handles.bitDepth,'string')))-1)) * ((2^8)-1)); % BitDepth Adaptation nbits to 8bits
            MIPimage2 = uint8((double(MIPimage2) / ((2^str2double(get(handles.bitDepth,'string')))-1)) * ((2^8)-1)); % BitDepth Adaptation nbits to 8bits    
        end
        
        imwrite(MIPimage , fullfile(handles.MIPfoldername,sprintf('MIP_%d.png',s)));
        imwrite(MIPimage2, fullfile(handles.MIPfoldername,sprintf('MIP_%d_ch2.png',s)));
% 
%         Icropped(:,:,z) = padarray(temp,[handles.padValue,handles.padValue]);
%         Icropped2(:,:,z) = padarray(temp2,[handles.padValue,handles.padValue]);
% 
%         
%         imwrite(temp, fullfile(handles.foldername,'3DStacks','MIP',sprintf('%s%d%s','registered_',s,'.tif')),'WriteMode','append','Compression','none');
%         imwrite(temp2, fullfile(handles.foldername,'3DStacks','Registered',sprintf('%s%d%s','registered_',s,'ch2.tif')),'WriteMode','append','Compression','none');

        if s>1
            if s == 2
                firstTimePoint = imread(fullfile(handles.MIPfoldername,'MIP_1.png'));
            end
            if ismac
                bestTransformation = -1*landmarkBasedRegistrationGlobalMac(adapthisteq(firstTimePoint),  adapthisteq(MIPimage));
            else
                bestTransformation = -1*landmarkBasedRegistrationGlobal(adapthisteq(firstTimePoint),  adapthisteq(MIPimage));
            end

            bty(s) = bestTransformation(1);
            btx(s) = bestTransformation(2);

            MIPimage  = circshift(MIPimage,bestTransformation);
            MIPimage2 = circshift(MIPimage2,bestTransformation);

            tempSumCube(:,:,s)  = circshift(SumImage,bestTransformation);
            tempSumCube2(:,:,s) = circshift(SumImage2,bestTransformation);

            zSize = size(Icube,3);

            for z = 1:zSize
                Icube(:,:,z)  = circshift(squeeze(Icube(:,:,z)) ,bestTransformation);
                Icube2(:,:,z) = circshift(squeeze(Icube2(:,:,z)),bestTransformation);
            end
        end
        
    IcircShifted = Icube;
    IcircShifted2 = Icube2;

    save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('shifted_%d.mat',s)),'IcircShifted');
    save(fullfile(handles.foldername,'3DStacks','Registered',sprintf('shifted_%d_ch2.mat',s)),'IcircShifted2');

    imwrite(MIPimage , fullfile(handles.MIPfoldername,sprintf('MIPCircShift_%d.png', s)));
    imwrite(MIPimage2, fullfile(handles.MIPfoldername,sprintf('MIPCircShift_%d_ch2.png', s)));

    clear Icube;
    clear Icube2;
end

if s>1
    maxx = max(btx(2:end));
    minx = min(btx(2:end));
    maxy = max(bty(2:end));
    miny = min(bty(2:end));
else
    maxx = 0;
    minx = 0;
    maxy = 0;
    miny = 0;
end

for m = 1:stackSize

    im  = imread(fullfile(handles.MIPfoldername,sprintf('MIPCircShift_%d.png', m)));
    im2 = imread(fullfile(handles.MIPfoldername,sprintf('MIPCircShift_%d_ch2.png', m)));

    tempImCube(:,:,m)  = padarray(cropAfterCircularShift(im,maxx,maxy,minx,miny),[handles.padValue,handles.padValue]);
    sumCube(:,:,m)     = padarray(cropAfterCircularShift(tempSumCube(:,:,m),maxx,maxy,minx,miny),[handles.padValue,handles.padValue]);

    tempImCube2(:,:,m) = padarray(cropAfterCircularShift(im2,maxx,maxy,minx,miny),[handles.padValue,handles.padValue]);
    sumCube2(:,:,m)    = padarray(cropAfterCircularShift(tempSumCube2(:,:,m),maxx,maxy,minx,miny),[handles.padValue,handles.padValue]);

    imwrite(squeeze(tempImCube(:,:,m)) , fullfile(handles.MIPfoldername,sprintf('MIPcropped_%d.png', m)));
    imwrite(squeeze(tempImCube2(:,:,m)), fullfile(handles.MIPfoldername,sprintf('MIPcropped_%d_ch2.png', m)));

    clear im;
    clear im2;

    load(fullfile(handles.foldername,'3DStacks','Registered',sprintf('shifted_%d.mat', m)));
    load(fullfile(handles.foldername,'3DStacks','Registered',sprintf('shifted_%d_ch2.mat', m)));

    clear Icropped;
    clear Icropped2;

    zSize = size(IcircShifted,3);

    for z = 1:zSize
        temp  = cropAfterCircularShift(squeeze(IcircShifted(:,:,z)),maxx,maxy,minx,miny);
        temp2 = cropAfterCircularShift(squeeze(IcircShifted2(:,:,z)),maxx,maxy,minx,miny);

        if str2double(get(handles.bitDepth,'string')) ~= 8
            temp  = uint8((double(temp) / ((2^str2double(get(handles.bitDepth,'string')))-1)) * ((2^8)-1)); % BitDepth Adaptation nbits to 8bits
            temp2 = uint8((double(temp2) / ((2^str2double(get(handles.bitDepth,'string')))-1)) * ((2^8)-1)); % BitDepth Adaptation nbits to 8bits
        end
        Icropped(:,:,z)  = padarray(temp,[handles.padValue,handles.padValue]);
        Icropped2(:,:,z) = padarray(temp2,[handles.padValue,handles.padValue]);

        imwrite(Icropped(:,:,z) , fullfile(handles.foldername,'3DStacks','Registered',sprintf('registered_%d.tif',m)),'WriteMode','append','Compression','none');
        imwrite(Icropped2(:,:,z), fullfile(handles.foldername,'3DStacks','Registered',sprintf('registered_%d_ch2.tif',m)),'WriteMode','append','Compression','none');
    end  
end

% 
% save(fullfile(handles.foldername,'3DStacks','Raw',sprintf('raw_%d.mat',s)),'Icube');
% save(fullfile(handles.foldername,'3DStacks','Raw',sprintf('raw_%d_ch2.mat',s)),'Icube2');
% 
% [MIPimage, SNRimage, SumImage] = calculateMIP(Icube);
% MIPimage = uint8((double(MIPimage) / ((2^str2double(get(handles.bitDepth,'string')))-1)) * ((2^8)-1)); % BitDepth Adaptation nbits to 8bits
%  
% imwrite(MIPimage, fullfile(handles.MIPfoldername,sprintf('MIP_%d.png',s)));
%     
% tempSumCube(:,:,1) = SumImage;
%     
% imwrite(MIPimage, fullfile(handles.MIPfoldername,sprintf('MIPcropped_%d.png', s)));
%  

set(handles.statusWin,'String',sprintf('MIP Completed'));
 
firstTimePoint = imread(fullfile(handles.MIPfoldername,'MIPcropped_1.png'));
 
axes(handles.axes1);
imshow(firstTimePoint, []);
 
handles.firstMIP = firstTimePoint;

handles.timePoint = 1;
handles.Flags.importStack = 1;
handles.twoChannelData = 1;
 