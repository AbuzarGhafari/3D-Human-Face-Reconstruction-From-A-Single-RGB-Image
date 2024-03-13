function saveKDTreeResultMinMean_CSV(summary, path)

    % Extract the second column (distances) into an array
    distances = cell2mat(summary(:,2));

    % Find the index of the minimum distance
    [minDistance, index] = min(distances);

    % Retrieve the file name corresponding to the minimum distance
    minDistanceFile = summary{index, 1};
    
    
    
    fileID = fopen(path, 'a');    
    
    fprintf(fileID, '\n\n');    
    
    headers = {'File Name', minDistanceFile};

    headerStr = strjoin(headers, ',');

    fprintf(fileID, '%s\n', headerStr);
    
    headers = {'Minimum Mean', num2str(minDistance)};

    headerStr = strjoin(headers, ',');

    fprintf(fileID, '%s\n', headerStr);
    
    
    % Find the index of the minimum distance
    [maxDistance, index] = max(distances);

    % Retrieve the file name corresponding to the minimum distance
    maxDistanceFile = summary{index, 1};
    
    fprintf(fileID, '\n\n');    
    
    headers = {'File Name', maxDistanceFile};

    headerStr = strjoin(headers, ',');

    fprintf(fileID, '%s\n', headerStr);
    
    headers = {'Maximum Mean', num2str(maxDistance)};

    headerStr = strjoin(headers, ',');

    fprintf(fileID, '%s\n', headerStr);
    
    avgDistances = mean(distances);
    
    fprintf(fileID, '\n\n');  
    
    headers = {'Average Mean', num2str(avgDistances)};

    headerStr = strjoin(headers, ',');

    fprintf(fileID, '%s\n', headerStr);
    
    fclose(fileID);

end

