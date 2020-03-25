function f = f_wdbc(w,D)

X = D(1:30,:);
y = D(31,:);
N = length(y);
f = 0;
wt = w(:)';
for i = 1:N
    xi = [X(:,i);1];
    fi = log(1+exp(-y(i)*(wt*xi)));
    f = f + fi;
end
f = f/N
