function imageSequenceTargets = getTargets(imageSequenceT)

% function imageSequenceTargets = getTargets(imageSequenceT)
% returns list of targets in the image sequence (0,1)

imageTypeNames = {'b','a1','a2','a3','c1','c2','c3','c4','d','z1','z2','z3','t'}'; 
lowerbounds = [(0:100:800) (1100:100:1300) (9000)]';
upperbounds = lowerbounds + 101;

for trial = 1:length(imageSequenceT)

    % finds if target was present in either eye
    imageNumber = imageSequenceT(trial);
    imageType = imageTypeNames{(imageNumber > lowerbounds) & (imageNumber < upperbounds)};
    targetPresent = 0;
    
    if imageType == 't'
        targetPresent = 1;
    end
  
    imageSequenceTargets(trial,1) = targetPresent;
    
end