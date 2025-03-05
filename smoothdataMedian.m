% smooth data using median to remove spikes on a vector curve.
% coded by Jixin Chen @ Ohio University 2024-07-30
% 

function data3 = smoothdataMedian(data, n) %n half size of the smooth window
    data = data(:);
    data2 = [ones(n,1)*median(data(1:n)); data; ones(n,1)*median(data(end-n:end))];
    for i = 1:length(data) 
        data3(i) = median(data2(i:i+2*n));
    end
end