function fitParams = fitLine( xData, yData )
designMat = [ xData, ones(size(xData)) ]
fitParams = designMat\yData
end

x = [0; 1; 2; 3]
y = [-1; 0.2; 0.9; 2.1]
fitLine( x, y )
