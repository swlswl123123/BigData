clc; clear all; close all;

data = xlsread('data.xlsx');
data = data(:,2:end);
arg_age = data(:,6);

f1 = figure(1);
% histfit(arg_age);
[mu,sigma] = normfit(arg_age);
x = min(arg_age) : 0.01 : max(arg_age);
histogram(arg_age, 'Normalization', 'pdf');
hold on;
plot(x, normpdf(x,mu,sigma), '--', 'linewidth',2);
% set(gca, 'yticklabel',{'0.000','0.025','0.050','0.075','0.100'});
set(get(gca, 'XLabel'), 'String', 'ƽ������', 'fontsize', 16);
set(get(gca, 'YLabel'), 'String', '�����ܶ�', 'fontsize', 16);
set(gca, 'FontSize', 16);
print(f1,'-dpng','-r300','./image/pdf_arg_age.png');

f2 = figure(2);
pd = makedist('Normal','mu',mu,'sigma',sigma);
qqplot(arg_age, pd);
set(get(gca, 'XLabel'), 'String', '�����̬��λ��');
set(gca, 'FontSize', 16);
print(f2,'-dpng','-r300','./image/qq_arg_age.png');

% ks-test
[h,p,~,c] = kstest(arg_age,'CDF',pd,'Alpha',0.1);

% group analysis

variance = zeros(5,1);

SIZE = get(0,'ScreenSize');	% ��ȡ��ʾ�������سߴ�
f3 = figure(3);				% ����ͼ�δ���
set(f3, 'position', SIZE);	% ����ͼ�δ���λ�óߴ�Ϊ��Ļ��С
for i = 1:5
    g = arg_age(data(:,1)==i);
    g_mean = sum(g)/size(g,1);
    variance(i) = sqrt(sum((g-g_mean).^2)/(size(g,1)-1));
    subplot(2,5,i)
    % histfit(g);
    % switch i
    % case 1
    %     set(gca, 'yticklabel',{'0.00','0.02','0.04','0.06','0.08','0.10','0.12'});
    % case 2
    %     set(gca, 'yticklabel',{'0.00','0.03','0.07','0.10','0.13'});
    % case 3
    %     set(gca, 'yticklabel',{'0.00','0.05','0.10','0.15','0.20'});
    % case 4
    %     set(gca, 'yticklabel',{'0.00','0.02','0.05','0.07','0.09','0.12','0.14'});
    % case 5
    %     set(gca, 'yticklabel',{'0.00','0.03','0.06','0.09','0.13','0.16','0.19'});
    % end
    [mu,sigma] = normfit(g);
    x = mu-3*sigma : 0.1 : mu + 3*sigma;
    histogram(g, 'Normalization', 'pdf');
    hold on;
    plot(x, normpdf(x,mu,sigma), '--', 'linewidth',2);

    set(get(gca, 'Title'), 'String', ['category:', num2str(i)]);
    set(gca, 'FontSize', 22);
    hold on;
    subplot(2,5,i+5)
    pd = makedist('Normal','mu',mu,'sigma',sigma);
    qqplot(g, pd);
    set(get(gca, 'XLabel'), 'String', '�����̬��λ��');
    set(gca, 'FontSize', 22);
    [h,p,~,c] = kstest(g,'CDF',pd,'Alpha',0.05);
end 

print(f3,'-dpng','-r300','./image/sub_arg_age.png');

variance

% ANOVA
category = data(:,1);
[p,tbl] = anova1(arg_age,category,'off');
f4 = figure(4)
boxplot(arg_age,category,'Labels',{'���1','���2','���3','���4','���5'})
set(get(gca, 'XLabel'), 'String', 'Ⱥ�����');
set(get(gca, 'YLabel'), 'String', 'ƽ������');
set(gca, 'FontSize', 16)
print(f4,'-dpng','-r300','./image/arg_age_boxplot.png');
F_total = tbl{2,5}

%other factor
SIZE = get(0,'ScreenSize');	% ��ȡ��ʾ�������سߴ�
f5 = figure(5);				% ����ͼ�δ���
set(f5, 'position', SIZE);	% ����ͼ�δ���λ�óߴ�Ϊ��Ļ��С
sel_set = {3,5,7};
sel_name = {'��Ϣ��','�Ա��','�����'};

for i = 1:3


    factor = data(:,sel_set{i});
    % factor(factor==0) = 0.02;
    % factor = log(factor);

    factor_var = zeros(5,1);
    for k = 1:5
        factor_sub = factor(data(:,1)==k);
        factor_sub_mean = sum( factor_sub)/size(factor_sub,1);
        factor_var(k) = sqrt(sum((factor_sub-factor_sub_mean).^2)/(size(factor_sub,1)-1));
    end

    max_factor_var = max(factor_var)
    min_factor_var = min(factor_var)

    subplot(2,3,i)
    % histfit(factor);
    [mu,sigma] = normfit(factor);
    x = mu - 3*sigma : 0.01 : mu + 3*sigma;
    histogram(factor, 'Normalization', 'pdf');
    hold on;
    plot(x, normpdf(x,mu,sigma), '--', 'linewidth',2);
    % if i ~= 1
    %     yticks([0,41,82,122,163,204,245,286])
    %     set(gca, 'yticklabel',{'0.00','0.02','0.04','0.06','0.08','0.10','0.12','0.14'});
    % else
    %     set(gca, 'yticklabel',{'0.00','0.25','0.50','0.75','1.00'});
    % end

    set(get(gca, 'XLabel'), 'String', sel_name{i});
    set(gca, 'FontSize', 22);
    subplot(2,3,i+3)
    pd = makedist('Normal','mu',mu,'sigma',sigma);
    qqplot(factor, pd);
    set(get(gca, 'XLabel'), 'String', '�����̬��λ��');
    set(gca, 'FontSize', 22);
    % ks-test
    [h,p,~,c] = kstest(factor,'CDF',pd,'Alpha',0.05);

end
print(f5,'-dpng','-r300','./image/factor_analysis.png');

SIZE = get(0,'ScreenSize');	% ��ȡ��ʾ�������سߴ�
f6 = figure(6);
set(f6, 'position', SIZE);	% ����ͼ�δ���λ�óߴ�Ϊ��Ļ��С

for i = 1:3
    factor = data(:,sel_set{i});
    % ANOVA
    anova1(factor, category, 'off');
    subplot(1,3,i)
    boxplot(factor,category,'Labels',{'���1','���2','���3','���4','���5'})
    set(get(gca, 'XLabel'), 'String', 'Ⱥ�����');
    set(get(gca, 'YLabel'), 'String', sel_name{i});
    set(gca, 'FontSize', 22)
end

print(f6,'-dpng','-r300','./image/factor_boxplot.png');

%simple  sampling

F = zeros(10,1);

for i = 1:100

    R = rand(size(arg_age));
    [~,R_index] = sort(R);
    data_random = data(R_index,:);
    data_sample = data_random(1:204,:);
    category_sample = data_sample(:,1);
    arg_age_sample = data_sample(:,6);
    [p,tbl] = anova1(arg_age_sample,category_sample,'off');

    F(i)=tbl{2,5};
end

F_mean = sum(F)/size(F,1)
F_var = sum((F - F_mean).^2) / (size(F,1))

% systematic sampling

for i = 1:100

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

F_mean = sum(F)/size(F,1)
F_var = sum((F - F_mean).^2) / (size(F,1))

%stratified random sampling

for j = 1:100
    D_set = cell(5,1);
    before = [];
    after = [];
    for i = 1:5
        tmp = data(data(:,1) == i,:);
        before(i) = sum(tmp(:,6))/size(tmp,1);
        R = rand(size(tmp));
        [~,R_index] = sort(R);
        tmp_random = tmp(R_index,:);
        D_set{i} = tmp_random(1:round(size(tmp,1)*0.1),:);
        after(i) = sum(D_set{i}(:,6))/round(size(tmp,1)*0.1);
    end
    
    data_sample = cell2mat(D_set);
    category_sample = data_sample(:,1);
    arg_age_sample = data_sample(:,6);
    [p,tbl] = anova1(arg_age_sample,category_sample,'off');
    
    F(j)=tbl{2,5};
end

F_mean = sum(F)/size(F,1)
F_var = sum((F - F_mean).^2) / (size(F,1))
    