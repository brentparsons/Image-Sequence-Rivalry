function allSetStackShuffled = shuffleSetStack(allSetStack)

% shuffle the sets
% if we require no set repeats, we need to do this in segments involving 8
% nRepsB or fewer. otherwise, the chance is too low of it finding a viable
% sequence in a reasonable time.
repeatFlag = 1;
counter = 0;
while repeatFlag
    shuffleInds = randperm(length(allSetStack))';
    allSetStackShuffled = allSetStack(shuffleInds,:);
    repeatFlag = any(diff(allSetStackShuffled(:,1))==0);
    counter = counter+1;
    
    if counter==100000
        error('Was not able to find a repeat-free ordering of the image sets!')
    end
end