function [errors, mean_error, all_errors] =   compute_performance()

fileNames = getDatasetFiles("results/optimization-3/AFLW/"); 

all_errors = [];
yaw_class_1 = [];
yaw_class_2 = [];
yaw_class_3 = [];

for fileIndex = 1:numel(fileNames)
    load(join(["results/optimization-3/AFLW/" fileNames{fileIndex}], ''));       
    
    fprintf("%d: %s\n", fileIndex, join(["results/optimization-3/AFLW/" fileNames{fileIndex}], ''));
    
    res.op_error = result.op_error;
    res.yaw_class = result.yaw_class_id;
    
    all_errors = [all_errors, res];    
end


% Extract `op_error` values from the structure array
op_errors = [all_errors.op_error];

% Get sorted indices based on `op_error`
[~, sorted_indices] = sort(op_errors);

% Sort the structure array `all_errors` using the sorted indices
sorted_all_errors = all_errors(sorted_indices);

% Extract only the first 1980 elements (or all if less than 1980)
sorted_all_errors = sorted_all_errors(1:min(1980, length(sorted_all_errors)));

for index = 1:numel(sorted_all_errors)
    if (sorted_all_errors(index).yaw_class == 1)
        yaw_class_1 = [yaw_class_1, sorted_all_errors(index).op_error];
    elseif (sorted_all_errors(index).yaw_class == 2)
        yaw_class_2 = [yaw_class_2, sorted_all_errors(index).op_error];        
    elseif (sorted_all_errors(index).yaw_class == 3)
        yaw_class_3 = [yaw_class_3, sorted_all_errors(index).op_error];        
    end
end

errors = [];

errors = [errors; round(sum(yaw_class_1)/numel(yaw_class_1)*100, 2)];
errors = [errors; round(sum(yaw_class_2)/numel(yaw_class_2)*100, 2)];
errors = [errors; round(sum(yaw_class_3)/numel(yaw_class_3)*100, 2)];

mean_error = round(sum(errors)/numel(errors), 2);

% Display results
% fprintf('NME: %.4f\n', mean);
% fprintf('NME (percentage): %.2f%%\n', errors_percentage);

end

