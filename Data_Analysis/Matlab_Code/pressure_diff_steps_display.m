% Find pressure steps

[step_means, step_indices, step_durations] = detect_pressure_steps(pressure_diff);

% Display results
fprintf('Detected %d pressure steps\n', length(step_means));
for i = 1:length(step_means)
    fprintf('Step %d: %.2f mBar (samples %d to %d, duration %d)\n', ...
        i, step_means(i), step_indices(i,1), step_indices(i,2), step_durations(i));
end

time_zeroed = convert_datetime_to_zeroed_time(dates_s1_aligned);

% Visualize the detected steps
figure;
plot(time_zeroed, pressure_diff, 'LineWidth', 1, 'Color', [0.7 0.7 0.7]);
hold on;

colors = jet(length(step_means));
for i = 1:length(step_means)
    x_range = step_indices(i,1):step_indices(i,2);
    plot(time_zeroed(x_range), pressure_diff(x_range), 'LineWidth', 2, 'Color', colors(i,:), ...
        'DisplayName', sprintf('Step %.2f mBar', step_means(i)));
    
    % Add text label for each step
    text(mean(x_range), step_means(i), sprintf('%.2f mBar', step_means(i)), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'FontWeight', 'bold', 'BackgroundColor', [1 1 1 0.7]);
end

title('Detected Pressure Steps');
xlabel('Time (s)');
ylabel('Pressure Difference (mBar)');
grid on;
legend show;

% Optional: Create a more refined plot showing just the step means
figure;
plot(time_zeroed, pressure_diff, 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
hold on;

% Create a step visualization
step_visualization = zeros(size(pressure_diff));
for i = 1:length(step_means)
    step_visualization(step_indices(i,1):step_indices(i,2)) = step_means(i);
end

% Plot only the non-zero values (the steps)
non_zero = step_visualization ~= 0;
plot(time_zeroed(non_zero), step_visualization(non_zero), 'r-', 'LineWidth', 2, ...
    'DisplayName', 'Detected Step Means');

title('Step Mean Values');
xlabel('Time');
ylabel('Pressure Difference (mBar)');
grid on;
legend show;