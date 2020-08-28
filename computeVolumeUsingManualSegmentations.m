function computeVolumeUsingManualSegmentations(handles)

minIntensityOnImage = handles.dendMinVal;
medFlorValOnDend = handles.dendNormVal;

filePathSegmentations = fullfile(handles.foldername,'Segmentation','Automatic');
filePathMIP = fullfile(handles.foldername,'MIP');

load(fullfile(handles.foldername,'Volumes','sumCube.mat'));

manual_IntensityVolumes = nan(handles.spineCounter,handles.stackSize);
manual_sumSpineVolumes = manual_IntensityVolumes;
try
    for spnum = 1:handles.spineCounter 
        for timePoint = 1:handles.stackSize
                spineHead = imread(fullfile(handles.foldername,'Segmentation','Manual',sprintf('spine_%d_%d.png',spnum,timePoint)));

                spineHead = im2bw(spineHead);
                spineHead = imdilate(spineHead, ones(1));
                darkRegionArea = size(find(spineHead==1),1);

                imS = imrotate(imread(fullfile(filePathSegmentations,sprintf('spine%d',spnum),sprintf('ROI_%d.png',timePoint))),handles.spinePositions(spnum,timePoint).angle);
                tempSOI = double(sum(imS(spineHead == 1)));

                spineHeadDilated = spineHead;

                tempSpineHeadDilated = zeros(size(imS));

                [shx,shy] = find(spineHeadDilated == 1);
                tempSpineHeadDilated(shx(1):shx(end),shy(1):shy(end)) =...
                    imS(shx(1):shx(end),shy(1):shy(end));

                if minIntensityOnImage(timePoint) == 0
                    minIntensityOnImage(timePoint) = 1;
                end

                tempSOI = (tempSOI-(double(darkRegionArea*minIntensityOnImage(timePoint))))...
                    / double(medFlorValOnDend(timePoint));

                manual_IntensityVolumes(spnum,timePoint) = tempSOI;
                % SUm Spine

                ss_yMin = handles.spinePositions(spnum,timePoint).yMin;
                ss_xMin = handles.spinePositions(spnum,timePoint).xMin;
                ss_height = handles.spinePositions(spnum,timePoint).height;
                ss_width = handles.spinePositions(spnum,timePoint).width;

                tempSumSpine1 = squeeze(sumCube(:,:,timePoint));
                tempSumSpine = imrotate(tempSumSpine1(ss_yMin:ss_yMin+ss_height,ss_xMin:ss_xMin+ss_width),handles.spinePositions(spnum,timePoint).angle);

                sumSpineHead = double(sum(tempSumSpine(spineHead == 1)));

                tempSOIsumSpine = (sumSpineHead-(double(darkRegionArea*minIntensityOnImage(timePoint))))...
                / double(medFlorValOnDend(timePoint));

                manual_sumSpineVolumes(spnum,timePoint) = tempSOIsumSpine;       
        end
    end
end
save(fullfile(handles.foldername,'Volumes','Intensity','Manual','manual_IntensityVolumes.mat'),'manual_IntensityVolumes');
save(fullfile(handles.foldername,'Volumes','Intensity','Manual','manual_sumSpineVolumes.mat'),'manual_sumSpineVolumes');

