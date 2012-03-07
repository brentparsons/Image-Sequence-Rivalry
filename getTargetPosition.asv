function imageSequenceTargetPosition = getTargetPosition(imageSequenceT)

% function imageSequenceTargetPosition = getTargetPosition(imageSequenceT)
% returns target positions in the image sequence (1,2,3)

imageTypeNames = {'b','a1','a2','a3','c1','c2','c3','c4','d','z1','z2','z3','t'}'; 
lowerbounds = [(0:100:800) (1100:100:1300) (9000)]';
upperbounds = lowerbounds + 101;

for trial = 1:length(imageSequenceT)

    imageNumber = imageSequenceT(trial);
    imageType = imageTypeNames{(imageNumber > lowerbounds) & (imageNumber < upperbounds)};
    targetPresent = 0;
    
    if imageType == 't'
        targetPresent = 1;
    end
    
    if targetPresent == 0;
        targetPosition = NaN;
    else
    targetPosition = rem(imageNumber, 3)
    end
    
    if targetPosition == 0
        targetPosition = 3
    end
    
    imageSequenceTargetPosition(trial,1) = targetPosition;
    
end
