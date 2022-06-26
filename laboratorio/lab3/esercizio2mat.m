%% ESERCIZIO 2
clear; close all; clc

%% dati del problema
M = 10;   % Massa del carrello [kg]
m = 1;    % massa all'estremo dell'asta [kg]
L = 1;    % lunghezza dell'asta [m]
g = 9.81; % accelerazione di gravità [m/s^2]

%% equazioni del sistema in forma matriciale
A = [0 1 0 0;
     0 0 -m/M*g 0;
     0 0 0 1;
     0 0 g/L*(m+M)/M 0];

B = [0 0;
     1/M -1/(L*M);
     0 0;
     -1/(L*M) 1/(L^2)*(M+m)/(m*M)];

C = [1 0 0 0;
     0 0 1 0];

D = [0 0;
     0 0];

%% stabilità del sistema
autovalori = eig(A); % il sistema è instabile
disp(autovalori)

%% raggiungibilità e osservabilità, prima coppia: forza - posizione
disp('Raggiungibilità forza')
ra = ctrb(A,B(:,1));		% selezione ingresso forza
disp(det(ra))
disp(rank(ra))
% il sistema è completamente raggiungibile

disp('Osservabilità posizione')
os = obsv(A,C(1,:));		% selezione misura posizione
disp(det(os))
disp(rank(os))
% il sistema è completamente osservabile

%% raggiungibilità e osservabilità, seconda coppia: coppia - posizione angolare
disp('Raggiungibilità coppia')
ra = ctrb(A,B(:,2));		% selezione ingresso coppia
disp(det(ra))
disp(rank(ra))
% il sistema NON è completamente raggiungibile

disp('Osservabilità posizione angolare')
ob = obsv(A,C(2,:));		% selezione misura posizione angolare
disp(det(ob))
disp(rank(ob))
% il sistema NON è completamente osservabile

%% utilizzo la prima coppia. ridefinisco le matrici del sistema
%A = A;
B = B(:, 1);
C = C(1, :);
D = D(1, 1);

%% Progetto della legge di controllo
% ricavo le radici del polinomio
disp('Autovalori desiderati')
autov_controllore = [roots([1 1.5 1]); roots([1 2 1])]; disp(autov_controllore)

disp('Legge di controllo k')
k = acker(A, -B, autov_controllore); disp(k)

disp('Verifica autovalori')
disp(eig(A + B*k))

%% Progetto del ricostruttore dello stato
% ricavo le radici del polinomio
disp('Autovalori desiderati')
autov_ricostruttore = [roots([1 15 100]); roots([1 20 100])]; disp(autov_ricostruttore)

disp('Ricostruttore dello stato k')
lT = acker(A', -C', autov_ricostruttore);
l = lT'; disp(l)

disp('Verifica autovalori')
disp(eig(A + l*C))

%% verifico che il sistema complessivo abbia effettivamente gli autovalori desiderati
matrice_complessivo = [A, B*k; -l*C, A+l*C+B*k]; disp(eig(matrice_complessivo))

%% ---------- SISTEMA + CONTROLLO ---------- (esercizio2sim_controllore.slx)
%% STATO INIZIALE VICINO ALL'EQUILIBRIO
x0 = [0 0 pi/6 .0]';

%% LANCIARE IL MODELLO SIMULINK LINEARIZZATO (settare orizzonte simulazione = 25)
tempo = x.Time;
x1_lin = x.Data(:, 1);
x2_lin = x.Data(:, 2);
x3_lin = x.Data(:, 3);
x4_lin = x.Data(:, 4);

%% LANCIARE IL MODELLO SIMULINK NON LINEARE (settare orizzonte simulazione = 25)
x1_nonLin = x.Data(:, 1);
x2_nonLin = x.Data(:, 2);
x3_nonLin = x.Data(:, 3);
x4_nonLin = x.Data(:, 4);

%% plot lin vs non lin
close all
figure
subplot(2, 2, 1)
plot(tempo, x1_lin, 'b')
hold on
plot(tempo, x1_nonLin, 'r')
title('x_1 = posizione')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 2)
plot(tempo, x2_lin, 'b')
hold on
plot(tempo, x2_nonLin, 'r')
title('x_2 = velocità')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 3)
plot(tempo, x3_lin, 'b')
hold on
plot(tempo, x3_nonLin, 'r')
title('x_3 = posizione angolare')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 4)
plot(tempo, x4_lin, 'b')
hold on
plot(tempo, x4_nonLin, 'r')
title('x_4 = velocità angolare')
legend('linearizzato', 'non lineare', 'location', 'north')




%% STATO INIZIALE LONTANO DALL'EQUILIBRIO
x0 = [0 0 pi/3 .0]';

%% LANCIARE IL MODELLO SIMULINK LINEARIZZATO (settare orizzonte simulazione = 25)
tempo_lin = x.Time;
x1_lin = x.Data(:, 1);
x2_lin = x.Data(:, 2);
x3_lin = x.Data(:, 3);
x4_lin = x.Data(:, 4);

%% LANCIARE IL MODELLO SIMULINK NON LINEARE (settare orizzonte simulazione = 25)
tempo_nonLin = x.Time;
x1_nonLin = x.Data(:, 1);
x2_nonLin = x.Data(:, 2);
x3_nonLin = x.Data(:, 3);
x4_nonLin = x.Data(:, 4);

%% plot lin vs non lin
close all
figure
subplot(2, 2, 1)
plot(tempo, x1_lin, 'b')
hold on
plot(tempo, x1_nonLin, 'r')
title('x_1 = posizione')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 2)
plot(tempo, x2_lin, 'b')
hold on
plot(tempo, x2_nonLin, 'r')
title('x_2 = velocità')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 3)
plot(tempo, x3_lin, 'b')
hold on
plot(tempo, x3_nonLin, 'r')
title('x_3 = posizione angolare')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 4)
plot(tempo, x4_lin, 'b')
hold on
plot(tempo, x4_nonLin, 'r')
title('x_4 = velocità angolare')
legend('linearizzato', 'non lineare', 'location', 'north')




%% ---------- SISTEMA + CONTROLLO + RICOSTRUTTORE ----------  (esercizio2sim_controllore_ricostruttore.slx)
%% STATO INIZIALE VICINO ALL'EQUILIBRIO
x0 = [0 0 pi/6 .0]';
xhat0 = x0 + [0.01 -0.02 -0.01 0.02]';

%% LANCIARE IL MODELLO SIMULINK LINEARIZZATO (settare orizzonte simulazione = 25)
tempo = x.Time;
x1_lin = x.Data(:, 1);
x2_lin = x.Data(:, 2);
x3_lin = x.Data(:, 3);
x4_lin = x.Data(:, 4);

%% LANCIARE IL MODELLO SIMULINK NON LINEARE (settare orizzonte simulazione = 25)
x1_nonLin = x.Data(:, 1);
x2_nonLin = x.Data(:, 2);
x3_nonLin = x.Data(:, 3);
x4_nonLin = x.Data(:, 4);

%% plot lin vs non lin
close all
figure
subplot(2, 2, 1)
plot(tempo, x1_lin, 'b')
hold on
plot(tempo, x1_nonLin, 'r')
title('x_1 = posizione')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 2)
plot(tempo, x2_lin, 'b')
hold on
plot(tempo, x2_nonLin, 'r')
title('x_2 = velocità')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 3)
plot(tempo, x3_lin, 'b')
hold on
plot(tempo, x3_nonLin, 'r')
title('x_3 = posizione angolare')
legend('linearizzato', 'non lineare', 'location', 'north')
subplot(2, 2, 4)
plot(tempo, x4_lin, 'b')
hold on
plot(tempo, x4_nonLin, 'r')
title('x_4 = velocità angolare')
legend('linearizzato', 'non lineare', 'location', 'north')



%% STATO INIZIALE LONTANO DALL'EQUILIBRIO
x0 = [0 0 pi/3 .0]';
xhat0 = x0 + [0.01 -0.02 -0.01 0.02]';

%% LANCIARE IL MODELLO SIMULINK LINEARIZZATO (settare orizzonte simulazione = 25)
tempo_lin = x.Time;
x1_lin = x.Data(:, 1);
x2_lin = x.Data(:, 2);
x3_lin = x.Data(:, 3);
x4_lin = x.Data(:, 4);

figure
subplot(2, 2, 1)
plot(tempo_lin, x1_lin, 'b')
title('x_1 = posizione')
subplot(2, 2, 2)
plot(tempo_lin, x2_lin, 'b')
title('x_2 = velocità')
subplot(2, 2, 3)
plot(tempo_lin, x3_lin, 'b')
title('x_3 = posizione angolare')
subplot(2, 2, 4)
plot(tempo_lin, x4_lin, 'b')
title('x_4 = velocità angolare')


%% LANCIARE IL MODELLO SIMULINK NON LINEARE (settare orizzonte simulazione = 3)
tempo_nonLin = x.Time;
x1_nonLin = x.Data(:, 1);
x2_nonLin = x.Data(:, 2);
x3_nonLin = x.Data(:, 3);
x4_nonLin = x.Data(:, 4);

subplot(2, 2, 1)
plot(tempo_nonLin, x1_nonLin, 'r')
title('x_1 = posizione')
subplot(2, 2, 2)
plot(tempo_nonLin, x2_nonLin, 'r')
title('x_2 = velocità')
subplot(2, 2, 3)
plot(tempo_nonLin, x3_nonLin, 'r')
title('x_3 = posizione angolare')
subplot(2, 2, 4)
plot(tempo_nonLin, x4_nonLin, 'r')
title('x_4 = velocità angolare')

