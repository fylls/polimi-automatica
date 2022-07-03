alpha=0.9; beta1=0.05; beta2=0.02; dist=3; y0=50;
A=[0 (1-alpha)*(1-beta2); 1-beta1 0]; b=[1; 0]; c=[0 alpha*(1-beta2)]; d=0;
x0=[1 0]'; xcap0=[0 0]';
R=[b A*b]; det(R)
O=[c; c*A]; det(O)
mu=c*inv(eye(2)-A)*b+d
Atilde=[0 (1-alpha)*(1-beta2) 0; 1-beta1 0 0; 0 -alpha*(1-beta2) 1];
btilde=[1; 0; 0]; ctilde=[0 0 1];
k1=-1;
k2=-(1+(1-alpha)*(1-beta1)*(1-beta2))/(1-beta1);
k3=1/(alpha*(1-beta1)*(1-beta2));
k=[k1 k2 k3];
l1=0;
l2=(1-alpha)*(1-beta1)/alpha;
l3=-1;
l=[l1; l2; l3];
Asis=Atilde+btilde*k;
Aric=Atilde+l*ctilde;
e=inv(eye(3)-Aric)*[0; 0; 1]*(-y0+dist);