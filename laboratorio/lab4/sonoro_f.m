function sonoro_f(freq,R,L,C);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INGRESSO
% Volendo generare un tono a frequenza freq di tlong secondi, il codice è:
tlong=3;
frcamp=freq*50;
T=linspace(0,tlong,tlong*frcamp);
U=sin(2*pi*freq*T);
figure(1);
subplot(3,1,1); plot(T,U); xlim([0 10/freq]); ylim([-1 1]); ylabel('ingresso');
% La funzione audiowrite ('nomefile',y,fs) genera il file audio nomefile.wav del vettore y campionandolo alla frequenza fs.
nomefile='sonoro_freq.wav';
audiowrite(nomefile,U,frcamp);
% La funzione audioread('nomefile') legge il file in Matlab
[U,Fs] = audioread(nomefile);
% Per ascoltare il suono
sound(U,Fs);

pause;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USCITA
% R=8;
% C=3.76*10^(-6);
% L=7.5*10^(-4);
% sistema
A=[-3*R/(2*L)  1/(2*L)
    -1/(2*C)   -1/(2*R*C)];
b=[1/(2*L)         1/(2*R*C)]';
c1=[R  0];
c2=[-R/2  -1/2];
d1=0;
d2=1/2;
woofer=ss(A,b,c1,d1);
tweeter=ss(A,b,c2,d2);
Ywoofer=lsim(woofer,U,T);
figure(1);
subplot(3,1,2); plot(T,Ywoofer); xlim([0 10/freq]); ylim([-1 1]); ylabel('woofer');

nomefile='sonoro_freq_woofer.wav';
audiowrite(nomefile,Ywoofer,frcamp);
% La funzione audioread('nomefile') legge il file in Matlab
[Ywoofer,Fs] = audioread(nomefile);
% Per ascoltare il suono
sound(Ywoofer,Fs);

pause;

Ytweeter=lsim(tweeter,U,T);
figure(1);
subplot(3,1,3); plot(T,Ytweeter); xlim([0 10/freq]); ylim([-1 1]); ylabel('tweeter');
nomefile='sonoro_freq_tweeter.wav';
audiowrite(nomefile,Ytweeter,frcamp);
% La funzione audioread('nomefile') legge il file in Matlab
[Ytweeter,Fs] = audioread(nomefile);
% Per ascoltare il suono
sound(Ytweeter,Fs);



% filename='prova_sout.wav';
% audiowrite(filename,ysout,Fs);
% % La funzione audiowrite ('nomefile',y,fs) genera il file audio nomefile.wav del vettore y campionandolo alla frequenza fs.
% % Read the data back into MATLAB using |audioread|.
% [ysout,Fs] = audioread(filename);
% % Listen to the audio.
% sound(ysout,Fs);
% 
% figure;
% plot(t,ys,'r'); hold on; plot(t,ysout,'k');


% % Woofer
% [NUM1,DEN1]=ss2tf(A,b,c1,d1);
% sistema1=tf(NUM1,DEN1);
% wmin=10^2; wmax=10^6;
% [ampiezza,fase,puls]=bode(sistema1,{wmin,wmax});
% 
% % Tweeter
% [NUM2,DEN2]=ss2tf(A,b,c2,d2);
% sistema2=tf(NUM2,DEN2);
% [ampiezza,fase,puls]=bode(sistema2,{wmin,wmax});
% 
% % suono in uscita dal filtro 
% [ampiezza,fase,puls]=bode(sistema1,2*pi*(Hzmin+(Hzmax-Hzmin)/tlong*t));
% 
% ysout=ampiezza(1,:).*sin(2*pi*(Hzmin+(Hzmax-Hzmin)/tlong*t).*t);
% % ysout=0.1*sin(2*pi*(Hzmin+(Hzmax-Hzmin)/tlong*t).*t);
% 
% filename='prova_sout.wav';
% audiowrite(filename,ysout,Fs);
% % La funzione audiowrite ('nomefile',y,fs) genera il file audio nomefile.wav del vettore y campionandolo alla frequenza fs.
% % Read the data back into MATLAB using |audioread|.
% [ysout,Fs] = audioread(filename);
% % Listen to the audio.
% sound(ysout,Fs);
% 
% figure;
% plot(t,ys,'r'); hold on; plot(t,ysout,'k');




% yout=0.5*sin(2*pi*TOTHz*t);
% filename='prova_uscita.wav';
% audiowrite(filename,yout,10000);
% % La funzione audiowrite ('nomefile',y,fs) genera il file audio nomefile.wav del vettore y campionandolo alla frequenza fs.
% 
% % Read the data back into MATLAB using |audioread|.
% [yout,Fs] = audioread(filename);
% 
% % Listen to the audio.
% sound(yout,Fs);
% 
% %%%%%%%%%%%%%%%%%%%%%
% % % creo un segnale con frequenza che varia da Hzmin a Hzmax
% tlong=5; Fs=20000
% t=linspace(0,tlong,tlong*Fs);
% Hzmin=200;
% Hzmax=2500;
% ys=sin(2*pi*(Hzmin+(Hzmax-Hzmin)/tlong*t).*t);
% % figure;
% % plot(t,ys); hold on; plot(t,ys,'*');
% filename='prova_s.wav';
% audiowrite(filename,ys,Fs);
% % La funzione audiowrite ('nomefile',y,fs) genera il file audio nomefile.wav del vettore y campionandolo alla frequenza fs.
% % Read the data back into MATLAB using |audioread|.
% [ys,Fs] = audioread(filename);
% % Listen to the audio.
% sound(ys,Fs);
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pause;
% % Metto il segnale nel filtro
% R=8;
% fcr=500;
% omegacr=2*pi*fcr;
% C=1/(R*omegacr);
% L=R^2*C;
% 
% A=[-3*R/(2*L)  1/(2*L)
%     -1/(2*C)   -1/(2*R*C)];
% b=[1/(2*L)         1/(2*R*C)]';
% c1=[R  0];
% c2=[-R/2  -1/2];
% d1=0;
% d2=1/2;
% 
% % Woofer
% [NUM1,DEN1]=ss2tf(A,b,c1,d1);
% sistema1=tf(NUM1,DEN1);
% wmin=10^2; wmax=10^6;
% [ampiezza,fase,puls]=bode(sistema1,{wmin,wmax});
% 
% % Tweeter
% [NUM2,DEN2]=ss2tf(A,b,c2,d2);
% sistema2=tf(NUM2,DEN2);
% [ampiezza,fase,puls]=bode(sistema2,{wmin,wmax});
% 
% % suono in uscita dal filtro 
% [ampiezza,fase,puls]=bode(sistema1,2*pi*(Hzmin+(Hzmax-Hzmin)/tlong*t));
% 
% ysout=ampiezza(1,:).*sin(2*pi*(Hzmin+(Hzmax-Hzmin)/tlong*t).*t);
% % ysout=0.1*sin(2*pi*(Hzmin+(Hzmax-Hzmin)/tlong*t).*t);
% 
% filename='prova_sout.wav';
% audiowrite(filename,ysout,Fs);
% % La funzione audiowrite ('nomefile',y,fs) genera il file audio nomefile.wav del vettore y campionandolo alla frequenza fs.
% % Read the data back into MATLAB using |audioread|.
% [ysout,Fs] = audioread(filename);
% % Listen to the audio.
% sound(ysout,Fs);
% 
% figure;
% plot(t,ys,'r'); hold on; plot(t,ysout,'k');