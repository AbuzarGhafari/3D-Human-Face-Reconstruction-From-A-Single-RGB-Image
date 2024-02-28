function [errPrJnts, errPrFr, errPrAllFr] = H_errorHumanEva(data,mocapGT,cJoints)
% data = data(1:3*length(cJoints),:);
% mocapGT = mocapGT(1:3*length(cJoints),:);

errPrFr   = nan(size(data,2),1);                   % error nrOfFrames
errPrJnts = nan(size(data,1)/3,1,size(data,2));    % error joints*knn*nrOfFrames

for f = 1:size(data,2)            % frames
    errPrJntsTmp = nan(size(data,1)/3,1);
    i = 1;
    for j = 1:size(data,1)/3      % joints
        errPrJntsTmp(j) = error_internal(data(i:i+2,f),mocapGT(i:i+2,f));
        i = i + 3;
    end
    errPrJnts(:,1,f) = errPrJntsTmp;
    errPrFr(f) = mean(errPrJntsTmp);
end
errPrAllFr = mean(errPrFr);
end

function [err] = error_internal(point1, point2)
err = sqrt(sum((point1(:) - point2(:)).^2));
end