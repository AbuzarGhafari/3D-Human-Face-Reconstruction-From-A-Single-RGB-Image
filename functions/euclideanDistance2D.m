function [distance] = euclideanDistance2D(landmarks1,landmarks2)

    res = sum((landmarks1 - landmarks2).^2);
    
    distance = sqrt(res);
    
    distance = sqrt(sum(distance));

end

