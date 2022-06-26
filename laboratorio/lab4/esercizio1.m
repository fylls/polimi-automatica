close all; clear all;

% parametri
R=8;
C=3.76*10^(-6);
L=7.5*10^(-4);

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

% simulazione con ingresso sinusoidale di frequenza 1 kHz
freq=1000; periodo=1/freq;
T=linspace(0,10*periodo,1000);
U=sin(2*pi*freq*T);
Ywoofer=lsim(woofer,U,T);
Ytweeter=lsim(tweeter,U,T);
figure;
subplot(2,1,1); plot(T,Ywoofer); xlabel('tempo [s]'); ylabel('woofer'); ylim([-1 1]);
subplot(2,1,2); plot(T,Ytweeter); xlabel('tempo [s]'); ylabel('tweeter'); ylim([-1 1]);

% Diagrammi di Bode per il woofer
figure; bode(woofer); grid;

% Diagrammi di Bode per il tweeter
figure; bode(tweeter); grid;

% calcolo della banda passante
% woofer
V=linspace(-4,10,50000); W=10.^V;  % V=log10(W) -> W=10^V
[MAG,PHASE,OMEGA]=bode(woofer,W);
ind=max(find(MAG>MAG(1)/sqrt(2)));
Bp_woofer=OMEGA(ind);
% tweeter
[MAG,PHASE,OMEGA]=bode(tweeter,W);
ind=min(find(MAG>MAG(length(MAG))/sqrt(2)));
Bp_tweeter=OMEGA(ind);

% poli di woofer e tweeter = autovalori di A
poli=eig(A);  % sono complessi coniugati 
omegan=sqrt(real(poli(1,1))^2+imag(poli(1,1))^2);  % omegan è circa pari a Bp_woofer e Bp_tweeter

%%%%%% PROGETTO DEL DISPOSITIVO DI RIPRODUZIONE CON FREQUENZA DI CROSSING
%%%%%% PARI A 0.5 KhZ
R=8;  % L=R^2*C
fcr=500;
omegacr=2*pi*fcr;
C=1/(R*omegacr);
L=R^2*C;

A=[-3*R/(2*L)  1/(2*L)
    -1/(2*C)   -1/(2*R*C)];
b=[1/(2*L)         1/(2*R*C)]';

woofer=ss(A,b,c1,d1);
tweeter=ss(A,b,c2,d2);

% simulazione con ingresso sinusoidale di frequenza 1 kHz
Ywoofer=lsim(woofer,U,T);
Ytweeter=lsim(tweeter,U,T);
figure;
subplot(2,1,1); plot(T,Ywoofer); xlabel('tempo [s]'); ylabel('woofer'); ylim([-1 1]);
subplot(2,1,2); plot(T,Ytweeter); xlabel('tempo [s]'); ylabel('tweeter'); ylim([-1 1]);

% Diagrammi di Bode per il woofer
figure; bode(woofer); grid;
% Diagrammi di Bode per il tweeter
figure; bode(tweeter); grid;

% calcolo della banda passante
% woofer
V=linspace(-4,10,50000); W=10.^V;  % V=log10(W) -> W=10^V
[MAG,PHASE,OMEGA]=bode(woofer,W);
ind=max(find(MAG>MAG(1)/sqrt(2)));
Bp_woofer=OMEGA(ind);
% tweeter
[MAG,PHASE,OMEGA]=bode(tweeter,W);
ind=min(find(MAG>MAG(length(MAG))/sqrt(2)));
Bp_tweeter=OMEGA(ind);
