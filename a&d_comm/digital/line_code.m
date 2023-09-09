%UNRZ(h)
n=1;
h=randi([0, 1], 1,10) %binary bit data
l=length(h);
h(l+1)=1;
while n<=length(h)-1;
    t=n-1:0.001:n;
if h(n) == 0
    if h(n+1)==0  
        y=(t>n);
    else
        y=(t==n);
    end
    d=plot(t,y);grid on;
    title('UNIPOLAR NRZ');
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
else
    if h(n+1)==0
        y=(t<n)-0*(t==n);
    else
        y=(t<n)+1*(t==n);
    end
    d=plot(t,y);grid on;
    title('Line code UNIPOLAR NRZ');
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
end
n=n+1;
end
%Spetra Calculation, Taking 512 points FFT
 f=1000*(0:256)/512;

 %unipolar 
 yu=fft(h, 512);
 pu=yu.*conj(yu)/512;

 figure; 
 plot(f,pu(1:257),'-k','linewidth',2)
 hold on
 title('Power Spectra Plot')
 grid on;





%PNRZ(h)
n=1;
h=randi([0, 1], 1,10) %binary bit data
l=length(h);
h(l+1)=1;
while n<=length(h)-1;
    t=n-1:0.001:n;
if h(n) == 0
    if h(n+1)==0  
        y=-(t<n)-(t==n);
    else
        y=-(t<n)+(t==n);
    end
    d=plot(t,y);grid on;
    title('Line code POLAR NRZ');
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
else
    if h(n+1)==0
        y=(t<n)-1*(t==n);
    else
        y=(t<n)+1*(t==n);
    end
    d=plot(t,y);grid on;
    title('Line code POLAR NRZ');
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
end
n=n+1;
end

%Spetra Calculation, Taking 512 points FFT
 f=1000*(0:256)/512;

 %Polar NRZ-L 
 yu=fft(h, 512);
 pu=yu.*conj(yu)/512;

 figure; 
 plot(f,pu(1:257),'-k','linewidth',2)
 hold on
 title('Power Spectra Plot')
 grid on; 





%NRZ-I
bits = randi([0, 1], 1,10) % input bit stream
streamLen = length(bits); % length of the stream
positionTime = 0.0001; % position duration
endTime = streamLen - positionTime; % required end time for given bit string
t = 0:positionTime:endTime;
j = 1; % index of the signal vector, s
bit = 1; % current bit
n = 1;
for i = 0:positionTime:endTime %
 if (floor(i)+1 ~= bit) % checks whether in the same bit
    bit = bit + 1;
    f = 0;
 else
    f=1;
 end
 if (bits(bit) == 0) % zero voltage for bit 0
     s(j) = n;
 else
     if(~f) % positive voltage for bit 1
         s(j) = n*-1; 
         n = s(j);
         f = 1;
         j = j + 1;
         continue; 
     end;
     s(j) = n;
     end;
 j = j + 1;
end;
plot(t,s); % PLOTTING THE RESULTS
axis([0 streamLen -3 3]);
title('Line code POLAR NRZ-I');
xlabel('Signal Element (s)');
ylabel('Voltage');
set(gca, 'XGrid', 'on'); % X-axis grid
set(gca, 'XTick', [0:1:streamLen]); % adjust X-axis ticks

%Spetra Calculation, Taking 512 points FFT
 f=1000*(0:256)/512;

 %polar NRZ-I 
 yu=fft(bits, 512);
 pu=yu.*conj(yu)/512;

 figure; 
 plot(f,pu(1:257),'-k','linewidth',2)
 hold on
 title('Power Spectra Plot')
 grid on;



%BRZ(h)
h=randi([0, 1], 1,10) %input binary bits
n=1;
l=length(h);
h(l+1)=1;
while n<=length(h)-1;
    t=n-1:0.001:n;
if h(n) == 0
    if h(n+1)==0  
        y=-(t<n-0.5)-(t==n);
    else
        y=-(t<n-0.5)+(t==n);
    end
    d=plot(t,y);grid on;
    title('Line code POLAR RZ');
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
else
    if h(n+1)==0
        y=(t<n-0.5)-1*(t==n);
    else
        y=(t<n-0.5)+1*(t==n);
    end
    d=plot(t,y);grid on;
     title('Line code POLAR RZ');
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
end
n=n+1;
end









%MANCHESTER(h)
n=1;
h=randi([0, 1], 1,10) %input binary bits
l=length(h);
h(l+1)=1;
while n<=length(h)-1;
    t=n-1:0.001:n;
if h(n) == 0
    if h(n+1)==0  
        y=-(t<n)+2*(t<n-0.5)+1*(t==n);
    else
        y=-(t<n)+2*(t<n-0.5)-1*(t==n);
    end
    d=plot(t,y);grid on;
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
else
    if h(n+1)==0
        y=(t<n)-2*(t<n-0.5)+1*(t==n);
    else
        y=(t<n)-2*(t<n-0.5)-1*(t==n);
    end
    d=plot(t,y);grid on;
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
end
n=n+1;
title('Line code MANCHESTER');
end
%Spetra Calculation, Taking 512 points FFT
 f=1000*(0:256)/512;

 %manchester
 yu=fft(h, 512);
 pu=yu.*conj(yu)/512;

 figure; 
 plot(f,pu(1:257),'-k','linewidth',2)
 hold on
 title('Power Spectra Plot')
 grid on;






%Differential Manchester
bits = randi([0, 1], 1,10); %input binary bits
bitrate = 1;
n = 1000;
T = length(bits)/bitrate; %set length of xaxis
N = n*length(bits);
dt = T/N;
t = 0:dt:T;
x = zeros(1,length(t));
lastbit = 1; %initial bit
for i=1:length(bits)    %loop through all the binary bits
  if bits(i)==0
    x((i-1)*n+1:(i-1)*n+n/2) = -lastbit;
    x((i-1)*n+n/2:i*n) = lastbit;
  else
    x((i-1)*n+1:(i-1)*n+n/2) = lastbit;
    x((i-1)*n+n/2:i*n) = -lastbit;
    lastbit = -lastbit;
  end
end
plot(t, x, 'Linewidth', 3);
counter = 0;
lastbit = 1;    %reset lastbit
grid on;
disp('Differential Manchester Decoding:');
%disp(result);

%Spetra Calculation, Taking 512 points FFT
 f=1000*(0:256)/512;

 %PRZ
 yu=fft(bits, 512);
 pu=yu.*conj(yu)/512;

 figure; 
 plot(f,pu(1:257),'-k','linewidth',2)
 hold on
 title('Power Spectra Plot')
 grid on;







%AMINRZ(h)
h=randi([0, 1], 1,10)
n=1;
l=length(h);
h(l+1)=1;
ami=-1;
while n<=length(h)-1
    t=n-1:0.001:n;
if h(n) == 0
    if h(n+1)==0  
        y=(t>n);
    else
        if ami==1
            y=-(t==n);
        else
            y=(t==n);
        end
    end
    d=plot(t,y);grid on;
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
else
    ami=ami*-1;
    if h(n+1)==0
        if ami==1
            y=(t<n);
        else
            y=-(t<n);
        end
    else
        if ami==1
            y=(t<n)-(t==n);
        else
            y=-(t<n)+(t==n);
        end
        
    end
    %y=(t>n-1)+(t==n-1);
    d=plot(t,y);grid on;
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 length(h)-1 -1.5 1.5]);
end
n=n+1;
end
title('Line code AMI NRZ');
%Spetra Calculation, Taking 512 points FFT
 f=1000*(0:256)/512;

 %AMI
 yu=fft(h, 512);
 pu=yu.*conj(yu)/512;

 figure; 
 plot(f,pu(1:257),'-k','linewidth',2)
 hold on
 title('Power Spectra Plot')
 grid on;
  %PSEUDOTERNARY Pseudoternary encoding
    bitstream=randi([0, 1], 1,10)
    % pulse height
    pulse = 5;
    % assume that current pulse level is a "low" pulse (binary 0)
    % this is the pulse level for the bit before given bitstream
    current_level = -pulse;

    for bit = 1:length(bitstream)
        % set bit time
        bt=bit-1:0.001:bit;

        if bitstream(bit) == 0
            % in pseudoternary, 0 denotes a change in signal levels
            current_level = -current_level;
            y = (bt<bit) * current_level;
        else
            % binary 1 is mapped to zero
            y = zeros(size(bt));
        end

        % assign last pulse point by inspecting the following bit
        try
            if bitstream(bit+1) == 0
                y(end) = -current_level;
            end
        catch e
            % bitstream end; assume next bit is 0
            y(end) = -current_level;
        end
        % draw pulse and label
        plot(bt, y, 'LineWidth', 2);
        text(bit-0.5, pulse+2, num2str(bitstream(bit)), ...
            'FontWeight', 'bold')
        hold on;
    end
    % draw grid
    grid on;
    axis([0 length(bitstream) -pulse*2 pulse*2]);
    set(gca,'YTick', [-pulse 0 pulse])
    set(gca,'XTick', 1:length(bitstream))
    set(gca,'XTickLabel', '')
    title('Pseudoternary')
    %Spetra Calculation, Taking 512 points FFT
 f=1000*(0:256)/512;

 %Pseudoternary
 yu=fft(bitstream, 512);
 pu=yu.*conj(yu)/512;

 figure; 
 plot(f,pu(1:257),'-k','linewidth',2)
 hold on
 title('Power Spectra Plot')
 grid on;

%>>>>>>>>> MATLAB code for binary ASK modulation and de-modulation >>>>>>>%
%>>>>>>>>> MATLAB code for binary ASK modulation and de-modulation >>>>>>>%
x=[1 0 1 1 1 0 1 0 1 0];                                    % Binary Information
bp=1;                                                    % bit period
disp(' Binary information at Transmitter :');
disp(x);

%XX representation of transmitting binary information as digital signal XXX
bit=[]; 
for n=1:1:length(x)
    if x(n)==1;
       se=ones(1,100);                      %set binary 1 to 1 in signal
    else x(n)==0;   
        se=zeros(1,100);                    %set binary 0 to 0 in signal
    end
     bit=[bit se];

end
t1=bp/100:bp/100:100*length(x)*(bp/100);    %calculate time needed for x axis
subplot(3,1,1);
plot(t1,bit,'lineWidth',2.5);grid on;
axis([ 0 bp*length(x) -.5 1.5]);
ylabel('amplitude(volt)');
xlabel(' time(sec)');
title('Transmitting information as digital signal');

%XXXXXXXXXXXXXXXXXXXXXXX Binary-ASK modulation XXXXXXXXXXXXXXXXXXXXXXXXXXX%
A1=1;                       % Amplitude of carrier signal for information 1
A2=0;                       % Amplitude of carrier signal for information 0
f=5;                                                 % carrier frequency 
t2=bp/99:bp/99:bp;                 
ss=length(t2);
m=[];
for (i=1:1:length(x))
    if (x(i)==1)
        y=A1*cos(2*pi*f*t2);                            %multiply carrier with 
    else
        y=A2*cos(2*pi*f*t2);
    end
    m=[m y];
end
t3=bp/99:bp/99:bp*length(x);
subplot(3,1,2);
plot(t3,m);
xlabel('time(sec)');
ylabel('amplitude(volt)');
title('Waveform for binary ASK modulation coresponding binary information');





%>>>>>>>>> MATLAB code for binary FSK modulation and de-modulation >>>>>>>%
x=[1 1 0 1 1 0 1 0 1 1];                                    % Binary Information
bp=1;                                                    % bit period
disp(' Binary information at Trans mitter :');
disp(x);

%XX representation of transmitting binary information as digital signal XXX
bit=[]; 
for n=1:1:length(x)
    if x(n)==1;
       se=ones(1,100);              % 1 represents value of 1
    else x(n)==0;       
        se=-1*ones(1,100);          % -1 represents value of 0
    end
     bit=[bit se];

end
t1=bp/100:bp/100:100*length(x)*(bp/100);
subplot(3,1,1);
plot(t1,bit,'lineWidth',2.5);grid on;
axis([ 0 bp*length(x) -1.5 1.5]);
ylabel('amplitude(volt)');
xlabel(' time(sec)');
title('Polar Non-return to zero');



%XXXXXXXXXXXXXXXXXXXXXXX Binary-FSK modulation XXXXXXXXXXXXXXXXXXXXXXXXXXX%
A=1;                                          % Amplitude of carrier signal
f1=10;                           % carrier frequency for information as 1
f2=5;                           % carrier frequency for information as 0
t2=bp/99:bp/99:bp;                 
ss=length(t2);
m=[];
for (i=1:1:length(x))
    if (x(i)==1)
        y=A*cos(2*pi*f1*t2);                    
    else
        y=A*cos(2*pi*f2*t2);
    end
    m=[m y];
end
t3=bp/99:bp/99:bp*length(x);
subplot(3,1,2);
plot(t3,m);
xlabel('time(sec)');
ylabel('amplitude(volt)');
title('Waveform for binary FSK modulation coresponding binary information');




%>>>>>>>>> MATLAB code for binary PSK modulation and de-modulation >>>>>>>%
x=[1 1 0 1 1 0 1 0 1 1];                                    % Binary Information
bp=1;                                                    % bit period
disp(' Binary information at Trans mitter :');
disp(x);

%XX representation of transmitting binary information as digital signal XXX
bit=[]; 
for n=1:1:length(x)
    if x(n)==1;
       se=ones(1,100);
    else x(n)==0;
        se=-1*ones(1,100);
    end
     bit=[bit se];

end
t1=bp/100:bp/100:100*length(x)*(bp/100);
subplot(3,1,1);
plot(t1,bit,'lineWidth',2.5);grid on;
axis([ 0 bp*length(x) -1.5 1.5]);
ylabel('amplitude(volt)');
xlabel(' time(sec)');
title('Polar Non-return to zero');



%XXXXXXXXXXXXXXXXXXXXXXX Binary-PSK modulation XXXXXXXXXXXXXXXXXXXXXXXXXXX%
A=1;                                          % Amplitude of carrier signal 
f=5;                                                 % carrier frequency 
t2=bp/99:bp/99:bp;                 
ss=length(t2);
m=[];
for (i=1:1:length(x))
    if (x(i)==1)
        y=A*cos(2*pi*f*t2);
    else
        y=-A*cos(2*pi*f*t2);   %A*cos(2*pi*f*t+pi) means -A*cos(2*pi*f*t)
    end
    m=[m y];
end
t3=bp/99:bp/99:bp*length(x);
subplot(3,1,2);
plot(t3,m);
xlabel('time(sec)');
ylabel('amplitude(volt)');
title('Waveform for binary PSK modulation coresponding binary information');


