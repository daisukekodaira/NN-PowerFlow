% This function defines the parameters for 'NeuralNetworkByFitNet'

function [NumOfLayers, trainRatio] = params

% NumOfLayers
% Note:
% - The number of layers for Neural Network
% - As the number of layers increase, the calcualtion time drastically increase
% - Recommended value is 3
NumOfLayers = 1;

% trainRatio
% Note:
% - Ratio of training data [%]. The rest data is for test data.
trainRatio = 90;



end