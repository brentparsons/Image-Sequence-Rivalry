function [imageTexture imagetexPointer] = rd_makeRivalryImageTexture(window, imageFilePathLeft, imageFilePathRight)

% Given two image file paths, create an image texture with one image on the left and the other
% on the right in rivalry fashion.
%
% Rachel Denison
% July 2009

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global pixelsPerDegree;

if isempty(pixelsPerDegree)
    pixelsPerDegree = 99; % this is with NEC Monitor with subject sitting 5 feet from the screen. 1280 x 1024 pixel fullscreen.
    display ('in present rivalry targets - passing global variable ppd did not work');
end;

global spaceBetweenMultiplier;
if isempty(spaceBetweenMultiplier)
    spaceBetweenMultiplier = 2;
    display ('error is passing global sbm in present rivalry targs...');
end;

% ---------------------------------
% Color Setup
% ---------------------------------
% Gets color values.

% Retrieves color codes for black and white and gray.
black = BlackIndex(window);  % Retrieves the CLUT color code for black.
white = WhiteIndex(window);  % Retrieves the CLUT color code for white.
gray = (black + white) / 2;  % Computes the CLUT color code for gray.


% ---------------------------------
% Annulus & Image Setup
% ---------------------------------

% Set diameter of targets, diameter and thickness of convergence annulus
circleDiameterDegrees = 1.8; % Diameter of presented circle in degrees of visual field.
convergenceAnnulusDiameterDegrees = 2.6; % Diameter of black annulus which individually surrounds both the target gratings
convergenceAnnulusThicknessDegrees = .2;
blurRadius = 0.1; % Proportion of circle radius that is blurred on the outer edge

circleDiameterPixels = circleDiameterDegrees * pixelsPerDegree;
convergenceAnnulusDiameterPixels = convergenceAnnulusDiameterDegrees * pixelsPerDegree;
convergenceAnnulusThicknessPixels = convergenceAnnulusThicknessDegrees* pixelsPerDegree;

widthOfGrid = convergenceAnnulusDiameterPixels ; % the next lines make sure that it is a whole, even number so matrix indices don't choke.
widthOfGrid = round (widthOfGrid);
if mod (widthOfGrid, 2) ~= 0
    widthOfGrid = widthOfGrid + 1 ;
end;

halfWidthOfGrid =  (widthOfGrid / 2);
widthArray = (-halfWidthOfGrid) : halfWidthOfGrid; % widthArray is used in creating the meshgrid.

% Creates a two-dimensional square grid
[x y] = meshgrid(widthArray, widthArray);

% Now we create an annulus that surrounds our circular grating
convergenceAnnulus = ...
    ((x.^2 + y.^2) >= (convergenceAnnulusDiameterPixels/2 - convergenceAnnulusThicknessPixels)^2 )  & ...
    ((x.^2 + y.^2) <  (convergenceAnnulusDiameterPixels/2)^2 );

convergenceAnnulus = ~convergenceAnnulus; % when we multiply this, it will create an annulus of zero/black

% Make masks and masked images
annulussize = size(convergenceAnnulus,1);
imsize = round(circleDiameterPixels);
mask = drawcircularblur(imsize, blurRadius);
square = ones(annulussize) * gray;
cornerPos = round((annulussize - imsize)/2);

im1 = double(imread(imageFilePathLeft));
im1 = imresize(im1,[imsize imsize]);
im1Masked = (im1 .* (1-mask) + gray * mask);
square1 = square;
square1(cornerPos:cornerPos + imsize - 1, cornerPos:cornerPos + imsize - 1) = im1Masked;
imageMatrix1 = square1 .* convergenceAnnulus;

im2 = double(imread(imageFilePathRight));
im2 = imresize(im2,[imsize imsize]);
im2Masked = (im2 .* (1-mask) + gray * mask);
square2 = square;
square2(cornerPos:cornerPos + imsize - 1, cornerPos:cornerPos + imsize - 1) = im2Masked;
imageMatrix2 = square2 .* convergenceAnnulus;

% Make blank and spacer matrices
graySpacerMatrix =  ones(widthOfGrid+1,(widthOfGrid)*spaceBetweenMultiplier ) * gray;
blankTargetMatrix = ones(widthOfGrid+1, widthOfGrid+1) * gray;
blankedGratingMatrix = blankTargetMatrix .*convergenceAnnulus;

% Make textures
imageTexture = [imageMatrix1, graySpacerMatrix, imageMatrix2];
blankTexture = [blankedGratingMatrix, graySpacerMatrix, blankedGratingMatrix];

imagetexPointer = Screen('MakeTexture', window, imageTexture);
blanktexPointer = Screen('MakeTexture', window, blankTexture);


