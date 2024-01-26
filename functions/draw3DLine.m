function draw3DLine(pt3d, firstPoint, lastPoint, color)
x = pt3d(1,:);
y = pt3d(2,:);
z = pt3d(3,:);
 
pl = line(x(firstPoint:lastPoint ),y(firstPoint:lastPoint ),z(firstPoint:lastPoint )) ;
pl.Color = color;
pl.LineWidth = 2;
 
end