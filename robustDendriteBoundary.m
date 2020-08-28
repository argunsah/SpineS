function [new_dend,B,D,skelD] = robustDendriteBoundary(Icube, MIP,Zmax,CropMask,padValue,smoothingParam, filterSize, xPixelSize)
%     I : 2D image
%     sigmas : vector of scales on which the vesselness is computed
%     spacing : input image spacing resolution - during hessian matrix 
%         computation, the gaussian filter kernel size in each dimension can 
%         be adjusted to account for different image spacing for different
%         dimensions 
%     tau : (between 0.5 and 1) : parameter that controls response uniformity
%         - lower tau -> more intense output response            
%     brightondark: (true/false) : are vessels (tubular structures) bright on 
%         dark background or dark on bright (default for 2D is false)
%  
%   outputs,
%     vesselness: maximum vesselness response over scales sigmas
%  
%   example:
%     V = vesselness2D(I, 1:5, [1;1], 1, false);

temp_MIP    = MIP;

V           = vesselness2D(double(MIP),[xPixelSize 2*xPixelSize],[xPixelSize;xPixelSize], 1, true);
MIP         = (double(MIP) + max(double(MIP(:)))*V)/2;
se          = offsetstrel('ball',round(filterSize/3),round(filterSize/3));
dilatedI    = imdilate(MIP,se);

filterSize  = filterSize - 4;

if filterSize < 3
    filterSize = 3;
end

% if isstruct(Zmax)
%     Zmax = Zmax.Zimage;
% else
%     Zmax = Zmax;
% end
% 
% Iline       = double(Icube(:));
% Cline       = reshape(Iline,[size(Icube,1)*size(Icube,2) size(Icube,3)]);
% 
% allvar      = nanstd(Cline(:,2:end-1),[],2);
% IDX         = reshape(allvar , [size(Icube,1), size(Icube,2)]);
% IDX         = IDX./max(IDX(:));
% 
% stdz        = stdfilt(Zmax);
% imgZ        = stdz/max(stdz(:));
% imgZ        = imcomplement(imgZ);
% 
% wF_Z        = wiener2(double(imgZ),[filterSize filterSize]);
% bL_Z        = bilateralFilter(double(wF_Z));
% 
% thr         = graythresh(bL_Z);
% temp        = imbinarize(bL_Z,thr)&CropMask;
% 
% wF_MIP      = wiener2(double(MIP),[filterSize filterSize]);
% bL_MIP      = bilateralFilter(double(wF_MIP));
% 
% V_idx       = vesselness2D(max(double(Icube(:)))*double(IDX),4*xPixelSize,[xPixelSize;xPixelSize], 1, true);
% IDX         = (double(V_idx) + max(double(Icube(:)))*V_idx)/2;

[skelD,bw1crop_temp] = iterativeSkeletonSmooting(MIP, CropMask);
skelD                = skelD > 0;
skelD                = bwmorph(skelD, 'fill');
skelD                = imfill(skelD,'holes');

end_points           = bwmorph(bwmorph(skelD,'skel',inf),'endpoints');
[ex,ey]              = find(end_points==1);

pD                   = pdist([ex,ey], 'euclidean');
pZ                   = squareform(pD);

[ii,jj]              = find(pZ==max(pZ(:)));

clear t_all;
for f = 1:round(sqrt(filterSize)*2)
    t_all(:,:,f) = double(imdilate(skelD,strel('disk', f),'same'));
end

im_new_dist          = imgaussfilt(mean(t_all,3),2)/(2*size(MIP,1));
im_new_dist          = im_new_dist/max(im_new_dist(:));

distanceMap_skelD_1  = msfm(im_new_dist+0.0001,[ex(ii(2)) ey(jj(1))]', true, true);
ShortestLine_skelD_1 = shortestpath(distanceMap_skelD_1,[ex(ii(1)) ey(jj(2))]',[ex(ii(2)) ey(jj(1))]',2);

distanceMap_skelD_2  = msfm(im_new_dist+0.0001,[ex(ii(1)) ey(jj(2))]', true, true);
ShortestLine_skelD_2 = shortestpath(distanceMap_skelD_2,[ex(ii(2)) ey(jj(1))]',[ex(ii(1)) ey(jj(2))]',2);

meanSL_skelD         = meanOfTwoLines(ShortestLine_skelD_1,ShortestLine_skelD_2);

% figure, imshow(max(Icube,[],3),[]);
% hold on, plot(meanSL_skelD(:,2),meanSL_skelD(:,1),'r');

cA      = consAngles(meanSL_skelD,MIP);
cA      = movmean(cA,filterSize);
sf      = fit([1:length(cA)]', cA, 'poly1' );
cA      = cA - sf([1:length(cA)]');
cA_thr  = 2*std(cA);
cA_thr2 = 2*std(diff(cA));

threshed_cA                         = cA;
threshed_cA(threshed_cA > cA_thr)   = nan;
threshed_cA(threshed_cA < -cA_thr)  = nan;

threshed_cA(diff(cA) > cA_thr2)     = nan;
threshed_cA(diff(cA) < -cA_thr2)    = nan;

threshed_cA(1:5)                    = nan;
threshed_cA(end:end-4)              = nan;
threshed_cA(end+1)                  = nan;

% figure, plot(cA), hold on, plot(threshed_cA,'r');

A = meanSL_skelD;
A(isnan(threshed_cA),1) = nan;
A(isnan(threshed_cA),2) = nan;

B = inpaint_nans(A',1);
B = B';

beg_end = round(size(B,1)/50);
B(end-beg_end-1:end,:)  = [];
B(1:beg_end,:)          = [];

bw1crop                 = bw1crop_temp > 0;
[new_dend,D,skelD]      = dend_dia(bw1crop,B,1);
% 
% figure, imshow(max(Icube,[],3),[]);
% hold on, plot(B(:,2),B(:,1),'r');
%
%
% 
% figure, imshow(double(temp_MIP)+im_new_dist*100,[]);
% hold on, plot(meanSL_skelD(:,2),meanSL_skelD(:,1),'.b');
% hold on, plot(B(:,2),B(:,1),'.r');
% 
% 
% Zsmooth         = imdilate(skelD,strel('disk', filterSize),'same');
% 
% dMIP            = double(MIP);
% dMIP            = dMIP/max(dMIP(:));
% 
% [lb,center]     = adaptcluster_kmeans(dMIP);
% [skr,rad]       = skeletonSpineS((lb>1)&CropMask);
% skel            = bwmorph(skr > 35,'skel',inf);
% [dmap,exy,jxy]  = anaskel(skel);
% 
% 
% StartPoint{1}   = [exy(2,1)   ; exy(1,1)];
% StartPoint{2}   = [exy(2,end) ; exy(1,end)];
% StartPoint{3}   = [jxy(2,1)   ; jxy(1,1)];
% StartPoint{4}   = [jxy(2,end) ; jxy(1,end)];
% 
% skel2           = imdilate(skel,[se1 se2],'same');
% 
% totalSkel       = imfill(skel2|Zsmooth,'holes');
% 
% distanceMap     = msfm(double(totalSkel)+0.01,StartPoint{1}, true, true);
% ShortestLine    = shortestpath(distanceMap,StartPoint{2},StartPoint{1},1);
% 
% distanceMap2    = msfm(double(totalSkel)+0.01,StartPoint{2}, true, true);
% ShortestLine2   = shortestpath(distanceMap2,StartPoint{1},StartPoint{2},1);
% 
% meanSL          = meanOfTwoLines(ShortestLine,ShortestLine2);
% meanSL          = smooth2Dline(meanSL,.1);
% 
% distanceMap3    = msfm(double(totalSkel)+0.01,StartPoint{3}, true, true);
% ShortestLine3   = shortestpath(distanceMap3,StartPoint{4},StartPoint{3},1);
% 
% distanceMap4    = msfm(double(totalSkel)+0.01,StartPoint{4}, true, true);
% ShortestLine4   = shortestpath(distanceMap4,StartPoint{3},StartPoint{4},1);
% 
% 
% meanSL2         = meanOfTwoLines(ShortestLine3,ShortestLine4);
% meanSLFinal     = meanOfTwoLines(meanSL,meanSL2);
% 
% bw1crop         = bw1crop_temp > 0;
% 
% [new_dend2,D2,skelD2] = dend_dia(bw1crop,meanSL_skelD,1);
% 
% figure, imshow(skelD2,[]);
% hold on, plot(meanSLFinal(:,2),meanSLFinal(:,1),'r');










%%
% 
% outerdisk = strel('disk', 6);
% J = bwmorph(totalSkel,'bridge');
% figure
% imshow(totalSkel)
%  figure
% imshow(J-totalSkel)
%  
% regions  = detectMSERFeatures(MIP,'MaxAreaVariation',1,'ThresholdDelta',2);
% [regions, mserCC] = detectMSERFeatures(totalSkel);
%  
%     % Show all detected MSER REgions
%     figure
%     imshow(totalSkel)
%  
% 
% windowWidth     = round((300*xPixelSize))*2+1;
% polynomialOrder = 3;
% smoothX         = sgolayfilt(meanSLFinal(:,1), polynomialOrder, windowWidth);
% smoothY         = sgolayfilt(meanSLFinal(:,2), polynomialOrder, windowWidth);
% 
% figure, imshow(MIP,[]);
% hold on, plot(meanSLFinal(:,2),meanSLFinal(:,1),'r');
% hold on, plot(smoothY,smoothX,'g');
% 
% for k = 1:10
%     meanSLFinal     = smooth2Dline(meanSLFinal,rand);
% end
% slopes = diff(meanSLFinal(:,1)) ./ diff(meanSLFinal(:,2));
% slopes = abs([0 ;slopes]);
% figure, imshow(MIP,[]);
% hold on, plot(meanSLFinal(:,2),meanSLFinal(:,1),'r');
% 
% %%
% 
% figure, imshow(bw1crop,[]);
% hold on, plot(meanSLFinal(:,2),meanSLFinal(:,1),'r');
% hold on, plot(vq1,xq,'g');
% %%
% figure, imshow(MIP,[]);
% hold on, plot(meanSL2(:,2),meanSL2(:,1),'g');

% 
% clear sL;
% clear meanSL;
% 
% meanSL          = meanOfTwoLines(ShortestLine,ShortestLine2);
% 
% bw1crop         = bw1crop_temp > 0;
% 
% [new_dend,D,skelD] = dend_dia(bw1crop,meanSL,1);
% 
% figure, imshow(Zsmooth,[]);
% 
% dend_skel(:,1) = medfilt1(double(meanSL(:,1)),53);
% dend_skel(:,2) = medfilt1(double(meanSL(:,2)),53);
% 
% figure, imshow(MIP,[]);
% hold on, plot(dend_skel(:,2),dend_skel(:,1),'r');
% hold on, plot(meanSL(:,2),meanSL(:,1),'g');
% 
% dMIP            = double(MIP);
% dMIP            = dMIP/max(dMIP(:));
% 
% [lb,center]     = adaptcluster_kmeans(dMIP);
% [skr,rad]       = skeletonSpineS(lb>1);
% skel            = bwmorph(skr > 35,'skel',inf);
% [dmap,exy,jxy]  = anaskel(skel);
% 
% 
% Ds    = pdist2(jxy',jxy','seuclidean');
% maxDs = max(Ds(:));
% [xDs,yDs] = find(Ds==maxDs);
% 
% 
% 
% 
% IND = [exy';jxy']';
% D = bwdistgeodesic(lb>1,IND(1,:),IND(2,:),'quasi-euclidean');
% 
% 
% figure, imagesc(D);
% hold on, scatter(exy(1,[1 end]),exy(2,[1 end]),'g.');
% hold on, scatter(jxy(1,[1 end]),jxy(2,[1 end]),'r*');
% 
% [lb,center] = adaptcluster_kmeans(lb>1);
% figure,
% imshow(dMIP);
% 
% distanceMap     = msfm(double(Zsmooth)+epsmin,SourcePoint, true, true);
% ShortestLine    = shortestpath(distanceMap,StartPoint,SourcePoint,1);
% 
% distanceMap2    = msfm(double(Zsmooth)+epsmin,StartPoint, true, true);
% ShortestLine2   = shortestpath(distanceMap2,SourcePoint,StartPoint,1);
% 
% clear sL;
% clear meanSL;
% 
% meanSL          = meanOfTwoLines(ShortestLine,ShortestLine2);
% 
% bw1crop         = bw1crop_temp > 0;
% 
% [new_dend,D,skelD] = dend_dia(bw1crop,meanSL,1);
% 
% 
% 
% 
% filterSize = filterSize - 4;
% 
% if filterSize < 3
%     filterSize = 3;
% end
% 
% if isstruct(Zmax)
%     Zmax = Zmax.Zimage;
% else
%     Zmax = Zmax;
% end
% 
% Iline       = double(Icube(:));
% Cline       = reshape(Iline,[size(Icube,1)*size(Icube,2) size(Icube,3)]);
% 
% allvar      = nanstd(Cline(:,2:end-1),[],2);
% IDX         = reshape(allvar , [size(Icube,1), size(Icube,2)]);
% IDX         = IDX./max(IDX(:));
% 
% thr         = graythresh(IDX);
% bw          = IDX>thr;
% 
% dMIP        = double(MIP);
% dMIP        = dMIP/max(dMIP(:));
% 
% [lb,center] = adaptcluster_kmeans(dMIP);
% [skr,rad]   = skeletonSpineS(lb>1);
% skel        = bwmorph(skr > 35,'skel',inf);
% 
% figure,
% imshow(dMIP);
% % try different thresholds besides 35 to see the effects
% 
% % anaskel returns the locations of endpoints and junction points
% [dmap,exy,jxy] = anaskel(skel);
% hold on
% plot(exy(1,:),exy(2,:),'go');
% plot(jxy(1,:),jxy(2,:),'ro');
% 
% [lb,center] = adaptcluster_kmeans(lb>1);
% 
% stdz = stdfilt(Zmax);
% imgZ = stdz/max(stdz(:));
% imgZ = imcomplement(imgZ);
% 
% wF_Z = wiener2(double(imgZ),[filterSize filterSize]);
% bL_Z = bilateralFilter(double(wF_Z));
% figure, imshow(bL_Z,[]);
% 
% thr  = graythresh(bL_Z);
% temp = imbinarize(bL_Z,thr);
% figure, imshow(temp,[]);
% 
% wF_MIP = wiener2(double(MIP),[filterSize filterSize]);
% bL_MIP = bilateralFilter(double(wF_MIP));
% 
% [skelD,bw1crop_temp] = iterativeSkeletonSmooting(IDX, temp, CropMask);
% 
% skelD   = skelD > 0;
% skelD   = bwmorph(skelD, 'fill');
% B       = bwmorph(skelD, 'branchpoints');
% B_loc   = find(B);
% [y2,x2] = find(B);
% Dmask2  = false(size(skelD));
% 
% for k = 1:numel(x2)
%     D1 = bwdistgeodesic(skelD,x2(k),y2(k));
%     [distanceToEndtoEntPt(k), ind(k)] = max(D1(B_loc));
%     Dmask2(D1 < distanceToEndtoEntPt(k)) = true;
% end
% 
% inds = unique(ind);
% 
% StartPoint      = [y2(inds(1)),x2(inds(1))]';
% SourcePoint     = [y2(inds(2)),x2(inds(2))]';
% smoothingParam  = filterSize;
% 
% se1             = strel('line',filterSize,0);
% se2             = strel('line',filterSize,90);
% Zsmooth         = imdilate(skelD,[se1 se2],'same');
% 
% ZsmoothOriginal = Zsmooth;
%  
% r               = floor(filterSize/2);
% SE              = strel('diamond',r);
% 
% ZsmoothOriginal = imdilate(ZsmoothOriginal, SE);
% 
% Zsmooth = Zsmooth | ZsmoothOriginal;
% 
% epsmin = 1e-8;
% 
% distanceMap   = msfm(double(Zsmooth)+epsmin,SourcePoint, true, true);
% ShortestLine  = shortestpath(distanceMap,StartPoint,SourcePoint,1);
% 
% distanceMap2  = msfm(double(Zsmooth)+epsmin,StartPoint, true, true);
% ShortestLine2 = shortestpath(distanceMap2,SourcePoint,StartPoint,1);
% 
% clear sL;
% clear meanSL;
% 
% meanSL  = meanOfTwoLines(ShortestLine,ShortestLine2);
% 
% bw1crop = bw1crop_temp > 0;
% 
% [new_dend,D,skelD] = dend_dia(bw1crop,meanSL,1);

%%

% figure, imshow(bw1crop,[]);
% 
% dend_skel(:,1) = medfilt1(double(meanSL(:,1)),53);
% dend_skel(:,2) = medfilt1(double(meanSL(:,2)),53);
% 
% figure, imshow(MIP,[]);
% hold on, plot(dend_skel(:,2),dend_skel(:,1),'r');
% hold on, plot(meanSL(:,2),meanSL(:,1),'g');


% skel_im_longest = zeros(size(bw1crop));
% for i = 1:size(meanSL,1)
%     skel_im_longest(floor(meanSL(i,1)),floor(meanSL(i,2))) = 1;
% end

%     [u,l] = tiltsxy(bw1crop,meanSL(:,2),meanSL(:,1));
%     u_ver = circshift(skel_im_longest,u);
%     l_ver = circshift(skel_im_longest,l);
%     Im = logical(u_ver + l_ver);
% 
% se1         = strel('disk',filterSize*3);
% 
% bw1cropComp = imcomplement(bw1crop);
% 
% bw1cropCompErr     = imerode(bw1cropComp,se1,'same');
% bw1cropCompDil     = imdilate(bw1cropCompErr,se1,'same');
% 
% figure, imshow(imcomplement(bw1cropCompDil));
% 

% num_iter = filterSize*3;
% bw1crop  = activecontour(double(MIP),bw1crop,num_iter,'edge','ContractionBias',1,'SmoothFactor',1.5); 

%%
% 
% ddd = zeros(size(bw1crop));
% for i = 1:size(meanSL,1)
%     ddd((round(meanSL(i,1))),(round(meanSL(i,2)))) = 1;
% end

% figure, imshow(double(MIP)+50*double(bwperim(new_dend,8)),[]);
% 
% skelD = bwmorph(new_dend,'thin',Inf);

% [new_dend_1,D_1] = dend_dia(bw1crop,meanSL,1);
% new_dend_1 = bwmorph(new_dend_1,'spur',1000);
% new_dend_1 = bwmorph(new_dend_1,'clean');
% new_dend_1 = bwmorph(new_dend_1,'majority');
% new_dend_1 = imfill(new_dend_1,'holes');
% 
% [new_dend_2,D_2] = dend_dia(bw1crop,meanSL,1);
% new_dend_2 = bwmorph(new_dend_2,'spur',1000);
% new_dend_2 = bwmorph(new_dend_2,'clean');
% new_dend_2 = bwmorph(new_dend_2,'majority');
% new_dend_2 = imfill(new_dend_2,'holes');
% 
% 
% % [new_dend,D] = dend_dia(bw1crop,meanSL,1);
% % 
% % new_dend = bwmorph(new_dend,'spur',1000);
% % new_dend = bwmorph(new_dend,'clean');
% % new_dend = bwmorph(new_dend,'majority');
% % 
% 
% [new_dend,D] = dend_dia(new_dend_1&new_dend_2,meanSL,1);
% 
% new_dend = bwmorph(new_dend,'spur',1000);
% new_dend = bwmorph(new_dend,'clean');
% new_dend = bwmorph(new_dend,'majority');
% 
% new_dend = imfill(new_dend,'holes');
% 
% skelD = bwmorph(new_dend,'thin',Inf);

% 
% [skelDnew,bw1crop_temp_New] = iterativeSkeletonSmooting(double(MIP).*double(new_dend), temp, CropMask);
% 
% Zsmooth_new = imfill(ZsmoothOriginal|skelDnew,'holes');
% 
% 
% figure, imshow(Zsmooth_new,[])
% 
% 
% 
% S=skeleton(Zsmooth_new);
%   % Display the skeleton
%     figure, imshow(ZsmoothOriginal); hold on;
%     for i=1:length(S)
%       L=S{i};
%       plot(L(:,2),L(:,1),'-','Color',rand(1,3));
%     end


% figure, imshow(double(MIP)+50*double(new_dend),[])
% 
% 
% figure, imshow(double(bw1crop)+double(new_dend)+double(bwmorph(new_dend,'skel',Inf)),[])
% figure, imshow(double(MIP)+50*double(bwmorph(new_dend,'skel',Inf))+50*double(bwmorph(bw1crop,'skel',Inf)),[])
% 
% 
% figure, imshow(double(MIP)+100*double(bwmorph(new_dend,'thin',Inf)),[])
% 


% 
% XXX = randn(100,5);
%        YYY = randn(25, 5);
%        [idx, dist] = knnsearch(ShortestLine,ShortestLine2,'dist','cityblock','k',2);
%  
%        
% [temp, dist] = knnsearch([ShortestLine,[ShortestLine2(:,2),ShortestLine2(:,1)],'dist','euclidean','k',1);
%         
% spineNeckBaseAtSkeletonCenter = unique([skel_x(temp),skel_y(temp)], 'rows');
% 
% 
% 
% temp2 = zeros(size(bw1crop));
% for kk = 1:numel(ShortestLine(:,1))
%     temp2(floor(ShortestLine(kk,1)),floor(ShortestLine(kk,2))) = 1;  
% end
% figure, imshow(bw1crop+temp2,[]);
% 
% % Plot the shortest route
% hold on, plot(ShortestLine(:,2),ShortestLine(:,1),'r');
% 
% skel2 = berk_test_Ali(bw1crop,temp2);
% figure, imshow(double(MIP)+100*double(temp2)+100*double(skel2),[]);
% figure, imshow(MIP,[]);

%%

% 
% numClusters = 10;
% 
% [IDX, C] = kmeans(Cline, numClusters, 'Distance', 'cityblock');
% IDX      = reshape(IDX , [size(Icube,1), size(Icube,2)]);
% 
% 
% figure, imshow(IDX,[]);
% 
% 
% maxI = max(IcubeFiltered,[],3);
% maxI = maxI/max(maxI(:));
% 
% figure
% imshow(imresize(imresize(maxI,.1,...
%     'lanczos3','Antialiasing',true),10,...
%     'nearest','Antialiasing',true),[]);
% 
% 
% [r,f] = vl_mser(maxI,'MinDiversity',0.7,...
%                 'MaxVariation',0.2,...
%                 'Delta',10) ;
% 
%             figure,
%             imshow(squeeze(max(IcubeFiltered,[],3)),[]);
% 
% f = vl_ertr(f) ;
% vl_plotframe(f) ;
% 
% regions  = detectMSERFeatures(max(IcubeFiltered,[],3),'MaxAreaVariation',1,'ThresholdDelta',2);
% 
% [d,f] = vl_sift(single(max(IcubeFiltered,[],3)));
% 
% % Visualize MSER regions which are described by pixel lists stored 
% % inside the returned 'regions' object
% figure
% imshow(squeeze(max(IcubeFiltered,[],3)),[]);
% 
% hold on, scatter(d(1,:),d(2,:));
% 
% hold on
% plot(regions, 'showPixelList', true, 'showEllipses', false)
% 
% allvar = nanstd(Cline(:,2:end-1),[],2);
% IDX      = reshape(allvar , [size(Icube,1), size(Icube,2)]);
% figure, imshow(IDX,[]);
% 
% allvar2 = allvar;
% allvar2(allvar2<0.1*10^6) = 0;
% 
% IDX      = reshape(allvar , [size(Icube,1), size(Icube,2)]);
% figure, imshow(IDX,[]);
% 
% 
% figure, imshow(max(IcubeFiltered,[],3),[]);
%  

