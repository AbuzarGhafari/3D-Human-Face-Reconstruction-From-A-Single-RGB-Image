function [fx, fy, cx, cy] = estimate_intrinsic_parameters(landmarks3D, landmarks2D)

landmarks3D = landmarks3D';
landmarks2D = landmarks2D';

% Image shape (replace with your actual image resolution)
image_width = 640;
image_height = 480;

% Estimate the principal point (cx, cy)
cx = image_width / 2;
cy = image_height / 2;

% Solve for focal lengths fx and fy
fx_vals = [];
fy_vals = [];

for i = 1:size(landmarks3D, 1)
    % Extract the 3D and 2D coordinates for each point
    x = landmarks3D(i, 1);
    y = landmarks3D(i, 2);
    z = landmarks3D(i, 3);
    u = landmarks2D(i, 1);
    v = landmarks2D(i, 2);
    
    % Estimate fx and fy for each point
    if x ~= 0
        fx_vals = [fx_vals; (u - cx) * z / x];
    else
        fx_vals = [fx_vals; 0];
    end
    if y ~= 0
        fy_vals = [fy_vals; (v - cy) * z / y];
    else
        fy_vals = [fy_vals; 0];
    end
end

% Compute the mean focal lengths
fx = mean(fx_vals);
fy = mean(fy_vals);

% Print out the intrinsic camera parameters
% fprintf('Intrinsic Camera Parameters:\n');
% fprintf('fx: %.2f, fy: %.2f, cx: %.2f, cy: %.2f\n', fx, fy, cx, cy);


end

