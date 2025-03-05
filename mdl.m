function y = mdl(para, x)  
    % para: t1, t2, t3, t4, t5, r0, r1, r2
    % para: t1 (0-t1 0), t2 (t1-t2 first test to restriction), r0 (R0), 
    % t3 (t2- restriction time), r1, t4, r2, t5 ; t is the starting time of
    % the next section not the end of the previous section.
    for i = 1:5
        para(i) = round(para(i));
    end
    x = x(:);
    y = zeros(length(x),1);
    y(para(1):para(2)-1) = para(6); % first spike ~R0
    y(para(2):para(3)-1) = para(7); % social distancing ~1
    y(para(3):para(4)-1) = para(7) + (para(8)-para(7))/(para(4)-para(3))*(x(para(3):para(4)-1)-para(3)); % baking to normal
    y(para(4):para(5)-1) = para(8); % fully normal.
end