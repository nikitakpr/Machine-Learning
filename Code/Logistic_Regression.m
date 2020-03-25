clear;
clc;
close all;

load D_bc_te.mat
load D_bc_tr.mat


%% the train and test data are normalized
Xtrain = zeros(30,480);
for i = 1:30
 xi = D_bc_tr(i,:);
 mi = mean(xi);
 vi = sqrt(var(xi));
 Xtrain(i,:) = (xi - mi)/vi;
end
Xtest = zeros(30,89);
for i = 1:30
 xi = D_bc_te(i,:);
 mi = mean(xi);
 vi = sqrt(var(xi));
 Xtest(i,:) = (xi - mi)/vi;
end

%% the labels associated with the train and test data are produced 

ytrain = D_bc_tr(31,:);
ytest = D_bc_te(31,:);

Dtrain = [Xtrain; ytrain];
Dtest = [Xtest; ytest];

Numfeature = 30;
it1 = 5;
it2 = 12;
it3 = 75;
K = it1;

%step1
eps = 10^-9;
W = zeros(Numfeature+1,1);
f1 = zeros (1,K);
k = 1;

%step2
gk = g(W, Dtrain);
dk = -gk;

%step3
ak = bt_lsearch2019(W,dk,'f','g',Dtrain);
while (norm(ak*dk)>= eps) && (k<=K)
    W = W+ak*dk;
    
    gk = g(W, Dtrain);
    dk = -gk;
    
    ak = bt_lsearch2019(W,dk,'f','g',Dtrain);
    
    f1(k) = f(W,Dtrain);
    
    k = k+1;
    
end

%%testing
Dt = [Xtest; ones(1,89)];
Result = W'*Dt;
TestLabel = zeros (1,length(Result));
FalsePos = 0;
FalseNeg = 0;
for ii= 1:length(Result)
    if Result(ii)<0
        TestLabel(ii)=-1;
        if ytest(ii)>0
            FalseNeg=FalseNeg+1;
        end
    else
        TestLabel(ii)=1;
        if ytest(ii)<0
            FalsePos = FalsePos+1;
        end
    end
end

mis_class = FalsePos+FalseNeg;
error_rate = mis_class/89*100;
accuracy = 100 - error_rate;

fprintf('number of false possitive is \n%2.4f%%\n',FalsePos)
fprintf('number of false Negative is \n%2.4f%%\n',FalseNeg)

fprintf('The error rate is \n%2.4f%% \n', error_rate);
fprintf('The accuracy rate is \n%2.4f% \n', accuracy);
fprintf('No. of misclassifications is \n%d out of 89', mis_class);

