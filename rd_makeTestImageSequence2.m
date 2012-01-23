function rivalrySequence = rd_makeTestImageSequence2(nImageBs, nRepsB, repsPerSubstack)

% Make rivalry sequence for testPredictiveRivalry, containing the image
% numbers, the sides they will be presented on, and their tints. Divide
% this sequence into blocks.
%
% Key to image codes:
% B (targets)            : 1-100
% A1 (zero predictive)   : 101-200
% A2 (low predictive)    : 201-300
% A3 (high predictive    : 301-400
% C3 (rival with B)      : 601-700
% C4 (rival with D)      : 701-800
% D (category match to B): 801-900
% Z1 (precedes A1)       : 1101-1200
% Z2 (precedes A2)       : 1201-1300
% Z3 (precedes A3)       : 1301-1400
%
% Modified from rd_makeTestImageSequence.m
%
% Rachel Denison
% March 2011
%
% NOTE: This version will probably *not* work with a contraBSet

%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%
% useSeparateZeroSet = 1 if a1 is a different set of images from a3,
% 0 if a1 is drawn from a3 (but still zero predictive)
useSeparateZeroSet = 0;

% option to have zero, low, and high predictive conditions, or just zero
% and high predictive (set highPredProb = 1, lowPredProb = 0)
highPredProb = 1;
lowPredProb = 0;

% set number of target B images, training reps, block size
if nargin==0
    % default values
    nImageBs = 4;
    nRepsB = 1;
    repsPerSubstack = 1;
end

nRivalPairTypes = 2; % (1) b-c3, (2) d-c4 % Note: changing this to 1 does not get rid of d-c4 pairs below

a1Constant = 100; % predicts b with zero probability
a2Constant = 200; % predicts b with low probability
a3Constant = 300; % predicts b with high probability
c3Constant = 600; % rival with b
c4Constant = 700; % rival with d
dConstant = 800;  % category match to b

z1Constant = 1100; % precedes a1
z2Constant = 1200; % precedes a2
z3Constant = 1300; % precedes a3

noTintNumber = 3; % if tint = this number, don't tint the image

nSides = 2;
nTints = 2;

if highPredProb == 1 && useSeparateZeroSet == 0
    nSets = 1; % no contraBSet, no a1
elseif highPredProb == 1
    nSets = 2; % no contraBSet
elseif useSeparateZeroSet == 0
    nSets = 2; % no a1
else
    nSets = 3; % bSet, contraBSet, a1Set
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Counterbalance image presentation for side of screen and tint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sides1 = 1:nSides;
sides1 = repmat(sides1, nImageBs*nSets, 1);
sides2 = fliplr(sides1);
sides1 = [sides1(:,1) sides1]; % for triplet sequences
sides2 = [sides2(:,1) sides2];
sides = [sides1; sides2];

sidesAB = sides;
% sidesAC3 = fliplr(sidesAB); % we want the c3 images to be presented on opposite sides from b images
sidesAC3 = 2-(sidesAB-1); % we want the c3 images to be presented on opposite sides from b images

tints1 = 1:nTints;
tints1 = repmat(tints1, nImageBs*nSets*nSides, 1);
tints2 = fliplr(tints1);
tints = [tints1; tints2];

noTint = ones(length(tints),1)*noTintNumber;
tintsAB = [noTint noTint tints(:,1)];
tintsAC3 = [noTint noTint tints(:,2)];

% rep mats appropriately
sidesAB = repmat(sidesAB, nTints*nRepsB, 1);
sidesAC3 = repmat(sidesAC3, nTints*nRepsB, 1);

tintsAB = repmat(tintsAB, nRepsB, 1);
tintsAC3 = repmat(tintsAC3, nRepsB, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make image number stacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make substacks to ensure no triplet repeats in sequence
nSubRepsB = floor(nRepsB/repsPerSubstack); % 6 is a viable number of reps for no repeats
subRepsB = repmat(repsPerSubstack, 1, nSubRepsB);
if mod(nRepsB,repsPerSubstack)~=0
    subRepsB = [subRepsB mod(nRepsB,repsPerSubstack)];
end

repeatFlag = 1; count = 0;
while repeatFlag
    asss = zeros(3*6, nImageBs*repsPerSubstack*nSets*nRivalPairTypes,length(subRepsB));
    for substack = 1:length(subRepsB)
        allSetStack = makeSetStack(...
            nImageBs, nSets, subRepsB(substack), ...
            useSeparateZeroSet, lowPredProb, highPredProb, ...
            a1Constant, a2Constant, a3Constant, ...
            z1Constant, z2Constant, z3Constant);

        % Make a stack for each rivalry pair image
        % a stack for the b-sets and for the c3-sets (actually zab now)
        aBSetStack = allSetStack;
        aC3SetStack = aBSetStack;
        aC3SetStack(:,end) = aC3SetStack(:,end) + c3Constant;

        % and similar stacks for the d-sets and c4-sets
        aDSetStack = aBSetStack;
        aDSetStack(:,end) = aDSetStack(:,end) + dConstant;
        aC4SetStack = aBSetStack;
        aC4SetStack(:,end) = aC4SetStack(:,end) + c4Constant;
        
        % rep mats appropriately (we jave a bunch of mats, so a bit inelegant here)
        aBSetStack = repmat(aBSetStack, nSides*nTints*nRepsB, 1);
        aC3SetStack = repmat(aC3SetStack, nSides*nTints*nRepsB, 1);

        aDSetStack = repmat(aDSetStack, nSides*nTints*nRepsB, 1);
        aC4SetStack = repmat(aC4SetStack, nSides*nTints*nRepsB, 1);

        % Assemble the sets -- identical sides & tints counterbalancing for b-c3
        % and d-c4 rivalry pairs
        allSetsForShuffling = [aBSetStack aC3SetStack sidesAB sidesAC3 tintsAB tintsAC3;
            aDSetStack aC4SetStack sidesAB sidesAC3 tintsAB tintsAC3];

        asss(:, 1:subRepsB(substack)*nImageBs*nSets*nTints*nSides*nRivalPairTypes, substack) = ...
            shuffleSetStack(allSetsForShuffling)';

    end

    % check for repeats across substacks
    repeatFlag = 0;
    for substack = 1:length(subRepsB)-1
        if asss(end,end,substack) == asss(end,1,substack+1)
            repeatFlag = 1;
        end
    end
    count = count+1;
end

allSetsShuffled = reshape(asss, 3*6, size(asss,2)*size(asss,3))';

% break back into image pairs / sides / tints
aBSetStackS = allSetsShuffled(:,1:3);
aC3SetStackS = allSetsShuffled(:,4:6);
sidesABS = allSetsShuffled(:,7:9);
sidesAC3S = allSetsShuffled(:,10:12);
tintsABS = allSetsShuffled(:,13:15);
tintsAC3S = allSetsShuffled(:,16:18);

nTrials = length(allSetsShuffled)*3; % 3 because we are changing triplets to 1-D
% reshape into 1-D lists (already shuffled)
aBImageSequence = reshape(aBSetStackS', nTrials, 1);
aC3ImageSequence = reshape(aC3SetStackS', nTrials, 1);
aBSideSequence = reshape(sidesABS', nTrials, 1);
aC3SideSequence = reshape(sidesAC3S', nTrials, 1);
aBTintSequence = reshape(tintsABS', nTrials, 1);
aC3TintSequence = reshape(tintsAC3S', nTrials, 1);

% % take out dummy zeros (this is only if there is a contra b pair)
% imageSequence(imageSequence==0) = [];

% put together into full rivalry sequence
rivalrySequence = [aBImageSequence aC3ImageSequence aBSideSequence aC3SideSequence ...
    aBTintSequence aC3TintSequence];

return
