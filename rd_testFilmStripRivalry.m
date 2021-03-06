function rd_testFilmStripRivalry

% Present sequences of images. All images are members of triplets (ZAB).
%
% Task is to search for a target image that will be paired with one of the
% triplet images (ie. presented in the other eye).
%
% Modified from rd_trainImageSequenceRivalry.m
%
% Rachel Denison
% January 2012

global pixelsPerDegree;
global spaceBetweenMultiplier;

% -------------------------------------------------------------------------
% User-defined values, might vary by testing room. Check these before running.
% -------------------------------------------------------------------------
% specify where the resulting datafile will be stored
dataDirectoryPath = '/Users/michaelsilver/Brent/Rivalry/Image_Sequence_Rivalry/data/'; % testing room
% dataDirectoryPath = '/Volumes/rachel-1/Projects/Filmstrip_Rivalry/data/'; % laptop

% specify the path for the displayParams file
targetDisplayPath ='/Users/michaelsilver/Brent/Displays/'; % testing room
% targetDisplayPath = '/Volumes/rachel-1/Projects/Displays/'; % laptop

% further specify the path for the displayParams file
targetDisplayName = 'Minor_582J_rivalry'; 

% specify where the images are stored
imageDirectoryPath = '/Users/michaelsilver/Brent/Rivalry/Kendrick_images/'; % testing room
% imageDirectoryPath = '/Volumes/rachel-1/Projects/Image_Sequence_Rivalry/Image_Sequence_Rivalry1/images/Kendrick_images/'; % laptop

% specify where the image file names lists organized by type are stored
typeListDirectoryPath = '/Users/michaelsilver/Brent/Rivalry/Types/'; % testing room
% typeListDirectoryPath = '/Volumes/rachel-1/Projects/Image_Sequence_Rivalry/Image_Sequence_Rivalry2/image_type_lists/'; % laptop

typeFile = 'TYPES_20110325_6Cat.mat'; % 4 hand-picked image sets

% set keypad device numbers
% devNums = findKeyboardDevNums; % testing room
devNums = findKeyboardDevNums_externalKeyboard; % laptop 
if isempty(devNums.Keypad)
    error('Could not find Keypad! Please check findKeyboardDevNums.')
end

% sound on?
sound_on = 1; % 1 for on, 0 for off

% searching for a target image
responseKeys = {'1'}; % these are our default keys
responseNames = {'target'};

% run parameters
nImageBs = 4; 
nRepsB = (3)*6; % determines the number of trials % 18 for actual expt (should be multiple of 3)
repsPerSubstack = 6; % should be <= nRepsB
nBlocks = 1; % do all the nReps in every block
imageDuration = 0.85; % seconds -- multiple of refresh, please!
trialDuration = 0.85;
responseDuration = 1.25;
nTargets = (nImageBs*3)*3; % should be multiple of nImageBs*3 (which gives one target per sequence position per imageB)
targetImage = 9001; % number of target image in types file
targetOnset = NaN;
trialTarget = NaN;

% note: prop bseqs with target = nTargets(outside parens) / nRepsB(outside
% parens)

imageTypeNames = {'b','a1','a2','a3','c1','c2','c3','c4','d','z1','z2','z3','t'}'; 
lowerbounds = [(0:100:800) (1100:100:1300) (9000)]';
upperbounds = lowerbounds + 101;

% Sound for starting trials
v = 1:2000;
soundvector = 0.25 * sin(2*pi*v/30); %a nice beep at 2kH samp freq

% Response error sound
v = 1:1000;
errorsound = 0.25 * sin(1*pi*v/30); 

% Response correct sound
v = 1:1000;
correctsound = 0.25 * sin(10*pi*v/30); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spaceBetweenMultiplier = 3;

Screen('Preference', 'VisualDebuglevel', 3); % replaces startup screen with black display
screenNumber = max(Screen('Screens'));

window = Screen('OpenWindow', screenNumber);
black = BlackIndex(window);  % Retrieves the CLUT color code for black.
white = WhiteIndex(window);  % Retrieves the CLUT color code for white.
gray = (black + white) / 2;  % Computes the CLUT color code for gray.  

Screen('TextSize', window, 60);

targetDisplay = loadDisplayParams_OSX('path',targetDisplayPath,'displayName',targetDisplayName,'cmapDepth',8); 
 
pixelsPerDegree = angle2pix(targetDisplay, 1); % number of pixels in one degree of visual angle

Screen('LoadNormalizedGammaTable', targetDisplay.screenNumber, targetDisplay.gammaTable);
 
fprintf('Welcome to the Film Strip Rivalry Study\n\n');
fprintf('Be sure to turn manually turn off console monitor before testing!\n\n')

KbName('UnifyKeyNames');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Keyboard mapping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for key = 1:length(responseKeys)
    responseKeyCode (1:256) = 0;
    responseKeyCode (KbName (responseKeys(key))) = 1; % creates the keyCode vector

    response = 1;
    while ~isempty (response)
        fprintf('The key assigned for %s is: %s \n', responseNames{key}, KbName(responseKeyCode));
        response = input ('Hit "enter" to keep this value or a new key to change it.\n','s');
        if ~isempty(response) && str2num(response)<10 % make sure response key is on the key pad
            responseKey = response; 
            responseKeyCode (1:256) = 0;
            responseKeyCode (KbName (responseKey)) = 1; % creates the keyCode vector
        end
    end

    responseKeyNumbers(:,key) = find(responseKeyCode);
end

fprintf('Key numbers: %d\n\n', responseKeyNumbers)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect subject and session info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subjectNumber = str2double(input('\nPlease input the subject number: ','s'));
runNumber = str2double(input('\nPlease input the run number: ','s'));
subjectID = sprintf('s%02d_run%02d', subjectNumber, runNumber);
timeStamp = datestr(now);

% Show the gray background, return timestamp of flip in 'vbl'
Screen('FillRect',window, gray);
vbl = Screen('Flip', window);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load image file lists by type (TYPES). types are b, a1, a3, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load TYPES
typeListFileName = [typeListDirectoryPath typeFile];
load(typeListFileName);

% or make TYPES now:
% TYPES = rd_imageCat2TypeTransform(nImageBs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Store experiment parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expt.timeStamp = timeStamp;
expt.subject = subjectNumber;
expt.run = runNumber;
expt.nImageBs = nImageBs;
expt.nRepsB = nRepsB;
expt.nBlocks = nBlocks;
expt.imageDuration = imageDuration;
expt.trialDuration = trialDuration;
expt.nTargets = nTargets;
expt.targetImage = targetImage;
expt.imageTypeNames = imageTypeNames;
expt.lowerbounds = lowerbounds;
expt.upperbounds = upperbounds;
expt.responseNames = responseNames;
expt.responseKeyNumbers = responseKeyNumbers;

stim.TYPES = TYPES;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataFileName = [dataDirectoryPath subjectID '_TestFilmStripRivalry_', datestr(now,'ddmmmyyyy')];

for block = 1:nBlocks
    
    DrawFormattedText(window, 'Preparing stimuli ...', 0, 'center', [255 255 255]);
    Screen('Flip', window);
    tic
    
    % make image sequence for this block
    imageSequence = rd_makeTrainingImageSequence2(nImageBs, nRepsB, repsPerSubstack);
    
    imageSequenceT = addTargetsToImageSequence(imageSequence, nImageBs, ...
        nRepsB, nTargets, targetImage);
    
    checkRepeat = 1;
    countRepeatChecks = 0;
    while checkRepeat
        countRepeatChecks = countRepeatChecks + 1;
        tidx = find(imageSequenceT==targetImage);
        checkRepeat = any(diff(tidx)==1);
        if checkRepeat
            imageSequenceT = addTargetsToImageSequence(imageSequence, nImageBs, nRepsB, nTargets, targetImage);
        end
        if countRepeatChecks > 1000
            error('Couldnt generate non-repeat sequence')
        end
    end
    
    [imageSequenceL imageSequenceR] = addTargetsByEye(imageSequence, imageSequenceT, targetImage);

    % get category labels for this image sequence
    imageSequenceCategories = getCategoryLabels(imageSequenceT, TYPES);
    
    % get triplet, target position, and eye
    imageSequenceTargets = getTargets(imageSequenceT); %0,1
    imageSequenceTriplets = getTriplets(imageSequence); % 1,2,3,4
    imageSequenceTargetPosition =  getTargetPosition(imageSequenceT);% 1,2,3
    imageSequenceTargetEye = getTargetEye(imageSequenceL,imageSequenceR);% 1,2
    

    clear imageTextures imagetexs
    
    % build image texture sequence
    for trial = 1:length(imageSequence)
        
        imageR = imageSequenceR(trial);
        imageTypeR = imageTypeNames{(imageR > lowerbounds) & (imageR < upperbounds)};
        imageNumberR = rem(imageR, 100);
        imageFileNameR = TYPES.(imageTypeR).imageFiles(imageNumberR).name;
        
        imageL = imageSequenceL(trial);
        imageTypeL = imageTypeNames{(imageL > lowerbounds) & (imageL < upperbounds)};
        imageNumberL = rem(imageL, 100);
        imageFileNameL = TYPES.(imageTypeL).imageFiles(imageNumberL).name;
        
        
        imageFilePathLeft = [imageDirectoryPath imageFileNameR];
        imageFilePathRight = [imageDirectoryPath imageFileNameL];
        
        [imageTexture imagetex] = rd_makeRivalryImageTexture(window, imageFilePathLeft, imageFilePathRight);
        
%         imageTextures{trial} = imageTexture; % a stack of image matrices (eg. imagesc(imageTexture))
        imagetexs(trial,1) = imagetex; % a list of texture pointers to said image matrices
        
    end
    
    % present alignment targets and wait for a keypress
    toc
    presentAlignmentTargets(window, devNums);  

    % make a beep to say we're ready
    if sound_on
        sound (soundvector, 8000); 
    end
    
    datestr(now)
    
    % present image sequence for this block
    [targetArray(block).keyTimes targetArray(block).keyEvents targetArray(block).responseAcc ...
        targetArray(block).targetMissed targetOnset trialTarget] = ...
        rd_presentRivalryFilmstripTargetImageSequence(window, imagetexs, ...
        imageDuration, trialDuration, imageSequenceCategories, ...
        responseNames, responseKeyNumbers, devNums, correctsound, errorsound,...
        imageSequenceTargets, targetOnset, trialTarget, responseDuration);
    
    % store image sequence and categories
    imageSequenceByBlock(:,block) = imageSequenceT;
    imageSequenceByBlockR(:,block) = imageSequenceR;
    imageSequenceByBlockL(:,block) = imageSequenceL;
    imageSequenceCategoriesByBlock(:,block) = imageSequenceCategories;
    imageSequenceTargetsByBlock(:,block) = imageSequenceTargets;
    imageSequenceTripletsByBlock(:,block) = imageSequenceTriplets;
    imageSequenceTargetPositionByBlock(:,block) = imageSequenceTargetPosition;
    imageSequenceTargetEyeByBlock(:,block) = imageSequenceTargetEye;
    
    stim.sequence = imageSequenceByBlock;
    stim.sequenceR = imageSequenceByBlock;
    stim.sequenceL = imageSequenceByBlock;
    stim.categories = imageSequenceCategoriesByBlock;
    stim.triplets = imageSequenceTripletsByBlock;
    stim.targetPosition = imageSequenceTargetPositionByBlock;
    stim.targetEye =imageSequenceTargetEyeByBlock;
    
    % save data
    save(dataFileName, 'subjectID', 'timeStamp', 'targetArray', 'stim', 'expt');

    % show response accuracy and rt
    hit = responseArray(block).responseAcc;
    hits = sum(hit);
    acc = hits/nTargets;
    
    rt = responseArray(block).keyTimes;
    mean_rt_correct = mean(rt(hit==1)); 
    
    DrawFormattedText(window, ...
        sprintf('Target Accuracy: %d%%\n\nRT: %d ms', round(acc*100), round(mean_rt_correct*1000)),...
        'center', 'center', [255 255 255]);
    Screen('Flip', window);
    
    WaitSecs(3);
    datestr(now)

end % end block

%%%%%%%%%%%%%
% Clean up
%%%%%%%%%%%%%
if ~exist('topup_run','var')
    Screen('CloseAll');
    ShowCursor;
end

