function imageSequenceTargetLeft = addTargetsToImageSequenceLeft(imageSequence, nImageBs, nRepsB, nTargets, targetImage)

nItemsInUnitSequence = length(imageSequence)/(nImageBs*nRepsB);
% nSetsWithTargets = nTargets/nItemsInUnitSequence;
nTargetsPerImageB = nTargets/nImageBs;

setStack = reshape(imageSequence, nItemsInUnitSequence, nImageBs*nRepsB);
[sortedSetStack idx] = sortrows(setStack');

sortedSetStack3D = reshape(sortedSetStack', nItemsInUnitSequence, nRepsB, nImageBs);

targetPositions3D = zeros(size(sortedSetStack3D));


for b = 1:nImageBs
    
    % decide which imageB sets get targets (in what order)
    setOrdering = repmat(1:nRepsB, 1, ceil(nTargetsPerImageB/nRepsB));
    w = randperm(length(setOrdering));
    setOrdering = setOrdering(w);
    
    % decide which sequence positions get targets (in what order)
    sequencePositionOrdering = repmat(1:nItemsInUnitSequence, 1, ...
        ceil(nTargetsPerImageB/nItemsInUnitSequence));
    w = randperm(length(sequencePositionOrdering));
    sequencePositionOrdering = sequencePositionOrdering(w);
    
    for t = 1:nTargetsPerImageB
        targetPositions3D(sequencePositionOrdering(t), setOrdering(t), b) = 1;
    end
    
end


sortedSetStack3DTarget = sortedSetStack3D;
sortedSetStackReplaced = sortedSetStack3DTarget(logical(targetPositions3D))
sortedSetStack3DTarget(logical(targetPositions3D)) = targetImage; % use just one target image

% adds targets for the left eye
[i] = find(sortedSetStack3DTarget == targetImage);
toReplaceTargetLeft = sortedSetStackReplaced;
toReplaceTargetLeft(2:2:end) = targetImage;

for c = 1:length(i)
    sortedSetStack3DTarget(i(c))= toReplaceTargetLeft(c);
end

sortedSetStackTarget = reshape(sortedSetStack3DTarget, nItemsInUnitSequence, nImageBs*nRepsB)';
  
setStackTarget = zeros(size(sortedSetStackTarget));
setStackTarget(idx,:) = sortedSetStackTarget; 
    
imageSequenceTargetLeft = reshape(setStackTarget', length(imageSequence), 1)


    
    





