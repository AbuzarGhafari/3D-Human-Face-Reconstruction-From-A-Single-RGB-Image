function draw2DLine(x, y, firstPoint, lastPoint, color)
 
pl = line(x(firstPoint:lastPoint ),y(firstPoint:lastPoint )) ;
pl.Color = color;
pl.LineWidth = 2;
 
end