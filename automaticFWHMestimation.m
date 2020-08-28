function automaticFWHMestimation(projectFolderName, lastTimePoint, spineCounter, dendrite, spinePositions, xySize)

k = 7; % 10 before - Made it 7 for stability

firstTimePoint = 1;

autoFWHMs = nan(spineCounter,lastTimePoint);
autoFWHMbasedVolumes = autoFWHMs;

for spnum = 1:spineCounter 
    for timePoint = firstTimePoint:lastTimePoint
         if spnum == 1
             imageS{timePoint} = imread(fullfile(projectFolderName,'MIP',sprintf('MIPcropped_%d.png',timePoint)));
         end
            try
                spineHead = imread(fullfile(projectFolderName, 'Segmentation','Automatic',sprintf('spine%d',spnum),sprintf('binary_k_%d_%d.png', k, timePoint)));
            catch
                spineHead = zeros(51,51);
                spineHead(26,26)=1;
            end
try % Check this line and correct the problem properly, ali september 2014
                [v1, v2, v3, g1, g2, g3] = AutoFWHM_v2(imageS{timePoint}, spineHead,dendrite, 'false',spinePositions(spnum,timePoint).angle,1); %true to check images of fwhm axes
end
                g = [g1 g2 g3];
                v = [v1 v2 v3];
                
                ind_g = (g>=0.95);
                
                vs = v(ind_g);
                if sum(ind_g)==0
                    Rval = nan;
                else
                    Rval = mean(vs(~isnan(vs)));
                end

                RvalReal = Rval*xySize;
                
                auto_FWHMValues(spnum, timePoint) = Rval;
                auto_FWHMValuesRealSize(spnum, timePoint) = RvalReal;
                auto_FWHMVolumes(spnum, timePoint) = 4/3*(pi*(Rval/2)^3);
                auto_FWHMVolumesRealSize(spnum, timePoint) = 4/3*(pi*(RvalReal/2)^3);
    
    end 
end

save(fullfile(projectFolderName,'Volumes','FWHM','Automatic','auto_FWHMValues.mat'),'auto_FWHMValues');
save(fullfile(projectFolderName,'Volumes','FWHM','Automatic','auto_FWHMVolumes.mat'),'auto_FWHMVolumes');

save(fullfile(projectFolderName,'Volumes','FWHM','Automatic','auto_FWHMValuesRealSize.mat'),'auto_FWHMValuesRealSize');
save(fullfile(projectFolderName,'Volumes','FWHM','Automatic','auto_FWHMVolumesRealSize.mat'),'auto_FWHMVolumesRealSize');


