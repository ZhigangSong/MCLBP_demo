clear all
% close all
% clc
addpath('./functions/');

rootpic = '../Outex-TC-00031/';
picNum = 2720;%

Radius = 1;

load ('patternMappingU2.mat');

Bincount = UniformLBP.num; %59 / 0
NeighborPoints = [UniformLBP.samples UniformLBP.samples UniformLBP.samples]; % XY, XT, and YT planes, respectively
BinNum = length(UniformLBP.table);
nDim = UniformLBP.num; %dimensionality of uniform patterns
Code = [(1:BinNum)',UniformLBP.table'];

% Feature extract
tic
for i=1:picNum;
    
    filename = sprintf('%s//images//%06d.bmp', rootpic, i-1);
    img = imread(filename);
    
    display([num2str(i) '.... '  filename]);

    VolData(:,:,1) = img(:,:,1);
    VolData(:,:,2) = img(:,:,2);
    VolData(:,:,3) = img(:,:,3);
    VolData(:,:,4) = img(:,:,1);
    VolData(:,:,5) = img(:,:,2);

    MC1   = MCLBP_X(VolData(:,:,1:3), NeighborPoints, Radius, Bincount, Code);
    MC11  = MCLBP_X(VolData(:,:,2:4), NeighborPoints, Radius, Bincount, Code);
    MC111 = MCLBP_X(VolData(:,:,3:5), NeighborPoints, Radius, Bincount, Code);
   
    MC2   = MCLBP_Y(VolData(:,:,1:3), NeighborPoints, Radius, Bincount, Code);
    MC22  = MCLBP_Y(VolData(:,:,2:4), NeighborPoints, Radius, Bincount, Code);
    MC222 = MCLBP_Y(VolData(:,:,3:5), NeighborPoints, Radius, Bincount, Code);
   
    MC3   = MCLBP_Z(VolData(:,:,1:3), NeighborPoints, Radius, Bincount, Code);
    MC33  = MCLBP_Z(VolData(:,:,2:4), NeighborPoints, Radius, Bincount, Code);
    MC333 = MCLBP_Z(VolData(:,:,3:5), NeighborPoints, Radius, Bincount, Code);
   
    MCLBPHist(i,:) = [MC1 MC11 MC111 MC2 MC22 MC222 MC3 MC33 MC333];
end
toc

% Classification
trainTxt = sprintf('%s000//train.txt', rootpic);
testTxt = sprintf('%s000//test.txt', rootpic);
[trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);
[testIDs, testClassIDs] = ReadOutexTxt(testTxt);
CP = cal_AP(MCLBPHist,trainIDs, trainClassIDs,testIDs, testClassIDs)



