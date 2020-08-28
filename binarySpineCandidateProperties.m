function [stats] = binarySpineCandidateProperties(tempImageBinary,spineId,k)

CC              = bwconncomp(tempImageBinary); %BW binary image

stats           = regionprops(CC, 'all');

