clc;

clear all;

%% Construct and Train a Function Fitting Network
% Load the training data.

%N=1;kore

T1=readtable('Delta_P_Data_Of_Buses.csv','ReadRowNames',true);
T1=table2array(T1);
%T1=T1.';
T2=readtable('Delta_Q_Data_Of_Buses.csv','ReadRowNames',true);
T2=table2array(T2);
%T2=T2.';

% inputs=T1(N,:);

%inputs=[T1(:,N),T2(:,N)];de-tabunnkatunomaenitukattetanohakore

%inputs=[T1(1:33,1:1000);T2(1:33,1:1000)];

inputs=[T1(1:33,1:800);T2(1:33,1:800)];%koreha 1000 konotoki
% inputs=[T1(1:33,1:8000);T2(1:33,1:8000)];

% inputs=T1(N,:);

% inputs={T1(N,:);T2(N,:)};

T3=readtable('Delta_V_Data_Of_Buses.csv');
T3=table2array(T3);
T3=T3.';
T4=readtable('Delta_Delta_Data_Of_Buses.csv');
T4=table2array(T4);
T4=T4.';

%targets=[T3(:,N),T4(:,N)];de-tabunnkatunomaenitukattetanohakore

%targets=[T3(1:33,1:1000);T4(1:33,1:1000)];

targets=[T3(1:33,1:800);T4(1:33,1:800)];%koreha 1000 konotoki
% targets=[T3(1:33,1:8000);T4(1:33,1:8000)];

% targets={T3(N,:),T4(N,:)};

x=inputs;

t=targets;

% [x,t] = simplefit_dataset;

%%
% The 1-by-94 matrix |x| contains the input values and the 1-by-94 matrix |t|
% contains the associated target output values.
%%
% Construct a function fitting neural network with one hidden layer of size
% 10.
% net = fitnet(10);
% net=fitnet([20,20],'trainscg');
net=fitnet(10,'trainlm');
%%
% View the network.
% view(net)
%%
% The sizes of the input and output are zero. The software adjusts
% the sizes of these during training according to the training data.
%%
% Train the network |net| using the training data.
net = train(net,x,t);
%%
% View the trained network.
view(net)
%%
% You can see that the sizes of the input and output are 1.
%%
% Estimate the targets using the trained network.
NetOutputY = net([T1(1:33,801:1000);T2(1:33,801:1000)]);%koreha 1000 konotoki
% NetOutputY = net([T1(1:33,8001:10000);T2(1:33,8001:10000)]);
MeanNetOutputY = mean(NetOutputY,2);
%%
% Assess the performance of the trained network. The default performance function is mean squared error.
%trainlmperf = perform(net,y,[T3(1:33,801:1000);T4(1:33,801:1000)])%これを変える必要がある。やるべきことは、perform関数の仕様の把握とその戻り値がわからないうちはこの関数を使わないで例の実装をすること。
PowerFlowCalculationY = [T3(1:33,801:1000);T4(1:33,801:1000)];%koreha 1000 konotoki
% PowerFlowCalculationY = [T3(1:33,8001:10000);T4(1:33,8001:10000)];
MeanPowerFlowCalculationY = mean(PowerFlowCalculationY,2);

error = MeanNetOutputY-MeanPowerFlowCalculationY;

f1 = figure;
f2 = figure;
f3 = figure;
f4 = figure;

plot(1:1:33,MeanNetOutputY(1:33),1:1:33,MeanPowerFlowCalculationY(1:33));
legend('ニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値');
axis([1 33 0.65 1]);
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f3);
plot(1:1:33,error(1:33));
xlabel('母線番号');
ylabel('NN出力電圧値-潮流計算電圧値[p.u.]');
title('各母線の電圧値の誤差');
figure(f2);
plot(1:1:33,MeanNetOutputY(34:66),1:1:33,MeanPowerFlowCalculationY(34:66));
legend('ニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値');
axis([1 33 0 0.85]);
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');
figure(f1);
plot(1:1:33,error(34:66));
xlabel('母線番号');
ylabel('NN出力電圧位相角値-潮流計算電圧位相角値[p.u.]');
title('各母線の電圧の位相角の値の誤差');
% trainlmperf = perform(net,y,t)
%%
% The default training algorithm for a function fitting network is
% Levenberg-Marquardt ( |'trainlm'| ). Use the Bayesian regularization training algorithm and
% compare the performance results.
%net=fitnet(10,'trainbr'); kore
% net=fitnet([20,20],'trainbr');
% net = fitnet(10,'trainbr');
%net = train(net,x,t); kore
%y = net(x); kore
%trainbrperf = perform(net,y,t) kore
%%
% The Bayesian regularization training algorithm improves the performance of the network in terms of
% estimating the target values.


%% 
% Copyright 2012 The MathWorks, Inc.