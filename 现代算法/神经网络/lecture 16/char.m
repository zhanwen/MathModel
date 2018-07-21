[alphabet,targets] = prprob;
[R,Q] = size(alphabet);
[S2,Q] = size(targets);

S1 = 10;
net = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');
net.LW{2,1} = net.LW{2,1}*0.01;
net.b{2} = net.b{2}*0.01;

net.performFcn = 'sse';        % Sum-Squared Error performance function
net.trainParam.goal = 0.1;     % Sum-squared error goal.
net.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net.trainParam.mc = 0.95;      % Momentum constant.

P = alphabet;
T = targets;

[net,tr] = train(net,P,T);

netn = net;

netn.trainParam.goal = 0.6;    % Mean-squared error goal.
netn.trainParam.epochs = 300;  % Maximum number of epochs to train.

T = [targets targets targets targets];
for pass = 1:10
  fprintf('Pass = %.0f\n',pass);
  P = [alphabet, alphabet, ...
      (alphabet + randn(R,Q)*0.1), ...
      (alphabet + randn(R,Q)*0.2)];

  [netn,tr] = train(netn,P,T);
  echo off
end
echo on

netn.trainParam.goal = 0.1;    % Mean-squared error goal.
netn.trainParam.epochs = 500;  % Maximum number of epochs to train.
net.trainParam.show = 5;       % Frequency of progress displays (in epochs).

P = alphabet;
T = targets;

[netn,tr] = train(netn,P,T);
% ≤‚ ‘
noise_range = 0:.05:.5;
max_test = 100;
network1 = [];
network2 = [];
T = targets;

for noiselevel = noise_range
  fprintf('Testing networks with noise level of %.2f.\n',noiselevel);
  errors1 = 0;
  errors2 = 0;

  for i=1:max_test
    P = alphabet + randn(35,26)*noiselevel;

    % TEST NETWORK 1
    A = sim(net,P);
    AA = compet(A);
    errors1 = errors1 + sum(sum(abs(AA-T)))/2;

    % TEST NETWORK 2
    An = sim(netn,P);
    AAn = compet(An);
    errors2 = errors2 + sum(sum(abs(AAn-T)))/2;
    echo off
  end

  % AVERAGE ERRORS FOR 100 SETS OF 26 TARGET VECTORS.
  network1 = [network1 errors1/26/100];
  network2 = [network2 errors2/26/100];
end
echo on

clf
plot(noise_range,network1*100,'--',noise_range,network2*100);
title('Percentage of Recognition Errors');
xlabel('Noise Level');
ylabel('Network 1 - -   Network 2 ---');
echo off