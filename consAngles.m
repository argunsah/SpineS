function cA = consAngles(meanSL_skelD,MIP)

len         = size(meanSL_skelD,1);

temp        = meanSL_skelD(1:end-1,:);
temp2       = meanSL_skelD(2:end,:);

temp(:,1)   = temp(:,1) - size(MIP,2);
temp2(:,1)  = temp2(:,1) - size(MIP,2);

dxy         = temp2 - temp;
cA          = atand(dxy(:,1)./dxy(:,2));
cA          = (-1*cA);
