clc; clear;

t = [0 88 90 92 94 96 138 166 170 174 180 182 190 200 210 216 218 230 240 250 260 270 280 290 300 310 320 322 330 338 340 342 350 352 360 370 380 382 384 390 396 400 410 418 420 428 430 432 434 436 500 550]';
bank = [0 22.9 82.1 90 90 180 0 15.4 41.7 49.3 35.3 32.4 42.4 51.9 54.2 54.6 -55.3 -68.3 -74.2 -79.3 -81.1 -82.3 -81.9 -82.3 -77.2 -73.5 -70.4 -43.7 -32.1 -58.8 62.8 63 91.9 94 78.5 72.5 64.1 57 -48.9 -65.5 -81.1 -84.7 -83.3 -86 -80 93.5 102.6 103.4 105 88.8 0 0]';
% figure(1)
% stairs(t,bank)
% xlim([0 550])
% ylim([-180 180])

new_x = t(1):0.1:t(end);
new_y = interp1(t,bank,new_x,'previous');
%figure(2)
%plot(t, bank, 'o', new_x, new_y, '-');
%plot(new_x,new_y)

Input = new_x;
Output = new_y;
net = feedforwardnet(10);

[trainInd,valInd,testInd] = divideblock(length(new_x),0.7,0.15,0.15);
in_Train = Input(:,trainInd);
out_Train = Output(:,trainInd);
in_Val = Input(:,valInd);
out_Val = Output(:,valInd);
in_Test = Input(:,testInd);
out_Test = Output(:,testInd);

% hiddenSizes = 10; %size of hidden layer
% inputSize = 1;
% outputSize = 1;
% layers = [ ...
%     featureInputLayer(inputSize)    
%     reluLayer
%     dropoutLayer(0.5)
%     fullyConnectedLayer(outputSize)  
%     regressionLayer];
% options = trainingOptions("sgdm", ...
%     "MaxEpochs", 50, ...
%     "MiniBatchSize", 42, ...
%     "GradientThreshold", 1, ...
%     "ValidationData",{in_Val' out_Val'}, ...
%     "Plots","training-progress", ...
%     "Verbose", true, ...
%     "ValidationFrequency",5, ...
%     "Shuffle", 'never', ...
%     'ValidationPatience', 5);
% 
% net = trainNetwork(in_Train',out_Train',layers,options);

net = train(net,Input,Output);

figure
plot(new_x,new_y)
Pred = net(new_x);
hold on
plot(new_x,Pred)
legend('Actual','NN Approx.')
xlim([0 550])
ylim([-180 180])

save('network.mat','net')