fid = fopen('private/crabdata.csv');
C = textscan(fid,'%f%f%f%f%f%f%s','delimiter',',');  % Import data
fclose(fid);

physchars = [C{1} C{2} C{3} C{4} C{5} C{6}]; % inputs to neural network
female = strncmpi(C{7}, 'Female', 1);
male = strncmpi(C{7}, 'Male', 1);
sex = double([female male]);                 % targets for neural network

physchars = physchars';
sex = sex';

[physchars,ps] = mapminmax(physchars);           % Normalize inputs
rand('seed', 491218382)

nout = size(sex,1);                       % Number of outputs = 2
net = newff(minmax(physchars),[20 nout]); % Create a new feed forward network

[trS, cvS, tstS] = dividevec(physchars, sex, 0.1, 0.1); 

net = train(net, trS.P, trS.T, [], [], cvS, tstS);
out = sim(net, tstS.P);            % Get response from trained network

[y_out,I_out] = max(out);
[y_t,I_t] = max(tstS.T);

diff = [I_t - 2*I_out];

f_f = length(find(diff==-2));     % Female crabs classified as Female
f_m = length(find(diff==-3));     % Female crabs classified as Male
m_m = length(find(diff==-1));     % Male crabs classified as Male
m_f = length(find(diff==0));      % Male crabs classified as Female

N = size(tstS.P,2);               % Number of testing samples
fprintf('Total testing samples: %d\n', N);

cm = [f_f f_m; m_f m_m]           % classification matrix

cm_p = (cm ./ N) .* 100          % classification matrix in percentages

fprintf('Percentage Correct classification   : %f%%\n', 100*(cm(1,1)+cm(2,2))/N);
fprintf('Percentage Incorrect classification : %f%%\n', 100*(cm(1,2)+cm(2,1))/N);

