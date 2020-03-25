function a = bt_lsearch(x,s,F,G,p1,p2)
rho = 0.1;
gma = 0.5;
x = x(:);
s = s(:);
a = 1;
parameterstring = '';

if nargin > 4,
    if ischar(p1),
        eval([p1 ';']);
    else
        parameterstring =',p1';
    end
end