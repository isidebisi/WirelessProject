function [rx_corrected] = phase_estimation(rx_data, conf)

% Channel estimation
switch conf.channel_estimation
    case 'none'
        rx_corrected = rx_data(:,2:end);

    case 'viterbi'
        %% Initialize plot

        % Define colors for plotting
        colors = ["#ff0000", "#ff1c00", "#ff3900", "#ff5500", "#ff7100", "#ff8e00", ...
                  "#ffaa00", "#ffc600", "#ffe300", "#ffff00"];
        colors = [colors, colors(end:-1:1)];

        % Create a figure for visualization
        figure()
        axis square
        hold on
        xline(0, "blue", "LineWidth", 2)
        yline(0, "blue", "LineWidth", 2)

        %% magnitude correction
        mag_corr = magnitude_correction(rx_data, conf);

        %% initial phase estimation

        training_phase_angle = angle(rx_data(:, conf.training_len));
        rx_init = mag_corr .* exp(-1j * repmat(training_phase_angle, 1, size(mag_corr, 2)));

        %% viterbi-viterbi algorithm

        % Initialize matrix for phase estimation
        theta = zeros(conf.nbcarriers, size(rx_init, 2) + 1);
        theta(:, 1) = angle(rx_init(:, 1));

        % Define phase angles
        ae = repmat(pi / 2 * (-1:4), conf.nbcarriers, 1);

        % Perform Viterbi-Viterbi algorithm
        for k = 1:size(mag_corr, 2)

            % Calculate delta_theta for phase estimation
            delta_theta = 1/4 * angle(-mag_corr(:, k).^4) + ae;

            % Find the index with minimum difference
            [~, idx] = min(abs(delta_theta - theta(:, k)), [], 2);

            % Update theta and apply phase correction to rx_res
            theta(:, k + 1) = mod(delta_theta(idx), 2 * pi);
            rx_corrected(:, k) = mag_corr(:, k) .* exp(-1j * theta(:, k + 1));

            % Plotting
            %plot(real(rx_res(1, k)), imag(phase_corr(1, k)), 'o', 'Color', colors(mod(k, length(colors)) + 1))
        end


    % case 'viterbi'
    %     rxdata = [];
    %     for block = 0:conf.nbtraining-1
    % 
    %         block_idx = block*(conf.nbdatapertrainning+1)+1;
    % 
    %         H_hat                       = rxsymbol(:,block_idx)./conf.trainingseq;
    %         theta_hat(:,block_idx)      = mod(angle(H_hat), 2*pi);
    % 
    %         for data_idx = block*(conf.nbdatapertrainning+1)+2:(block+1)*(conf.nbdatapertrainning+1)
    % 
    %                 deltaTheta = (1/4*angle(-rxsymbol(:, data_idx).^4) + pi/2*(-1:4));
    %                 [~, ind] = min(abs(deltaTheta - theta_hat(:, data_idx-1)),[],2);
    %                 indvec = (0:conf.nbcarriers-1).*6 + ind'; 
    %                 deltaTheta = deltaTheta';
    %                 theta = deltaTheta(indvec);
    %                 theta_hat(:, data_idx) = mod(0.01*theta' + 0.99*theta_hat(:, data_idx-1), 2*pi);
    % 
    %                 rxsymbol(:,data_idx) = rxsymbol(:,data_idx)./abs(H_hat);
    %                 rxsymbol(:,data_idx) = rxsymbol(:,data_idx) .* exp(-1i*theta_hat(:,data_idx));
    % 
    % 
    %         end
    %         rxdata = [rxdata rxsymbol(:, block*(conf.nbdatapertrainning+1)+2:(block+1)*(conf.nbdatapertrainning+1))];
    % 
    %     end
end



