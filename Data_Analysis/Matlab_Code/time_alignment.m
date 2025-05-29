% --- START OF TIME ALIGNMENT CODE ---

% Ensure original data are column vectors for consistency
dates_s1_orig = dates_s1(:);
pressure_s1_orig = pressure_s1(:); % Assuming single column pressure data
dates_s2_orig = dates_s2(:);
pressure_s2_orig = pressure_s2(:); % Assuming single column pressure data

% Initialize aligned variables with original s2 data
pressure_s2_aligned = pressure_s2_orig;
dates_s2_aligned = dates_s2_orig;

% Handle edge cases: empty inputs or insufficient data for interval calculation
if isempty(dates_s1_orig) || isempty(dates_s2_orig)
    warning('One or both date series are empty. Skipping time alignment.');
    % If you want the script to stop or handle this differently, modify here.
    % For now, it will proceed with original/empty s2 data.
elseif length(dates_s2_orig) < 2 && length(dates_s1_orig) >= 2 && (dates_s1_orig(1) ~= dates_s2_orig(1))
    warning('Sensor 2 has only one data point and start times differ. Precise interval-based alignment is not possible. Consider resampling or manual placement if critical.');
    % Basic alignment if s2 is a single point:
    % If s1 starts earlier, s2 is effectively "later". If s2 starts earlier, it's "before".
    % This simplified logic doesn't create padding based on interval but could place the single point.
    % For this solution, we require dates_s2_orig to have >=2 points if shifting is needed.
    if (dates_s1_orig(1) ~= dates_s2_orig(1))
        error('Sensor 2 needs at least two data points to determine sampling interval for shifting when start times differ.');
    end
elseif length(dates_s1_orig) < 2 && length(dates_s2_orig) >=2 && (dates_s1_orig(1) ~= dates_s2_orig(1))
    error('Sensor 1 needs at least two data points to determine its timeline if start times differ and alignment is required.');
elseif length(dates_s1_orig) < 2 && length(dates_s2_orig) < 2 && (dates_s1_orig(1) ~= dates_s2_orig(1))
    error('Both sensors have insufficient data points for interval-based alignment when start times differ.');
end


% Proceed with alignment if inputs are sufficient
if ~isempty(dates_s1_orig) && ~isempty(dates_s2_orig)
    t_start_s1 = dates_s1_orig(1);
    t_start_s2 = dates_s2_orig(1);

    % Determine sampling interval for s2. Critical for num_points calculation.
    % This assumes a reasonably constant sampling rate for s2.
    sample_interval_s2 = NaT; % Initialize as Not-a-Time
    if length(dates_s2_orig) >= 2
        sample_interval_s2 = dates_s2_orig(2) - dates_s2_orig(1);
    elseif length(dates_s2_orig) == 1 && length(dates_s1_orig) >=2
        % If s2 has 1 point, but s1 has more, we might use s1's interval
        % for constructing the aligned date vector if s2 needs "padding" around it.
        % However, calculating num_points_to_pad/remove based on s2's interval is not possible.
        % This case is complex for "pad/truncate elements" logic.
        % The error checks above should catch most problematic scenarios.
        % If code reaches here and length(dates_s2_orig) == 1 and t_start_s1 == t_start_s2, no action is needed.
    end

    time_diff = t_start_s2 - t_start_s1; % Positive if s2 starts after s1

    % Define a small tolerance for comparing times (e.g., 1 microsecond)
    % Durations can be compared directly to seconds(0)
    epsilon_duration = seconds(0.000001);

    if time_diff > epsilon_duration % s1 started before s2 (s2 needs left-padding)
        if isnat(sample_interval_s2)
             error('Cannot determine sampling interval for s2 to calculate padding.');
        end
        fprintf('Sensor 1 starts before Sensor 2. Padding beginning of Sensor 2 data.\n');
        num_points_to_pad_start = round(seconds(time_diff) / seconds(sample_interval_s2));

        if num_points_to_pad_start > 0
            pressure_s2_aligned = [NaN(num_points_to_pad_start, size(pressure_s2_orig, 2)); pressure_s2_orig];
            
            % Create new timestamps for dates_s2_aligned
            % It starts at t_start_s1 and uses s2's original interval
            idx_vector = (0 : length(pressure_s2_aligned)-1)';
            dates_s2_aligned = t_start_s1 + idx_vector * sample_interval_s2;
        end
        % Length of s2 increases. No specific instruction to match s1 length here.

    elseif time_diff < -epsilon_duration % s2 started before s1 (s2 needs left-truncation and possibly right-padding)
        % if isnat(sample_interval_s2)
        %      error('Cannot determine sampling interval for s2 to
        %      calculate truncation.');
        % end
        fprintf('Sensor 2 starts before Sensor 1. Truncating beginning of Sensor 2 data.\n');
        time_to_remove_from_s2_start = abs(time_diff);
        num_points_to_remove_start = round(seconds(time_to_remove_from_s2_start) / seconds(sample_interval_s2));

        if num_points_to_remove_start >= length(pressure_s2_orig)
            warning('All Sensor 2 data occurs before Sensor 1. Resulting Sensor 2 pressure will be all NaNs, matching Sensor 1 length.');
            pressure_s2_aligned = NaN(size(pressure_s1_orig));
            % The dates for these NaNs should align with dates_s1.
            % We can use dates_s1 directly, or construct a similar one.
            % If sample_interval_s2 is known, construct dates starting at t_start_s1.
            % If sample_interval_s2 was not determinable (e.g. s2 had 1 point), use s1's interval.
            ref_interval = sample_interval_s2;
            if isnat(ref_interval) && length(dates_s1_orig) >=2
                ref_interval = dates_s1_orig(2) - dates_s1_orig(1);
            elseif isnat(ref_interval)
                 error('Cannot determine an interval to construct aligned dates for Sensor 2.');
            end
            idx_vector = (0 : length(pressure_s1_orig)-1)';
            dates_s2_aligned = t_start_s1 + idx_vector * ref_interval;

        else
            pressure_s2_aligned = pressure_s2_orig(num_points_to_remove_start + 1 : end, :);
            dates_s2_aligned = dates_s2_orig(num_points_to_remove_start + 1 : end);

            % "pad the end" to match pressure_s1's length
            len_s1 = length(pressure_s1_orig);
            len_s2_adj = length(pressure_s2_aligned);

            if len_s2_adj < len_s1
                fprintf('Sensor 2 data (after truncation) is shorter than Sensor 1. Padding end of Sensor 2 data.\n');
                num_points_to_pad_end = len_s1 - len_s2_adj;
                pressure_s2_aligned = [pressure_s2_aligned; NaN(num_points_to_pad_end, size(pressure_s2_aligned, 2))];
                
                % Extend dates_s2_aligned
                if ~isempty(dates_s2_aligned) % Should be true here
                    last_time_s2 = dates_s2_aligned(end);
                    idx_vector_end_pad = (1 : num_points_to_pad_end)';
                    additional_dates = last_time_s2 + idx_vector_end_pad * sample_interval_s2;
                    dates_s2_aligned = [dates_s2_aligned; additional_dates];
                else
                    % This case should ideally not be reached if num_points_to_remove_start < length(pressure_s2_orig)
                    % If it were, construct all dates from t_start_s1 for len_s1 points
                    idx_vector = (0 : len_s1-1)';
                    dates_s2_aligned = t_start_s1 + idx_vector * sample_interval_s2;
                end
            elseif len_s2_adj > len_s1
                 % Optional: Truncate s2 if it's now longer than s1 and you want exact length match
                 fprintf('Sensor 2 data (after truncation) is longer than Sensor 1. Truncating end of Sensor 2 to match Sensor 1 length.\n');
                 pressure_s2_aligned = pressure_s2_aligned(1:len_s1, :);
                 dates_s2_aligned = dates_s2_aligned(1:len_s1);
            end
        end
    else
        fprintf('Start times of Sensor 1 and Sensor 2 are effectively the same. No start-time shift applied.\n');
        % If start times are same, but lengths differ, and you want s2 to match s1 length:
        len_s1 = length(pressure_s1_orig);
        len_s2_curr = length(pressure_s2_aligned);
        if len_s2_curr < len_s1
            fprintf('Sensor 2 data is shorter than Sensor 1. Padding end of Sensor 2 data.\n');
            if isnat(sample_interval_s2) && length(dates_s2_orig) == 1 % s2 is a single point
                 % Cannot determine interval to pad dates. Use s1's if available or error.
                 if length(dates_s1_orig) >= 2
                     sample_interval_s2 = dates_s1_orig(2) - dates_s1_orig(1);
                 else
                     error('Cannot determine sampling interval for extending Sensor 2 dates.');
                 end
            elseif isnat(sample_interval_s2)
                 error('Cannot determine sampling interval for extending Sensor 2 dates.');
            end
            num_points_to_pad_end = len_s1 - len_s2_curr;
            pressure_s2_aligned = [pressure_s2_aligned; NaN(num_points_to_pad_end, size(pressure_s2_aligned,2))];
            last_time_s2 = dates_s2_aligned(end); % Could be the single point if length was 1
            idx_vector_end_pad = (1 : num_points_to_pad_end)';
            additional_dates = last_time_s2 + idx_vector_end_pad * sample_interval_s2;
            dates_s2_aligned = [dates_s2_aligned; additional_dates];
        elseif len_s2_curr > len_s1
            fprintf('Sensor 2 data is longer than Sensor 1. Truncating end of Sensor 2 data.\n');
            pressure_s2_aligned = pressure_s2_aligned(1:len_s1, :);
            dates_s2_aligned = dates_s2_aligned(1:len_s1);
        end
    end
    
    % Ensure final aligned dates are column vector if original was, for consistency
    if isrow(dates_s2_orig) && iscolumn(dates_s2_aligned)
        dates_s2_aligned = dates_s2_aligned.';
    elseif iscolumn(dates_s2_orig) && isrow(dates_s2_aligned)
        dates_s2_aligned = dates_s2_aligned.';
    end
else
    % This block is reached if inputs were empty or had issues not caught by initial errors
    % The original pressure_s2_aligned and dates_s2_aligned will be used.
    warning('Time alignment skipped due to input data issues. Using original Sensor 2 data.');
end

% --- END OF TIME ALIGNMENT CODE ---

% Now, you should use 'pressure_s2_aligned' and 'dates_s2_aligned' 
% in place of 'pressure_s2' and 'dates_s2' in your subsequent code.

% FOR EXAMPLE, YOUR EXISTING CODE MODIFIED:

% Moving mean and median
% Calculate the mean of the filtered pressures
% Ensure consistent lengths for end-window calculation if they might differ
len1_for_mean = min(10, length(pressure_s1_orig));
len2_for_mean = min(10, length(pressure_s2_aligned)); % Use aligned data

mean_pressure_s1 = mean(pressure_s1_orig(end-len1_for_mean+1:end));

% Check if pressure_s2_aligned is empty or too short
if isempty(pressure_s2_aligned) || length(pressure_s2_aligned) < len2_for_mean || len2_for_mean == 0
    warning('Aligned Sensor 2 data is too short or empty for offset calculation. Skipping offset.');
    offset = 0; % Default offset to 0 or handle as error
    pressure_s2_adjusted_offset = pressure_s2_aligned; % No offset adjustment
else
    mean_pressure_s2 = mean(pressure_s2_aligned(end-len2_for_mean+1:end));
    offset = 0; % Default offset
    if not (mean_pressure_s1 == mean_pressure_s2)
        offset = mean_pressure_s2 - mean_pressure_s1;
    end
    % Display the offset
    fprintf('Offset between Sensor 2 (aligned) and Sensor 1: %.4f mBar\n', offset);
    % Adjust Sensor 2 data by subtracting the offset
    pressure_s2_adjusted_offset = pressure_s2_aligned - offset; % Use aligned data
end


% Define the window size for the moving average filter
window_size_mean = 20; % Renamed to avoid conflict if you have another window_size

% Apply a moving average filter to both datasets
pressure_s1_movmean = movmean(pressure_s1_orig, window_size_mean);
if ~isempty(pressure_s2_adjusted_offset)
    pressure_s2_movmean = movmean(pressure_s2_adjusted_offset, window_size_mean); % Use aligned and offset-adjusted data
else
    pressure_s2_movmean = []; % or NaN(size(pressure_s1_orig)) depending on plot needs
end

% Plot movmean
% Plot the movmean pressure data
figure;
plot(dates_s1_orig, pressure_s1_movmean, 'b-', 'LineWidth', 1, 'DisplayName', 'Sensor 1 Movmean Filter');
hold on;
if ~isempty(pressure_s2_movmean)
    plot(dates_s2_aligned, pressure_s2_movmean, 'r-', 'LineWidth', 1, 'DisplayName', 'Sensor 2 Movmean Filter (Aligned & Adjusted)'); % Use aligned dates
end
hold off;
title('Moving Average Filtered Pressure Data');
legend;
xlabel('Datetime');
ylabel('Pressure (mBar)');

% Filter the movmean with movmedian filter
window_size_median = 10; % Renamed
pressure_s1_movmedian = movmedian(pressure_s1_movmean, window_size_median);
if ~isempty(pressure_s2_movmean)
    pressure_s2_movmedian = movmedian(pressure_s2_movmean, window_size_median); % Use data from previous step
else
    pressure_s2_movmedian = [];
end

% Plot the movmedian pressure data
figure;
plot(dates_s1_orig, pressure_s1_movmedian, 'b-', 'LineWidth', 1, 'DisplayName', 'Sensor 1 Movmedian Filter');
hold on;
if ~isempty(pressure_s2_movmedian)
    plot(dates_s2_aligned, pressure_s2_movmedian, 'r-', 'LineWidth', 1, 'DisplayName', 'Sensor 2 Movmedian Filter (Aligned & Adjusted)'); % Use aligned dates
end
hold off;
title('Moving Median Filtered Pressure Data');
legend;
xlabel('Datetime');
ylabel('Pressure (mBar)');

fprintf('Note: Subsequent processing uses time-aligned Sensor 2 data.\n');