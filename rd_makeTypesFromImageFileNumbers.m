% rd_makeTypesFromImageFileNumbers

%% 4 categories
bFileNums = [297 312 45 794];
c3FileNums = [45 794 297 312];
a3FileNums = [175 825 1396 1489];
z3FileNums = [26 1138 1384 1937];

bCategories = {'animals','animals','rooms','rooms'};
c3Categories = {'rooms','rooms','animals','animals'};
a3Categories = {'landscapes','landscapes','people','people'};
z3Categories = {'people','people','landscapes','landscapes'};

%% 6 categories
bFileNums = [297 312 45 794];
c3FileNums = [45 794 297 312];
a3FileNums = [175 825 1396 26];
z3FileNums = [2065 1138 408 409];

dFileNums = [312 297 794 45];
c4FileNums = [794 45 312 297];

bCategories = {'animal','animal','indoor','indoor'};
c3Categories = {'indoor','indoor','animal','animal'};
a3Categories = {'outdoor','outdoor','man','man'};
z3Categories = {'woman','woman','food','food'};

% category match rivalry test pairs
dCategories = bCategories;
c4Categories = c3Categories;

% image types
imageTypeNames = {'b','c3','a3','z3','d','c4'}'; 
imageTypeFileNums = {bFileNums, c3FileNums, a3FileNums, z3FileNums, dFileNums, c4FileNums};
imageTypeCats = {bCategories, c3Categories, a3Categories, z3Categories, dCategories, c4Categories};

%% Film strip target (start with 6 categories)
tFileNums = [1644 1644 1644 1644]; % same target for all triplets
tCategories = {'target', 'target', 'target', 'target'};

% image types
imageTypeNames = {'b','a3','z3','t'}'; 
imageTypeFileNums = {bFileNums, a3FileNums, z3FileNums, tFileNums};
imageTypeCats = {bCategories, a3Categories, z3Categories, tCategories};


%% Post-test
bFileNumsOrig = [297 312 45 794];
a3FileNumsOrig = [175 825 1396 26];
z3FileNumsOrig = [2065 1138 408 409];

% 12 image sequences: 4 orig (trained), 4 category match, 4 category different
% only the middle (a3) item differs across these sets
bFileNums = [bFileNumsOrig bFileNumsOrig bFileNumsOrig];
a3FileNums = [a3FileNumsOrig 825 175 26 1396 1396 26 175 825];
z3FileNums = [z3FileNumsOrig z3FileNumsOrig z3FileNumsOrig];

bCategories = {'animal','animal','indoor','indoor',...
    'animal','animal','indoor','indoor',...
    'animal','animal','indoor','indoor'};
a3Categories = {'outdoor','outdoor','man','man'...
    'outdoor','outdoor','man','man',...
    'man','man','outdoor','outdoor'};
z3Categories = {'woman','woman','food','food',...
    'woman','woman','food','food',...
    'woman','woman','food','food'};

% image types
imageTypeNames = {'b','a3','z3'}'; 
imageTypeFileNums = {bFileNums, a3FileNums, z3FileNums};
imageTypeCats = {bCategories, a3Categories, z3Categories};

%% Initializations
nImageBs = length(bFileNums);

nImageTypes = length(imageTypeNames);

imDirectory = '../Image_Sequence_Rivalry1/images/Kendrick_images';

TYPES = struct('whenCreated', datestr(now));

%% Make TYPES
for type = 1:nImageTypes

    typeName = imageTypeNames{type};

    if ~isfield(TYPES, typeName) % if the field hasn't been created yet
        TYPES = setfield(TYPES, typeName, []);
    end

    for image = 1:nImageBs
        imageFile = dir(sprintf('%s/image%06d.png', imDirectory, imageTypeFileNums{type}(image)));
        TYPES.(typeName).imageFiles(image) = imageFile; % dynamic field names!

        TYPES.(typeName).categories{image} = imageTypeCats{type}{image};
    end

end % end types

