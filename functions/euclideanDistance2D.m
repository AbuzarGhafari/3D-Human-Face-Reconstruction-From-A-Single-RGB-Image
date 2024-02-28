function [distance] = euclideanDistance2D(landmarks1,landmarks2)

    res = sum((landmarks1 - landmarks2).^2);
    
    res = sum(res);
    
    distance = sqrt(res);
    
%     distance = sqrt(sum(distance));

end

