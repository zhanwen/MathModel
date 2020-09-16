u=[-1:0.05:1];
% t=sin(2*pi*u);
t=0.5+0.5*sin(2*pi*u);
% try to use newrbe and rb for comparison
%net=newrbe(u,t,0.1);
net=newrb(u,t,1e-2,0.1,5,1);

y=sim(net,u);
plot(u,t,'b',u,y,'r');
% nnd9sdq