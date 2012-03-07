function imageSequenceCategories = getCategoryLabels(imageSequenceT, TYPES)

% function imageSequenceCategories = getCategoryLabels(imageSequence, TYPES)
% returns category ids for each image in the image sequence

imageTypeNames = {'b','a1','a2','a3','c1','c2','c3','c4','d','z1','z2','z3','t'}'; 
lowerbounds = [(0:100:800) (1100:100:1300) (9000)]';
upperbounds = lowerbounds + 101;

for trial = 1:length(imageSequenceT)

    imageNumber = imageSequenceT(trial);
    imageType = imageTypeNames{(imageNumber > lowerbounds) & (imageNumber < upperbounds)};
    image = rem(imageNumber, 100);

    imageSequenceCategories{trial,1} = TYPES.(imageType).categories{image};

end