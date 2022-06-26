function sweep(R,L,C);

% creo un segnale con frequenza che varia da Hzmin a Hzmax
tlong=5;
frcamp=20000;
T=linspace(0,tlong,tlong*frcamp);
Hzmin=100;
Hzmax=1500;
Us=sin(2*pi*(Hzmin+(Hzmax-Hzmin)/tlong*T).*T);
filename='sweep.wav';
audiowrite(filename,Us,frcamp);
[Us,frcamp] = audioread(filename);
sound(Us,frcamp);

figure(1);
subplot(4,1,1);plot(T,(Hzmin+(Hzmax-Hzmin)/tlong*T)); ylabel('frequenza'); xlabel('tempo');
subplot(4,1,2);plot(T,Us); ylabel('ingresso'); xlabel('tempo');

pause;

% Metto il segnale nel dispositivo di riproduzione audio (il circuito
% elettrico)
A=[-3*R/(2*L)  1/(2*L)
    -1/(2*C)   -1/(2*R*C)];
b=[1/(2*L)         1/(2*R*C)]';
c1=[R  0];
c2=[-R/2  -1/2];
d1=0;
d2=1/2;
woofer=ss(A,b,c1,d1);
tweeter=ss(A,b,c2,d2);

% Uscita dal Woofer
Ywoofer=lsim(woofer,Us,T);
filename='woofer.wav';
audiowrite(filename,Ywoofer,frcamp);
[Ywoofer,frcamp] = audioread(filename);
sound(Ywoofer,frcamp);

figure(1);
subplot(4,1,3);plot(T,Ywoofer); ylabel('woofer'); xlabel('tempo');

pause;

% Uscita dal Tweeter
Ytweeter=lsim(tweeter,Us,T);
filename='tweeter.wav';
audiowrite(filename,Ytweeter,frcamp);
[Ytweeter,frcamp] = audioread(filename);
sound(Ytweeter,frcamp);

figure(1);
subplot(4,1,4);plot(T,Ytweeter); ylabel('tweeter'); xlabel('tempo');

pause;

close;
% 
% 
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
% audiowrite(filename,ysout,frcamp);
% % La funzione audiowrite ('nomefile',y,fs) genera il file audio nomefile.wav del vettore y campionandolo alla frequenza frcamp.
% % Read the data back into MATLAB using |audioread|.
% [ysout,frcamp] = audioread(filename);
% % Listen to the audio.
% sound(ysout,frcamp);
% 
% figure;
% plot(t,ys,'r'); hold on; plot(t,ysout,'k');
% 
% 
% 
% Ytweeter=lsim(tweeter,U,T);
