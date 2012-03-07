function imageSequenceTargetEye = getTargetEye(imageSequenceL,imageSequenceR)

% function imageSequenceTargeteye = getTargetEye(imageSequence,imageSequenceT)
% returns eye target was presented to in the image sequence (L,1,R,2)

imageTypeNames = {'b','a1','a2','a3','c1','c2','c3','c4','d','z1','z2','z3','t'}'; 
lowerbounds = [(0:100:800) (1100:100:1300) (9000)]';
upperbounds = lowerbounds + 101;

for trial = 1:length(imageSequenceL)

    % finds if target was present in either eye
    imageNumberL = imageSequenceL(trial);
    imageTypeL = imageTypeNames{(imageNumberL > lowerbounds) & (imageNumberL < upperbounds)};
    targetPresentL = 0;
    
    if imageTypeL == 't'
        targetPresentL = 1;
    end
    
    imageNumberR = imageSequenceR(trial);
    imageTypeR = imageTypeNames{(imageNumberR > lowerbounds) & (imageNumberR < upperbounds)};
    targetPresentR = 0;
    
    if imageTypeR == 't'
        targetPresentR = 1;
    end
    
  % specifies target eye (L=1,R=2)
    if targetPresentL == 0 && targetPresentR == 0;
        targetEye = NaN;
    elseif TargetPresentL == 1;
        targetEye = 1;
    else
    targetEye = 2;   
    end
    
    imageSequenceTargetEye(trial,1) = targetEye;
    
end