function updateSpineProperties(handles,sn,tp)

load(fullfile(handles.foldername,'Volumes','Intensity','Automatic','auto_IntensityVolumes.mat'));
% load(fullfile(handles.foldername,'Volumes','Intensity','Automatic','auto_IntensityVolumes_MIP.mat'));
load(fullfile(handles.foldername,'Volumes','nanPositionsFull.mat'));        
% load(fullfile(handles.foldername,'Volumes','times.mat'));

auto_IntensityVolumes       = auto_IntensityVolumes.*nanPositionsFull;
% auto_MIPSpineVolumes        = auto_IntensityVolumes_MIP.*nanPositionsFull;
% 
% auto_normIntensityVolumes   = auto_IntensityVolumes./repmat(nanmean(auto_IntensityVolumes(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);
% auto_normMIPSpineVolumes    = auto_MIPSpineVolumes./repmat(nanmean(auto_MIPSpineVolumes(:,1:handles.lastBaselinePoint),2),1,handles.stackSize);


if handles.Flags.manualFWHM == 1
    try
        set(handles.FWHMSizeTextChange,'String', sprintf('%.3f',handles.fwhmValueManual(sn,tp)));
    end
end


if handles.Flags.autoIntensity == 1
    try
        set(handles.spineSizeTextChange,'String', sprintf('%.3f',auto_IntensityVolumes(sn,tp)));
    end
end


if handles.Flags.autoNeckLegth == 1
    try
        set(handles.NeckLengthTextChange,'String', sprintf('%.3f',handles.neckLenMicroMeters_justNeck(sn,tp)));
    end
end

 