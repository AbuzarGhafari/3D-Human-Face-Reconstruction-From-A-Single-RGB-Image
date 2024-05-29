function optimized_knn_error_plot()

fileNames = getDatasetFiles("results/optimization/AFLW/"); 

o_part_1 = [];
o_part_2 = [];

k_part_1 = [];
k_part_2 = [];

optimized_errors = [];
knn_errors = [];

for fileIndex = 1:numel(fileNames)
    fprintf("%d\n", fileIndex);
    load(join(["results/optimization/AFLW/" fileNames{fileIndex}], ''));
    if(fileIndex <= 1000)
        o_part_1 = [o_part_1, result.op_error];
        k_part_1 = [k_part_1, result.knn_avg_error];
    else
        o_part_2 = [o_part_2, result.op_error];
        k_part_2 = [k_part_2, result.knn_avg_error];
    end
    
end
optimized_errors = [o_part_1, o_part_2];
knn_errors = [k_part_1, k_part_2];

x_values = 1:length(optimized_errors); % This assumes both vectors are the same length

% Plotting the data
figure; % Opens a new figure window
plot(x_values, optimized_errors, '-b', 'LineWidth', 1); % Plot optimized_errors in red
hold on; % Hold on to add the second line in the same figure
plot(x_values, knn_errors, '-r', 'LineWidth', 1); % Plot knn_errors in blue
hold off;
 

% Adding labels and title
xlabel('Index');
ylabel('Error');
title('Comparison of Optimized Errors and KNN Errors');

% Adding legend
legend('Optimized Errors', 'KNN Errors');

% Optional: Grid
grid on;


end

