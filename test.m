clc, clearvars, close all;



function classify_aflw2000_3d(directory)
    % List all .mat files in the given directory
    files = dir(fullfile(directory, '*.mat'));

    % Process each .mat file
    for k = 1:length(files)
        matFile = fullfile(files(k).folder, files(k).name);
        [yaw, pitch, roll, yaw_class, pitch_class, roll_class] = get_face_angles_and_classify(matFile);
        
        % Display the result
        fprintf('Filename: %s\n', files(k).name);
        fprintf('Yaw: %.2f (Class: %s)\n', yaw, yaw_class);
        fprintf('Pitch: %.2f (Class: %s)\n', pitch, pitch_class);
        fprintf('Roll: %.2f (Class: %s)\n', roll, roll_class);
        fprintf('------------------------------\n');
    end
end






