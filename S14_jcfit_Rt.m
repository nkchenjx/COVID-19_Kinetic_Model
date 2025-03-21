% All rights reserved by Jixin Chen
% First coding: 2016/04/05 by Jixin Chen @ Department of Chemistry and Biochemistry, Ohio University
% 20170110 Jixin Chen modified it to a function
% 20180609 Jixin Chen simplified it into single curve fitting
% 20211116 Jixin Chen cleaned the code for better reading

% Copyright (c) 2018 Jixin Chen @ Ohio University
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

%% Use the lay down 5 shape to fit the Rt of SIRVB model for COVID-19 in each country
clear;
load('data_SIRVB.mat');

for c = 1:length(country)


% clear
Rt = country(c).SIRVB.Rt; %77 France, 240 USA, world 251
L = length(Rt);
if L<1500
    Rt = Rt(:)
    Rt = [Rt;zeros(1500-L,1)];
end

t = 1:length(Rt);



%% ------load raw data------------------    
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
        paraGuess = [ind(1), ind(1)+30, 500, 1000, 1300,     3, 1, 3];   
    else
        paraGuess = [100, 200, 500, 1000, 1300,     3, 1, 3];
    end

    bounds = [0,   0,   0,  0,     0,               0, 0, 0;   % lower boundary
              300, 300, 800, 1500, length(x)+1,     10, 10, 50]; % upper boundary
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
    country(c).SIRVB.parafinal = Results.parafinal;
end
    
%     fprintf(['\n rsq = ', num2str(rsq), '\n']);
    % parafinal is the fitted results; yfit is the fittered curve; 
    % use residual = y-yfit; to get the residual
    % rsq: root mean sqare value best will be close to 1
    
    % %--------- plot results -----------------
    % yfit = Results.yfit;
    % residual = Results.residual;
    % figure; plot(x,y,'linewidth',1.5); hold on; plot(x,yfit,'linewidth',1.5); plot(x, residual,'linewidth',1.5);
    % title(['rsq = ', num2str(Results.rsq)]);
    % ax = gca;
    % ax.LineWidth = 1.5;
    % ax.Box = 'on';
    % ax.TickLength = [0.02, 0.02];
    % ax.FontName = 'Arial';
    % ax.FontSize = 20;
    % ax.FontWeight = 'Bold';
    % 
    % figure; plot(Results.errorHist, 'linewidth',1.5);
    % title('error vs iteration');
    % ax = gca;
    % ax.LineWidth = 1.5;
    % ax.Box = 'on';
    % ax.TickLength = [0.02, 0.02];
    % ax.FontName = 'Arial';
    % ax.FontSize = 20;
    % ax.FontWeight = 'Bold';
    
    %-------------------------------------
    % End. by Jixin Chen @ Ohio University


    save('data_SRIVB_fit', 'country', 'option');