function [d_mean] = saveKDTreeResult_CSV(Idx, D, file_name, path)

    A = [Idx; D];
    
    d_mean = mean(D, 'all');

    fileID = fopen(path, 'a');    
    
    headers = {'File Name', file_name};

    headerStr = strjoin(headers, ',');

    fprintf(fileID, '%s\n', headerStr);
    
    headers = {'Mean', num2str(d_mean)};

    headerStr = strjoin(headers, ',');

    fprintf(fileID, '%s\n', headerStr);
    
%     headers = {'Index', 'Distance'};
%     
%     headerStr = strjoin(headers, ',');
% 
%     fprintf(fileID, '%s\n', headerStr);
    
 
    writematrix(A, path, 'WriteMode', 'append'); 
    
    fprintf(fileID, '\n');
    
    fclose(fileID);

end

