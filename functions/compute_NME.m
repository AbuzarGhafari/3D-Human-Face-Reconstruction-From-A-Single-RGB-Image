function NME = compute_NME(estimated_3d, gt_3d,  dir, angle)


% Project to 2D (for bounding box calculation)
landmarks_2d = projection3D(estimated_3d, dir, angle)';
x_coords_gt = landmarks_2d(1, :);
y_coords_gt = landmarks_2d(2, :);

% Calculate bounding box for ground truth landmarks
w_bbox = max(x_coords_gt) - min(x_coords_gt);
h_bbox = max(y_coords_gt) - min(y_coords_gt);
d = sqrt(w_bbox * h_bbox);

% Compute the Euclidean distance between each landmark
errors = vecnorm(gt_3d - estimated_3d, 2, 1) / d;

% Calculate NME
NME = mean(errors);

% Display the NME value
% fprintf('NME: %.4f\n', NME);

end

