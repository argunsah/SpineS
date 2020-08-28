% Compile .c and .cpp files using mex function
% You should have a compiles installed in order for mex to run
% If you are using a Mac Computer, Install XCode from Apple website, it is
% free. If you are using Windows machine, you can download MinGW.
% Or Better Read This: https://www.mathworks.com/support/requirements/supported-compilers.html

% email me if you need help: aoargunsah@gmail.com
% Put This Line on the Subject Line Only: SpineS Install Problem

% This mex compiler part has nothing to do with SpineS, so any IT knowing person
% with some experience with Matlab can help you.

% For Support From Different Microscopes, Check: https://github.com/ome/bio-formats-matlab

% Ali Ozgur Argunsah, November 11, 2019.
% Zurich, Switzerland.

current_dir = pwd;

cd(fullfile(pwd,'fastMarch','functions'));

clear msfm2d
mex -compatibleArrayDims msfm2d.c;

clear msfm3d
mex -compatibleArrayDims msfm3d.c;

cd('..');
cd('..');

cd(fullfile(pwd,'fastMarch','shortestpath'));

clear rk4
mex -compatibleArrayDims rk4.c;

cd('..');
cd('..');

cd(fullfile(pwd,'JermanFilt'));

clear eig3volume
mex -compatibleArrayDims eig3volume.c;

cd('..');

cd(fullfile(pwd,'Skeleton'));

clear analskel
mex -compatibleArrayDims anaskel.cpp;

clear skeleton
mex -compatibleArrayDims skeleton.cpp;

clear skeleton
mex -compatibleArrayDims skeletonSpineS.cpp;

cd('..');

addpath(genpath(pwd));
