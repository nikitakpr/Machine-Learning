clc
clear all
close all

load('D_bc_tr.mat');
load('D_bc_te.mat');

hk = [];hj = [];

for i = 1 : 480
    if D_bc_tr(31,i) == 1
        hk1 = D_bc_tr(:,i);
        hk = [hk hk1];
    end
    
    if D_bc_tr(31,i) == -1
        hj2 = D_bc_tr(:,i);
        hj = [hj hj2];
    end
end

Xtr = [hk(1:30,:) hj(1:30,:)];

sd = 48;
q = 8;

meann = [];U = [];var = [];

meann1 = [];U1 = [];var1 = [];

meann2 = [];U2 = [];var2 = [];

for j = 0 : 1
    if j == 0
        sd = 180;
        X = Xtr(:,1:180);
        meann = mean(X,2);
        A = X - meann;
        C = 1/sd*(A*A');
        
        [uq, Sq] = eigs(C,q);
        meann1 = [meann1 meann];
        U1 = [U1 uq];
        var1 = [var1 X];
    end

    if j == 1
        sd = 300;
        X = Xtr(:,181:end);
        meann = mean(X,2);
        A = X - meann;
        C = 1/sd*(A*A');
        
        [uq, Sq] = eigs(C,q);
        meann2 = [meann2 meann];
        U2 = [U2 uq];
        var2 = [var2 X];
    end
end

U = [U1 U2];
var = [var1 var2];
meann = [meann1 meann2];
D_test = D_bc_te(1:30,:);
t = cputime;
tic;
for j = 1:89
    for i = 0:1
        Uq = U(:,(i*q)+1:(i+1)*q);
        f_j = Uq'*(D_test(:,j)-meann(:,i+1));
        x_capp = Uq*f_j+meann(:,i+1);
        e(i+1,j) = norm(D_test(:,j)-x_capp);
        
    end
end

Label = D_bc_te(31,:);
Label_1 = zeros(1,89);

for i = 1 : 89
    if Label(:,i) == -1
        Label_1(1,i) = 2;
    end
    if Label(:,i) == 1
        Label_1(1,i) = 1;
    end
end

Label = Label_1;

yz = toc;
[k,ind] = min(e);
t1 = cputime - t;
cmp = Label - (ind);

misclass = nnz(cmp);
error_rate = (misclass*100)/length(Label);
accuracy = 100 - error_rate;

fprintf('\nThe error rate is \n%2.4f%% \n', error_rate);
fprintf('\nThe accuracy rate is \n%2.4f% \n', accuracy);
fprintf('\nNo. of misclassifications is \n%d out of 89', misclass);


