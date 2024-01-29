function [normalize_data] = zeroOneNormalize2D(data)
    
    % Find the minimum and maximum values for each dimension (x, y, z)
    x_min = min(data(1, :));
    x_max = max(data(1, :));
    
    y_min = min(data(2, :));
    y_max = max(data(2, :));
     
    
    % Apply min-max scaling to each dimension independently
    normalize_x = (data(1, :) - x_min) ./ (x_max - x_min);
    normalize_y = (data(2, :) - y_min) ./ (y_max - y_min);     
        
    normalize_data = [normalize_x; normalize_y];
end

