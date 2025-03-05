G2_Refit_List = [21, 22, 44,45,47,52,55,61,82,92,93,94,113];


for c = G2_Refit_List
    % figure; plot(country2(c).Immune); ylim([0,1E6]); title(country2(c).country);
    % hold on; plot(country2(c).pfvpm); plot(cumsum(country2(c).ncspm));

    N = 1E6; % total population, use per million data so total is 1 million.
    gamma0 = 0.2; % recover/quarantine rate
    Rt_maxAllowed = 50;
    I_minAllowed = 1;
    S_minAllowed = 1;
    smoothWindow = 40;
    b = 0.2;
    R0 = 3;
    HerdIm = 1-1/R0;

    data = [];

    V2 = country2(c).pfvpm; % fully vaccinated people per million population.
    nc = country2(c).ncspm; %new case per million people raw data from Our World in Data.
    nc = smoothdata(nc, 'gaussian', smoothWindow); % Gaussian smooth
    Icumu = cumsum(nc); % cummulated infectious population per day so total people is cumsum(I*gamma). Simplify gamma to gamma0.
    I_NormFactor = 1;
    if HerdIm*1E6>V2(940)
        I_NormFactor = (HerdIm*1E6-V2(940))/(Icumu(940)*gamma0);
    end
    nc = nc*I_NormFactor;
    rr = country2(c).rr; % reproduction rate calculated by Our World in Data.

    t = length(nc); % total days

    beta2 = [];
    Rt2 = [];
    RE2 = [];
    S2 = [];
    I2 = [];
    R2 = [];

    %initialize
    beta2(1) = 0;
    gamma2 = ones(t,1)*gamma0;
    Rt2(1) = 0;
    RE2(1) = 0;
    S2(1) = N;
    I2(1) = 1;
    R2(1) = 0;
    vd(1) = 0;
    for i = 2:t
        vd(i) = V2(i)-V2(i-1);
    end


    for i = 2:t
        beta2(i) = nc(i)*N/( S2(i-1) + (R2(i-1)+V2(i-1))*b )/I2(i-1);
        S2(i) = S2(i-1)-nc(i)-vd(i);
        if(S2(i)) < S_minAllowed % avoid unreasonably large beta due to no susceptable population.
            S2(i) = S_minAllowed; % set to 1 to avoid singularity at 0
        end

        I2(i) = I2(i-1) + nc(i) - gamma2(i-1)*I2(i-1);
        R2(i) = R2(i-1) + gamma2(i-1)*I2(i-1);

        if(R2(i))>(N-V2(i)-I2(i)-S2(i)) % simplify overlap of infected and vaccinated to if sum >N set to N.
             R2(i) = (N-V2(i)-I2(i)-S2(i));
        end
        if I2(i) < I_minAllowed % avoid unreasonably large beta due to no infected population.
            I2(i) = I_minAllowed;
        end

        % calculate reproduction numbers
        Rt2(i) = beta2(i)/gamma2(i);
        RE2(i) = nc(i)/I2(i)/gamma2(i); 
        % OR
        % RE2(i) = Rt2(i)*S2(i)/N;
    end

    % figure;
    % plot(Rt2,'linewidth', 2);

    % store
    %Rt2 = Rt2(:);
    % data = [data, Rt2(1:1600)];

    country2(c).SIRVB.Rt = Rt2(:);
    country2(c).SIRVB.RE = RE2(:);
    country2(c).SIRVB.S = S2(:);
    country2(c).SIRVB.I = I2(:);
    country2(c).SIRVB.R = R2(:);
    country2(c).SIRVB.V = V2(:);
    country2(c).SIRVB.I_NormFactor = I_NormFactor;


    %% fit the data with the laydown 5 model

    Rt = Rt2;
    L = length(Rt);
    if L<1500
        Rt = Rt(:)
        Rt = [Rt;zeros(1500-L,1)];
    end

    t = 1:length(Rt);


        x = t(:); % a vector 
        y = Rt(:); % a vector. 2D data need to modify the fitting function to calculate residual correctly 
                   % or vectorize and modify the mdl function to calculate the y_guess correctly
     %   figure; plot(x,y); title('raw data');


    % x=[0.25 0.5 1 1.5 2 3 4 6 8];
    % y=[19.21 18.15 15.36 14.10 12.89 9.32 7.45 5.24 3.01];
    %------------END of loading data: x and y in row vectors--------

    %% ----Setting up fitting model and parameters-------------
        %           the rest can be a double expnential function, any custom function 
        %           or a group of functions in a separated Matlab
        %           function. Just pass the function handle to the fitting
        %           funciton, e.g.
        %           function [yfit1, yfit2, yfit3,...] = yournamedoubleExp(para, x1, x2, x3,...)
        %                 
        %           All functions are numerical solved with no efforts to fit
        %           analytically with x and y data.
        %-----------------------------------------

        % set fitting options
        option.maxiteration = 50;  % number of iteration fixed, the fitting will stop either this iteration or convergence reached first 
        option.precision = 1E-6;  % best searching precision, recommend 1 decimal better than desired. e.g want 0.01, set to 0.001.
        option.convgtest = 1e-10; % difference between two iterations on the square difference between fitting and data.
    %    option.step = 0.5; %Super important for speed. Suggest 0.5. Can be 0.1-4;

        % ----------------Attn: change below for different fitting equations-----------------
        % set the fitting equation to double exponential decay with a base line%
    %    mdl = @(para, x) para(1)*exp(-(x/para(2))) + para(3)*exp(-(x/para(4))) + para(5)*exp(-(x/para(6))) + para(7);

    %    mdl = @(para, x) para(1)*exp(-(x/para(2))); 
        % equation grammar: modle name 'mdl' use as function y = mdl(para, x), the rest is the equation.
        % you can also generate a function to replace the above equation: 
        % function newy = mdl(para, x)
        % which will allow combination of equations and global fitting using
        % different equations for different pieces of data that share some
        % common parameters.

        % initial guess
        ind = [];
        ind = find(y>1.5);
        % para: t1, t2, t3, t4, t5,                r0, r1, r2
        if ~isempty(ind)
            day1 = ind(1);
            paraGuess = [day1, day1, 400, 1000, 1300,     3, 1, 3];
            bounds = [0,     0,  0, 0,    0,               0, 0, 0;   % lower boundary
                     day1+10, 300,  800, 1500, length(x)+1,     10, 10, 50]; % upper boundary

        else
            paraGuess = [50, 100, 600, 1000, 1300,     4, 1, 4];
            bounds = [0,  101, 301, 801,   1501,       0, 0, 0;   % lower boundary
                     100, 300, 800, 1500, length(x)+1,   10, 10, 50]; % upper boundary
        end


    %     bounds = [0, 0,;   % lower boundary
    %               100, 100]; % upper boundary

        %-------------------------------

        d1 = paraGuess-bounds(1,:);
        d2 = bounds(2,:)-paraGuess;
        if ~isempty(find([d1,d2]<=0))
            display(['WARNING: initial guess out of boundary paraGuess #', num2str(find(d1<=0)), num2str(find(d2<=0))]);
        end
        %--------------END of fitting option setting, equation, initial guess,
        %              and guessed parameter boundaries.


        %------------------and start fitting:------------------------

    %    tic

         Results = jcfit_L2(x, y, paraGuess, bounds, option);
        % warning: the parameter 95% confidence lower and upper bounds are based on estimation of the local minimum,
        % not considering global minimum and other local minima.
    %    toc
        country2(c).SIRVB.parafinal = Results.parafinal;




figure; hold on;
t = 1:length(country2(c).SIRVB.Rt);
t = t(:);
yfit = mdl(country2(c).SIRVB.parafinal, t);
plot(country2(c).SIRVB.Rt);
plot(yfit);

t = 1:length(country2(c).SIRVB.Rt);
t = t(:);
yfit = mdl(country2(c).SIRVB.parafinal, t);
plot(country2(c).SIRVB.Rt);
plot(yfit,'color','black'); title(['Rt & Rt_corrected Group 1', country2(c).country, num2str(c)]);

end

G1_remove = [79, 55, 51, 23, 21];
G2_remove = [82];