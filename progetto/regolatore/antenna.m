J=1500; h=200;
A=[0 1; 0 -h/J]; b=[0; 1/J]; c=[1 0]; d=0;
x0=[-0.5 0]'; xcap0=[0 0]';
R=[b A*b]; det(R)
O=[c; c*A]; det(O)
T1=2; T2=1; T3=0.1; T4=0.05; y0=0.5;
k1=-J/(T1*T2);
k2=J*(h/J-1/T1-1/T2);
k=[k1 k2];
l1=h/J-1/T3-1/T4;
l2=-h/J*(h/J-1/T3-1/T4)-1/(T3*T4);
l=[l1; l2];
Asis=A+b*k;
Aric=A+l*c;
M=A+(b+d*l)*k+l*c;
muR=-k*inv(M)*l;
e=-inv(Aric)*l*y0;
