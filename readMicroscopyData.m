function [info, fPath, fName, fExt, multiCube] = readMicroscopyData(fileName,numChannels,imresizeFlag,isMedianFilter,isPatrick)

[fPath, fName, fExt] = fileparts(fileName);
info = [];

switch lower(fExt)
  case '.mat'
        S = load(fileName);
        if isempty(info)
            info = struct;
        end
  case {'.png','.jpg','.pgm'}
        imdata = imread(fileName);
        if isempty(info)
            info = struct;
        end
  case {'.tif'}
        rTemp = bfopen(fileName);
        zSize = size(rTemp{1,1},1);
        
        h           = waitbar(0,'Loading Data...');
        % Create Z-Stack with Interleaved Channels
        for z = 1:zSize
            temp             = rTemp{1,1}{z,1};
            if isMedianFilter == 1
                cube(:,:,z)     = medfilt2(temp,[3 3]);
            else
                cube(:,:,z)     = temp;
            end
            if (z == zSize)
                metadata = rTemp{1,2};
            end
            waitbar(z/zSize,h);
        end  
        for ch = 1:numChannels
             multiCube(:,:,:,ch) = cube(:,:,ch:numChannels:end);
        end
        
        delete(h);

        if isempty(info)
            info = struct;
        end
    case {'.czi','.oib','.oif'}  % Under all circumstances SWITCH gets an OTHERWISE!
        if isPatrick == 0
            reader           = bfGetReader(fullfile(fileName));
            omeMetadata      = reader.getMetadataStore;

            voxelSizeX       = omeMetadata.getPixelsPhysicalSizeX(0).value; % in ?m
            voxelSizeXdouble = voxelSizeX.doubleValue(); 
            info.voxelSizeX  = voxelSizeX.doubleValue();
            % The numeric value represented by this object after conversion to type double
            voxelSizeY       = omeMetadata.getPixelsPhysicalSizeY(0).value; % in ?m
            voxelSizeYdouble = voxelSizeY.doubleValue();                                  % The numeric value represented by this object after conversion to type double
            info.voxelSizeY  = voxelSizeY.doubleValue();
            
            try
                voxelSizeZ       = omeMetadata.getPixelsPhysicalSizeZ(0).value; % in ?m
                voxelSizeZdouble = voxelSizeZ.doubleValue();
                info.voxelSizeZ  = voxelSizeZ.doubleValue();
            catch
            end
            
            omeMetadata.getImageName(0)

            num_series       = omeMetadata.getImageCount();

            % Create Info Structure
            info.totalCellCount = num_series;
            info.lastTimeIndex  = reader.getSizeT;
            info.ZStackSize     = reader.getSizeZ;
            info.dataFolder     = fPath;
            info.rawDataName    = fName;
            info.rawDataExt     = fExt;

            % delta T between planes
            info.deltaT             = double(omeMetadata.getPlaneDeltaT(0,0).value);
            info.totalTime          = info.deltaT*num_series*reader.getSizeT*reader.getSizeC*reader.getSizeZ;
            info.deltaTimePerCell   = info.deltaT*reader.getSizeZ*reader.getSizeC*num_series;
            
            % Check Cell Locations
            errorCounter = 0;
            try
                for series = 1:omeMetadata.getImageCount()
                    reader.setSeries(series-1);
                    X(series) = omeMetadata.getPlanePositionX(series-1,1-1).value.doubleValue;
                    Y(series) = omeMetadata.getPlanePositionY(series-1,1-1).value.doubleValue;
                    Z(series) = omeMetadata.getPlanePositionZ(series-1,1-1).value.doubleValue;
                end

                info.Xlocs = X;
                info.Ylocs = Y;
                info.Zlocs = Z;
            catch 
               errorCounter = errorCounter + 1;
               errorMessage{errorCounter} = 'No XYZ Positions Information';
            end

            if imresizeFlag == 1
                multiCube = zeros(1600,1600,reader.getSizeZ,reader.getSizeC,reader.getSizeT);
            else
                multiCube = zeros(reader.getSizeY,reader.getSizeX,reader.getSizeZ,reader.getSizeC,reader.getSizeT);
            end

            for series = 1:omeMetadata.getImageCount()
                reader.setSeries(series-1);
                for timepoint = 1: reader.getSizeT
                    for channel = 1: reader.getSizeC
                        for zplane = 1: reader.getSizeZ
                            % get linear index of the plane (1-based)
                            iPlane = reader.getIndex(zplane - 1, channel - 1, timepoint - 1) + 1;
                            if imresizeFlag == 1
                                multiCube(:,:,zplane,channel,timepoint) = imresize(bfGetPlane(reader, iPlane),[1600 1600]);
                            else
                                multiCube(:,:,zplane,channel,timepoint) = bfGetPlane(reader, iPlane);
                            end
                        end
                    end
                end
            end
        else
            reader           = bfGetReader(fullfile(fileName));
            multiCubePatrick = bfopen(fullfile(fileName));
            timepoint        = 1;
            
            for channel = 1: reader.getSizeC
                zS = 1;
                for zplane = channel:reader.getSizeC:size(multiCubePatrick{1,1},1)
                    multiCube(:,:,zS,channel,timepoint) = multiCubePatrick{1,1}{zplane,1};
                    zS = zS + 1;
                end
            end
            
            reader.getSizeZ
            reader.getSizeC
        end
end
%                         [registeredCube1,registeredCube3,shiftY(timepoint-1),shiftX(timepoint-1)] = registerAndCropGephyrin(firstTimePoint1,currentTimePoint1,currentTimePoint3); 

