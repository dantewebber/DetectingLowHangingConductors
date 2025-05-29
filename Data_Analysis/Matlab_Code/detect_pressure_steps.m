% % Pressure Step Identifier
% 
% function step_means = detect_pressure_steps(pressure_diff, time_vector)
% % detect_pressure_steps Detects steps in pressure difference data and computes mean values.
% %
% % Args:
% %   pressure_diff (array): Numerical array of pressure differences (e.g., from pressure_s2 - pressure_s1).
% %   time_vector (array, optional): Numerical array representing time or sample indices.
% %       If provided, must match length of pressure_diff. Defaults to sample indices.
% %
% % Returns:
% %   step_means (array): Mean pressure values (in mBar) for each detected step.
% %
% % Description:
% %   A step is detected when the pressure difference exceeds the maximum standard
% %   deviation of the first 500 samples. The function identifies step boundaries,
% %   computes the mean pressure for each step, and returns these means.
% %
% % Example Usage:
% %   % Sample data
% %   N = 2000;
% %   pressure_diff = [zeros(500,1); 10*ones(500,1); -5*ones(500,1); 15*ones(500,1)];
% %   time_vector = (0:0.1:(N-1)*0.1)';
% %   step_means = detect_pressure_steps(pressure_diff, time_vector);
% %   disp('Mean values of detected steps (mBar):');
% %   disp(step_means);
% 
% % --- Input Validation ---
% if ~isnumeric(pressure_diff) || ~isvector(pressure_diff)
%     error('pressure_diff must be a numeric vector.');
% end
% 
% % if nargin < 2 || isempty(time_vector)
% %     time_vector = 1:length(pressure_diff);
% % else
% %     if ~isnumeric(time_vector) || ~isvector(time_vector)
% %         error('time_vector must be a numeric vector.');
% %     end
% %     if length(time_vector) ~= length(pressure_diff)
% %         error('time_vector must match the length of pressure_diff.');
% %     end
% % end
% 
% % --- Step Detection Parameters ---
% baseline_samples = min(500, length(pressure_diff)); % Use first 500 samples or all if fewer
% baseline_data = pressure_diff(1:baseline_samples);
% baseline_std = std(baseline_data);
% baseline_max = max(baseline_data);
% baseline_mean = mean(baseline_data);
% threshold = baseline_std; % Step occurs when difference exceeds this
% 
% fprintf("Standard Deviation = %f.4\n", baseline_std);
% fprintf("Baseline Max = %f.4\n", baseline_max);
% 
% threshold_exceeded = false;
% 
% % --- Detect Steps ---
% step_indices = [];
% for i = 2:length(pressure_diff)
%     % Check if the absolute value of the diff exceeds the threshold
%     if (abs(pressure_diff(i)) > baseline_max*2) && (threshold_exceeded == false)
%         step_indices = [step_indices, i];
%         threshold_exceeded = true;
%     end
%     if (abs(pressure_diff(i)) < baseline_max*2) && threshold_exceeded
%         step_indices = [step_indices, i];
%         threshold_exceeded = false;
%     end
% end
% 
% % Include start and end for complete step segments
% step_indices = [1, step_indices, length(pressure_diff) + 1];
% 
% % --- Compute Mean of Each Step ---
% step_means = [];
% for i = 1:(length(step_indices) - 1)
%     start_idx = step_indices(i);
%     end_idx = step_indices(i+1) - 1;
%     if end_idx >= start_idx
%         step_data = pressure_diff(start_idx:end_idx);
%         step_mean = mean(step_data);
%         step_means = [step_means; step_mean];
%     end
% end
% 
% % --- Optional: Display Results ---
% % fprintf('Detected %d steps.\n', length(step_means));
% % for i = 1:length(step_means)
% %     fprintf('Step %d: Mean = %.2f mBar\n', i, step_means(i));
% % end
% 
% % --- Optional: Plot for Visualization ---
% figure;
% plot(time_vector, pressure_diff, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Pressure Difference');
% hold on;
% for i = 1:length(step_means)
%     start_idx = step_indices(i);
%     end_idx = step_indices(i+1) - 1;
%     if end_idx >= start_idx
%         plot(time_vector(start_idx:end_idx), repmat(step_means(i), 1, end_idx - start_idx + 1), ...
%              'r--', 'LineWidth', 2, 'DisplayName', sprintf('Step %d Mean', i));
%     end
% end
% xlabel('Time or Sample Index');
% ylabel('Pressure Difference (mBar)');
% title('Detected Steps in Pressure Difference');
% grid on;
% legend('show');
% hold off;
% 
% end
function [step_means, step_indices, step_durations] = detect_pressure_steps(pressure_diff)
% FIND_PRESSURE_STEPS Detects steps in pressure difference data and calculates
% the mean value for each step.
%
% This function analyzes pressure difference data to identify step changes
% based on deviations from the baseline established by the first 500 samples.
% It returns the mean value of each detected step in mBar.
%
% Args:
%   pressure_diff (array): Numerical array of pressure difference readings
%
% Returns:
%   step_means (array): Mean pressure value for each detected step (mBar)
%   step_indices (array): Starting and ending indices for each step [start, end]
%   step_durations (array): Duration of each detected step in number of samples
%
% Example Usage:
%   [step_means, step_indices, step_durations] = find_pressure_steps(pressure_diff);
%   disp('Detected steps (mBar):');
%   disp(step_means);

% Input validation
if ~isnumeric(pressure_diff) || ~isvector(pressure_diff)
    error('pressure_diff must be a numeric vector.');
end

% Ensure pressure_diff is a column vector
pressure_diff = pressure_diff(:);

% Parameters
n_baseline = min(500, length(pressure_diff)); % Use first 500 samples (or all if fewer)
min_step_duration = 50; % Minimum number of samples to consider a stable step

% Calculate baseline statistics from first 500 samples
baseline_mean = mean(pressure_diff(1:n_baseline));
baseline_std = std(pressure_diff(1:n_baseline));
fprintf('Baseline Standard Deviation = %f\n', baseline_std);

% Define threshold for step detection (multiple of standard deviation)
std_multiplier = 4; % Adjust this for sensitivity
threshold = std_multiplier * baseline_std;
% threshold = 0.013865;
fprintf('Threshold (%d * baseline_std) = %f\n', std_multiplier, threshold);

% Initialize variables
in_step = false;
step_start = 1;
step_count = 0;
step_means = [];
step_indices = [];
step_durations = [];

% Process the data
for i = 1:length(pressure_diff)
    % Check if we're outside the threshold
    is_step = abs(pressure_diff(i) - baseline_mean) > threshold;
    
    % Transition into a step
    if ~in_step && is_step
        in_step = true;
        step_start = i;
    % Transition out of a step
    elseif in_step && ~is_step
        in_step = false;
        step_end = i - 1;
        step_duration = step_end - step_start + 1;
        
        % Only count it as a step if it lasts long enough
        if step_duration >= min_step_duration
            step_count = step_count + 1;
            step_means(step_count) = mean(pressure_diff(step_start:step_end));
            step_indices(step_count, :) = [step_start, step_end];
            step_durations(step_count) = step_duration;
        end
    end
end

% Check if we ended while still in a step
if in_step
    step_end = length(pressure_diff);
    step_duration = step_end - step_start + 1;
    
    % Only count it as a step if it lasts long enough
    if step_duration >= min_step_duration
        step_count = step_count + 1;
        step_means(step_count) = mean(pressure_diff(step_start:step_end));
        step_indices(step_count, :) = [step_start, step_end];
        step_durations(step_count) = step_duration;
    end
end

% If no steps were detected
if step_count == 0
    warning('No pressure steps detected. Consider adjusting the threshold multiplier.');
end

% Convert step_means to row vector for consistency
step_means = step_means(:)';
end