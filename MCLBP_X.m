function Histogram = MCLBP_X(VolData, NeighborPoints, Radius, Bincount, Code)
% load the coordinator templates
LF = load('Coordinatortemplates1_8_X.mat');
CoorTemp = LF.CoorTemp;
PlaneNum = size(CoorTemp,3);

[height,width,Length] = size(VolData);

NPoints = NeighborPoints(1);
if (Bincount == 0)      % normal code
    nDim = 2^(YTNeighborPoints);
    Histogram = zeros(PlaneNum, nDim);
else    % uniform code
    Histogram = zeros(PlaneNum, Bincount);
end
zc=2;
    for yc = Radius + 1 : height - Radius
        for xc = Radius + 1 : width - Radius
            
            CenterVal = VolData(yc, xc, zc);
            for i=1:PlaneNum    % Loop in planes
                CoorT = CoorTemp(:,:,i);
                BasicLBP = 0;
                FeaBin = 0;
                for k=1:NPoints
                    xd=CoorT(1,k); yd=CoorT(2,k); zd=CoorT(3,k);
                    CurrentVal=VolData(yc+yd, xc+xd, zc+zd);
                    if CurrentVal >= CenterVal
                        BasicLBP = BasicLBP + 2 ^ FeaBin;
                        %                         BasicLBP = BasicLBP + 1;
                    end
                    FeaBin = FeaBin + 1;
                end
                if Bincount == 0
                    Histogram(i, BasicLBP + 1) = Histogram(i, BasicLBP + 1) + 1;
                else
                    Histogram(i, Code(BasicLBP + 1, 2) + 1) = Histogram(i, Code(BasicLBP + 1, 2) + 1) + 1;
                end
            end
        end
    end


% normalization
for j = 1 : PlaneNum
    Histogram(j, :) = Histogram(j, :)./sum(Histogram(j, :));
end
end