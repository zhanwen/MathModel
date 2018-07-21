u=[-1:0.002:1];
%t=0.5+0.5*sin(2*pi*u);
a=2; w=10*pi;
t=exp(-(ones(size(u))*a+rand(size(u))).*(u+1)).*sin(w*u);
% try to use newrbe and rb for comparison
%net=newrbe(u,t,0.1);
net=newrb(u,t,1e-4,0.08,30,1);

y=sim(net,u);
plot(u,t,'b',u,y,'r');
