function [distance] = euclideanDistance2D(landmarks1,landmarks2)

    distance = sum(sqrt(sum((landmarks1 - landmarks2).^2, 1)));

end

