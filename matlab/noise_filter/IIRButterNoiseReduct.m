clc, close all
%% Initialization
Fs = 6000;      % Sampling Rate
T = 1/Fs;
S = 499;        % No of Samples
n = 0:1:S;  
N = length(n); 
x = (exp(0.2)*cos(2*pi*1000*n*T))+(sqrt(3)*cos(2*pi*1700*n*T)); 
xn = awgn(x,1,'measured'); % adding Gaussian Noise
t = n/Fs;                  % Time series

% Applying FFT on noisy Signal for DFT coefficien
xfft = fft(xn);          % DFT coefficient
N1 = length(xn);         
k = [0:(N1-1)/2];        
f = Fs*k/N1;             % formula for frequency bin
y = (2*abs(xfft))/N1;    % Amplitude Spectrum k>0
y(1) = y(1)/2;           % Amplitude Spectrum k=0
p = (2*abs(xfft)).^2/N.^2;    % Power Spectrum k>0
p(1) = p(1)/2;                % Power Spectrum k=0

%% Bandpass Filter : passband 0~999 Hz, 1701 Hz and above
FL = 999/(Fs/2);
FH = 1701/(Fs/2); 
[b a]= butter(2,[FL FH],'bandpass'); % Bandpass using Butterworth Filter 2nd order
h = tf(b,a) % transfer  function

%% Bandstop Filter : stopband 1001~1699 Hz
FL1 = 1001/(Fs/2);
FH1 = 1699/(Fs/2);
[b1 a1] = butter(2,[FL1 FH1],'stop'); % Bandstop using Butterworth Filter 2nd order
h1 = tf(b1,a1) % transfer  function

%% Apply both filter on the Signal
filtered_xn = filter(b,a,xn);               % Apply Bandpass on noisy signal
filtered_xn1 = filter(b1,a1,filtered_xn);   % Apply Bandstop on noisy signal

% apply FFT on the Filtered Signal 
y1 = (2*abs(fft(filtered_xn1)))/N; % Amplitude Spectrum k>0
y1(1) = y(1)/2;                    % Amplitude Spectrum k=0

%% Plot all waveforms
figure(1)
% input signal 
subplot(2,2,1);
plot(n,x);
xlabel('No of Samples'),ylabel('x(n)'),title('Input Signal of x(n)'),grid on;

% Single Sided Amplitude Spectrum
subplot(2,2,2);
plot(f,y(1:N/2));
xlabel('Frequency(Hz)'),ylabel('Amplitude |A(k)|'),title('Single Sided Amplitude Spectrum (input)'),grid on;

% Filtered Signal
subplot(2,2,3);
plot(1:N,filtered_xn1);
xlabel('No of Samples'),ylabel('Sample Value'),title('Filtered Signal'),grid on;

% Single Sided Amplitude Spectrum (filtered)
subplot(2,2,4);
plot(f,y1(1:N/2));
xlabel('Frequency(Hz)'),ylabel('Amplitude |A(k)|'),title('Single Sided Amplitude Spectrum (filtered)'),grid on;

% Magnitude & Phase Response (Bandpass)
figure(2)
freqz(b,a)
title('Magnitude & Phase Response (Bandpass)'); 

% Magnitude & Phase Response (Bandstop)
figure(21)
freqz(b1,a1)
title('Magnitude & Phase Response (Bandstop)'); 

pause;
close all;
