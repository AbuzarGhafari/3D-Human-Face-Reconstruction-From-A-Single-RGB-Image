function draw2DFace(pt2d, t)

x = pt2d(1,:);
y = pt2d(2,:);

% figure;
hold on;

% face
draw2DLine(x, y, 1, 17, 'red');

% Left Eye Brow
draw2DLine(x, y, 18, 22, 'black');
% Right Eye Brow
draw2DLine(x, y, 23, 27, 'black');

% Nose 
draw2DLine(x, y, 28, 36, 'blue');
 
% Left Eye
draw2DLineCircle(x, y, 37, 42, 'black');
% Right Eye
draw2DLineCircle(x, y, 43, 48, 'black');
  
% Lips
draw2DLineCircle(x, y, 49, 68, 'blue');
 
% Landmark Points
% scatter(x,y,'MarkerEdgeColor',"r",...
%             'MarkerFaceColor',"k",...
%               'LineWidth',1.5);

% Add a title to the plot
title(t);

% Set the background color to white
set(gcf, 'Color', 'white');

grid on;
 
axis off;
hold off; 
end