function Hd = Equiripple_FIR(passband1, passband2)
%EQUIRIPPLE-FIR Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.12 and Signal Processing Toolbox 9.0.
% Generated on: 13-Jul-2022 18:53:18

% Equiripple Bandpass filter designed using the FIRPM function.

% All frequency values are in Hz.

Fstop1 = passband1 - 60;      % First Stopband Frequency
Fpass1 = passband1;           % First Passband Frequency
Fpass2 = passband2;           % Second Passband Frequency
Fstop2 = passband2 + 60;      % Second Stopband Frequency
Astop1 = 60;                  % First Stopband Attenuation (dB)
Apass  = 1;                   % Passband Ripple (dB)
Astop2 = 60;                  % Second Stopband Attenuation (dB)
Fs = 16000;                   % Sampling Frequency



h = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', Fstop1, Fpass1, ...
    Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);

Hd = design(h, 'equiripple', ...
    'MinOrder', 'any');

% [EOF]