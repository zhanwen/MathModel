%APPCR1 Character recognition.

% Mark Beale, 12-15-93
% Copyright 1992-2005 The MathWorks, Inc.
% $Revision: 1.15.2.1 $  $Date: 2005/11/15 01:14:56 $

clf;
figure(gcf)

echo on


%    NEWFF   - Inititializes feed-forward networks.
%    TRAINGDX - Trains a feed-forward network with faster backpropagation.
%    SIM   - Simulates feed-forward networks.

%    CHARACTER RECOGNITION:

%    Using the above functions a feed-forward network is trained
%    to recognize character bit maps, in the presence of noise.

pause % Strike any key to continue...

%    DEFINING THE MODEL PROBLEM
%    ==========================

%    The script file PRPROB defines a matrix ALPHABET
%    which contains the bit maps of the 26 letters of the
%    alphabet.

%    This file also defines target vectors TARGETS for
%    each letter.  Each target vector has 26 elements with
%    all zeros, except for a single 1.  A has a 1 in the
%    first element, B in the second, etc.

[alphabet,targets] = prprob;
[R,Q] = size(alphabet);
[S2,Q] = size(targets);

pause % Strike any key to define the network...

%    DEFINING THE NETWORK
%    ====================

%    The character recognition network will have 25 TANSIG
%    neurons in its hidden layer.

S1 = 10;
net = newff(minmax(alphabet),[S1 S2],{'logsig' 'logsig'},'traingdx');
net.LW{2,1} = net.LW{2,1}*0.01;
net.b{2} = net.b{2}*0.01;

pause % Strike any key to train the network...

%    TRAINING THE NETWORK WITHOUT NOISE
%    ==================================

net.performFcn = 'sse';        % Sum-Squared Error performance function
net.trainParam.goal = 0.1;     % Sum-squared error goal.
net.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net.trainParam.epochs = 5000;  % Maximum number of epochs to train.
net.trainParam.mc = 0.95;      % Momentum constant.

%    Training begins...please wait...

P = alphabet;
T = targets;

[net,tr] = train(net,P,T);

%    ...and finally finishes.

pause % Strike any key to train the network with noise...

%    TRAINING THE NETWORK WITH NOISE
%    ===============================

%    A copy of the network will now be made.  This copy will
%    be trained with noisy examples of letters of the alphabet.

netn = net;

netn.trainParam.goal = 0.6;    % Mean-squared error goal.
netn.trainParam.epochs = 300;  % Maximum number of epochs to train.

%    The network will be trained on 10 sets of noisy data.

pause % Strike any key to begin training...        

%    Training begins...please wait...

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

%    ...and finally finishes.

pause % Strike any key to finish training the network...

%    TRAINING THE SECOND NETWORK WITHOUT NOISE
%    =========================================

%    The second network is now retrained without noise to
%    insure that it correctly categorizes non-noizy letters.

netn.trainParam.goal = 0.1;    % Mean-squared error goal.
netn.trainParam.epochs = 500;  % Maximum number of epochs to train.
net.trainParam.show = 5;       % Frequency of progress displays (in epochs).

%    Training begins...please wait...

P = alphabet;
T = targets;

[netn,tr] = train(netn,P,T);

%    ...and finally finishes.

pause % Strike any key to test the networks...

%    TRAINING THE NETWORK
%    ====================

% SET TESTING PARAMETERS
noise_range = 0:.05:.5;
max_test = 100;
network1 = [];
network2 = [];
T = targets;

% PERFORM THE TEST
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

pause % Strike any key to display the test results...

%    DISPLAY RESULTS
%    ===============

%    Here is a plot showing the percentage of errors for
%    the two networks for varying levels of noise.

clf
plot(noise_range,network1*100,'--',noise_range,network2*100);
title('Percentage of Recognition Errors');
xlabel('Noise Level');
ylabel('Network 1 - -   Network 2 ---');

%    Network 1, trained without noise, has more errors due
%    to noise than does Network 2, which was trained with noise.

echo off
disp('End of APPCR1')

 
