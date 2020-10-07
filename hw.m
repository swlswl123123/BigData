clc; clear all; close all;

data = xlsread('data.xlsx');
data = data(:,2:end);
arg_age = data(:,6);

f1 = figure(1);
histfit(arg_age);
[mu,sigma] = normfit(arg_age)
set(get(gca, 'XLabel'), 'String', 'age');
set(get(gca, 'YLabel'), 'String', 'N');
print(f1,'-dpng','-r300','./image/pdf_arg_age_TX_B.png');

f2 = figure(2);
qqplot(arg_age);
print(f2,'-dpng','-r300','./image/qq_arg_age_TX_B.png');

% ks-test
pd = makedist('Normal','mu',mu,'sigma',sigma);
[h,p,~,c] = kstest(arg_age,'CDF',pd,'Alpha',0.01)

% group analysis

variance = zeros(5,1);

SIZE = get(0,'ScreenSize');	% 获取显示屏的像素尺寸
f3 = figure(3);				% 创建图形窗口
set(f3, 'position', SIZE);	% 设置图形窗口位置尺寸为屏幕大小
for i = 1:5
    g = arg_age(data(:,1)==i);
    g_mean = sum(g)/size(g,1);
    variance(i) = sqrt(sum((g-g_mean).^2)/(size(g,1)-1));
    subplot(2,5,i)
    histfit(g);
    [mu,sigma] = normfit(g);
    hold on;
    subplot(2,5,i+5)
    qqplot(g);
    pd = makedist('Normal','mu',mu,'sigma',sigma);
    [h,p,~,c] = kstest(g,'CDF',pd,'Alpha',0.1)
end 

print(f3,'-dpng','-r300','./image/sub_arg_age_TX_B.png');

variance

% ANOVA
category = data(:,1);
anova1(arg_age,category)

SIZE = get(0,'ScreenSize');	% 获取显示屏的像素尺寸
f4 = figure(6);				% 创建图形窗口
set(f4, 'position', SIZE);	% 设置图形窗口位置尺寸为屏幕大小
sel_set = {2,11,5};
sel_name = {'age\_dif','area','phone\_num'};

for i = 1:3

    factor = log10(data(:,sel_set{i})+1);

    subplot(2,3,i)
    histfit(factor);
    [mu,sigma] = normfit(factor)
    set(get(gca, 'XLabel'), 'String', sel_name{i});
    set(get(gca, 'YLabel'), 'String', 'N');
    subplot(2,3,i+3)
    qqplot(factor);

    % ks-test
    pd = makedist('Normal','mu',mu,'sigma',sigma);
    [h,p,~,c] = kstest(factor,'CDF',pd,'Alpha',0.01)

end

print(f4,'-dpng','-r300','./image/factor_arg_age_TX_B.png');

% sampling

F = zeros(10,1);

for i = 1:10

    R = rand(size(arg_age));
    [~,R_index] = sort(R);
    data_random = data(R_index,:);
    data_sample = data_random(1:204,:);
    category_sample = data_sample(:,1);
    arg_age_sample = data_sample(:,6);
    [p,tbl] = anova1(arg_age_sample,category_sample,'off');

    F(i)=tbl{2,5};
end

F

% another sampling

for i = 1:10

    R = rand(size(arg_age));
    [~,R_index] = sort(R);
    start = R_index(1);
    S_index = [1:10:2040] + start;
    S_index(S_index > 2040) = S_index(S_index > 2040) - 2040;
    data_sample = data(S_index',:);
    category_sample = data_sample(:,1);
    arg_age_sample = data_sample(:,6);
    [p,tbl] = anova1(arg_age_sample,category_sample,'off');

    F(i)=tbl{2,5};
end

F