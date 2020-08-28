function [MIPimage,Zimage,SUMimage] = calculateMIP(Icube)

% calculateMIP function calculates the MIP of the stack 

% i : stack id
% Ali Ozgur Argunsah, IGC, Lisbon; CCU, Lisbon; HIFO, Zurich.
% Last Update : April, 2017.

[MIPimage, Zimage] = max(Icube,[],3);
SUMimage = sum(Icube,3);

% 
% stdZ = stdfilt(Zimage);
% figure, imshow(SUMimage,[])
% figure, imagesc(Zimage);
% [val] = sort(Icube,3);
% MIPimage = squeeze(val(:,:,end));
% %MIPpos = squeeze(ind(:,:,end-1));
% 
% tempZslice = squeeze(Icube(:,:,floor(size(Icube,3)/2)));
% minZ = min(min(tempZslice));
% maxZ = max(max(tempZslice));
% 
% [minx_z,miny_z] = find(tempZslice==minZ);
% [maxx_z,maxy_z] = find(tempZslice==maxZ);
% 
% for k = 1:length(maxx_z)
% 
%     snr_curve(k,:) = squeeze(val(floor(maxx_z(k)),floor(maxy_z(k)),:))./...
%         squeeze(val(floor(minx_z(1)),floor(miny_z(1)),:));
% 
% end
% 
% [v,z_slice] = max(mean(snr_curve));
% 
% SNRimage = squeeze(val(:,:,z_slice));