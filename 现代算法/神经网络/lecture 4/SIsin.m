u=[-1:0.05:1];
t=0.5+0.5*sin(2*pi*u);

% try to use different f and training algorithm
net=newff([-1 1],[10 1],{'tansig','purelin'},'trainlm');
% training param.
net.trainParam.goal=1e-8;
net.trainParam.epochs=10000;

[net,tr]=train(net,u,t);
y=sim(net,u);
plot(u,t,'b',u,y,'r');
