
%% Cell with initialization
clear; clc; close all; warning off;

tic
load('timed.txt');
[points, columns] = size(timed);
parameters = columns - 3;
parameter_data = timed(:,i+3:end);
parameter_data = [parameter_data, ones(size(parameter_data,1),1)];
max_order = 50;

%% Cell with single parameters evaluation

fprintf('-------------------------------------------------------\n');
fprintf('Number of parameters: %d\n', parameters);
for i = 1:parameters
    unique_values = unique(timed(:,i+3));
    fprintf('  Parameter %d has %d unique values\n', ...
      i, length(unique_values));
end
fprintf('-------------------------------------------------------\n');

for i = 1:parameters
    fprintf('Analyzing parameter %d:\n', i);
    unique_values = unique(timed(:,i+3));
    error = ones(length(unique_values), 1) * inf;
    best_order = 0;
    for j = 1:length(unique_values)
        for order = 1:max_order
            partition = timed(timed(:,i+3) == unique_values(j), :);
            parameters_without_fixed = [partition(:,4:i+2), partition(:,i+4:end)];
            fit = polyfit(parameters_without_fixed, partition(:,1), order);
            evaluation = polyval(fit, parameters_without_fixed);
            actual_error_vector = sqrt((evaluation - partition(:,1)).^2);
            actual_error = sum(actual_error_vector)/length(evaluation);
            if actual_error < error(j)
                error(j) = actual_error;
                best_order = order;
            end
        end
        fit = polyfit(parameters_without_fixed, partition(:,1), best_order);
        evaluation = polyval(fit, parameters_without_fixed);
        % plot part, comment out if you don't need
        %figure();
        %plot(1:length(evaluation), evaluation, 'ko'); hold on;
        %plot(1:length(evaluation), partition(:,1), 'r*');
        % -----
        fprintf('  Error per parameter %d (value %d) with order %d: %d\n', ...
                i, unique_values(j), best_order, error(j));
    end
    errormean = mean(error);
    fprintf('Mean error per parameter %d: %d\n', i, mean(error));
    fprintf('-------------------------------------------------------\n');
end

%% Cell with multiple parameters evaluation

[fit,fitint,residuals,residualsint,stats] = regress(timed(:,1), parameter_data);
evaluation = (fit'*parameter_data')';
global_error_vector = sqrt((evaluation - timed(:,1)).^2);
global_error = sum(global_error_vector)/length(evaluation);
fprintf('Error for multivariate linear regressione: %d\n', global_error);
disp(stats);

linear = regstats(timed(:,1), parameter_data, 'linear', {'beta','mse','r','rsquare'});
disp(linear);
interaction = regstats(timed(:,1), parameter_data, 'interaction', {'beta','mse','r','rsquare'});
disp(interaction);
quadratic = regstats(timed(:,1), parameter_data, 'quadratic', {'beta','mse','r','rsquare'});
disp(quadratic);
purequadratic = regstats(timed(:,1), parameter_data, 'purequadratic', {'beta','mse','r','rsquare'});
disp(purequadratic);

toc