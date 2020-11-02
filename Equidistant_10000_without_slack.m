%% 今10000(1万)個のデータの場合になっている

%% slack(swing)母線のデータを抜いた場合






%% もう直した　あとは変数の名前とかを変えるだけ






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

%% 3母線(19,21,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_30buses = [T1(2:18,1:8000);T1(20,1:8000);T1(22:31,1:8000);T1(33,1:8000);T2(2:18,1:8000);T2(20,1:8000);T2(22:31,1:8000);T2(33,1:8000)];

targets_for_30buses = [T3(2:18,1:8000);T3(20,1:8000);T3(22:31,1:8000);T3(33,1:8000);T4(2:18,1:8000);T4(20,1:8000);T4(22:31,1:8000);T4(33,1:8000)];

x_for_30buses = inputs_for_30buses;

t_for_30buses = targets_for_30buses;

net_for_30buses = fitnet(10,'trainlm');

net_for_30buses = train(net_for_30buses,x_for_30buses,t_for_30buses);

%view(net_for_30buses) kore iranai

NetOutputY_for_30buses = net_for_30buses([T1(2:18,8001:10000);T1(20,8001:10000);T1(22:31,8001:10000);T1(33,8001:10000);T2(2:18,8001:10000);T2(20,8001:10000);T2(22:31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_30buses = mean(NetOutputY_for_30buses,2);

PowerFlowCalculationY_for_30buses = [T3(2:18,8001:10000);T3(20,8001:10000);T3(22:31,8001:10000);T3(33,8001:10000);T4(2:18,8001:10000);T4(20,8001:10000);T4(22:31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_30buses = mean(PowerFlowCalculationY_for_30buses,2);

error_for_30buses = MeanNetOutputY_for_30buses - MeanPowerFlowCalculationY_for_30buses;

MeanNetOutputY_for_30buses_converted_into_33 = [NaN;MeanNetOutputY_for_30buses(1:17,1);NaN;MeanNetOutputY_for_30buses(18,1);NaN;MeanNetOutputY_for_30buses(19:28,1);NaN;MeanNetOutputY_for_30buses(29,1);
                                                NaN;MeanNetOutputY_for_30buses(30:46,1);NaN;MeanNetOutputY_for_30buses(47,1);NaN;MeanNetOutputY_for_30buses(48:57,1);NaN;MeanNetOutputY_for_30buses(58,1)];

MeanPowerFlowCalculationY_for_30buses_converted_into_33 = [NaN;MeanPowerFlowCalculationY_for_30buses(1:17,1);NaN;MeanPowerFlowCalculationY_for_30buses(18,1);NaN;MeanPowerFlowCalculationY_for_30buses(19:28,1);NaN;MeanPowerFlowCalculationY_for_30buses(29,1);
                                                           NaN;MeanPowerFlowCalculationY_for_30buses(30:46,1);NaN;MeanPowerFlowCalculationY_for_30buses(47,1);NaN;MeanPowerFlowCalculationY_for_30buses(48:57,1);NaN;MeanPowerFlowCalculationY_for_30buses(58,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(1,1) = NaN;
MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(34,1) = NaN;
MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f1 = figure;
f2 = figure;

plot(1:1:33,MeanNetOutputY_for_30buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_30buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('4母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f1);
plot(1:1:33,MeanNetOutputY_for_30buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_30buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('4母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 5母線(19,21,"28","30",32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_28buses = [T1(2:18,1:8000);T1(20,1:8000);T1(22:27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(2:18,1:8000);T2(20,1:8000);T2(22:27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_28buses = [T3(2:18,1:8000);T3(20,1:8000);T3(22:27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(2:18,1:8000);T4(20,1:8000);T4(22:27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_28buses = inputs_for_28buses;

t_for_28buses = targets_for_28buses;

net_for_28buses = fitnet(10,'trainlm');

net_for_28buses = train(net_for_28buses,x_for_28buses,t_for_28buses);

%view(net_for_28buses) kore iranai

NetOutputY_for_28buses = net_for_28buses([T1(2:18,8001:10000);T1(20,8001:10000);T1(22:27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(2:18,8001:10000);T2(20,8001:10000);T2(22:27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_28buses = mean(NetOutputY_for_28buses,2);

PowerFlowCalculationY_for_28buses = [T3(2:18,8001:10000);T3(20,8001:10000);T3(22:27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(2:18,8001:10000);T4(20,8001:10000);T4(22:27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_28buses = mean(PowerFlowCalculationY_for_28buses,2);

error_for_28buses = MeanNetOutputY_for_28buses - MeanPowerFlowCalculationY_for_28buses;
%% 5母線(19,21,"28","30",32)分のデータを抜いて
MeanNetOutputY_for_28buses_converted_into_33 = [NaN;MeanNetOutputY_for_28buses(1:17,1);NaN;MeanNetOutputY_for_28buses(18,1);NaN;MeanNetOutputY_for_28buses(19:24,1);NaN;MeanNetOutputY_for_28buses(25,1);NaN;MeanNetOutputY_for_28buses(26,1);NaN;MeanNetOutputY_for_28buses(27,1);
                                                NaN;MeanNetOutputY_for_28buses(28:44,1);NaN;MeanNetOutputY_for_28buses(45,1);NaN;MeanNetOutputY_for_28buses(46:51,1);NaN;MeanNetOutputY_for_28buses(52,1);NaN;MeanNetOutputY_for_28buses(53,1);NaN;MeanNetOutputY_for_28buses(54,1)];

MeanPowerFlowCalculationY_for_28buses_converted_into_33 = [NaN;MeanPowerFlowCalculationY_for_28buses(1:17,1);NaN;MeanPowerFlowCalculationY_for_28buses(18,1);NaN;MeanPowerFlowCalculationY_for_28buses(19:24,1);NaN;MeanPowerFlowCalculationY_for_28buses(25,1);NaN;MeanPowerFlowCalculationY_for_28buses(26,1);NaN;MeanPowerFlowCalculationY_for_28buses(27,1);
                                                           NaN;MeanPowerFlowCalculationY_for_28buses(28:44,1);NaN;MeanPowerFlowCalculationY_for_28buses(45,1);NaN;MeanPowerFlowCalculationY_for_28buses(46:51,1);NaN;MeanPowerFlowCalculationY_for_28buses(52,1);NaN;MeanPowerFlowCalculationY_for_28buses(53,1);NaN;MeanPowerFlowCalculationY_for_28buses(54,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(1,1) = NaN;
MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(34,1) = NaN;
MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(61,1) = NaN;
MeanNetOutputY_for_33buses(63,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f3 = figure;
f4 = figure;

plot(1:1:33,MeanNetOutputY_for_28buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_28buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('6母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f3);
plot(1:1:33,MeanNetOutputY_for_28buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_28buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('6母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 6母線(19,21,"26",28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_27buses = [T1(2:18,1:8000);T1(20,1:8000);T1(22:25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(2:18,1:8000);T2(20,1:8000);T2(22:25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_27buses = [T3(2:18,1:8000);T3(20,1:8000);T3(22:25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(2:18,1:8000);T4(20,1:8000);T4(22:25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_27buses = inputs_for_27buses;

t_for_27buses = targets_for_27buses;

net_for_27buses = fitnet(10,'trainlm');

net_for_27buses = train(net_for_27buses,x_for_27buses,t_for_27buses);

%view(net_for_27buses) kore iranai

NetOutputY_for_27buses = net_for_27buses([T1(2:18,8001:10000);T1(20,8001:10000);T1(22:25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(2:18,8001:10000);T2(20,8001:10000);T2(22:25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_27buses = mean(NetOutputY_for_27buses,2);

PowerFlowCalculationY_for_27buses = [T3(2:18,8001:10000);T3(20,8001:10000);T3(22:25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(2:18,8001:10000);T4(20,8001:10000);T4(22:25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_27buses = mean(PowerFlowCalculationY_for_27buses,2);

error_for_27buses = MeanNetOutputY_for_27buses - MeanPowerFlowCalculationY_for_27buses;
%% 6母線(19,21,"26",28,30,32)分のデータを抜いて
MeanNetOutputY_for_27buses_converted_into_33 = [NaN;MeanNetOutputY_for_27buses(1:17,1);NaN;MeanNetOutputY_for_27buses(18,1);NaN;MeanNetOutputY_for_27buses(19:22,1);NaN;MeanNetOutputY_for_27buses(23,1);NaN;MeanNetOutputY_for_27buses(24,1);NaN;MeanNetOutputY_for_27buses(25,1);NaN;MeanNetOutputY_for_27buses(26,1);
                                                NaN;MeanNetOutputY_for_27buses(27:43,1);NaN;MeanNetOutputY_for_27buses(44,1);NaN;MeanNetOutputY_for_27buses(45:48,1);NaN;MeanNetOutputY_for_27buses(49,1);NaN;MeanNetOutputY_for_27buses(50,1);NaN;MeanNetOutputY_for_27buses(51,1);NaN;MeanNetOutputY_for_27buses(52,1)];

MeanPowerFlowCalculationY_for_27buses_converted_into_33 = [NaN;MeanPowerFlowCalculationY_for_27buses(1:17,1);NaN;MeanPowerFlowCalculationY_for_27buses(18,1);NaN;MeanPowerFlowCalculationY_for_27buses(19:22,1);NaN;MeanPowerFlowCalculationY_for_27buses(23,1);NaN;MeanPowerFlowCalculationY_for_27buses(24,1);NaN;MeanPowerFlowCalculationY_for_27buses(25,1);NaN;MeanPowerFlowCalculationY_for_27buses(26,1);
                                                           NaN;MeanPowerFlowCalculationY_for_27buses(27:43,1);NaN;MeanPowerFlowCalculationY_for_27buses(44,1);NaN;MeanPowerFlowCalculationY_for_27buses(45:48,1);NaN;MeanPowerFlowCalculationY_for_27buses(49,1);NaN;MeanPowerFlowCalculationY_for_27buses(50,1);NaN;MeanPowerFlowCalculationY_for_27buses(51,1);NaN;MeanPowerFlowCalculationY_for_27buses(52,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(1,1) = NaN;
MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(26,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(34,1) = NaN;
MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(59,1) = NaN;
MeanNetOutputY_for_33buses(61,1) = NaN;
MeanNetOutputY_for_33buses(63,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f5 = figure;
f6 = figure;

plot(1:1:33,MeanNetOutputY_for_27buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_27buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('7母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f5);
plot(1:1:33,MeanNetOutputY_for_27buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_27buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('7母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 9母線("13","15","17",19,21,26,28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_24buses = [T1(2:12,1:8000);T1(14,1:8000);T1(16,1:8000);T1(18,1:8000);T1(20,1:8000);T1(22:25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(2:12,1:8000);T2(14,1:8000);T2(16,1:8000);T2(18,1:8000);T2(20,1:8000);T2(22:25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_24buses = [T3(2:12,1:8000);T3(14,1:8000);T3(16,1:8000);T3(18,1:8000);T3(20,1:8000);T3(22:25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(2:12,1:8000);T4(14,1:8000);T4(16,1:8000);T4(18,1:8000);T4(20,1:8000);T4(22:25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_24buses = inputs_for_24buses;

t_for_24buses = targets_for_24buses;

net_for_24buses = fitnet(10,'trainlm');

net_for_24buses = train(net_for_24buses,x_for_24buses,t_for_24buses);

%view(net_for_24buses) kore iranai

NetOutputY_for_24buses = net_for_24buses([T1(2:12,8001:10000);T1(14,8001:10000);T1(16,8001:10000);T1(18,8001:10000);T1(20,8001:10000);T1(22:25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(2:12,8001:10000);T2(14,8001:10000);T2(16,8001:10000);T2(18,8001:10000);T2(20,8001:10000);T2(22:25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_24buses = mean(NetOutputY_for_24buses,2);

PowerFlowCalculationY_for_24buses = [T3(2:12,8001:10000);T3(14,8001:10000);T3(16,8001:10000);T3(18,8001:10000);T3(20,8001:10000);T3(22:25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(2:12,8001:10000);T4(14,8001:10000);T4(16,8001:10000);T4(18,8001:10000);T4(20,8001:10000);T4(22:25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_24buses = mean(PowerFlowCalculationY_for_24buses,2);

error_for_24buses = MeanNetOutputY_for_24buses - MeanPowerFlowCalculationY_for_24buses;
%% 9母線("13","15","17",19,21,26,28,30,32)分のデータを抜いて
MeanNetOutputY_for_24buses_converted_into_33 = [NaN;MeanNetOutputY_for_24buses(1:11,1);NaN;MeanNetOutputY_for_24buses(12,1);NaN;MeanNetOutputY_for_24buses(13,1);NaN;MeanNetOutputY_for_24buses(14,1);NaN;MeanNetOutputY_for_24buses(15,1);NaN;MeanNetOutputY_for_24buses(16:19,1);NaN;MeanNetOutputY_for_24buses(20,1);NaN;MeanNetOutputY_for_24buses(21,1);NaN;MeanNetOutputY_for_24buses(22,1);NaN;MeanNetOutputY_for_24buses(23,1);
                                                NaN;MeanNetOutputY_for_24buses(24:34,1);NaN;MeanNetOutputY_for_24buses(35,1);NaN;MeanNetOutputY_for_24buses(36,1);NaN;MeanNetOutputY_for_24buses(37,1);NaN;MeanNetOutputY_for_24buses(38,1);NaN;MeanNetOutputY_for_24buses(39:42,1);NaN;MeanNetOutputY_for_24buses(43,1);NaN;MeanNetOutputY_for_24buses(44,1);NaN;MeanNetOutputY_for_24buses(45,1);NaN;MeanNetOutputY_for_24buses(46,1)];

MeanPowerFlowCalculationY_for_24buses_converted_into_33 = [NaN;MeanPowerFlowCalculationY_for_24buses(1:11,1);NaN;MeanPowerFlowCalculationY_for_24buses(12,1);NaN;MeanPowerFlowCalculationY_for_24buses(13,1);NaN;MeanPowerFlowCalculationY_for_24buses(14,1);NaN;MeanPowerFlowCalculationY_for_24buses(15,1);NaN;MeanPowerFlowCalculationY_for_24buses(16:19,1);NaN;MeanPowerFlowCalculationY_for_24buses(20,1);NaN;MeanPowerFlowCalculationY_for_24buses(21,1);NaN;MeanPowerFlowCalculationY_for_24buses(22,1);NaN;MeanPowerFlowCalculationY_for_24buses(23,1);
                                                           NaN;MeanPowerFlowCalculationY_for_24buses(24:34,1);NaN;MeanPowerFlowCalculationY_for_24buses(35,1);NaN;MeanPowerFlowCalculationY_for_24buses(36,1);NaN;MeanPowerFlowCalculationY_for_24buses(37,1);NaN;MeanPowerFlowCalculationY_for_24buses(38,1);NaN;MeanPowerFlowCalculationY_for_24buses(39:42,1);NaN;MeanPowerFlowCalculationY_for_24buses(43,1);NaN;MeanPowerFlowCalculationY_for_24buses(44,1);NaN;MeanPowerFlowCalculationY_for_24buses(45,1);NaN;MeanPowerFlowCalculationY_for_24buses(46,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(1,1) = NaN;
MeanNetOutputY_for_33buses(13,1) = NaN;
MeanNetOutputY_for_33buses(15,1) = NaN;
MeanNetOutputY_for_33buses(17,1) = NaN;
MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(26,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(34,1) = NaN;
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
legend('10母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f7);
plot(1:1:33,MeanNetOutputY_for_24buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_24buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('10母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 10母線("11",13,15,17,19,21,26,28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_23buses = [T1(2:10,1:8000);T1(12,1:8000);T1(14,1:8000);T1(16,1:8000);T1(18,1:8000);T1(20,1:8000);T1(22:25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(2:10,1:8000);T2(12,1:8000);T2(14,1:8000);T2(16,1:8000);T2(18,1:8000);T2(20,1:8000);T2(22:25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_23buses = [T3(2:10,1:8000);T3(12,1:8000);T3(14,1:8000);T3(16,1:8000);T3(18,1:8000);T3(20,1:8000);T3(22:25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(2:10,1:8000);T4(12,1:8000);T4(14,1:8000);T4(16,1:8000);T4(18,1:8000);T4(20,1:8000);T4(22:25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_23buses = inputs_for_23buses;

t_for_23buses = targets_for_23buses;

net_for_23buses = fitnet(10,'trainlm');

net_for_23buses = train(net_for_23buses,x_for_23buses,t_for_23buses);

%view(net_for_23buses) kore iranai

NetOutputY_for_23buses = net_for_23buses([T1(2:10,8001:10000);T1(12,8001:10000);T1(14,8001:10000);T1(16,8001:10000);T1(18,8001:10000);T1(20,8001:10000);T1(22:25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(2:10,8001:10000);T2(12,8001:10000);T2(14,8001:10000);T2(16,8001:10000);T2(18,8001:10000);T2(20,8001:10000);T2(22:25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_23buses = mean(NetOutputY_for_23buses,2);

PowerFlowCalculationY_for_23buses = [T3(2:10,8001:10000);T3(12,8001:10000);T3(14,8001:10000);T3(16,8001:10000);T3(18,8001:10000);T3(20,8001:10000);T3(22:25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(2:10,8001:10000);T4(12,8001:10000);T4(14,8001:10000);T4(16,8001:10000);T4(18,8001:10000);T4(20,8001:10000);T4(22:25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_23buses = mean(PowerFlowCalculationY_for_23buses,2);

error_for_23buses = MeanNetOutputY_for_23buses - MeanPowerFlowCalculationY_for_23buses;
%% 10母線("11",13,15,17,19,21,26,28,30,32)分のデータを抜いて
MeanNetOutputY_for_23buses_converted_into_33 = [NaN;MeanNetOutputY_for_23buses(1:9,1);NaN;MeanNetOutputY_for_23buses(10,1);NaN;MeanNetOutputY_for_23buses(11,1);NaN;MeanNetOutputY_for_23buses(12,1);NaN;MeanNetOutputY_for_23buses(13,1);NaN;MeanNetOutputY_for_23buses(14,1);NaN;MeanNetOutputY_for_23buses(15:18,1);NaN;MeanNetOutputY_for_23buses(19,1);NaN;MeanNetOutputY_for_23buses(20,1);NaN;MeanNetOutputY_for_23buses(21,1);NaN;MeanNetOutputY_for_23buses(22,1);
                                                NaN;MeanNetOutputY_for_23buses(23:31,1);NaN;MeanNetOutputY_for_23buses(32,1);NaN;MeanNetOutputY_for_23buses(33,1);NaN;MeanNetOutputY_for_23buses(34,1);NaN;MeanNetOutputY_for_23buses(35,1);NaN;MeanNetOutputY_for_23buses(36,1);NaN;MeanNetOutputY_for_23buses(37:40,1);NaN;MeanNetOutputY_for_23buses(41,1);NaN;MeanNetOutputY_for_23buses(42,1);NaN;MeanNetOutputY_for_23buses(43,1);NaN;MeanNetOutputY_for_23buses(44,1)];

MeanPowerFlowCalculationY_for_23buses_converted_into_33 = [NaN;MeanPowerFlowCalculationY_for_23buses(1:9,1);NaN;MeanPowerFlowCalculationY_for_23buses(10,1);NaN;MeanPowerFlowCalculationY_for_23buses(11,1);NaN;MeanPowerFlowCalculationY_for_23buses(12,1);NaN;MeanPowerFlowCalculationY_for_23buses(13,1);NaN;MeanPowerFlowCalculationY_for_23buses(14,1);NaN;MeanPowerFlowCalculationY_for_23buses(15:18,1);NaN;MeanPowerFlowCalculationY_for_23buses(19,1);NaN;MeanPowerFlowCalculationY_for_23buses(20,1);NaN;MeanPowerFlowCalculationY_for_23buses(21,1);NaN;MeanPowerFlowCalculationY_for_23buses(22,1);
                                                           NaN;MeanPowerFlowCalculationY_for_23buses(23:31,1);NaN;MeanPowerFlowCalculationY_for_23buses(32,1);NaN;MeanPowerFlowCalculationY_for_23buses(33,1);NaN;MeanPowerFlowCalculationY_for_23buses(34,1);NaN;MeanPowerFlowCalculationY_for_23buses(35,1);NaN;MeanPowerFlowCalculationY_for_23buses(36,1);NaN;MeanPowerFlowCalculationY_for_23buses(37:40,1);NaN;MeanPowerFlowCalculationY_for_23buses(41,1);NaN;MeanPowerFlowCalculationY_for_23buses(42,1);NaN;MeanPowerFlowCalculationY_for_23buses(43,1);NaN;MeanPowerFlowCalculationY_for_23buses(44,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(1,1) = NaN;
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

MeanNetOutputY_for_33buses(34,1) = NaN;
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
legend('11母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f9);
plot(1:1:33,MeanNetOutputY_for_23buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_23buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('11母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 12母線("7","9",11,13,15,17,19,21,26,28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_21buses = [T1(2:6,1:8000);T1(8,1:8000);T1(10,1:8000);T1(12,1:8000);T1(14,1:8000);T1(16,1:8000);T1(18,1:8000);T1(20,1:8000);T1(22:25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(2:6,1:8000);T2(8,1:8000);T2(10,1:8000);T2(12,1:8000);T2(14,1:8000);T2(16,1:8000);T2(18,1:8000);T2(20,1:8000);T2(22:25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_21buses = [T3(2:6,1:8000);T3(8,1:8000);T3(10,1:8000);T3(12,1:8000);T3(14,1:8000);T3(16,1:8000);T3(18,1:8000);T3(20,1:8000);T3(22:25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(2:6,1:8000);T4(8,1:8000);T4(10,1:8000);T4(12,1:8000);T4(14,1:8000);T4(16,1:8000);T4(18,1:8000);T4(20,1:8000);T4(22:25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_21buses = inputs_for_21buses;

t_for_21buses = targets_for_21buses;

net_for_21buses = fitnet(10,'trainlm');

net_for_21buses = train(net_for_21buses,x_for_21buses,t_for_21buses);

%view(net_for_21buses) kore iranai

NetOutputY_for_21buses = net_for_21buses([T1(2:6,8001:10000);T1(8,8001:10000);T1(10,8001:10000);T1(12,8001:10000);T1(14,8001:10000);T1(16,8001:10000);T1(18,8001:10000);T1(20,8001:10000);T1(22:25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(2:6,8001:10000);T2(8,8001:10000);T2(10,8001:10000);T2(12,8001:10000);T2(14,8001:10000);T2(16,8001:10000);T2(18,8001:10000);T2(20,8001:10000);T2(22:25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_21buses = mean(NetOutputY_for_21buses,2);

PowerFlowCalculationY_for_21buses = [T3(2:6,8001:10000);T3(8,8001:10000);T3(10,8001:10000);T3(12,8001:10000);T3(14,8001:10000);T3(16,8001:10000);T3(18,8001:10000);T3(20,8001:10000);T3(22:25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(2:6,8001:10000);T4(8,8001:10000);T4(10,8001:10000);T4(12,8001:10000);T4(14,8001:10000);T4(16,8001:10000);T4(18,8001:10000);T4(20,8001:10000);T4(22:25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_21buses = mean(PowerFlowCalculationY_for_21buses,2);

error_for_21buses = MeanNetOutputY_for_21buses - MeanPowerFlowCalculationY_for_21buses;
%% 12母線("7","9",11,13,15,17,19,21,26,28,30,32)分のデータを抜いて
MeanNetOutputY_for_21buses_converted_into_33 = [NaN;MeanNetOutputY_for_21buses(1:5,1);NaN;MeanNetOutputY_for_21buses(6,1);NaN;MeanNetOutputY_for_21buses(7,1);NaN;MeanNetOutputY_for_21buses(8,1);NaN;MeanNetOutputY_for_21buses(9,1);NaN;MeanNetOutputY_for_21buses(10,1);NaN;MeanNetOutputY_for_21buses(11,1);NaN;MeanNetOutputY_for_21buses(12,1);NaN;MeanNetOutputY_for_21buses(13:16,1);NaN;MeanNetOutputY_for_21buses(17,1);NaN;MeanNetOutputY_for_21buses(18,1);NaN;MeanNetOutputY_for_21buses(19,1);NaN;MeanNetOutputY_for_21buses(20,1);
                                                NaN;MeanNetOutputY_for_21buses(21:25,1);NaN;MeanNetOutputY_for_21buses(26,1);NaN;MeanNetOutputY_for_21buses(27,1);NaN;MeanNetOutputY_for_21buses(28,1);NaN;MeanNetOutputY_for_21buses(29,1);NaN;MeanNetOutputY_for_21buses(30,1);NaN;MeanNetOutputY_for_21buses(31,1);NaN;MeanNetOutputY_for_21buses(32,1);NaN;MeanNetOutputY_for_21buses(33:36,1);NaN;MeanNetOutputY_for_21buses(37,1);NaN;MeanNetOutputY_for_21buses(38,1);NaN;MeanNetOutputY_for_21buses(39,1);NaN;MeanNetOutputY_for_21buses(40,1)];

MeanPowerFlowCalculationY_for_21buses_converted_into_33 = [NaN;MeanPowerFlowCalculationY_for_21buses(1:5,1);NaN;MeanPowerFlowCalculationY_for_21buses(6,1);NaN;MeanPowerFlowCalculationY_for_21buses(7,1);NaN;MeanPowerFlowCalculationY_for_21buses(8,1);NaN;MeanPowerFlowCalculationY_for_21buses(9,1);NaN;MeanPowerFlowCalculationY_for_21buses(10,1);NaN;MeanPowerFlowCalculationY_for_21buses(11,1);NaN;MeanPowerFlowCalculationY_for_21buses(12,1);NaN;MeanPowerFlowCalculationY_for_21buses(13:16,1);NaN;MeanPowerFlowCalculationY_for_21buses(17,1);NaN;MeanPowerFlowCalculationY_for_21buses(18,1);NaN;MeanPowerFlowCalculationY_for_21buses(19,1);NaN;MeanPowerFlowCalculationY_for_21buses(20,1);
                                                           NaN;MeanPowerFlowCalculationY_for_21buses(21:25,1);NaN;MeanPowerFlowCalculationY_for_21buses(26,1);NaN;MeanPowerFlowCalculationY_for_21buses(27,1);NaN;MeanPowerFlowCalculationY_for_21buses(28,1);NaN;MeanPowerFlowCalculationY_for_21buses(29,1);NaN;MeanPowerFlowCalculationY_for_21buses(30,1);NaN;MeanPowerFlowCalculationY_for_21buses(31,1);NaN;MeanPowerFlowCalculationY_for_21buses(32,1);NaN;MeanPowerFlowCalculationY_for_21buses(33:36,1);NaN;MeanPowerFlowCalculationY_for_21buses(37,1);NaN;MeanPowerFlowCalculationY_for_21buses(38,1);NaN;MeanPowerFlowCalculationY_for_21buses(39,1);NaN;MeanPowerFlowCalculationY_for_21buses(40,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(1,1) = NaN;
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

MeanNetOutputY_for_33buses(34,1) = NaN;
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
legend('13母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f11);
plot(1:1:33,MeanNetOutputY_for_21buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_21buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('13母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧の位相角の値[p.u.]');
title('各母線の電圧の位相角の値');

%% 15母線("3","5",7,9,11,13,15,17,19,21,"24",26,28,30,32)分のデータを抜いてNNに学習・訓練をさせた場合

inputs_for_18buses = [T1(2,1:8000);T1(4,1:8000);T1(6,1:8000);T1(8,1:8000);T1(10,1:8000);T1(12,1:8000);T1(14,1:8000);T1(16,1:8000);T1(18,1:8000);T1(20,1:8000);T1(22:23,1:8000);T1(25,1:8000);T1(27,1:8000);T1(29,1:8000);T1(31,1:8000);T1(33,1:8000);T2(2,1:8000);T2(4,1:8000);T2(6,1:8000);T2(8,1:8000);T2(10,1:8000);T2(12,1:8000);T2(14,1:8000);T2(16,1:8000);T2(18,1:8000);T2(20,1:8000);T2(22:23,1:8000);T2(25,1:8000);T2(27,1:8000);T2(29,1:8000);T2(31,1:8000);T2(33,1:8000)];

targets_for_18buses = [T3(2,1:8000);T3(4,1:8000);T3(6,1:8000);T3(8,1:8000);T3(10,1:8000);T3(12,1:8000);T3(14,1:8000);T3(16,1:8000);T3(18,1:8000);T3(20,1:8000);T3(22:23,1:8000);T3(25,1:8000);T3(27,1:8000);T3(29,1:8000);T3(31,1:8000);T3(33,1:8000);T4(2,1:8000);T4(4,1:8000);T4(6,1:8000);T4(8,1:8000);T4(10,1:8000);T4(12,1:8000);T4(14,1:8000);T4(16,1:8000);T4(18,1:8000);T4(20,1:8000);T4(22:23,1:8000);T4(25,1:8000);T4(27,1:8000);T4(29,1:8000);T4(31,1:8000);T4(33,1:8000)];

x_for_18buses = inputs_for_18buses;

t_for_18buses = targets_for_18buses;

net_for_18buses = fitnet(10,'trainlm');

net_for_18buses = train(net_for_18buses,x_for_18buses,t_for_18buses);

%view(net_for_18buses) kore iranai

NetOutputY_for_18buses = net_for_18buses([T1(2,8001:10000);T1(4,8001:10000);T1(6,8001:10000);T1(8,8001:10000);T1(10,8001:10000);T1(12,8001:10000);T1(14,8001:10000);T1(16,8001:10000);T1(18,8001:10000);T1(20,8001:10000);T1(22:23,8001:10000);T1(25,8001:10000);T1(27,8001:10000);T1(29,8001:10000);T1(31,8001:10000);T1(33,8001:10000);T2(2,8001:10000);T2(4,8001:10000);T2(6,8001:10000);T2(8,8001:10000);T2(10,8001:10000);T2(12,8001:10000);T2(14,8001:10000);T2(16,8001:10000);T2(18,8001:10000);T2(20,8001:10000);T2(22:23,8001:10000);T2(25,8001:10000);T2(27,8001:10000);T2(29,8001:10000);T2(31,8001:10000);T2(33,8001:10000)]);

MeanNetOutputY_for_18buses = mean(NetOutputY_for_18buses,2);

PowerFlowCalculationY_for_18buses = [T3(2,8001:10000);T3(4,8001:10000);T3(6,8001:10000);T3(8,8001:10000);T3(10,8001:10000);T3(12,8001:10000);T3(14,8001:10000);T3(16,8001:10000);T3(18,8001:10000);T3(20,8001:10000);T3(22:23,8001:10000);T3(25,8001:10000);T3(27,8001:10000);T3(29,8001:10000);T3(31,8001:10000);T3(33,8001:10000);T4(2,8001:10000);T4(4,8001:10000);T4(6,8001:10000);T4(8,8001:10000);T4(10,8001:10000);T4(12,8001:10000);T4(14,8001:10000);T4(16,8001:10000);T4(18,8001:10000);T4(20,8001:10000);T4(22:23,8001:10000);T4(25,8001:10000);T4(27,8001:10000);T4(29,8001:10000);T4(31,8001:10000);T4(33,8001:10000)];

MeanPowerFlowCalculationY_for_18buses = mean(PowerFlowCalculationY_for_18buses,2);

error_for_18buses = MeanNetOutputY_for_18buses - MeanPowerFlowCalculationY_for_18buses;
%% 15母線("3","5",7,9,11,13,15,17,19,21,"24",26,28,30,32)分のデータを抜いて
MeanNetOutputY_for_18buses_converted_into_33 = [NaN;MeanNetOutputY_for_18buses(1,1);NaN;MeanNetOutputY_for_18buses(2,1);NaN;MeanNetOutputY_for_18buses(3,1);NaN;MeanNetOutputY_for_18buses(4,1);NaN;MeanNetOutputY_for_18buses(5,1);NaN;MeanNetOutputY_for_18buses(6,1);NaN;MeanNetOutputY_for_18buses(7,1);NaN;MeanNetOutputY_for_18buses(8,1);NaN;MeanNetOutputY_for_18buses(9,1);NaN;MeanNetOutputY_for_18buses(10,1);NaN;MeanNetOutputY_for_18buses(11:12,1);NaN;MeanNetOutputY_for_18buses(13,1);NaN;MeanNetOutputY_for_18buses(14,1);NaN;MeanNetOutputY_for_18buses(15,1);NaN;MeanNetOutputY_for_18buses(16,1);NaN;MeanNetOutputY_for_18buses(17,1);
                                                NaN;MeanNetOutputY_for_18buses(18,1);NaN;MeanNetOutputY_for_18buses(19,1);NaN;MeanNetOutputY_for_18buses(20,1);NaN;MeanNetOutputY_for_18buses(21,1);NaN;MeanNetOutputY_for_18buses(22,1);NaN;MeanNetOutputY_for_18buses(23,1);NaN;MeanNetOutputY_for_18buses(24,1);NaN;MeanNetOutputY_for_18buses(25,1);NaN;MeanNetOutputY_for_18buses(26,1);NaN;MeanNetOutputY_for_18buses(27,1);NaN;MeanNetOutputY_for_18buses(28:29,1);NaN;MeanNetOutputY_for_18buses(30,1);NaN;MeanNetOutputY_for_18buses(31,1);NaN;MeanNetOutputY_for_18buses(32,1);NaN;MeanNetOutputY_for_18buses(33,1);NaN;MeanNetOutputY_for_18buses(34,1);];

MeanPowerFlowCalculationY_for_18buses_converted_into_33 = [NaN;MeanPowerFlowCalculationY_for_18buses(1,1);NaN;MeanPowerFlowCalculationY_for_18buses(2,1);NaN;MeanPowerFlowCalculationY_for_18buses(3,1);NaN;MeanPowerFlowCalculationY_for_18buses(4,1);NaN;MeanPowerFlowCalculationY_for_18buses(5,1);NaN;MeanPowerFlowCalculationY_for_18buses(6,1);NaN;MeanPowerFlowCalculationY_for_18buses(7,1);NaN;MeanPowerFlowCalculationY_for_18buses(8,1);NaN;MeanPowerFlowCalculationY_for_18buses(9,1);NaN;MeanPowerFlowCalculationY_for_18buses(10,1);NaN;MeanPowerFlowCalculationY_for_18buses(11:12,1);NaN;MeanPowerFlowCalculationY_for_18buses(13,1);NaN;MeanPowerFlowCalculationY_for_18buses(14,1);NaN;MeanPowerFlowCalculationY_for_18buses(15,1);NaN;MeanPowerFlowCalculationY_for_18buses(16,1);NaN;MeanPowerFlowCalculationY_for_18buses(17,1);
                                                           NaN;MeanPowerFlowCalculationY_for_18buses(18,1);NaN;MeanPowerFlowCalculationY_for_18buses(19,1);NaN;MeanPowerFlowCalculationY_for_18buses(20,1);NaN;MeanPowerFlowCalculationY_for_18buses(21,1);NaN;MeanPowerFlowCalculationY_for_18buses(22,1);NaN;MeanPowerFlowCalculationY_for_18buses(23,1);NaN;MeanPowerFlowCalculationY_for_18buses(24,1);NaN;MeanPowerFlowCalculationY_for_18buses(25,1);NaN;MeanPowerFlowCalculationY_for_18buses(26,1);NaN;MeanPowerFlowCalculationY_for_18buses(27,1);NaN;MeanPowerFlowCalculationY_for_18buses(28:29,1);NaN;MeanPowerFlowCalculationY_for_18buses(30,1);NaN;MeanPowerFlowCalculationY_for_18buses(31,1);NaN;MeanPowerFlowCalculationY_for_18buses(32,1);NaN;MeanPowerFlowCalculationY_for_18buses(33,1);NaN;MeanPowerFlowCalculationY_for_18buses(34,1)];

MeanNetOutputY_for_33buses = MeanNetOutputY;

MeanNetOutputY_for_33buses(1,1) = NaN;
MeanNetOutputY_for_33buses(3,1) = NaN;
MeanNetOutputY_for_33buses(5,1) = NaN;
MeanNetOutputY_for_33buses(7,1) = NaN;
MeanNetOutputY_for_33buses(9,1) = NaN;
MeanNetOutputY_for_33buses(11,1) = NaN;
MeanNetOutputY_for_33buses(13,1) = NaN;
MeanNetOutputY_for_33buses(15,1) = NaN;
MeanNetOutputY_for_33buses(17,1) = NaN;
MeanNetOutputY_for_33buses(19,1) = NaN;
MeanNetOutputY_for_33buses(21,1) = NaN;
MeanNetOutputY_for_33buses(24,1) = NaN;
MeanNetOutputY_for_33buses(26,1) = NaN;
MeanNetOutputY_for_33buses(28,1) = NaN;
MeanNetOutputY_for_33buses(30,1) = NaN;
MeanNetOutputY_for_33buses(32,1) = NaN;

MeanNetOutputY_for_33buses(34,1) = NaN;
MeanNetOutputY_for_33buses(36,1) = NaN;
MeanNetOutputY_for_33buses(38,1) = NaN;
MeanNetOutputY_for_33buses(40,1) = NaN;
MeanNetOutputY_for_33buses(42,1) = NaN;
MeanNetOutputY_for_33buses(44,1) = NaN;
MeanNetOutputY_for_33buses(46,1) = NaN;
MeanNetOutputY_for_33buses(48,1) = NaN;
MeanNetOutputY_for_33buses(50,1) = NaN;
MeanNetOutputY_for_33buses(52,1) = NaN;
MeanNetOutputY_for_33buses(54,1) = NaN;
MeanNetOutputY_for_33buses(57,1) = NaN;
MeanNetOutputY_for_33buses(59,1) = NaN;
MeanNetOutputY_for_33buses(61,1) = NaN;
MeanNetOutputY_for_33buses(63,1) = NaN;
MeanNetOutputY_for_33buses(65,1) = NaN;

f13 = figure;
f14 = figure;

plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33(1:33),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33(1:33),'-*',1:1:33,MeanNetOutputY_for_33buses(1:33),'-x');
legend('16母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧値','電力潮流計算による各母線の電圧値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧値');
axis auto;
xlabel('母線番号');
ylabel('母線の電圧値[p.u.]');
title('各母線の電圧値');
figure(f13);
plot(1:1:33,MeanNetOutputY_for_18buses_converted_into_33(34:66),'-+',1:1:33,MeanPowerFlowCalculationY_for_18buses_converted_into_33(34:66),'-*',1:1:33,MeanNetOutputY_for_33buses(34:66),'-x');
legend('16母線分のデータを抜いて学習させた時にニューラルネットワークが出力した各母線の電圧の位相角の値','電力潮流計算による各母線の電圧の位相角の値','すべての母線のデータを利用して訓練させた時にニューラルネットワークが出力した各母線の電圧の位相角の値');
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