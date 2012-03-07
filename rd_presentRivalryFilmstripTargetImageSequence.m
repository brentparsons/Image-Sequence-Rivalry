function [responseTimes responseKeyboardEvents responseAcc responseMissed] = ...
    rd_presentRivalryFilmstripTargetImageSequence(window, texs, imageDuration, trialDuration, imageSequenceCategories, categoryNames, categoryKeyNumbers, devNums, correctsound, errorsound, imageSequenceTargets)

% Given a list of image texture pointers and image durations, present one
% image after the other and collect responses throughout. Separate images
% by blank rivalry annuluses. Collect target detection responses and give 
% feedback for wrong or missed responses.
%
% Modified from rd_presentRivalryTrainingImageSequence
%
% Rachel Denison
% January 2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initializations
refrate = 60;
nTrials = length(texs);
[blankTexture blanktex] = rd_makeRivalryBlankTexture(window);

% % Switch to realtime:
% priorityLevel = MaxPriority(window);
% 
% % kluge to deal with random intermittent crashes until MacOS is updated
% successfullySetPriority = 0;
% while ~ successfullySetPriority
%     try
%         Priority(priorityLevel);
%         successfullySetPriority = 1;
%     catch
%         successfullySetPriority = 0;
%     end
% end

% Initialize response measures
responseTimes = zeros(nTrials,1);
responseKeyboardEvents = zeros(nTrials,1);
responseAcc = zeros(nTrials,1);
responseMissed = zeros(nTrials,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRESENT TRIAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
slack = 1/refrate/2; 

for trial = 1:nTrials

    imagetex = texs(trial);

    % Draw images
    Screen('DrawTexture', window, imagetex);
    timeFlipImage = Screen('Flip', window);

    keyAlreadyPressed = 0; % take first key press only
    
    %Check if previous trial and current trial are targets
    if trial == 1;
        previousTrialTarget = 0;  
        currentTrialTarget = imageSequenceTargets(trial);
    elseif imageSequenceTargets(trial-1)&& ~imageSequenceTargets(trial)
        previousTrialTarget = imageSequenceTargets(trial-1);
    else
        currentTrialTarget = imageSequenceTargets(trial);
        
        
    while GetSecs < timeFlipImage + imageDuration - slack
        % Check subject response
        [keyIsDown, seconds, keyCode] = KbCheck(devNums.Keypad); % Check the state of the keyboard
        
        if keyIsDown && ~keyAlreadyPressed && sum(keyCode)<2 % don't take multiple responses
            [responseTimes(trial) responseKeyboardEvents(trial) responseAcc(trial)] = ...
                keyDownActions(seconds, timeFlipImage, keyCode, categoryNames, ...
                categoryKeyNumbers, imageSequenceCategories, errorsound);
            keyAlreadyPressed = 1;
        end
    end
    
    % Draw blank
    Screen('DrawTexture', window, blanktex);
    timeFlipBlank = Screen('Flip', window);

    while GetSecs < timeFlipImage + trialDuration - slack
        % Check subject response
        [keyIsDown, seconds, keyCode] = KbCheck(devNums.Keypad); % Check the state of the keyboard

        if keyIsDown && ~keyAlreadyPressed && sum(keyCode)<2
            [responseTimes(trial) responseKeyboardEvents(trial) responseAcc(trial,1)] = ...
                keyDownActions(seconds, timeFlipImage, keyCode, categoryNames, ...
                categoryKeyNumbers, imageSequenceCategories, errorsound);
            keyAlreadyPressed = 1;
        end
    end
    
    % play error sound if target missed and record miss
    if GetSecs == timeFlipImage + trialDuration - slack && currentTrialTarget && ~keyAlreadyPressed
        sound(errorsound, 8000);
        [responseMissed(trial)] = 1;
    end
     
end % end trials

% Shut down realtime-mode:
% kluge to deal with random intermittent crashes until MacOS is updated
successfullySetPriority = 0;
while ~ successfullySetPriority
    try
        Priority(0);
        successfullySetPriority = 1;

    catch
        successfullySetPriority = 0;
    end
end

% release all textures and offscreen windows
Screen('Close');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keyDownActions
function [rt response correct] = keyDownActions(seconds, timeFlipImage, keyCode, categoryNames, categoryKeyNumbers, imageSequenceCategories, errorsound);
    rt = seconds - timeFlipImage;
    response = find(keyCode);

    % feedback
    responseCategory = categoryNames{categoryKeyNumbers==response};
    if ~isempty(responseCategory)
        correct = strcmp(imageSequenceCategories{trial}, responseCategory);
        feedbackSound = correctsound;
    else
        correct = 0;
        feedbackSound = errorsound;
    end
    sound (feedbackSound, 8000);
end % end keyDownActions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end % end main function




