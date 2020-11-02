%% 今10000(1万)個のデータの場合になっている
%% データを抜く母線を等間隔にしない場合

clc;

clear all;

%% Construct and Train a Function Fitting Network
% Load the training data.

%N=1;kore

T1 = readtable('P_Data_Of_Buses_10000.csv','ReadRowNames',true);
T1 = table2array(T1);
%T1=T1.';
T2 = readtable('Q_Data_Of_Buses_10000.csv','ReadRowNames',true);
T2 = table2array(T2);
%T2=T2.';

% inputs=T1(N,:);

%inputs=[T1(:,N),T2(:,N)];de-tabunnkatunomaenitukattetanohakore

%inputs=[T1(1:33,1:1000);T2(1:33,1:1000)];

%inputs = [T1(1:33,1:800);T2(1:33,1:800)];%koreha 1000 konotoki
inputs=[T1(1:33,1:8000);T2(1:33,1:8000)];

% inputs=T1(N,:);

% inputs={T1(N,:);T2(N,:)};

T3 = readtable('V_Data_Of_Buses_10000.csv');
T3 = table2array(T3);
T3 = T3.';
T4 = readtable('Delta_Data_Of_Buses_10000.csv');
T4 = table2array(T4);
T4 = T4.';

%targets=[T3(:,N),T4(:,N)];de-tabunnkatunomaenitukattetanohakore

%targets=[T3(1:33,1:1000);T4(1:33,1:1000)];

%targets = [T3(1:33,1:800);T4(1:33,1:800)];%koreha 1000 konotoki
targets=[T3(1:33,1:8000);T4(1:33,1:8000)];

% targets={T3(N,:),T4(N,:)};

x = inputs;

t = targets;

% [x,t] = simplefit_dataset;

%%
% The 1-by-94 matrix |x| contains the input values and the 1-by-94 matrix |t|
% contains the associated target output values.
%%
% Construct a function fitting neural network with one hidden layer of size
% 10.
% net = fitnet(10);
% net=fitnet([20,20],'trainscg');
net = fitnet(10,'trainlm');
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

%view(net) kore iranai

%%
% You can see that the sizes of the input and output are 1.
%%
% Estimate the targets using the trained network.
%NetOutputY = net([T1(1:33,801:1000);T2(1:33,801:1000)]);%koreha 1000 konotoki
NetOutputY = net([T1(1:33,8001:10000);T2(1:33,8001:10000)]);
MeanNetOutputY = mean(NetOutputY,2);
%%
% Assess the performance of the trained network. The default performance function is mean squared error.
%trainlmperf = perform(net,y,[T3(1:33,801:1000);T4(1:33,801:1000)])%これを変える必要がある。やるべきことは、perform関数の仕様の把握とその戻り値がわからないうちはこの関数を使わないで例の実装をすること。
%PowerFlowCalculationY = [T3(1:33,801:1000);T4(1:33,801:1000)];%koreha 1000 konotoki
PowerFlowCalculationY = [T3(1:33,8001:10000);T4(1:33,8001:10000)];
MeanPowerFlowCalculationY = mean(PowerFlowCalculationY,2);

error = MeanNetOutputY - MeanPowerFlowCalculationY;

%% ここから新しいコード
%{
%% 3母線(19,21,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_30buses = [T1(1:18,1:8000);T1(20,1:8000);T1(22:31,1:8000);T1(33,1:8000);T2(1:18,1:8000);T2(20,1:8000);T2(22:31,1:8000);T2(33,1:8000)];

targets_for_30buses = [T3(1:18,1:8000);T3(20,1:8000);T3(22:31,1:8000);T3(33,1:8000);T4(1:18,1:8000);T4(20,1:8000);T4(22:31,1:8000);T4(33,1:8000)];

x_for_30buses = inputs_for_30buses;

t_for_30buses = targets_for_30buses;

net_for_30buses = fitnet(10,'trainlm');

net_for_30buses = train(net_for_30buses,x_for_30buses,t_for_30buses);

%view(net_for_30buses) kore iranai

NetOutputY_for_30buses = net_for_30buses([T1(1:18,8001:10000);T1(20,8001:10000);T1(22:31,8001:10000);T1(33,8001:10000);T2(1:18,8001:10000);T2(20,8001:10000);T2(22:31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_30buses = mean(NetOutputY_for_30buses,2);

PowerFlowCalculationY_for_30buses = [T3(1:18,8001:10000);T3(20,8001:10000);T3(22:31,8001:10000);T3(33,8001:10000);T4(1:18,8001:10000);T4(20,8001:10000);T4(22:31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_30buses = mean(PowerFlowCalculationY_for_30buses,2);

error_for_30buses = MeanNetOutputY_for_30buses - MeanPowerFlowCalculationY_for_30buses;

MeanNetOutputY_for_30buses_converted_into_33 = [MeanNetOutputY_for_30buses(1:18,1);NaN;MeanNetOutputY_for_30buses(19,1);NaN;MeanNetOutputY_for_30buses(20:29,1);NaN;MeanNetOutputY_for_30buses(30,1);
                                                MeanNetOutputY_for_30buses(31:48,1);NaN;MeanNetOutputY_for_30buses(49,1);NaN;MeanNetOutputY_for_30buses(50:59,1);NaN;MeanNetOutputY_for_30buses(60,1)];

MeanPowerFlowCalculationY_for_30buses_converted_into_33 = [MeanPowerFlowCalculationY_for_30buses(1:18,1);NaN;MeanPowerFlowCalculationY_for_30buses(19,1);NaN;MeanPowerFlowCalculationY_for_30buses(20:29,1);NaN;MeanPowerFlowCalculationY_for_30buses(30,1);
                                                           MeanPowerFlowCalculationY_for_30buses(31:48,1);NaN;MeanPowerFlowCalculationY_for_30buses(49,1);NaN;MeanPowerFlowCalculationY_for_30buses(50:59);NaN;MeanPowerFlowCalculationY_for_30buses(60,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;
MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f1 = figure;
f2 = figure;

plot(1:1:33,MeanNetOutputY_for_30buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_30buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('3母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f1);
plot(1:1:33,MeanNetOutputY_for_30buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_30buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('3母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 5母線(19,21,"28","30",32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_28buses = [T1(1:18,1:8000);T1(20,1:8000);T1(22:27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(1:18,1:8000);T2(20,1:8000);T2(22:27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_28buses = [T3(1:18,1:8000);T3(20,1:8000);T3(22:27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(1:18,1:8000);T4(20,1:8000);T4(22:27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_28buses = inputs_for_28buses;

t_for_28buses = targets_for_28buses;

net_for_28buses = fitnet(10,'trainlm');

net_for_28buses = train(net_for_28buses,x_for_28buses,t_for_28buses);

%view(net_for_28buses) kore iranai

NetOutputY_for_28buses = net_for_28buses([T1(1:18,8001:10000);T1(20,8001:10000);T1(22:27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(1:18,8001:10000);T2(20,8001:10000);T2(22:27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_28buses = mean(NetOutputY_for_28buses,2);

PowerFlowCalculationY_for_28buses = [T3(1:18,8001:10000);T3(20,8001:10000);T3(22:27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(1:18,8001:10000);T4(20,8001:10000);T4(22:27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_28buses = mean(PowerFlowCalculationY_for_28buses,2);

error_for_28buses = MeanNetOutputY_for_28buses - MeanPowerFlowCalculationY_for_28buses;
%% 5母線(19,21,"28","30",32)分のデータを抜いて
MeanNetOutputY_for_28buses_converted_into_33 = [MeanNetOutputY_for_28buses(1:18,1);NaN;MeanNetOutputY_for_28buses(19,1);NaN;MeanNetOutputY_for_28buses(20:25,1);NaN;MeanNetOutputY_for_28buses(26,1);NaN;MeanNetOutputY_for_28buses(27,1);NaN;MeanNetOutputY_for_28buses(28,1);
                                                MeanNetOutputY_for_28buses(29:46,1);NaN;MeanNetOutputY_for_28buses(47,1);NaN;MeanNetOutputY_for_28buses(48:53,1);NaN;MeanNetOutputY_for_28buses(54,1);NaN;MeanNetOutputY_for_28buses(55,1);NaN;MeanNetOutputY_for_28buses(56,1)];

MeanPowerFlowCalculationY_for_28buses_converted_into_33 = [MeanPowerFlowCalculationY_for_28buses(1:18,1);NaN;MeanPowerFlowCalculationY_for_28buses(19,1);NaN;MeanPowerFlowCalculationY_for_28buses(20:25,1);NaN;MeanPowerFlowCalculationY_for_28buses(26,1);NaN;MeanPowerFlowCalculationY_for_28buses(27,1);NaN;MeanPowerFlowCalculationY_for_28buses(28,1);
                                                           MeanPowerFlowCalculationY_for_28buses(29:46,1);NaN;MeanPowerFlowCalculationY_for_28buses(47,1);NaN;MeanPowerFlowCalculationY_for_28buses(48:53,1);NaN;MeanPowerFlowCalculationY_for_28buses(54,1);NaN;MeanPowerFlowCalculationY_for_28buses(55,1);NaN;MeanPowerFlowCalculationY_for_28buses(56,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(61,1) = NaN;
MeanNetOutputY_for_33buses(63,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f3 = figure;
f4 = figure;

plot(1:1:33,MeanNetOutputY_for_28buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_28buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('5母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f3);
plot(1:1:33,MeanNetOutputY_for_28buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_28buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('5母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 6母線(19,21,"26",28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_27buses = [T1(1:18,1:8000);T1(20,1:8000);T1(22:25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(1:18,1:8000);T2(20,1:8000);T2(22:25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_27buses = [T3(1:18,1:8000);T3(20,1:8000);T3(22:25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(1:18,1:8000);T4(20,1:8000);T4(22:25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_27buses = inputs_for_27buses;

t_for_27buses = targets_for_27buses;

net_for_27buses = fitnet(10,'trainlm');

net_for_27buses = train(net_for_27buses,x_for_27buses,t_for_27buses);

%view(net_for_27buses) kore iranai

NetOutputY_for_27buses = net_for_27buses([T1(1:18,8001:10000);T1(20,8001:10000);T1(22:25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(1:18,8001:10000);T2(20,8001:10000);T2(22:25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_27buses = mean(NetOutputY_for_27buses,2);

PowerFlowCalculationY_for_27buses = [T3(1:18,8001:10000);T3(20,8001:10000);T3(22:25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(1:18,8001:10000);T4(20,8001:10000);T4(22:25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_27buses = mean(PowerFlowCalculationY_for_27buses,2);

error_for_27buses = MeanNetOutputY_for_27buses - MeanPowerFlowCalculationY_for_27buses;
%% 6母線(19,21,"26",28,30,32)分のデータを抜いて
MeanNetOutputY_for_27buses_converted_into_33 = [MeanNetOutputY_for_27buses(1:18,1);NaN;MeanNetOutputY_for_27buses(19,1);NaN;MeanNetOutputY_for_27buses(20:23,1);NaN;MeanNetOutputY_for_27buses(24,1);NaN;MeanNetOutputY_for_27buses(25,1);NaN;MeanNetOutputY_for_27buses(26,1);NaN;MeanNetOutputY_for_27buses(27,1);
                                                MeanNetOutputY_for_27buses(28:45,1);NaN;MeanNetOutputY_for_27buses(46,1);NaN;MeanNetOutputY_for_27buses(47:50,1);NaN;MeanNetOutputY_for_27buses(51,1);NaN;MeanNetOutputY_for_27buses(52,1);NaN;MeanNetOutputY_for_27buses(53,1);NaN;MeanNetOutputY_for_27buses(54,1)];

MeanPowerFlowCalculationY_for_27buses_converted_into_33 = [MeanPowerFlowCalculationY_for_27buses(1:18,1);NaN;MeanPowerFlowCalculationY_for_27buses(19,1);NaN;MeanPowerFlowCalculationY_for_27buses(20:23,1);NaN;MeanPowerFlowCalculationY_for_27buses(24,1);NaN;MeanPowerFlowCalculationY_for_27buses(25,1);NaN;MeanPowerFlowCalculationY_for_27buses(26,1);NaN;MeanPowerFlowCalculationY_for_27buses(27,1);
                                                           MeanPowerFlowCalculationY_for_27buses(28:45,1);NaN;MeanPowerFlowCalculationY_for_27buses(46,1);NaN;MeanPowerFlowCalculationY_for_27buses(47:50,1);NaN;MeanPowerFlowCalculationY_for_27buses(51,1);NaN;MeanPowerFlowCalculationY_for_27buses(52,1);NaN;MeanPowerFlowCalculationY_for_27buses(53,1);NaN;MeanPowerFlowCalculationY_for_27buses(54,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(26,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(59,1) = NaN;
MeanNetOutputY_for_33buses(61,1) = NaN;
MeanNetOutputY_for_33buses(63,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f5 = figure;
f6 = figure;

plot(1:1:33,MeanNetOutputY_for_27buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_27buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('6母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f5);
plot(1:1:33,MeanNetOutputY_for_27buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_27buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('6母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 9母線("13","15","17",19,21,26,28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_24buses = [T1(1:12,1:8000);T1(14,1:8000);T1(16,1:8000);T1(18,1:8000);T1(20,1:8000);T1(22:25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(1:12,1:8000);T2(14,1:8000);T2(16,1:8000);T2(18,1:8000);T2(20,1:8000);T2(22:25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_24buses = [T3(1:12,1:8000);T3(14,1:8000);T3(16,1:8000);T3(18,1:8000);T3(20,1:8000);T3(22:25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(1:12,1:8000);T4(14,1:8000);T4(16,1:8000);T4(18,1:8000);T4(20,1:8000);T4(22:25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_24buses = inputs_for_24buses;

t_for_24buses = targets_for_24buses;

net_for_24buses = fitnet(10,'trainlm');

net_for_24buses = train(net_for_24buses,x_for_24buses,t_for_24buses);

%view(net_for_24buses) kore iranai

NetOutputY_for_24buses = net_for_24buses([T1(1:12,8001:10000);T1(14,8001:10000);T1(16,8001:10000);T1(18,8001:10000);T1(20,8001:10000);T1(22:25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(1:12,8001:10000);T2(14,8001:10000);T2(16,8001:10000);T2(18,8001:10000);T2(20,8001:10000);T2(22:25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_24buses = mean(NetOutputY_for_24buses,2);

PowerFlowCalculationY_for_24buses = [T3(1:12,8001:10000);T3(14,8001:10000);T3(16,8001:10000);T3(18,8001:10000);T3(20,8001:10000);T3(22:25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(1:12,8001:10000);T4(14,8001:10000);T4(16,8001:10000);T4(18,8001:10000);T4(20,8001:10000);T4(22:25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_24buses = mean(PowerFlowCalculationY_for_24buses,2);

error_for_24buses = MeanNetOutputY_for_24buses - MeanPowerFlowCalculationY_for_24buses;
%% 9母線("13","15","17",19,21,26,28,30,32)分のデータを抜いて
MeanNetOutputY_for_24buses_converted_into_33 = [MeanNetOutputY_for_24buses(1:12,1);NaN;MeanNetOutputY_for_24buses(13,1);NaN;MeanNetOutputY_for_24buses(14,1);NaN;MeanNetOutputY_for_24buses(15,1);NaN;MeanNetOutputY_for_24buses(16,1);NaN;MeanNetOutputY_for_24buses(17:20,1);NaN;MeanNetOutputY_for_24buses(21,1);NaN;MeanNetOutputY_for_24buses(22,1);NaN;MeanNetOutputY_for_24buses(23,1);NaN;MeanNetOutputY_for_24buses(24,1);
                                                MeanNetOutputY_for_24buses(25:36,1);NaN;MeanNetOutputY_for_24buses(37,1);NaN;MeanNetOutputY_for_24buses(38,1);NaN;MeanNetOutputY_for_24buses(39,1);NaN;MeanNetOutputY_for_24buses(40,1);NaN;MeanNetOutputY_for_24buses(41:44,1);NaN;MeanNetOutputY_for_24buses(45,1);NaN;MeanNetOutputY_for_24buses(46,1);NaN;MeanNetOutputY_for_24buses(47,1);NaN;MeanNetOutputY_for_24buses(48,1)];

MeanPowerFlowCalculationY_for_24buses_converted_into_33 = [MeanPowerFlowCalculationY_for_24buses(1:12,1);NaN;MeanPowerFlowCalculationY_for_24buses(13,1);NaN;MeanPowerFlowCalculationY_for_24buses(14,1);NaN;MeanPowerFlowCalculationY_for_24buses(15,1);NaN;MeanPowerFlowCalculationY_for_24buses(16,1);NaN;MeanPowerFlowCalculationY_for_24buses(17:20,1);NaN;MeanPowerFlowCalculationY_for_24buses(21,1);NaN;MeanPowerFlowCalculationY_for_24buses(22,1);NaN;MeanPowerFlowCalculationY_for_24buses(23,1);NaN;MeanPowerFlowCalculationY_for_24buses(24,1);
                                                           MeanPowerFlowCalculationY_for_24buses(25:36,1);NaN;MeanPowerFlowCalculationY_for_24buses(37,1);NaN;MeanPowerFlowCalculationY_for_24buses(38,1);NaN;MeanPowerFlowCalculationY_for_24buses(39,1);NaN;MeanPowerFlowCalculationY_for_24buses(40,1);NaN;MeanPowerFlowCalculationY_for_24buses(41:44,1);NaN;MeanPowerFlowCalculationY_for_24buses(45,1);NaN;MeanPowerFlowCalculationY_for_24buses(46,1);NaN;MeanPowerFlowCalculationY_for_24buses(47,1);NaN;MeanPowerFlowCalculationY_for_24buses(48,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(13,1) = NaN;
MeanNetOutputY_for_33buses(15,1) = NaN;
MeanNetOutputY_for_33buses(17,1) = NaN;
MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(26,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(46,1) = NaN;
MeanNetOutputY_for_33buses(48,1) = NaN;
MeanNetOutputY_for_33buses(50,1) = NaN;
MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(59,1) = NaN;
MeanNetOutputY_for_33buses(61,1) = NaN;
MeanNetOutputY_for_33buses(63,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f7 = figure;
f8 = figure;

plot(1:1:33,MeanNetOutputY_for_24buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_24buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('9母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f7);
plot(1:1:33,MeanNetOutputY_for_24buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_24buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('9母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 10母線("11",13,15,17,19,21,26,28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_23buses = [T1(1:10,1:8000);T1(12,1:8000);T1(14,1:8000);T1(16,1:8000);T1(18,1:8000);T1(20,1:8000);T1(22:25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(1:10,1:8000);T2(12,1:8000);T2(14,1:8000);T2(16,1:8000);T2(18,1:8000);T2(20,1:8000);T2(22:25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_23buses = [T3(1:10,1:8000);T3(12,1:8000);T3(14,1:8000);T3(16,1:8000);T3(18,1:8000);T3(20,1:8000);T3(22:25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(1:10,1:8000);T4(12,1:8000);T4(14,1:8000);T4(16,1:8000);T4(18,1:8000);T4(20,1:8000);T4(22:25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_23buses = inputs_for_23buses;

t_for_23buses = targets_for_23buses;

net_for_23buses = fitnet(10,'trainlm');

net_for_23buses = train(net_for_23buses,x_for_23buses,t_for_23buses);

%view(net_for_23buses) kore iranai

NetOutputY_for_23buses = net_for_23buses([T1(1:10,8001:10000);T1(12,8001:10000);T1(14,8001:10000);T1(16,8001:10000);T1(18,8001:10000);T1(20,8001:10000);T1(22:25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(1:10,8001:10000);T2(12,8001:10000);T2(14,8001:10000);T2(16,8001:10000);T2(18,8001:10000);T2(20,8001:10000);T2(22:25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_23buses = mean(NetOutputY_for_23buses,2);

PowerFlowCalculationY_for_23buses = [T3(1:10,8001:10000);T3(12,8001:10000);T3(14,8001:10000);T3(16,8001:10000);T3(18,8001:10000);T3(20,8001:10000);T3(22:25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(1:10,8001:10000);T4(12,8001:10000);T4(14,8001:10000);T4(16,8001:10000);T4(18,8001:10000);T4(20,8001:10000);T4(22:25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_23buses = mean(PowerFlowCalculationY_for_23buses,2);

error_for_23buses = MeanNetOutputY_for_23buses - MeanPowerFlowCalculationY_for_23buses;
%% 10母線("11",13,15,17,19,21,26,28,30,32)分のデータを抜いて
MeanNetOutputY_for_23buses_converted_into_33 = [MeanNetOutputY_for_23buses(1:10,1);NaN;MeanNetOutputY_for_23buses(11,1);NaN;MeanNetOutputY_for_23buses(12,1);NaN;MeanNetOutputY_for_23buses(13,1);NaN;MeanNetOutputY_for_23buses(14,1);NaN;MeanNetOutputY_for_23buses(15,1);NaN;MeanNetOutputY_for_23buses(16:19,1);NaN;MeanNetOutputY_for_23buses(20,1);NaN;MeanNetOutputY_for_23buses(21,1);NaN;MeanNetOutputY_for_23buses(22,1);NaN;MeanNetOutputY_for_23buses(23,1);
                                                MeanNetOutputY_for_23buses(24:33,1);NaN;MeanNetOutputY_for_23buses(34,1);NaN;MeanNetOutputY_for_23buses(35,1);NaN;MeanNetOutputY_for_23buses(36,1);NaN;MeanNetOutputY_for_23buses(37,1);NaN;MeanNetOutputY_for_23buses(38,1);NaN;MeanNetOutputY_for_23buses(39:42,1);NaN;MeanNetOutputY_for_23buses(43,1);NaN;MeanNetOutputY_for_23buses(44,1);NaN;MeanNetOutputY_for_23buses(45,1);NaN;MeanNetOutputY_for_23buses(46,1)];

MeanPowerFlowCalculationY_for_23buses_converted_into_33 = [MeanPowerFlowCalculationY_for_23buses(1:10,1);NaN;MeanPowerFlowCalculationY_for_23buses(11,1);NaN;MeanPowerFlowCalculationY_for_23buses(12,1);NaN;MeanPowerFlowCalculationY_for_23buses(13,1);NaN;MeanPowerFlowCalculationY_for_23buses(14,1);NaN;MeanPowerFlowCalculationY_for_23buses(15,1);NaN;MeanPowerFlowCalculationY_for_23buses(16:19,1);NaN;MeanPowerFlowCalculationY_for_23buses(20,1);NaN;MeanPowerFlowCalculationY_for_23buses(21,1);NaN;MeanPowerFlowCalculationY_for_23buses(22,1);NaN;MeanPowerFlowCalculationY_for_23buses(23,1);
                                                           MeanPowerFlowCalculationY_for_23buses(24:33,1);NaN;MeanPowerFlowCalculationY_for_23buses(34,1);NaN;MeanPowerFlowCalculationY_for_23buses(35,1);NaN;MeanPowerFlowCalculationY_for_23buses(36,1);NaN;MeanPowerFlowCalculationY_for_23buses(37,1);NaN;MeanPowerFlowCalculationY_for_23buses(38,1);NaN;MeanPowerFlowCalculationY_for_23buses(39:42,1);NaN;MeanPowerFlowCalculationY_for_23buses(43,1);NaN;MeanPowerFlowCalculationY_for_23buses(44,1);NaN;MeanPowerFlowCalculationY_for_23buses(45,1);NaN;MeanPowerFlowCalculationY_for_23buses(46,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(11,1) = NaN;
MeanNetOutputY_for_33buses(13,1) = NaN;
MeanNetOutputY_for_33buses(15,1) = NaN;
MeanNetOutputY_for_33buses(17,1) = NaN;
MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(26,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(44,1) = NaN;
MeanNetOutputY_for_33buses(46,1) = NaN;
MeanNetOutputY_for_33buses(48,1) = NaN;
MeanNetOutputY_for_33buses(50,1) = NaN;
MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(59,1) = NaN;
MeanNetOutputY_for_33buses(61,1) = NaN;
MeanNetOutputY_for_33buses(63,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f9 = figure;
f10 = figure;

plot(1:1:33,MeanNetOutputY_for_23buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_23buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('10母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f9);
plot(1:1:33,MeanNetOutputY_for_23buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_23buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('10母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 12母線("7","9",11,13,15,17,19,21,26,28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_21buses = [T1(1:6,1:8000);T1(8,1:8000);T1(10,1:8000);T1(12,1:8000);T1(14,1:8000);T1(16,1:8000);T1(18,1:8000);T1(20,1:8000);T1(22:25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(1:6,1:8000);T2(8,1:8000);T2(10,1:8000);T2(12,1:8000);T2(14,1:8000);T2(16,1:8000);T2(18,1:8000);T2(20,1:8000);T2(22:25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_21buses = [T3(1:6,1:8000);T3(8,1:8000);T3(10,1:8000);T3(12,1:8000);T3(14,1:8000);T3(16,1:8000);T3(18,1:8000);T3(20,1:8000);T3(22:25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(1:6,1:8000);T4(8,1:8000);T4(10,1:8000);T4(12,1:8000);T4(14,1:8000);T4(16,1:8000);T4(18,1:8000);T4(20,1:8000);T4(22:25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_21buses = inputs_for_21buses;

t_for_21buses = targets_for_21buses;

net_for_21buses = fitnet(10,'trainlm');

net_for_21buses = train(net_for_21buses,x_for_21buses,t_for_21buses);

%view(net_for_21buses) kore iranai

NetOutputY_for_21buses = net_for_21buses([T1(1:6,8001:10000);T1(8,8001:10000);T1(10,8001:10000);T1(12,8001:10000);T1(14,8001:10000);T1(16,8001:10000);T1(18,8001:10000);T1(20,8001:10000);T1(22:25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(1:6,8001:10000);T2(8,8001:10000);T2(10,8001:10000);T2(12,8001:10000);T2(14,8001:10000);T2(16,8001:10000);T2(18,8001:10000);T2(20,8001:10000);T2(22:25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_21buses = mean(NetOutputY_for_21buses,2);

PowerFlowCalculationY_for_21buses = [T3(1:6,8001:10000);T3(8,8001:10000);T3(10,8001:10000);T3(12,8001:10000);T3(14,8001:10000);T3(16,8001:10000);T3(18,8001:10000);T3(20,8001:10000);T3(22:25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(1:6,8001:10000);T4(8,8001:10000);T4(10,8001:10000);T4(12,8001:10000);T4(14,8001:10000);T4(16,8001:10000);T4(18,8001:10000);T4(20,8001:10000);T4(22:25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_21buses = mean(PowerFlowCalculationY_for_21buses,2);

error_for_21buses = MeanNetOutputY_for_21buses - MeanPowerFlowCalculationY_for_21buses;
%% 12母線("7","9",11,13,15,17,19,21,26,28,30,32)分のデータを抜いて
MeanNetOutputY_for_21buses_converted_into_33 = [MeanNetOutputY_for_21buses(1:6,1);NaN;MeanNetOutputY_for_21buses(7,1);NaN;MeanNetOutputY_for_21buses(8,1);NaN;MeanNetOutputY_for_21buses(9,1);NaN;MeanNetOutputY_for_21buses(10,1);NaN;MeanNetOutputY_for_21buses(11,1);NaN;MeanNetOutputY_for_21buses(12,1);NaN;MeanNetOutputY_for_21buses(13,1);NaN;MeanNetOutputY_for_21buses(14:17,1);NaN;MeanNetOutputY_for_21buses(18,1);NaN;MeanNetOutputY_for_21buses(19,1);NaN;MeanNetOutputY_for_21buses(20,1);NaN;MeanNetOutputY_for_21buses(21,1);
                                                MeanNetOutputY_for_21buses(22:27,1);NaN;MeanNetOutputY_for_21buses(28,1);NaN;MeanNetOutputY_for_21buses(29,1);NaN;MeanNetOutputY_for_21buses(30,1);NaN;MeanNetOutputY_for_21buses(31,1);NaN;MeanNetOutputY_for_21buses(32,1);NaN;MeanNetOutputY_for_21buses(33,1);NaN;MeanNetOutputY_for_21buses(34,1);NaN;MeanNetOutputY_for_21buses(35:38,1);NaN;MeanNetOutputY_for_21buses(39,1);NaN;MeanNetOutputY_for_21buses(40,1);NaN;MeanNetOutputY_for_21buses(41,1);NaN;MeanNetOutputY_for_21buses(42,1)];

MeanPowerFlowCalculationY_for_21buses_converted_into_33 = [MeanPowerFlowCalculationY_for_21buses(1:6,1);NaN;MeanPowerFlowCalculationY_for_21buses(7,1);NaN;MeanPowerFlowCalculationY_for_21buses(8,1);NaN;MeanPowerFlowCalculationY_for_21buses(9,1);NaN;MeanPowerFlowCalculationY_for_21buses(10,1);NaN;MeanPowerFlowCalculationY_for_21buses(11,1);NaN;MeanPowerFlowCalculationY_for_21buses(12,1);NaN;MeanPowerFlowCalculationY_for_21buses(13,1);NaN;MeanPowerFlowCalculationY_for_21buses(14:17,1);NaN;MeanPowerFlowCalculationY_for_21buses(18,1);NaN;MeanPowerFlowCalculationY_for_21buses(19,1);NaN;MeanPowerFlowCalculationY_for_21buses(20,1);NaN;MeanPowerFlowCalculationY_for_21buses(21,1);
                                                           MeanPowerFlowCalculationY_for_21buses(22:27,1);NaN;MeanPowerFlowCalculationY_for_21buses(28,1);NaN;MeanPowerFlowCalculationY_for_21buses(29,1);NaN;MeanPowerFlowCalculationY_for_21buses(30,1);NaN;MeanPowerFlowCalculationY_for_21buses(31,1);NaN;MeanPowerFlowCalculationY_for_21buses(32,1);NaN;MeanPowerFlowCalculationY_for_21buses(33,1);NaN;MeanPowerFlowCalculationY_for_21buses(34,1);NaN;MeanPowerFlowCalculationY_for_21buses(35:38,1);NaN;MeanPowerFlowCalculationY_for_21buses(39,1);NaN;MeanPowerFlowCalculationY_for_21buses(40,1);NaN;MeanPowerFlowCalculationY_for_21buses(41,1);NaN;MeanPowerFlowCalculationY_for_21buses(42,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(7,1) = NaN;
MeanNetOutputY_for_33buses(9,1) = NaN;
MeanNetOutputY_for_33buses(11,1) = NaN;
MeanNetOutputY_for_33buses(13,1) = NaN;
MeanNetOutputY_for_33buses(15,1) = NaN;
MeanNetOutputY_for_33buses(17,1) = NaN;
MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(26,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(40,1) = NaN;
MeanNetOutputY_for_33buses(42,1) = NaN;
MeanNetOutputY_for_33buses(44,1) = NaN;
MeanNetOutputY_for_33buses(46,1) = NaN;
MeanNetOutputY_for_33buses(48,1) = NaN;
MeanNetOutputY_for_33buses(50,1) = NaN;
MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(59,1) = NaN;
MeanNetOutputY_for_33buses(61,1) = NaN;
MeanNetOutputY_for_33buses(63,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f11 = figure;
f12 = figure;

plot(1:1:33,MeanNetOutputY_for_21buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_21buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('12母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f11);
plot(1:1:33,MeanNetOutputY_for_21buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_21buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('12母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');
%}
%% 15母線(23456789,10,11,12,13,14,15,16)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_18buses_0 = [T1(1,1:8000);T1(17:33,1:8000);T2(1,1:8000);T2(17:33,1:8000)];

targets_for_18buses_0 = [T3(1,1:8000);T3(17:33,1:8000);T4(1,1:8000);T4(17:33,1:8000)];

x_for_18buses_0 = inputs_for_18buses_0;

t_for_18buses_0 = targets_for_18buses_0;

net_for_18buses_0 = fitnet(10,'trainlm');

net_for_18buses_0 = train(net_for_18buses_0,x_for_18buses_0,t_for_18buses_0);

%view(net_for_18buses) kore iranai

NetOutputY_for_18buses_0 = net_for_18buses_0([T1(1,8001:10000);T1(17:33,8001:10000);T2(1,8001:10000);T2(17:33,8001:10000)]);

MeanNetOutputY_for_18buses_0 = mean(NetOutputY_for_18buses_0,2);

PowerFlowCalculationY_for_18buses_0 = [T3(1,8001:10000);T3(17:33,8001:10000);T4(1,8001:10000);T4(17:33,8001:10000)];

MeanPowerFlowCalculationY_for_18buses_0 = mean(PowerFlowCalculationY_for_18buses_0,2);

error_for_18buses_0 = MeanNetOutputY_for_18buses_0 - MeanPowerFlowCalculationY_for_18buses_0;
%% 15母線(23456789,10,11,12,13,14,15,16)分のデータを抜いて
MeanNetOutputY_for_18buses_converted_into_33_0 = [MeanNetOutputY_for_18buses_0(1,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_0(2:18,1);
                                                  MeanNetOutputY_for_18buses_0(19,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_0(20:36,1)];

MeanPowerFlowCalculationY_for_18buses_converted_into_33_0 = [MeanPowerFlowCalculationY_for_18buses_0(1,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_0(2:18,1);
                                                             MeanPowerFlowCalculationY_for_18buses_0(19,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_0(20:36,1)];
    
MeanNetOutputY_for_33buses_0 = MeanNetOutputY;

MeanNetOutputY_for_33buses_0(2,1) = NaN;
MeanNetOutputY_for_33buses_0(3,1) = NaN;
MeanNetOutputY_for_33buses_0(4,1) = NaN;
MeanNetOutputY_for_33buses_0(5,1) = NaN;
MeanNetOutputY_for_33buses_0(6,1) = NaN;
MeanNetOutputY_for_33buses_0(7,1) = NaN;
MeanNetOutputY_for_33buses_0(8,1) = NaN;
MeanNetOutputY_for_33buses_0(9,1) = NaN;
MeanNetOutputY_for_33buses_0(10,1) = NaN;
MeanNetOutputY_for_33buses_0(11,1) = NaN;
MeanNetOutputY_for_33buses_0(12,1) = NaN;
MeanNetOutputY_for_33buses_0(13,1) = NaN;
MeanNetOutputY_for_33buses_0(14,1) = NaN;
MeanNetOutputY_for_33buses_0(15,1) = NaN;
MeanNetOutputY_for_33buses_0(16,1) = NaN;

MeanNetOutputY_for_33buses_0(35,1) = NaN;
MeanNetOutputY_for_33buses_0(36,1) = NaN;
MeanNetOutputY_for_33buses_0(37,1) = NaN;
MeanNetOutputY_for_33buses_0(38,1) = NaN;
MeanNetOutputY_for_33buses_0(39,1) = NaN;
MeanNetOutputY_for_33buses_0(40,1) = NaN;
MeanNetOutputY_for_33buses_0(41,1) = NaN;
MeanNetOutputY_for_33buses_0(42,1) = NaN;
MeanNetOutputY_for_33buses_0(43,1) = NaN;
MeanNetOutputY_for_33buses_0(44,1) = NaN;
MeanNetOutputY_for_33buses_0(45,1) = NaN;
MeanNetOutputY_for_33buses_0(46,1) = NaN;
MeanNetOutputY_for_33buses_0(47,1) = NaN;
MeanNetOutputY_for_33buses_0(48,1) = NaN;
MeanNetOutputY_for_33buses_0(49,1) = NaN;

f13 = figure;
f14 = figure;

plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33_0(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33_0(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses_0(1:33),'-x');
legend('15母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f13);
plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33_0(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33_0(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses_0(34:66),'-x');
legend('15母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 15母線(6789,10,11,12,13,14,15,,,,,26,27,28,29,30)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_18buses_1 = [T1(1:5,1:8000);T1(16:25,1:8000);T1(31:33,1:8000);T2(1:5,1:8000);T2(16:25,1:8000);T2(31:33,1:8000)];

targets_for_18buses_1 = [T3(1:5,1:8000);T3(16:25,1:8000);T3(31:33,1:8000);T4(1:5,1:8000);T4(16:25,1:8000);T4(31:33,1:8000)];

x_for_18buses_1 = inputs_for_18buses_1;

t_for_18buses_1 = targets_for_18buses_1;

net_for_18buses_1 = fitnet(10,'trainlm');

net_for_18buses_1 = train(net_for_18buses_1,x_for_18buses_1,t_for_18buses_1);

%view(net_for_18buses) kore iranai

NetOutputY_for_18buses_1 = net_for_18buses_1([T1(1:5,8001:10000);T1(16:25,8001:10000);T1(31:33,8001:10000);T2(1:5,8001:10000);T2(16:25,8001:10000);T2(31:33,8001:10000)]);

MeanNetOutputY_for_18buses_1 = mean(NetOutputY_for_18buses_1,2);

PowerFlowCalculationY_for_18buses_1 = [T3(1:5,8001:10000);T3(16:25,8001:10000);T3(31:33,8001:10000);T4(1:5,8001:10000);T4(16:25,8001:10000);T4(31:33,8001:10000)];

MeanPowerFlowCalculationY_for_18buses_1 = mean(PowerFlowCalculationY_for_18buses_1,2);

error_for_18buses_1 = MeanNetOutputY_for_18buses_1 - MeanPowerFlowCalculationY_for_18buses_1;
%% 15母線(6789,10,11,12,13,14,15,,,,,26,27,28,29,30)分のデータを抜いて
MeanNetOutputY_for_18buses_converted_into_33_1 = [MeanNetOutputY_for_18buses_1(1:5,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_1(6:15,1);NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_1(16:18,1);
                                                  MeanNetOutputY_for_18buses_1(19:23,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_1(24:33,1);NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_1(34:36,1)];
    
MeanPowerFlowCalculationY_for_18buses_converted_into_33_1 = [MeanPowerFlowCalculationY_for_18buses_1(1:5,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_1(6:15,1);NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_1(16:18,1);
                                                             MeanPowerFlowCalculationY_for_18buses_1(19:23,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_1(24:33,1);NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_1(34:36,1)];
                                                       
MeanNetOutputY_for_33buses_1 = MeanNetOutputY;

MeanNetOutputY_for_33buses_1(6,1) = NaN;
MeanNetOutputY_for_33buses_1(7,1) = NaN;
MeanNetOutputY_for_33buses_1(8,1) = NaN;
MeanNetOutputY_for_33buses_1(9,1) = NaN;
MeanNetOutputY_for_33buses_1(10,1) = NaN;
MeanNetOutputY_for_33buses_1(11,1) = NaN;
MeanNetOutputY_for_33buses_1(12,1) = NaN;
MeanNetOutputY_for_33buses_1(13,1) = NaN;
MeanNetOutputY_for_33buses_1(14,1) = NaN;
MeanNetOutputY_for_33buses_1(15,1) = NaN;
MeanNetOutputY_for_33buses_1(26,1) = NaN;
MeanNetOutputY_for_33buses_1(27,1) = NaN;
MeanNetOutputY_for_33buses_1(28,1) = NaN;
MeanNetOutputY_for_33buses_1(29,1) = NaN;
MeanNetOutputY_for_33buses_1(30,1) = NaN;

MeanNetOutputY_for_33buses_1(39,1) = NaN;
MeanNetOutputY_for_33buses_1(40,1) = NaN;
MeanNetOutputY_for_33buses_1(41,1) = NaN;
MeanNetOutputY_for_33buses_1(42,1) = NaN;
MeanNetOutputY_for_33buses_1(43,1) = NaN;
MeanNetOutputY_for_33buses_1(44,1) = NaN;
MeanNetOutputY_for_33buses_1(45,1) = NaN;
MeanNetOutputY_for_33buses_1(46,1) = NaN;
MeanNetOutputY_for_33buses_1(47,1) = NaN;
MeanNetOutputY_for_33buses_1(48,1) = NaN;
MeanNetOutputY_for_33buses_1(59,1) = NaN;
MeanNetOutputY_for_33buses_1(60,1) = NaN;
MeanNetOutputY_for_33buses_1(61,1) = NaN;
MeanNetOutputY_for_33buses_1(62,1) = NaN;
MeanNetOutputY_for_33buses_1(63,1) = NaN;

f15 = figure;
f16 = figure;

plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33_1(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33_1(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses_1(1:33),'-x');
legend('15母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f15);
plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33_1(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33_1(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses_1(34:66),'-x');
legend('15母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 15母線(23456789,10,,,,,19,,,,,26,27,28,29,30)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_18buses_2 = [T1(1,1:8000);T1(11:18,1:8000);T1(20:25,1:8000);T1(31:33,1:8000);T2(1,1:8000);T2(11:18,1:8000);T2(20:25,1:8000);T2(31:33,1:8000)];

targets_for_18buses_2 = [T3(1,1:8000);T3(11:18,1:8000);T3(20:25,1:8000);T3(31:33,1:8000);T4(1,1:8000);T4(11:18,1:8000);T4(20:25,1:8000);T4(31:33,1:8000)];

x_for_18buses_2 = inputs_for_18buses_2;

t_for_18buses_2 = targets_for_18buses_2;

net_for_18buses_2 = fitnet(10,'trainlm');

net_for_18buses_2 = train(net_for_18buses_2,x_for_18buses_2,t_for_18buses_2);

%view(net_for_18buses) kore iranai

NetOutputY_for_18buses_2 = net_for_18buses_2([T1(1,8001:10000);T1(11:18,8001:10000);T1(20:25,8001:10000);T1(31:33,8001:10000);T2(1,8001:10000);T2(11:18,8001:10000);T2(20:25,8001:10000);T2(31:33,8001:10000)]);

MeanNetOutputY_for_18buses_2 = mean(NetOutputY_for_18buses_2,2);

PowerFlowCalculationY_for_18buses_2 = [T3(1,8001:10000);T3(11:18,8001:10000);T3(20:25,8001:10000);T3(31:33,8001:10000);T4(1,8001:10000);T4(11:18,8001:10000);T4(20:25,8001:10000);T4(31:33,8001:10000)];

MeanPowerFlowCalculationY_for_18buses_2 = mean(PowerFlowCalculationY_for_18buses_2,2);

error_for_18buses_2 = MeanNetOutputY_for_18buses_2 - MeanPowerFlowCalculationY_for_18buses_2;
%% 15母線(23456789,10,,,,,19,,,,,26,27,28,29,30)分のデータを抜いて
MeanNetOutputY_for_18buses_converted_into_33_2 = [MeanNetOutputY_for_18buses_2(1,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_2(2:9,1);NaN;MeanNetOutputY_for_18buses_2(10:15,1);NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_2(16:18,1);
                                                  MeanNetOutputY_for_18buses_2(19,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_2(20:27,1);NaN;MeanNetOutputY_for_18buses_2(28:33,1);NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_2(34:36,1)];

MeanPowerFlowCalculationY_for_18buses_converted_into_33_2 = [MeanPowerFlowCalculationY_for_18buses_2(1,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_2(2:9,1);NaN;MeanPowerFlowCalculationY_for_18buses_2(10:15,1);NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_2(16:18,1);
                                                             MeanPowerFlowCalculationY_for_18buses_2(19,1);NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_2(20:27,1);NaN;MeanPowerFlowCalculationY_for_18buses_2(28:33,1);NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_2(34:36,1)];
                                                           
MeanNetOutputY_for_33buses_2 = MeanNetOutputY;

MeanNetOutputY_for_33buses_2(2,1) = NaN;
MeanNetOutputY_for_33buses_2(3,1) = NaN;
MeanNetOutputY_for_33buses_2(4,1) = NaN;
MeanNetOutputY_for_33buses_2(5,1) = NaN;
MeanNetOutputY_for_33buses_2(6,1) = NaN;
MeanNetOutputY_for_33buses_2(7,1) = NaN;
MeanNetOutputY_for_33buses_2(8,1) = NaN;
MeanNetOutputY_for_33buses_2(9,1) = NaN;
MeanNetOutputY_for_33buses_2(10,1) = NaN;
MeanNetOutputY_for_33buses_2(19,1) = NaN;
MeanNetOutputY_for_33buses_2(26,1) = NaN;
MeanNetOutputY_for_33buses_2(27,1) = NaN;
MeanNetOutputY_for_33buses_2(28,1) = NaN;
MeanNetOutputY_for_33buses_2(29,1) = NaN;
MeanNetOutputY_for_33buses_2(30,1) = NaN;

MeanNetOutputY_for_33buses_2(35,1) = NaN;
MeanNetOutputY_for_33buses_2(36,1) = NaN;
MeanNetOutputY_for_33buses_2(37,1) = NaN;
MeanNetOutputY_for_33buses_2(38,1) = NaN;
MeanNetOutputY_for_33buses_2(39,1) = NaN;
MeanNetOutputY_for_33buses_2(40,1) = NaN;
MeanNetOutputY_for_33buses_2(41,1) = NaN;
MeanNetOutputY_for_33buses_2(42,1) = NaN;
MeanNetOutputY_for_33buses_2(43,1) = NaN;
MeanNetOutputY_for_33buses_2(52,1) = NaN;
MeanNetOutputY_for_33buses_2(59,1) = NaN;
MeanNetOutputY_for_33buses_2(60,1) = NaN;
MeanNetOutputY_for_33buses_2(61,1) = NaN;
MeanNetOutputY_for_33buses_2(62,1) = NaN;
MeanNetOutputY_for_33buses_2(63,1) = NaN;

f17 = figure;
f18 = figure;

plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33_2(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33_2(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses_2(1:33),'-x');
legend('15母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f17);
plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33_2(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33_2(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses_2(34:66),'-x');
legend('15母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 15母線(234567,,,,,19,20,,,,,23,,,,,26,27,28,29,30,31)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_18buses_3 = [T1(1,1:8000);T1(8:18,1:8000);T1(21:22,1:8000);T1(24:25,1:8000);T1(32:33,1:8000);T2(1,1:8000);T2(8:18,1:8000);T2(21:22,1:8000);T2(24:25,1:8000);T2(32:33,1:8000)];

targets_for_18buses_3 = [T3(1,1:8000);T3(8:18,1:8000);T3(21:22,1:8000);T3(24:25,1:8000);T3(32:33,1:8000);T4(1,1:8000);T4(8:18,1:8000);T4(21:22,1:8000);T4(24:25,1:8000);T4(32:33,1:8000)];

x_for_18buses_3 = inputs_for_18buses_3;

t_for_18buses_3 = targets_for_18buses_3;

net_for_18buses_3 = fitnet(10,'trainlm');

net_for_18buses_3 = train(net_for_18buses_3,x_for_18buses_3,t_for_18buses_3);

%view(net_for_18buses) kore iranai

NetOutputY_for_18buses_3 = net_for_18buses_3([T1(1,8001:10000);T1(8:18,8001:10000);T1(21:22,8001:10000);T1(24:25,8001:10000);T1(32:33,8001:10000);T2(1,8001:10000);T2(8:18,8001:10000);T2(21:22,8001:10000);T2(24:25,8001:10000);T2(32:33,8001:10000)]);

MeanNetOutputY_for_18buses_3 = mean(NetOutputY_for_18buses_3,2);

PowerFlowCalculationY_for_18buses_3 = [T3(1,8001:10000);T3(8:18,8001:10000);T3(21:22,8001:10000);T3(24:25,8001:10000);T3(32:33,8001:10000);T4(1,8001:10000);T4(8:18,8001:10000);T4(21:22,8001:10000);T4(24:25,8001:10000);T4(32:33,8001:10000)];

MeanPowerFlowCalculationY_for_18buses_3 = mean(PowerFlowCalculationY_for_18buses_3,2);

error_for_18buses_3 = MeanNetOutputY_for_18buses_3 - MeanPowerFlowCalculationY_for_18buses_3;
%% 15母線(234567,,,,,19,20,,,,,23,,,,,26,27,28,29,30,31)分のデータを抜いて
MeanNetOutputY_for_18buses_converted_into_33_3 = [MeanNetOutputY_for_18buses_3(1,1);NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_3(2:12,1);NaN;NaN;MeanNetOutputY_for_18buses_3(13:14,1);NaN;MeanNetOutputY_for_18buses_3(15:16,1);NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_3(17:18,1);
                                                  MeanNetOutputY_for_18buses_3(19,1);NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_3(20:30,1);NaN;NaN;MeanNetOutputY_for_18buses_3(31:32,1);NaN;MeanNetOutputY_for_18buses_3(33:34,1);NaN;NaN;NaN;NaN;NaN;NaN;MeanNetOutputY_for_18buses_3(35:36,1)];

MeanPowerFlowCalculationY_for_18buses_converted_into_33_3 = [MeanPowerFlowCalculationY_for_18buses_3(1,1);NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_3(2:12,1);NaN;NaN;MeanPowerFlowCalculationY_for_18buses_3(13:14,1);NaN;MeanPowerFlowCalculationY_for_18buses_3(15:16,1);NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_3(17:18,1);
                                                             MeanPowerFlowCalculationY_for_18buses_3(19,1);NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_3(20:30,1);NaN;NaN;MeanPowerFlowCalculationY_for_18buses_3(31:32,1);NaN;MeanPowerFlowCalculationY_for_18buses_3(33:34,1);NaN;NaN;NaN;NaN;NaN;NaN;MeanPowerFlowCalculationY_for_18buses_3(35:36,1)];

MeanNetOutputY_for_33buses_3 = MeanNetOutputY;

MeanNetOutputY_for_33buses_3(2,1) = NaN;
MeanNetOutputY_for_33buses_3(3,1) = NaN;
MeanNetOutputY_for_33buses_3(4,1) = NaN;
MeanNetOutputY_for_33buses_3(5,1) = NaN;
MeanNetOutputY_for_33buses_3(6,1) = NaN;
MeanNetOutputY_for_33buses_3(7,1) = NaN;
MeanNetOutputY_for_33buses_3(19,1) = NaN;
MeanNetOutputY_for_33buses_3(20,1) = NaN;
MeanNetOutputY_for_33buses_3(23,1) = NaN;
MeanNetOutputY_for_33buses_3(26,1) = NaN;
MeanNetOutputY_for_33buses_3(27,1) = NaN;
MeanNetOutputY_for_33buses_3(28,1) = NaN;
MeanNetOutputY_for_33buses_3(29,1) = NaN;
MeanNetOutputY_for_33buses_3(30,1) = NaN;
MeanNetOutputY_for_33buses_3(31,1) = NaN;

MeanNetOutputY_for_33buses_3(35,1) = NaN;
MeanNetOutputY_for_33buses_3(36,1) = NaN;
MeanNetOutputY_for_33buses_3(37,1) = NaN;
MeanNetOutputY_for_33buses_3(38,1) = NaN;
MeanNetOutputY_for_33buses_3(39,1) = NaN;
MeanNetOutputY_for_33buses_3(40,1) = NaN;
MeanNetOutputY_for_33buses_3(52,1) = NaN;
MeanNetOutputY_for_33buses_3(53,1) = NaN;
MeanNetOutputY_for_33buses_3(56,1) = NaN;
MeanNetOutputY_for_33buses_3(59,1) = NaN;
MeanNetOutputY_for_33buses_3(60,1) = NaN;
MeanNetOutputY_for_33buses_3(61,1) = NaN;
MeanNetOutputY_for_33buses_3(62,1) = NaN;
MeanNetOutputY_for_33buses_3(63,1) = NaN;
MeanNetOutputY_for_33buses_3(64,1) = NaN;

f19 = figure;
f20 = figure;

plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33_3(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33_3(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses_3(1:33),'-x');
legend('15母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f19);
plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33_3(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33_3(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses_3(34:66),'-x');
legend('15母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% ここまで新しいコード

%{
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
axis auto;
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
axis auto;
xlabel('母線番号');
ylabel('NN出力電圧位相角値-潮流計算電圧位相角値[p.u.]');
title('各母線の電圧の位相角の値の誤差');
%}
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