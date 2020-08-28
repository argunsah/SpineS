function computeVolumeWithCurveFitting(projectFolderName, lastTimePoint, spineCounter, spinePositions, medFlorValOnDend)

filePathSegmentations = fullfile(projectFolderName,'Segmentation','Automatic');
filePathMIP = fullfile(projectFolderName,'MIP');

% load(fullfile(projectFolderName,'Volumes','sumCube.mat'));

k = 10;
firstTimePoint = 1;

% sumOfIntensities = zeros(k, 1);
plotstyle = char('bx--', 'rx--', 'gx--');
normalizedSumIntensity = zeros(spineCounter, lastTimePoint);

for spnum = 1:spineCounter
    for timePoint = firstTimePoint:lastTimePoint
        if spnum == 1
            imageS{timePoint} = imread(fullfile(filePathMIP,sprintf('MIP_filtered_%d.png',timePoint)));
            minIntensityOnImage(timePoint)=min(min(imageS{timePoint}));
            % SUM Image
%             fname = fullfile(projectFolderName,...
%                     '3DStacks','Registered',sprintf('reg_%d.tif',timePoint));
%             info = imfinfo(fname);
%             num_images = numel(info);            
%             for z_slice_num = 1:num_images
%                 stack_unfilt(:,:,z_slice_num) = imread(fname, z_slice_num);
%             end
            load(fullfile(projectFolderName,...
                    'MIP',sprintf('SUM_%d.mat',timePoint)));
            
            imageS_SumImage{timePoint} = SUMimage;
            minIntensityOnImage_SumImage(timePoint) = min(min(imageS_SumImage{timePoint}));

            clear stack_unfilt;
        end
        
        try
            % Spine Segment Image
            spineHead = imread(fullfile(filePathSegmentations,sprintf('spine%d',spnum),sprintf('binary_k_%d_%d.png', k, timePoint)));    
        catch
            spineHead = zeros(51,51);
            spineHead(26,26)=1;
        end

        spineHead   = imbinarize(spineHead); %im2bw
        spineArea   = bwarea(spineHead);

        imMIP       = imageS{timePoint};
        imSum       = imageS_SumImage{timePoint};
        
        tempMIP_SOI = double(imMIP).*double(spineHead);
        tempSum_SOI = double(imSum).*double(spineHead);
        
        SOI_MIP = sum(sum(tempMIP_SOI));
        SOI_Sum = sum(sum(tempSum_SOI));

        SOI_MIP = SOI_MIP - (double(spineArea*minIntensityOnImage(timePoint)));
        SOI_Sum = SOI_Sum - (double(spineArea*minIntensityOnImage_SumImage(timePoint)));
        
        sumOfIntensities_MIP(spnum, timePoint) = SOI_MIP;
        sumOfIntensities_SUM(spnum, timePoint) = SOI_Sum;

        sumOfIntensities_MIP_normToDend(spnum, timePoint) = sumOfIntensities_MIP(spnum, timePoint) / double((medFlorValOnDend(timePoint)));%^1.17));%1.219
        sumOfIntensities_SUM_normToDend(spnum, timePoint) = sumOfIntensities_SUM(spnum, timePoint) / double((medFlorValOnDend(timePoint)));%^1.17));%1.219        
    end  
end

figure,      
tms = 1:(size(sumOfIntensities_SUM,2));
meanControls = nanmean(sumOfIntensities_SUM,1);
stdControls = nanstd(sumOfIntensities_SUM,1)./sqrt(repmat(size(sumOfIntensities_SUM,1),1,size(sumOfIntensities_SUM,2))-sum(isnan(sumOfIntensities_SUM)));
errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
title('Non-Normalized Integrated Flor. Intensity');
ylabel('Volume'); xlabel('Time'); set(gca,'FontSize',12);

saveas(gcf, fullfile(projectFolderName,'Volumes','Non_Normalized_Flor_Intensity.eps'), 'epsc');
close(gcf);

figure,      
tms = 1:(size(sumOfIntensities_SUM_normToDend,2));
meanControls = nanmean(sumOfIntensities_SUM_normToDend,1);
stdControls = nanstd(sumOfIntensities_SUM_normToDend,1)./sqrt(repmat(size(sumOfIntensities_SUM_normToDend,1),1,size(sumOfIntensities_SUM_normToDend,2))-sum(isnan(sumOfIntensities_SUM_normToDend)));
errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
title('Pre-Baseline Integrated Flor. Intensity (Normalized to Dend )');
ylabel('Volume'); xlabel('Time'); set(gca,'FontSize',12);
saveas(gcf, fullfile(projectFolderName,'Volumes','Pre_Baseline_Flor_Intensity.eps'), 'epsc');
close(gcf);

figure,      
tms = 1:(size(sumOfIntensities_MIP,2));
meanControls = nanmean(sumOfIntensities_MIP,1);
stdControls = nanstd(sumOfIntensities_MIP,1)./sqrt(repmat(size(sumOfIntensities_MIP,1),1,size(sumOfIntensities_MIP,2))-sum(isnan(sumOfIntensities_MIP)));
errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
title('MIP Non-Normalized Integrated Flor. Intensity');
ylabel('Volume'); xlabel('Time'); set(gca,'FontSize',12);
saveas(gcf, fullfile(projectFolderName,'Volumes','MIP_Non_Normalized_Flor_Intensity.eps'), 'epsc');
close(gcf);

figure,      
tms = 1:(size(sumOfIntensities_MIP_normToDend,2));
meanControls = nanmean(sumOfIntensities_MIP_normToDend,1);
stdControls = nanstd(sumOfIntensities_MIP_normToDend,1)./sqrt(repmat(size(sumOfIntensities_MIP_normToDend,1),1,size(sumOfIntensities_MIP_normToDend,2))-sum(isnan(sumOfIntensities_MIP_normToDend)));
errorbar(tms,meanControls,stdControls,'LineWidth', 2, 'MarkerSize', 12,'Color',[0 0 0],'Marker','o');
title('MIP Pre-Baselin Integrated Flor. Intensity (Normalized to Dend )');
ylabel('Dend. Norm. Volume'); xlabel('Time'); set(gca,'FontSize',12);
saveas(gcf, fullfile(projectFolderName,'Volumes','MIP_Pre_Baselin_Flor_Intensity.eps'), 'epsc');
close(gcf);

% Normalize to Baseline
auto_IntensityVolumes     = sumOfIntensities_SUM_normToDend;
auto_IntensityVolumes_MIP = sumOfIntensities_MIP_normToDend;

%auto_sumSpineVolumes = tempSOIsumSpine;

save(fullfile(projectFolderName,'Volumes','Intensity','Automatic','auto_IntensityVolumes.mat'),'auto_IntensityVolumes');
save(fullfile(projectFolderName,'Volumes','Intensity','Automatic','auto_IntensityVolumes_MIP.mat'),'auto_IntensityVolumes_MIP');

save(fullfile(projectFolderName,'Volumes','Intensity','Automatic','sumOfIntensities_MIP.mat'),'sumOfIntensities_MIP');
save(fullfile(projectFolderName,'Volumes','Intensity','Automatic','sumOfIntensities_SUM.mat'),'sumOfIntensities_SUM');

