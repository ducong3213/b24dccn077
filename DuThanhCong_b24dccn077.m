clear; close all; clc;

%% Thong so thiet ke
fs = 1000;          % tan so lay mau (Hz)
fc = 50;            % tan so cat (Hz)
N  = 51;            % chieu dai bo loc
Wn = fc / (fs/2);   % tan so cat chuan hoa

%% Thiet ke bo loc FIR thong thap dung cua so Hamming
b = fir1(N-1, Wn, 'low', hamming(N));
a = 1;  % FIR


%% Tao tin hieu vao: chirp 0 -> 100 Hz trong 1s
T = 1;
t = 0:1/fs:T;
x = chirp(t, 0, T, 100);

%% Loc tin hieu
y = filter(b, a, x);

%% Dap ung xung
figure;
stem(0:N-1, b, 'filled'); grid on;
xlabel('n'); ylabel('h[n]');
title('Dap ung xung bo loc FIR thong thap (Hamming, N=51)');

%% Dap ung tan so
figure;
[H,wf] = freqz(b, a, 1024, fs);
subplot(2,1,1);
plot(wf, 20*log10(abs(H))); grid on;
xlabel('Tan so (Hz)'); ylabel('Bien do (dB)');
title('Dap ung bien do cua bo loc');
subplot(2,1,2);
plot(wf, unwrap(angle(H))); grid on;
xlabel('Tan so (Hz)'); ylabel('Pha (rad)');
title('Dap ung pha cua bo loc');

%% So sanh tin hieu vao/ra
figure;
subplot(2,1,1); plot(t, x); grid on;
title('Tin hieu vao x(t) - chirp 0-100 Hz'); xlabel('Thoi gian (s)'); ylabel('Bien do');
subplot(2,1,2); plot(t, y); grid on;
title('Tin hieu ra y(t) sau bo loc'); xlabel('Thoi gian (s)'); ylabel('Bien do');

%% So sanh pho truoc/sau loc
Nfft = 4096;
X = abs(fft(x, Nfft));
Y = abs(fft(y, Nfft));
f = (0:Nfft-1)*(fs/Nfft);
figure;
plot(f, 20*log10(X/max(X))); hold on;
plot(f, 20*log10(Y/max(Y))); grid on;
xlim([0 200]);
xlabel('Tan so (Hz)'); ylabel('Bien do (dB)');
legend('Truoc loc','Sau loc');
title('So sanh pho truoc va sau loc');