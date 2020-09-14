# SpineS
Dendritic Spine Analysis Software

% Main Developers

% Ali Ozgur Argunsah, Champalimaud Neuroscience Programme, 2011-2016

% Ali Ozgur Argunsah, University of Zurich, 2016-2020

% Ertunc Erdil, Sabanci University, 2012-2016

% Devrim Unay, Bahcesehir University, 2011-2016

% Muhammad Usman Ghani, Sabanci University, 2015-2016


% DEPENDENCIES AND RELATED COPYRIGHT INFORMATION:


% xlwrite:
% Copyright (c) 2013, Alec de Zegher
% All rights reserved.
% https://ch.mathworks.com/matlabcentral/fileexchange/38591-xlwrite-generate-xls-x-files-without-excel-on-mac-linux-win


% skeleton:
% Nicholas R. Howe, http://www.cs.smith.edu/~nhowe/research/code/


% jermanEnhancementFilter:
% BSD 3-Clause License
% Base code: Copyright (c) 2009, Dirk-Jan Kroon 
% Upgraded code: Copyright (c) 2017, Tim Jerman
% All rights reserved.
% https://github.com/timjerman/JermanEnhancementFilter/blob/master/LICENSE


% fastMarch:
% Copyright (c) 2009, Gabriel Peyre
% All rights reserved.
% https://ch.mathworks.com/matlabcentral/fileexchange/6110-toolbox-fast-marching


% bioformats:
% GNU General Public License v2.0
% https://github.com/ome/bio-formats-matlab/blob/master/LICENSE.txt



Please check the related paper in order to learn how to use and cite: https://doi.org/10.1101/2020.09.12.294546

Steps to Analyze a Dataset:

1: Start Matlab.
2: Change the Current Path of Matlab to SpineS folder.
3: Run install_SpineS.m in command window while in SpineS folder.
4: Run SpineS.m  while in SpineS folder.
5: Change pixel sizes (x- and y- pixel size in micrometers, z-spacing between z-slices in micrometers) and bit depth in lower right corner before importing a dataset. Play with the bit depth value to get the optimum results. (i.e. 11 bits might give better results sometimes even if your images are collected 12 bits. This is not going alter the volume and neck measurements, it is just to improve segmentation performence)
6: Read the paper. 
7: Send an e-mail to the first author if you face any problems.

