function [multiCube,info] = load_bioformats_initial(fileName)

[fPath, fName, fExt] = fileparts(fileName);
info                 = [];

reader               = bfGetReader(fullfile(fileName));
omeMetadata          = reader.getMetadataStore;

voxelSizeX           = omeMetadata.getPixelsPhysicalSizeX(0).value; % in ?m
voxelSizeXdouble     = voxelSizeX.doubleValue(); 
info.voxelSizeX      = voxelSizeX.doubleValue();

% The numeric value represented by this object after conversion to type double
voxelSizeY           = omeMetadata.getPixelsPhysicalSizeY(0).value; % in ?m
voxelSizeYdouble     = voxelSizeY.doubleValue();                                  % The numeric value represented by this object after conversion to type double
info.voxelSizeY      = voxelSizeY.doubleValue();

try
    voxelSizeZ       = omeMetadata.getPixelsPhysicalSizeZ(0).value; % in ?m
    voxelSizeZdouble = voxelSizeZ.doubleValue();
    info.voxelSizeZ  = voxelSizeZ.doubleValue();
catch
end

omeMetadata.getImageName(0)

for series = 1:omeMetadata.getImageCount()
    reader.setSeries(series-1);
    for timepoint = 1: reader.getSizeT
        for channel = 1: reader.getSizeC
            for zplane = 1: reader.getSizeZ
                iPlane = reader.getIndex(zplane - 1, channel - 1, timepoint - 1) + 1;
                multiCube(:,:,zplane,channel,timepoint) = bfGetPlane(reader, iPlane);
            end
        end
    end
end