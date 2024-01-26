function draw2DLineCircle(x, y, firstPoint, lastPoint, color)

 
pl = line(x(firstPoint:lastPoint ),y(firstPoint:lastPoint )) ;
pl.Color = color;  
pl.LineWidth = 2;

pl = line(x([firstPoint lastPoint] ),y([firstPoint lastPoint]));
pl.Color = color;  
pl.LineWidth = 2;
 
end