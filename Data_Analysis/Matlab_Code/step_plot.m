% Step Plot
% Extract the date and pressure data from both sensors
dates_s1 = s1_pressure_data.Date; % Date column from sensor 1
pressure_s1 = s1_pressure_data.Pressure_mBar_; % Pressure column from sensor 1

dates_s2 = s2_pressure_data.Date; % Date column from sensor 2
pressure_s2 = s2_pressure_data.Pressure_mBar_; % Pressure column from sensor 2

% Calculate the mean of the filtered pressures
mean_pressure_s1 = mean(pressure_s1(end-10:end));
mean_pressure_s2 = mean(pressure_s2(end-10:end));

% Calculate the offset (Sensor 2 - Sensor 1)
if not (mean_pressure_s1 == mean_pressure_s2)
    offset = mean_pressure_s2 - mean_pressure_s1;
end
% offset = 0;

% Display the offset
fprintf('Offset between Sensor 2 and Sensor 1: %.4f mBar\n', offset);

% Adjust Sensor 2 data by subtracting the offset
pressure_s2_adjusted = pressure_s2 - offset; % Unfiltered

% Define the window size for the moving average filter
window_size = 20;

% Apply a moving average filter to both datasets
pressure_s1_movmean = movmean(pressure_s1, window_size);
pressure_s2_movmean = movmean(pressure_s2_adjusted, window_size);

% Zero the pressure dates
dates_s2 = dates_s2 - (dates_s2(1) - dates_s1(1));

% Plot the unfiltered data after adjustment
figure;
% Plot unfiltered Sensor 1 (unchanged)
plot(dates_s1, pressure_s1, 'b-', 'LineWidth', 1, 'DisplayName', 'Sensor 1 Unfiltered');
hold on;
% Plot adjusted unfiltered Sensor 2
plot(dates_s2, pressure_s2_adjusted, 'r-', 'LineWidth', 1, 'DisplayName', 'Sensor 2 Unfiltered (Adjusted)');
hold off;

% Compute and plot the pressure difference
pressure_diff = pressure_s2 - pressure_s1;

% Plot the unfiltered data subtracted from each other
figure;
% Plot unfiltered Sensor 1 (unchanged)
plot(dates_s1, pressure_diff, 'b-', 'LineWidth', 1, 'DisplayName', 'Unfiltered Pressure Difference');
title('Unfiltered Pressure Difference');

% Plot the movmean pressure data
figure;
plot(dates_s1, pressure_s1_movmean, 'b-', 'LineWidth', 1, 'DisplayName', 'Sensor 1 Movmean Filter');
hold on;
plot(dates_s2, pressure_s2_movmean, 'r-', 'LineWidth', 1, 'DisplayName', 'Sensor 2 Movmean Filter (Adjusted)');
hold off;
title('Moving Average Filtered Pressure Data');

% Compute and plot the pressure difference of movmean filtered pressure
pressure_diff_movmean = pressure_s2_movmean - pressure_s1_movmean;

% Plot the movmean data subtracted from each other
figure;
plot(dates_s1, pressure_diff_movmean, 'b-', 'LineWidth', 1, 'DisplayName', 'Movmean Pressure Difference');
title('Movmean Filtered Pressure Difference');

% Calculate expected change in pressure
mBar_per_m = (1013.25-1007.26)/50;
step_height = 0.36; %[m]
step_height_mBar = mBar_per_m * step_height;
fprintf('Expected pressure difference from step = %.4f mBar\n', step_height_mBar);

% Calculate average of stepped pressure (average of the pressure
% difference when the one device has been stepped)

% Slice window of step:
cropped_data = pressure_diff_movmean(1:188);
cropped_data_time = dates_s1(1:188);

% Plot cropped data:
figure;
plot(cropped_data_time, cropped_data, 'b-', 'LineWidth', 1, 'DisplayName', 'Movmean Pressure Difference');
title('Movmean Filtered Pressure Difference');

% Calculate average of everything above pressure_step/2
pressure_step_cutoff = step_height_mBar/2;
sum_values = 0;
count = 0;

for i = 1:length(cropped_data)
    if cropped_data(i) > pressure_step_cutoff
        sum_values = sum_values + cropped_data(i);
        count = count + 1;
    end
end

if count > 0
    average = sum_values / count;
else
    average = 0; % Handle case where no values exceed cutoff
end

fprintf('Average pressure difference of step = %.4f mBar\n', average);

for i = 1:length(cropped_data)
    if cropped_data(i) > pressure_step_cutoff
        cropped_data(i) = average;
    else 
        cropped_data(i) = 0;
    end
end

% Plot corrected step
figure;
plot(cropped_data_time, cropped_data, 'b-', 'LineWidth', 1, 'DisplayName', 'Movmean Pressure Difference');
title('Movmean Filtered Pressure Difference');

% TRY SOMETHING LIKE A MOVING MEDIAN FILTER HERE (TO REMOVE OUTLIERS) AND
% SEE IF THE PRESSURE DIFFERENCE IS CLOSER TO THE EXPECTED VALUE