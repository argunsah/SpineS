function [new_dend,dia,ddd]=dend_dia(dendrite,dend_skel,diaRatio)

dend_perim  = bwmorph(dendrite,'remove');
[dr,dc]     = find(dend_perim);
new_dend    = dendrite;

ndr         = dr;
ndc         = dc;

right       = 1;
left        = 1;

ddd1        = zeros(size(dendrite));
ddd2        = zeros(size(dendrite));
ddd3        = zeros(size(dendrite));

for i = 1:size(dend_skel,1)
    ddd1((round(dend_skel(i,1))),(round(dend_skel(i,2)))) = 1;
    ddd2((floor(dend_skel(i,1))),(floor(dend_skel(i,2)))) = 1;
    ddd3((ceil(dend_skel(i,1))),(ceil(dend_skel(i,2))))   = 1;
end

ddd = ddd1 | ddd2 | ddd3;

[IDX,D]         = knnsearch([dr,dc],[double(round(dend_skel(:,1))),double(round(dend_skel(:,2)))],'dist','euclidean');

gm              = fitgmdist(D,2,'RegularizationValue',0.5);
mus             = gm.mu;
vus             = gm.Sigma;
dia             = min(mus); % median(D)*diaRatio;
median(D)

dia             = min([dia,median(D)]);
se              = strel('disk',floor(dia));

new_dend        = imdilate(ddd,se);

