d1=10; d2=1;
A=[-d1 0; d1 -d2]; b=[1; 0]; c=[0 d2]; d=0;
x0=[1 0]'; xcap0=[0 0]';
R=[b A*b]; det(R)
O=[c; c*A]; det(O)
T1=0.05; T2=0.1; T3=0.01; T4=0.01; y0=5;
k1=d1+d2-1/T1-1/T2;
k2=1/d1*(-d2*(d2-1/T1-1/T2)-1/(T1*T2));
k=[k1 k2];
l1=1/(d1*d2)*(-d1*(d1-1/T3-1/T4)-1/(T3*T4));
l2=1/d2*(d1+d2-1/T3-1/T4);
l=[l1; l2];
Asis=A+b*k;
Aric=A+l*c;
M=A+(b+d*l)*k+l*c;
muR=-k*inv(M)*l;
mu=-c*inv(A)*b+d;
muy0y=muR*mu/(1+muR*mu);
mudy=1/(1+muR*mu);
e=-inv(Aric)*l*y0;