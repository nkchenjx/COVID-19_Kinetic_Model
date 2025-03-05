function datas = movingsmooth(data, bin)
L = length(data);    
if length(L<=bin/2)
   datas = ones(L, 1)*mean(data);
else
    for i = 1:bin/2;
       