function [all_errors, mean_error] =   compute_performance_chunk(path)

fileNames = getDatasetFiles(path); 

all_errors = [];


for fileIndex = 1:numel(fileNames)
    
    load(join([path fileNames{fileIndex}], ''));       
    
    fprintf("%d: %s\n", fileIndex, join([path fileNames{fileIndex}], ''));    
    
    all_errors = [all_errors, result.op_error];    
end

mean_error = sum(all_errors)/numel(all_errors) * 100;

% Display results
% fprintf('NME: %.4f\n', mean);
% fprintf('NME (percentage): %.2f%%\n', errors_percentage);

end

