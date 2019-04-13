%% Demo: Brute Force Registration 
%
%-------------------------------------------
% by Giacomo Benvenuti
% <giacomox@gmail.com>
% Repository
% https://github.com/giacomox/RetinoMapModel
%-------------------------------------------

%% Load test images
% we load two test images 'I' and 'J'. They have been shooted in the same 
% cortical area at two different moments in time, with different lenses and 
% camera rotation. The resolution is pretty bad and the vasculature has 
% changed a bit between the first and second shoot. For this reason automatic 
% registration algoritms are not very good in matching these two images. 

load ./test_data/images.mat

%% Display test images

% Adjust contrast 
I = imadjust(I);
J = imadjust(J);

% Display
figure; 
subplot(121); imshow(I); 
subplot(122); imshow(J);

%% Select the same features in the two images
% We need to define some global variable that will be 
% modified by our function
global Trans_Param_GUI Selected_Points RetinoMask
T = SelectFeatures(I,J); %delete(gcf)
