
function handles = correctBadSegmentations(hObject,handles,x,y,factor,k)

y_inds = ceil(y/factor);
x_inds = ceil(x/factor);

sp = y_inds;
tp = x_inds;

%[sp,tp] = find(isnan(nanPositions)==1);

 h_segment = waitbar(0, 'Bad Segmentations are being Corrected...');

for correction = 1:length(sp)

    waitbar(correction/length(sp),h_segment);
    
    fileO = fullfile(handles.Segfoldername,'Automatic',sprintf('spine%d',sp(correction)),sprintf('border_roi_k_%d_%d.png',k,tp(correction)));
    imO   = imread(fileO);

    % Find Scaled Translation from Mosaic Image to Rotated Image
    [sxO,syO]  = size(imO);

    y_before_C = floor(factor/2);
    x_before_C = floor(factor/2);

    y_C = floor(y(correction) - (y_inds(correction)-1)*factor);
    x_C = floor(x(correction) - (x_inds(correction)-1)*factor);

    dy = (y_C - y_before_C);
    dx = (x_C - x_before_C);

    dy = dy*(syO/factor);
    dx = dx*(sxO/factor);

    dx_org_unscaled = round(dx);
    dy_org_unscaled = round(dy);

    dxx = handles.spinePositions(sp(correction),tp(correction)).xMin + dx_org_unscaled;
    dyy = handles.spinePositions(sp(correction),tp(correction)).yMin + dy_org_unscaled;
    
    if dxx<1
        dxx = 1;
    end
    if dyy<1
        dyy = 1;
    end
        
    handles.spinePositions(sp(correction),tp(correction)).xMin = dxx;
    handles.spinePositions(sp(correction),tp(correction)).yMin = dyy;

    imCorrect = imread(fullfile(handles.foldername,'MIP',sprintf('MIP_filtered_%d.png',tp(correction))));

    xMin   = floor(handles.spinePositions(sp(correction),tp(correction)).xMin);
    yMin   = floor(handles.spinePositions(sp(correction),tp(correction)).yMin);
    height = floor(handles.spinePositions(sp(correction),tp(correction)).height);
    width  = floor(handles.spinePositions(sp(correction),tp(correction)).width);

    handles.imroi = imCorrect(yMin:(yMin+height),xMin:(xMin+width));
%     handles.dendroi = handles.dendPiece(yMin:(yMin+height),xMin:(xMin+width));

    handles.ROIlist{sp(correction),tp(correction)} = handles.imroi;
%     handles.ROIdend{sp(correction),tp(correction)} = handles.dendroi;

    [segmentedROI,segmentedROI_2,segmentedROI_3,Ix,Iy] = imsegmWaterShed(handles.ROIlist{sp(correction),tp(correction)}, handles.skelROIlist{sp(correction),tp(correction)}, handles.dendROIlist{sp(correction),tp(correction)});
    spineHead    = detectDendriteSpine(segmentedROI);
    
    if Ix < 200
        spineHead = imresize(spineHead,[Ix Iy],'nearest');
    end
    xyS         = get(handles.xyPixelSize, 'string');
    xPixelSize  = str2double(xyS);
    
    try % I added this because of empty image problem, Ali - May, 2014.
        graphBased(handles.ROIlist{sp(correction),tp(correction)}, spineHead, 10, imCorrect, ...
        handles.spinePositions(sp(correction),tp(correction)).xMin, handles.spinePositions(sp(correction),tp(correction)).yMin,...
        handles.spinePositions(sp(correction),tp(correction)).height, handles.spinePositions(sp(correction),tp(correction)).width,...
        fullfile(handles.Segfoldername,'Automatic'), sp(correction),tp(correction), handles.spinePositions(sp(correction),tp(correction)).angle, handles.dendROIlist{sp(correction),tp(correction)}, xPixelSize);
    catch turtle

    end

end

delete(h_segment);

