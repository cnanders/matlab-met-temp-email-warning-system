[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Dependency
addpath(genpath(fullfile(cDirThis, '..', 'src')));


%% Default
buffer = Buffer(5);
if isequal(buffer.get(), [0 0 0 0 0])
    fprintf('default test passed\n');
else
    fprintf('default test failed\n');
end

%% Single push
buffer = Buffer(5);
buffer.push(1);
if isequal(buffer.get, [1 0 0 0 0])
    fprintf('single push test passed\n');
else
    fprintf('single push test failed\n');
end
    

%% Double push
buffer = Buffer(5);
buffer.push(1);
buffer.push(2);
if isequal(buffer.get, [2 1 0 0 0])
    fprintf('double push test passed\n');
else
    fprintf('double push test failed\n');
end


%% Avg 
buffer = Buffer(5);
buffer.push(1);
buffer.push(2);
if isequal(buffer.getAvg(), mean([2 1 0 0 0]))
    fprintf('getAvg() test passed\n');
else
    fprintf('getAvg() test failed\n');
end

%% Spillover 
buffer = Buffer(5);
buffer.push(1);
buffer.push(2);
buffer.push(3);
buffer.push(4);
buffer.push(5);
buffer.push(6);
if isequal(buffer.get(), [6 5 4 3 2])
    fprintf('spillover test passed\n');
else
    fprintf('spillover test failed\n');
end

%% Is full
buffer = Buffer(5);
buffer.push(1);
buffer.push(2);

if ~buffer.getIsFull()
    fprintf('getIsFull push test passed\n');
else
    fprintf('getIsFull test failed\n');
end

%% Is full
buffer = Buffer(5);
buffer.push(1);
buffer.push(2);
buffer.push(3);
buffer.push(4);
buffer.push(5);

if buffer.getIsFull()
    fprintf('getIsFull push test passed\n');
else
    fprintf('getIsFull test failed\n');
end
