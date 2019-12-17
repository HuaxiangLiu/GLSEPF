%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of "A novel active contour model guided by global and local signed 
% energy-based pressure force" submiting to" submitting to IEEE Access
% Huaxiang Liu
% Central South University&&East China University of Technology, Changsha, 
% China
% 18th, Nov, 2019
% Email: felicia_liu@126.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;

addpath 'image';
ImgID = 7;

Img = imread([num2str(ImgID),'.bmp']);
I=Img;
[row,col,K] = size(Img);

if K>1
    Img = rgb2gray(Img);
end


%%%----parameters settings----------------------------------------------%%%
IterNum = 120;
mu = 10;
epsilon =1.5;
lambda1 = 1;
lambda2 = 1;
K = fspecial('gaussian',3, 1.0);
Img = imfilter(Img,K,'replicate');

%%%----Inintial contour curve-------------------------------------------%%%
phi = ones(size(Img(:,:,1))).*2;

switch ImgID
    case 1
        phi(19:56,51:62) = -2;
        position = 0;% 0: the intensity value in the object region is 
         sigma = 8;
    case 2
        phi(30:50,36:66) = -2;
        position = 0;
        sigma = 6;
    case 3
        phi(10:26,51:72) = -2;
        position = 0;
        sigma = 6;
    case 4        
        phi(19:26,51:62) = -2;
        position = 0;
        sigma = 5;
    case 5        
        phi(40:50,70:80) = -2;
        position = 1;
        sigma = 4;    
    case 6        
        phi(29:36,51:62) = -2;
        position = 0;
         sigma = 4;
    case 7        
        phi(29:36,51:62) = -2;
        position = 0;
        sigma = 7;
    case 8
        phi(19:26,51:62) = -2;
        position = 1; 
        sigma = 5;
    otherwise
        phi(1:10,1:10) = -2;
        position = 0;
end
u = phi;
figure,subplot(1,2,1);
imshow(I,[0 255]);
hold on;
[c, h] = contour(u, [0 0], 'r');
title('Initial contour');
hold off;
Img = double(Img);
Ksigma = fspecial('gaussian', round(2*sigma)*2+1, sigma);
[w1,w2] = computeweight(Img,sigma);
subplot(1,2,2);

for i=1:IterNum
    [u,e1,e2] = GLSEPF(w1,w2,Img,u, Ksigma,epsilon,position);
    if mod(i,10)==0
        pause(0.1);
        imshow(I, [0, 255]);colormap(gray);hold on;axis off,axis equal%imagesc
        [c,h] = contour(u,[0 0],'r');
        iterNum=[num2str(i), ' iterations'];
        title(iterNum);
        hold off;
    end
end
imshow(I,[0 255]);colormap(gray);hold on;
title('final segmentation results');
[c, h] = contour(u, [0 0], 'r','LineWidth', 1.5);



    
