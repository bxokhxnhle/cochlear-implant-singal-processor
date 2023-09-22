phase2("Dog Barking.mp3", 24)

function phase2(sample_audio, N)

    % Code from phase 1 - Task 3
    % Reading audio and obtaining sampling rate 
    [original_signal,Fs] = audioread(sample_audio);
    
    % Obtaining size of signal and converting to mono if stereo 
    if size(original_signal, 2) == 2
        mono_signal = original_signal(:, 1) + original_signal(:, 2);
    end 

    % Resampling if sampling rate is not equal to 16kHz
    desiredFs = 16000;
    if Fs ~= desiredFs
        [p,q] = rat(desiredFs/Fs);
        resampled_signal = resample(mono_signal, p, q);
    end

    period = 1/desiredFs;
    duration = size(resampled_signal, 1)/desiredFs;
    t1 = 0:period:duration;
%     
    % Plot waveform vs sample number 
    figure(1)
    %plot(resampled_signal);
%     xlabel('Samples') 
%     ylabel('Signal')
%     title('Resampled Signal versus Sample Number')

    % Task 4 - Filter Design
    
    % Set passband frequencies in mel
    melsLower = hz2mel(100);
    melsUpper = hz2mel(7940); 
    
    % Divide mels into N uniformly spaced channels
    melsChannels = linspace(melsLower, melsUpper, N + 1);
    
    % Mels to Hertz conversion
    freqChannels = mel2hz(melsChannels);
    
    % Array to store signals for each channel
    signalChannels = zeros(1, length(resampled_signal));
    
    %Task 5 - Filter the sound
    
    % Apply equiripple filter to all channels
    for elm = 1:N
        % Generate filter
        filt = Equiripple_FIR(freqChannels(elm), freqChannels(elm + 1));
        
        % Apply filter
        filteredChannel = filter(filt, resampled_signal);
        
        % Store signals
        signalChannels(elm, :) = transpose(filteredChannel);
    end

    % Task 6 

    % Plotting output signals of lowest/highest frequency channels
    % against sample number 
    lowestChannel = signalChannels(1, :);
    highestChannel = signalChannels(N, :);
    
%     figure(2);
%     plot(lowestChannel);
%     xlabel('Samples') 
%     ylabel('Signal')
%     title('Lowest Bandpass Frequency Channel vs Sample Number')
%     figure(3);
%     plot(highestChannel);
%     xlabel('Samples') 
%     ylabel('Signal')
%     title('Highest Bandpass Frequency Channel vs Sample Number')

    % Task 7 
    rectifiedSignals = abs(signalChannels);
    
    % Task 8 
    % Array to store extracted envelopes
    envelopedChannels = zeros(N, length(resampled_signal));
    
    % Defining LPF obtained using filterDesigner
    lpf = Equiripple_lpf1000Hz();
    
    % Filtering each channel using equiripple_lpf
    for elm = 1:N
        envelopedChannels(elm, :) = filter(lpf, rectifiedSignals(elm, :));
    end
   
    % Task 9 
    % Plotting lowest channel against sample number
%     figure(4);
%     plot(envelopedChannels(1, :));
%     xlabel('Samples') 
%     ylabel('Signal')
%     title('Lowest Low-pass Frequency Channel vs Sample Number')
    
    % Plotting highest channel against sample number
%     figure(5);
%     plot(envelopedChannels(N, :));
%     xlabel('Samples') 
%     ylabel('Signal')
%     title('Highest Low-pass Frequency Channel vs Sample Number')
    
    length_rectified = size(rectifiedSignals, 2);
    period = 1/desiredFs;
    duration = (length_rectified - 1)/desiredFs;
    t = 0:period:duration;
 
    output_signal = zeros(N, length(rectifiedSignals));
    
    for elm = 1:N
        central_frequency = sqrt(freqChannels(elm)*freqChannels(elm +1));
       
        cosine_signal = cos(2.*pi.*central_frequency.*t);
    
        am_signal = envelopedChannels(elm, :).*cosine_signal;
        output_signal(elm, :) = am_signal;
    end
    
    output_signal = transpose(output_signal);
    final = sum(output_signal, 2);
    
    normal_output = final/(max(abs(final)));
    
    %sound(normal_output);

    filename1 = 'dog_barking_1000Hz.wav';
    audiowrite(filename1,normal_output,16000)
   
    %figure(2)
    %plot(normal_output);
end


