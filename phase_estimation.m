function [rx_corrected] = phase_estimation(rx_data, conf)

% Channel estimation
switch conf.estimationtype
    case 'none'
        for block = 0:conf.nbtraining-1
            block_idx = block*conf.nbdatapertrainning+1;
            rxsymbol(:,block_idx) = []; %remove training seq
        end
        rxdata = rxsymbol;
    case 'viterbi'
        rxdata = [];
        for block = 0:conf.nbtraining-1

            block_idx = block*(conf.nbdatapertrainning+1)+1;

            H_hat                       = rxsymbol(:,block_idx)./conf.trainingseq;
            theta_hat(:,block_idx)      = mod(angle(H_hat), 2*pi);

            for data_idx = block*(conf.nbdatapertrainning+1)+2:(block+1)*(conf.nbdatapertrainning+1)

                    deltaTheta = (1/4*angle(-rxsymbol(:, data_idx).^4) + pi/2*(-1:4));
                    [~, ind] = min(abs(deltaTheta - theta_hat(:, data_idx-1)),[],2);
                    indvec = (0:conf.nbcarriers-1).*6 + ind'; 
                    deltaTheta = deltaTheta';
                    theta = deltaTheta(indvec);
                    theta_hat(:, data_idx) = mod(0.01*theta' + 0.99*theta_hat(:, data_idx-1), 2*pi);

                    rxsymbol(:,data_idx) = rxsymbol(:,data_idx)./abs(H_hat);
                    rxsymbol(:,data_idx) = rxsymbol(:,data_idx) .* exp(-1i*theta_hat(:,data_idx));


            end
            rxdata = [rxdata rxsymbol(:, block*(conf.nbdatapertrainning+1)+2:(block+1)*(conf.nbdatapertrainning+1))];
            
        end
end



