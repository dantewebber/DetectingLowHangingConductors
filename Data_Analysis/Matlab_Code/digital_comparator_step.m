% ALTER THE CODE BELOW TO CALCULATE, DISPLAY, AND PLOT BOTH THE MEDIAN AND
% THE AVERAGE (NOT JUST THE MEDIAN)

% Calculate difference
pressure_diff_movmean = pressure_s2_movmean - pressure_s1_movmean;

% Calculate expected change in pressure
mBar_per_m = (1013.25-1007.26)/50;
step_height = 0.36; %[m]
step_height_mBar = mBar_per_m * step_height;
fprintf('Expected pressure difference from physical step = %.4f mBar\n', step_height_mBar);

% --- Analysis of the stepped pressure ---
% Slice window of step:
% Ensure 1:188 is a valid index range for your data, or adjust as needed.
% This example assumes dates_s1 corresponds to pressure_diff_movmean.
end_index = min(188, length(pressure_diff_movmean)); % Prevent out-of-bounds error
cropped_data = pressure_diff_movmean(1:end_index);
% Ensure dates_s1 has at least end_index elements if it's a common time vector
if length(dates_s1) < end_index
    error('dates_s1 does not have enough elements for the chosen end_index.');
end
cropped_data_time = dates_s1(1:end_index);

% Plot cropped data:
figure;
plot(cropped_data_time, cropped_data, 'b-', 'LineWidth', 1, 'DisplayName', 'Original Movmean Pressure Difference');
title('Original Movmean Filtered Pressure Difference in Cropped Window');
xlabel('Time / Index');
ylabel('Pressure Difference (mBar)');
grid on;
legend show;

% Define the cutoff for identifying the step based on expected change
% This cutoff helps isolate the data points that are considered part of the step.
pressure_step_cutoff = step_height_mBar/2;
fprintf('Pressure step cutoff (expected_diff/2) = %.4f mBar\n', pressure_step_cutoff);

% Collect values that are part of the step
step_values = [];
for i = 1:length(cropped_data)
    if cropped_data(i) > pressure_step_cutoff
        step_values = [step_values, cropped_data(i)]; %#ok<AGROW>
    end
end

% Calculate median, average, and standard deviation of the identified step values
if ~isempty(step_values)
    median_step_pressure = median(step_values);
    average_step_pressure = mean(step_values);
    std_dev_step_pressure = std(step_values);
else
    median_step_pressure = 0; % Handle case where no values exceed cutoff
    average_step_pressure = 0;
    std_dev_step_pressure = 0;
    warning('No data points found above the pressure step cutoff. Median, Average, and Std Dev set to 0.');
end

% Display calculated statistics
fprintf('Median pressure difference of detected step = %.4f mBar\n', median_step_pressure);
fprintf('Average pressure difference of detected step = %.4f mBar\n', average_step_pressure);
fprintf('Standard deviation of detected step pressure values = %.4f mBar\n', std_dev_step_pressure);

% Create a processed data array where step values are replaced by the MEDIAN
% This demonstrates one way to "correct" or "represent" the step.
processed_cropped_data_median_based = zeros(size(cropped_data)); % Initialize with zeros
for i = 1:length(cropped_data)
    if cropped_data(i) > pressure_step_cutoff
        processed_cropped_data_median_based(i) = median_step_pressure;
    else
        % Values not part of the step are set to 0 in this processed version.
        % Alternatively, they could be kept as original: cropped_data(i)
        processed_cropped_data_median_based(i) = 0;
    end
end

% --- Plotting the results ---
figure;
hold on;

% Plot the original data within the cropped window for reference
plot(cropped_data_time, cropped_data, 'c--', 'LineWidth', 1, 'DisplayName', 'Original Data in Window');

% Plot the data processed using the median
% This shows the step portion flattened to the median value, and non-step parts as 0.
plot(cropped_data_time, processed_cropped_data_median_based, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Processed Step (Median-based)');

% Get current x-axis limits for drawing full-width lines, or use specific time range
plot_xlim = [cropped_data_time(1), cropped_data_time(end)];

% Plot a horizontal line for the MEDIAN of the step values
line(plot_xlim, [median_step_pressure, median_step_pressure], ...
    'Color', 'r', 'LineStyle', '-.', 'LineWidth', 2, ...
    'DisplayName', sprintf('Median of Step (%.2f mBar)', median_step_pressure));

% Plot a horizontal line for the AVERAGE of the step values
line(plot_xlim, [average_step_pressure, average_step_pressure], ...
    'Color', 'g', 'LineStyle', ':', 'LineWidth', 2, ...
    'DisplayName', sprintf('Average of Step (%.2f mBar)', average_step_pressure));

hold off;
title('Step Analysis: Original, Processed (Median), Average & Median Lines');
xlabel('Time / Index');
ylabel('Pressure Difference (mBar)');
legend show;
grid on;
ylim_current = ylim; % Get current y-limits
ylim_padding = (ylim_current(2) - ylim_current(1)) * 0.1; % Add 10% padding
ylim([ylim_current(1) - ylim_padding, ylim_current(2) + ylim_padding]); % Adjust y-limits for better visibility of lines