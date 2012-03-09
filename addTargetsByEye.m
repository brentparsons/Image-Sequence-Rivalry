function [imageSequenceL imageSequenceR] = addTargetsByEye(imageSequence, imageSequenceT, targetImage)

[i] = find(imageSequenceT == targetImage);

w = randperm(length(i));
i = i(w);

left = i(1:2:end);
right = i(2:2:end);

imageSequenceL = imageSequence;
imageSequenceR = imageSequence;

imageSequenceL(left) = targetImage;
imageSequenceR(right) = targetImage;

