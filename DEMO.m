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

[tform fixpoints movingpoints] = SelectFeatures(I,J); 

%%

tform= fitgeotrans(movingpoints, fixpoints,'projective');
I2 = imwarp(I,tform,'OutputView', imref2d(size(I)));

figure
col = 'rgbymc';

subplot(131)
imshow(I); hold on 
for i = 1:6
scatter(movingpoints(i,1),movingpoints(i,2),['+' col(i)])
end
title('Moving image')


subplot(132)
imshow(J); hold on 
for i = 1:6    
scatter(fixpoints(i,1),fixpoints(i,2),['+' col(i)])
end
title('Fix image')

subplot(133)
imshow(I2); hold on 
title('Transformation ')
%% Apply same transformation to the Retino matrix


%%
clear M J2

tform= fitgeotrans( fixpoints,movingpoints,'projective');
J2 = imwarp(J,tform,'OutputView', imref2d(size(I)));

J2 = double(J2);
J2(find(J2==0)) = nan;
reshape(J2,[504 504]);

M(:,:,2) = double(I);
M(:,:,3) = (RX.*-100);
M(:,:,4) = (RY.*-100);
M(:,:,5) = double(J2);
hf2 = figure ;
hs = slice(M,[],[],[2: 5]) ;
shading interp
set(hs,'FaceAlpha',0.8);
caxis([-10 200])
colormap(gray)
zlim([0 6])
view([110   25])

%%

