function imageSequenceTriplets = getTriplets(imageSequence)

% function imageSequenceTriplets = getTriplets(imageSequence)
% returns triplet ids (1,2,3,4) for each image in the image sequence

for trial = 1:length(imageSequence)

    imageNumber = imageSequenceTarget(trial);
    image = rem(imageNumber, 100);

    imageSequenceTriplets(trial,1) = image;

end