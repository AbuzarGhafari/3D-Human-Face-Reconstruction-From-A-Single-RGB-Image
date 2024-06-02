function index = findFileIndexPathMatrix(pathMatrix, filename)
    % Initialize an empty array to store indices where the filename is found
    index = [];

    % Loop through each row of the pathMatrix
    for i = 1:size(pathMatrix, 1)
        % Check if the filename is a substring of the full path in the first column of the matrix
        if ~isempty(strfind(pathMatrix{i, 1}, filename))
            % If found, append the index to the array
            index = [index; i];
        end
    end
end
