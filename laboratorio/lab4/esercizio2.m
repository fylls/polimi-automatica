close all; clear all;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% PRESTAZIONI DEL MOTORE ALL'EQUILIBRIO  %%%

% verifico che all'equilibrio, con tensione di ingresso ueq pari a 1V
% e assenza di disturbo, y=1000 giri/min
 
R=48*10^(-3);
L=75*10^(-2);
J=8.37*10^(-7);
q=8.7*10^(-5);
h=9.1*10^(-3);
k=0.2*10^(-3);

A=[-R/L  -h/L
    h/J   -q/J];

bu=[1/L   0]';         % ruolo di u sullo stato
bd=[0  -k/J]';         % ruolo di d sullo stato

c=[0     60/(2*pi)];   % velocità albero motore y=x2*60/(2*pi)

d=0;

% equilibrio in assenza di disturbo
ueq=1;               % tensione di ingresso pari a 1V
xeq=-inv(A)*bu*ueq;
yeq=c*xeq+d*ueq;     % giri/min albero motore
yeq

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% PRESTAZIONI DEL MOTORE IN ANELLO APERTO  %%%%

% simulazione: da motore fermo a 1000 giri/min (w)
[NUM,DEN]=ss2tf(A,bu,c,d);
G=tf(NUM,DEN);                 % fdt da w a y
[NUMd,DENd]=ss2tf(A,bd,c,d);
Gd=tf(NUMd,DENd);              % fdt da d a y

% assenza di disturbo
T=linspace(0,6,1000);
w=1000;           % velocità desiderata
u=w/dcgain(G);    % y=G(0)u  -> u=w/G(0)
y_wy=u*step(G,T);
figure(1);
plot(T,y_wy); hold on; xlabel('tempo [s]'); ylabel('rpm [giri/min]'); title('ROTAZIONE [rpm] SENZA DISTURBO');

% pause;

% calcolo del tempo di risposta
autov=eig(A);
autov_dom=max(autov);
TD=-1/autov_dom;
TR=5*TD     % TR è circa pari a 3.7s (troppo!)

% disturbo costante: raffica di vento sull'elica da motore fermo a 1000 giri/min (w)
disturbo=100;
y_dy=disturbo*step(Gd,T);
ytot=y_wy+y_dy;
figure(1); plot(T,ytot); title('ROTAZIONE [rpm] CON DISTURBO');
% in anello aperto il disturbo "si ritrova" sull'uscita

% pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%% PRESTAZIONI DEL MOTORE CON CONTROLLORE INTEGRALE  %%%%
% annulla l'errore a regime dovuto al disturbo e fa sì che 
% l'uscita a regime del sistema di controllo sia pari all'uscita desiderata.

ki=1;
C=ki*tf(1,[1 0]);
L=C*G;
figure(2); bode(L); grid;

% per wc=10 (TR=5/wc=0.5) la fase critica è di poco superiore a -pi, così 
% che il margine di fase è al limite della stabilità

% provo allora con un controllore integrale-proporzionale "aggiungendo"
% al controllore integrale uno zero (-tau) che cancelli il polo dominante in G
% così facendo si alza la fase del sistema di controllo, garantendone 
% la stabilità robusta
ki=1;
tau=-1/max(autov);   % polo dominante di G
C=ki*tf(1,[1 0])*tf([tau 1],1);
L=C*G;
figure(3); margin(L); grid;
% determino ki tale che omegac=10
omegac=10;
[MAG,PHASE]=bode(L,omegac);
ki=ki/MAG;
C=ki*tf(1,[1 0])*tf([tau 1],1);
L=C*G;
figure(3); margin(L); grid;
% semplificando zeri/poli in L/(1+L) ( zero(L/(1+L)) e pole(1/(1+L)) )
% il polo dominante del sistema di controllo è pari a 11.29 così che
% il tempo di risposta è circa pari a 0.45s
% vediamo con la simulazione

% simulo senza disturbo
y_wy=w*step(L/(1+L),T);
figure(4);
plot(T,y_wy); hold on; xlabel('tempo [s]'); ylabel('rpm [giri/min]'); title('ROTAZIONE [rpm] SENZA DISTURBO');
% y tende a regime in circa mezzo secondo

% pause;

% tuttavia...
% simulo con disturbo
y_dy=disturbo*step(Gd/(1+L),T);
ytot=y_wy+y_dy;
figure(4); plot(T,ytot); title('ROTAZIONE [rpm] CON/SENZA DISTURBO');
% il disturbo viene compensato ma occorre più tempo, lo stesso tempo di G!
% l'autovalore dominante in G rimane polo in Gd/(1+L)

% compenso quindi il disturbo d

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% PRESTAZIONI DEL MOTORE CON CONTROLLORE INTEGRALE-PROPORZIONALE E COMPENSATORE DEL DISTURBO  %%%%
% quanto più piccolo è sigma e maggiore è la velocità di inseguimento
% del disturbo nella compensazione

sigma=0.01; H=-Gd/G*tf(1,[sigma 1]);
y_dy_c001=disturbo*step((G*H+Gd)/(1+L),T);
ytot_c001=y_wy+y_dy_c001;
errore_c001=w-ytot_c001;

sigma=0.1; H=-Gd/G*tf(1,[sigma 1]);
y_dy_c01=disturbo*step((G*H+Gd)/(1+L),T);
ytot_c01=y_wy+y_dy_c01;
errore_c01=w-ytot_c01;

sigma=1; H=-Gd/G*tf(1,[sigma 1]);
y_dy_c1=disturbo*step((G*H+Gd)/(1+L),T);
ytot_c1=y_wy+y_dy_c1;
errore_c1=w-ytot_c1;

figure(5);
plot(T,ytot_c1); hold on; plot(T,ytot_c01); plot(T,ytot_c001);
legend('\sigma=1','\sigma=0.1','\sigma=0.01'); title('ROTAZIONE [rpm] CON DISTURBO COMPENSATO'); xlim([0 1]);
xlabel('tempo [s]'); ylabel('rmp [giri/min]');

figure(6);
plot(T,errore_c1); hold on; plot(T,errore_c01); plot(T,errore_c001);
legend('\sigma=1','\sigma=0.1','\sigma=0.01'); title('ERRORE [rpm] CON DISTURBO COMPENSATO'); xlim([0 1]);
xlabel('tempo [s]'); ylabel('rmp [giri/min]');

% sigma=0.1 andrebbe già bene!
% QUINDI...
C
H=-tf(NUMd,NUM(3))*tf(1,[sigma 1])
