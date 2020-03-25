clc
clear all
close all

load('D_bc_tr.mat');
load('D_bc_te.mat');

hk = [];
hj = [];

for i = 1 : 480
    if D_bc_tr(31,i) == -1
    
        be = D_bc_tr(:,i);
        hk = [hk be];
    end

    if D_bc_tr(31,i) == 1
        ma = D_bc_tr(:,i);
        hj = [hj ma];
    end
end

Xtr1 = hk(1:30,:);
Xtr2 = hj(1:30,:);
y1 = [ones(300,1);-ones(180,1)];
y2 = [ones(180,1);-ones(300,1)];

Xtr = [Xtr1 Xtr2];
x_11 = [Xtr1 Xtr2];
x_11(31,:) = [ones(1,300) ones(1,180)];

X11 = x_11'; 
w1star = pinv(X11)*y1;
w1 = w1star(1:30,:);
b1 = w1star(31,:);

x_22 = [Xtr2 Xtr1];
x_22(31,:) = [ones(1,180) ones(1,300)];

X22 = x_22'; 
w2star = pinv(X22)*y2;
w2 = w2star(1:30,:);
b2 = w2star(31,:);

W_star = [w1 w2];
b_star = [b1;b2];

Label = D_bc_te(31,:);

orig1 = [];orig2 = [];
XTe1 = [];XTe2 = [];

for i = 1 : 89

    if Label(:,i) == -1
        orig2  = -1;
        orig2 = [orig2 orig2];
        Xte = D_bc_te(1:30,i);
        XTe1 = [XTe1 Xte];
    end

    if Label(:,i) == 1
        orig1  = 1;
        orig1 = [orig1 orig1];
        Xte = D_bc_te(1:30,i);
        XTe2 = [XTe2 Xte];
    end

end

L = [orig1 orig2];
XTe = [XTe1 XTe2];

Xte = [XTe];
Label = [ones(1,57) ones(1,32)+1];

ek = zeros(2,89);
mis_class = 0;

for col = 1:89
    f = W_star'*Xte(:,col)+b_star;
    [maxvalue index] = max(f);
    ek(index,col)  = 1;

    if index ~= Label(col)
        mis_class = mis_class +1;
    end
end

ek;
mis_class;

error_rate = mis_class/89*100;
accuracy = 100 - error_rate;

fprintf('\nThe error rate is \n%2.4f%% \n', error_rate);
fprintf('\nThe accuracy rate is \n%2.4f% \n', accuracy);
fprintf('\nNo. of misclassifications is \n%d out of 89', mis_class);

