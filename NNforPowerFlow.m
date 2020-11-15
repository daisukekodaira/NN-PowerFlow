%% Construct and Train a Function Fitting Network
% [Here, write down what the input and output of this code.]

function NNforPowerFlow
    %% Load the training data.
    % Note: 
    %     - P and Q are inputs for NN. The target is V and Delt.
    %     - The original data is calculated by traditional power flow analysis in **.m
    %     - IEEE 33 Bus model is utilized to generate the data set.
    P = readtable('P_Data_Of_Buses_10000.csv');
    Q = readtable('Q_Data_Of_Buses_10000.csv');
    V = readtable('V_Data_Of_Buses_10000.csv');
    Delt = readtable('Delta_Data_Of_Buses_10000.csv');
    % Transform from table to matrix
    P = table2array(P);
    Q = table2array(Q);
    V = table2array(V);
    Delt = table2array(Delt);

    %% Load parameters
    [NumOfLayers, trainRatio] = params;

    %% Neural Network; training and test
    % Decide the ratio of test
    testRatio = 100-trainRatio; % ex) 10[%]
    % Get the row in the table
    trainLastRow = round(size(P,1)*trainRatio/100);
    testFirstRow = trainLastRow+1;
    % Compose the data matrix for NN model input
    % Note: 
    %   - We have 33 bus data for P and Q, so each matrix has 66 by Cases
    %   - All matrixes are transposed to fit them to the 'fitnet' input form.
    trainInput = transpose([P(1:trainLastRow, :) Q(1:trainLastRow, :)]);
    testInput = transpose([P(testFirstRow:end, :) Q(testFirstRow:end, :)]);
    targetsForTrain = transpose([V(1:trainLastRow, :) Delt(1:trainLastRow, :)]);
    targetsForTest = transpose([V(testFirstRow:end, :) Delt(testFirstRow:end, :)]);
    % Construct the network 
    net = fitnet(NumOfLayers,'trainlm'); 
    net.trainParam.showWindow = 0;  % Disable windows
    % Train the network using the training data.
    % Note:
    %   - Input nodes (P and Q) by Cases
    net = train(net, trainInput, targetsForTrain); 
    % Estimate the targets using the trained network.
    EstimatedTarget = net(testInput);   % Row: Number of Buses, Column: Number of Cases
    err = EstimatedTarget - targetsForTest;   % Calculate error for each cases

    %% Display the result 
    numOfCases = size(targetsForTest,1)/2;
    histogram(err(:,1:numOfCases)); % error about Voltage
    figure;
    histogram(err(:,numOfCases+1:end)); % error about phesor(delta)
%     % Display standard deviation of the error distribution (what )
%     sigma = getStdDev();
%     % Display the Voltage and Delta graph for the best case (minimum error case)
%     % Display the Voltage and Delta graph for the worst case (max error case)
%     describeGraphs();
end
