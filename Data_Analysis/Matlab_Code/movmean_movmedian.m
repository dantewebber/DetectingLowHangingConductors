% Moving mean and median

% Calculate the mean of the filtered pressures
mean_pressure_s1 = mean(pressure_s1_aligned(1:100));
mean_pressure_s2 = mean(pressure_s2_aligned(1:100));
% mean_pressure_s1 = mean(pressure_s1_aligned(end-80:end));
% mean_pressure_s2 = mean(pressure_s2_aligned(end-80:end));

% Calculate the offset (Sensor 2 - Sensor 1)
if not (mean_pressure_s1 == mean_pressure_s2)
    offset = mean_pressure_s2 - mean_pressure_s1;
end

% Display the offset
fprintf('Offset between Sensor 2 and Sensor 1: %.4f mBar\n', offset);

% Adjust Sensor 2 data by subtracting the offset
pressure_s2_adjusted = pressure_s2_aligned - offset; % Unfiltered

% Define the window size for the moving average filter
window_size = 50;

% Apply a moving average filter to both datasets
pressure_s1_movmean = movmean(pressure_s1_aligned, window_size);
pressure_s2_movmean = movmean(pressure_s2_adjusted, window_size);

time_zeroed = convert_datetime_to_zeroed_time(dates_s1_aligned);

% Plot movmean
% Plot the movmean pressure data
figure;
plot(time_zeroed, pressure_s1_movmean, 'b-', 'LineWidth', 1, 'DisplayName', 'Sensor 1 Movmean Filter');
hold on;
plot(time_zeroed, pressure_s2_movmean, 'r-', 'LineWidth', 1, 'DisplayName', 'Sensor 2 Movmean Filter (Adjusted)');
hold off;
title('Moving Average Filtered Pressure Data');
xlabel('Time');
ylabel('Pressure (mBar)');
legend;
grid on;


% Filter the movmean with movmedian filter
window_size = 10;

pressure_s1_movmedian = movmedian(pressure_s1_movmean, window_size);
pressure_s2_movmedian = movmedian(pressure_s2_movmean, window_size);

% Plot the movmedian pressure data
figure;
plot(time_zeroed, pressure_s1_movmedian, 'b-', 'LineWidth', 1, 'DisplayName', 'Sensor 1 Movmedian Filter');
hold on;
plot(time_zeroed, pressure_s2_movmedian, 'r-', 'LineWidth', 1, 'DisplayName', 'Sensor 2 Movmedian Filter (Adjusted)');
hold off;
title('Moving Median Filtered Pressure Data');
xlabel('Time');
ylabel('Pressure (mBar)');
legend;
grid on;