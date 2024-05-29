function [dir, angle] = getMostlyUsedDirAndAngle(DA)


    % Convert angles to numeric for easier manipulation
    angles = str2double(DA(:,2));

    % Find the most frequently occurring direction
    [uniqueDirs, ~, dirIndices] = unique(DA(:,1));
    dirCounts = accumarray(dirIndices, 1);
    [~, maxDirIndex] = max(dirCounts);
    mostFreqDir = uniqueDirs{maxDirIndex};

    % Filter for the most frequent direction
    isMostFreqDir = strcmp(DA(:,1), mostFreqDir);
    filteredAngles = angles(isMostFreqDir);

    % Find the most frequently occurring angle within the most frequent direction
    [uniqueAngles, ~, angleIndices] = unique(filteredAngles);
    angleCounts = accumarray(angleIndices, 1);
    [~, maxAngleIndex] = max(angleCounts);
    mostFreqAngle = uniqueAngles(maxAngleIndex);

    % Display the results
%     fprintf('Most frequently occurring direction: %s\n', mostFreqDir);
%     fprintf('Most frequently occurring angle within that direction: %d\n', mostFreqAngle);

    dir = mostFreqDir;
    angle = mostFreqAngle;

end

