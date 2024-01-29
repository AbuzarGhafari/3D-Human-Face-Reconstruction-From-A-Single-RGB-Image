function [normalize_data] = zeroOneNormalize3D(data)
    
    % Find the minimum and maximum values for each dimension (x, y, z)
    x_min = min(data(1, :));
    x_max = max(data(1, :));
    
    y_min = min(data(2, :));
    y_max = max(data(2, :));
    
    z_min = min(data(3, :));
    z_max = max(data(3, :));
    
    % Apply min-max scaling to each dimension independently
    normalize_x = (data(1, :) - x_min) ./ (x_max - x_min);
    normalize_y = (data(2, :) - y_min) ./ (y_max - y_min);   
    normalize_z = (data(3, :) - z_min) ./ (z_max - z_min);   
        
    normalize_data = [normalize_x; normalize_y; normalize_z];
end

