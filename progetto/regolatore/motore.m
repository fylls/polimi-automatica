J=1; nu=100; h=20; dist=-3;
Atilde=[-h/J 0; -1 0]; btilde=[nu/J; 0]; ctilde=[0 1];
R=[btilde Atilde*btilde]; det(R)
O=[ctilde; ctilde*Atilde]; det(O)
T1=0.2; T2=0.1; T3=0.02; T4=0.01; y0=5;
k1=J/nu*(h/J-1/T1-1/T2);
k2=J/nu/(T1*T2);
k=[k1 k2];
l1=h/J*(h/J-1/T3-1/T4)+1/(T3*T4);
l2=h/J-1/T3-1/T4;
l=[l1; l2];
Asis=Atilde+btilde*k;
Aric=Atilde+l*ctilde;
e=inv(Aric)*[0; 1]*(y0-dist);
