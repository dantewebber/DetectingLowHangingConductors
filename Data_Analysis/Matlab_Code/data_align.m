% Data Alignment

% Ensure original data are column vectors for consistency
dates_s1_orig = dates_s1(:);
pressure_s1_orig = pressure_s1(:);
dates_s2_orig = dates_s2(:);
pressure_s2_orig = pressure_s2(:);

t_start_s1 = dates_s1_orig(1);
t_start_s2 = dates_s2_orig(1);
time_diff = t_start_s2 - t_start_s1; % Positive if s2 starts after s1
sample_shift = int32(seconds(round(time_diff/0.1)));
fprintf('Sample Shift = %d\n', sample_shift);

if (sample_shift < 0)
    % Sensor 2 started before sensor 1
    % Truncate start of s2 data
    pressure_s2_aligned = pressure_s2_orig(abs(sample_shift)+1:end);
    dates_s2_aligned = dates_s2_orig(abs(sample_shift)+1:end);
    % Truncate end of s1
    pressure_s1_aligned = pressure_s1_orig(1:length(pressure_s2_aligned));
    dates_s1_aligned = dates_s1_orig(1:length(dates_s2_aligned));
elseif (sample_shift > 0)
    % Sensor 1 started before sensor 2
    % Truncate start of s1 data
    pressure_s1_aligned = pressure_s1_orig(abs(sample_shift)+1:end);
    dates_s1_aligned = dates_s1_orig(abs(sample_shift)+1:end);
    % Truncate end of s2
    pressure_s2_aligned = pressure_s2_orig(1:length(pressure_s1_aligned));
    dates_s2_aligned = dates_s2_orig(1:length(dates_s1_aligned));
else
    % Sensor data already aligned so just ensure that the arrays are the
    % same size.
    if (length(pressure_s1_orig) > length(pressure_s2_orig))
        % Truncate end of pressure_s1_orig
        pressure_s1_aligned = pressure_s1_orig(1:length(pressure_s2_orig));
        dates_s1_aligned = dates_s1_orig(1:length(dates_s2_orig));
        pressure_s2_aligned = pressure_s2_orig;
        dates_s2_aligned = dates_s2_orig;
    elseif (length(pressure_s1_orig) < length(pressure_s2_orig))
        % Truncate end of pressure_s2_orig
        pressure_s2_aligned = pressure_s2_orig(1:length(pressure_s1_orig));
        dates_s2_aligned = dates_s2_orig(1:length(dates_s1_orig));
        pressure_s1_aligned = pressure_s1_orig;
        dates_s1_aligned = dates_s1_orig;
    end
end
