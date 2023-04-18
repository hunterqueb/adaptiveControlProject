clc; clear;


%%Probably not enough data to get an accurate network
Mach = [0.4 0.7 0.9 1.1 1.2 1.35 1.65 2 2.4 3 4 10 29.5];
Cl = [0.24465 0.26325 0.32074 0.49373 0.47853 0.56282 0.55002 0.53247 0.5074 0.47883 0.44147 0.42856 0.38773];
Cd = [0.853 0.98542 1.10652 1.1697 1.156 1.2788 1.2657 1.2721 1.2412 1.2167 1.2148 1.2246 1.2891];
Input = Mach;
Output = [Cl;Cd];
data = [Input;Output];
net = feedforwardnet(10);

splitRatio = 0.9;
nTrain = round(size(Input,2) * splitRatio);
idx = randperm(size(Input,2));
InputTrain = Input(idx(1:nTrain));
OutputTrain = Output(:,idx(1:nTrain));

InputTest = Input(idx(nTrain:end));
net = train(net,Input,Output);

figure(1)
plot(Mach,Cl,Mach,Cd)
Pred = net(Mach);
hold on
plot(Mach,Pred)
legend('Cl Actual','Cd Actual','Cl NN', 'Cd NN')