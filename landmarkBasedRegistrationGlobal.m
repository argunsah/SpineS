function bestTransformation = landmarkBasedRegistrationGlobal(im1, im2)
 
% im1 = double(imread('im7_1.png'));
% im2 = double(imread('im7_2.png'));

im1 = double(im1);
im2 = double(im2);

[obs1, desc1, locs1] = sift(im1);
[obs2, desc2, locs2] = sift(im2);
clear obs1;
clear obs2;

[match1, angles, locations] = match(im1, im2, desc1, desc2, locs1, locs2, 0.9);
indices = find(match1 ~= 0);
match1 = match1(indices);
angles = angles(indices);

roundedAngles = round(angles);
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

bestTransformation = [y x];

%figure, visualizer(uint8(im2), im2bw(im1, graythresh(im1)), 0.4, '');
% saveas(h, sprintf('registered_%d', id), 'png');
% plot(1:length(find(angles > 0)), angles(find(angles > 0)), 'x');

