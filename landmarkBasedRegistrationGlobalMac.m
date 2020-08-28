function bestTransformation = landmarkBasedRegistrationGlobalMac(im1, im2)
 
% im1 = double(imread('im7_1.png'));
% im2 = double(imread('im7_2.png'));

I1 = double(im1);
I2 = double(im2);

I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
I2=I2-min(I2(:)) ;
I2=I2/max(I2(:)) ;

[frames1,descr1,gss1,dogss1] = siftMac( I1, 'verbosity',0,'boundarypoint',1) ;
[frames2,descr2,gss2,dogss2] = siftMac( I2, 'verbosity',0,'boundarypoint',1) ;

desc1 = descr1';
desc2 = descr2';

locs1 = frames1';
locs2 = frames2';

clear frames1;
clear frames2;
clear descr1;
clear descr2;

[match1, angles, locations] = match(im1, im2, desc1, desc2, locs1, locs2, 0.9);

indices = find(match1 ~= 0);
match1  = match1(indices);
angles  = angles(indices);

roundedAngles     = round(angles);
maxRepeatedAngles = mode(roundedAngles);

indices = find(roundedAngles == maxRepeatedAngles);

translations = zeros(length(indices), 2); %(x, y)

for i = 1:length(indices)
    translations(i, 1) = locations(indices(i), 2) - size(im1, 2) - locations(indices(i), 1);
    translations(i, 2) = locations(indices(i), 4) - locations(indices(i), 3);
end

x = sort(translations(:, 1));
y = sort(translations(:, 2));
len = round(length(x) * 0.20);

x = x(len:(end - len));
y = y(len:(end - len));

x = round(mean(x));
y = round(mean(y));

% im1 = uint8(im1);
% visualizer(uint8(im2), im2bw(im1, graythresh(im1)), 0.4, '');
 
% se = translate(strel(1), [y x]);
% im1 = imdilate(im1, se);

bestTransformation = [0 x y]; %[y x] -> [x y] in Mac

% h = figure, visualizer(uint8(im2), im2bw(im1, graythresh(im1)), 0.4, '');
% saveas(h, sprintf('registered_%d', id), 'png');
% plot(1:length(find(angles > 0)), angles(find(angles > 0)), 'x');

