function draw2DFace(pt2d, t, color)

x = pt2d(1,:);
y = pt2d(2,:);

% figure;
hold on;

% face
draw2DLine(x, y, 1, 17, color);

% Left Eye Brow
draw2DLine(x, y, 18, 22, color);
% Right Eye Brow
draw2DLine(x, y, 23, 27, color);

% Nose 
draw2DLine(x, y, 28, 36, color);


nose_index = 31;
scatter(pt2d(1,nose_index),...
            pt2d(2,nose_index),... 
            'MarkerEdgeColor',"r", ...
            'MarkerFaceColor',"k",...
            'LineWidth',1);
        
% Add the label to the plot
% text(pt2d(1,nose_index), pt2d(2,nose_index), num2str([pt2d(1,nose_index), pt2d(2,nose_index)]), 'FontSize', 12, 'FontWeight', 'bold');

 
% Left Eye
draw2DLineCircle(x, y, 37, 42, color);
% Right Eye
draw2DLineCircle(x, y, 43, 48, color);
  
% Lips
draw2DLineCircle(x, y, 49, 68, color);
 
% Landmark Points
% scatter(x,y,'MarkerEdgeColor',"r",...
%             'MarkerFaceColor',"k",...
%               'LineWidth',1.5);

% Add a title to the plot
title(t);

% Set the background color to white
set(gcf, 'Color', 'white');

% set(gca, 'XDir','reverse');
% set(gca, 'YDir','reverse');

grid on;
 
% axis off;
% hold off; 
end