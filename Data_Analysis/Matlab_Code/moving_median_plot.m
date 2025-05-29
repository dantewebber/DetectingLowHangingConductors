% Median Plot

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

% Display the offset
fprintf('Offset between Sensor 2 and Sensor 1: %.4f mBar\n', offset);

% Adjust Sensor 2 data by subtracting the offset
pressure_s2_adjusted = pressure_s2 - offset; % Unfiltered

window_size = 20;

pressure_s1_movmedian = movmedian(pressure_s1, window_size);
pressure_s2_movmedian = movmedian(pressure_s2_adjusted, window_size);

% Zero the pressure dates
dates_s2 = dates_s2 - (dates_s2(1) - dates_s1(1));

% Plot the movmedian pressure data
figure;
plot(dates_s1, pressure_s1_movmedian, 'b-', 'LineWidth', 1, 'DisplayName', 'Sensor 1 Movmedian Filter');
hold on;
plot(dates_s2, pressure_s2_movmedian, 'r-', 'LineWidth', 1, 'DisplayName', 'Sensor 2 Movmedian Filter (Adjusted)');
hold off;
title('Moving Median Filtered Pressure Data');



