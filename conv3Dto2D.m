function [pt2d] = conv3Dto2D(pt3d)
% Define camera intrinsic parameters
f_x = 1000;   % Focal length in x-direction
f_y = 1000;   % Focal length in y-direction
c_x = 640;    % Principal point x-coordinate
c_y = 480;    % Principal point y-coordinate
s = 0;        % Skew factor

% Intrinsic matrix K
K = [f_x, s, c_x; 0, f_y, c_y; 0, 0, 1];

% Define camera extrinsic parameters (rotation matrix R and translation vector t)
% You would typically have these values from camera calibration or scene setup.
R = eye(3);  % Identity rotation matrix (no rotation)
t = [0; 0; 0];  % Translation vector (no translation)

% Combine intrinsic and extrinsic matrices to form the camera matrix P
P = K * [R, t];
 
pt2d = P * pt3d';


end

