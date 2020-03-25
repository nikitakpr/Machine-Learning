function g = g_wdbc(w,D)
X = D(1:30, :);
y = D(31, :);
N = length(y)
g = zeros(31,1);
wt = w(:)';
for i = 1:N
    xi = [X(:,i);1];
    ei = exp(-y(i)*(wt*xi));
    ci = -y(i)*ei/(1+ei);
    gi = ci*xi;
    g = g + gi;
end
g= g/N;