function rx_magnitude_correction = magnitude_correction(rx_data, conf)
%MAGNITUDE CORRECTION 
% This function performs magnitude correction of an OFDM frame for each
% subcarrier

% Training phase magnitude
training_phase = rx_data(:, 1:conf.training_len);
magnitude_training = abs(training_phase);

% Calculate the mean magnitude across subcarriers during training
mean_magnitude = mean(magnitude_training, 2);

% Extend the mean magnitude to match the signal length after training
extended_mean = repmat(mean_magnitude, 1, size(rx_data, 2) - conf.training_len);

% Extract the signal after the training phase
extracted = rx_data(:, conf.training_len + 1:end);

% Perform magnitude correction by dividing by extended mean magnitude
corrected_sig = extracted ./ extended_mean;

% Calculate the RMS value
rms_corrected = rms(corrected_sig, "all");

% divide by its RMS value
rx_magnitude_correction = corrected_sig ./ rms_corrected;
end

