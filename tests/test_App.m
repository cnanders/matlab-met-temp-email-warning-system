
[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

% Dependency
addpath(genpath(fullfile(cDirThis, '..', 'vendor', 'github', 'cnanders', 'matlab-omega-utc-usb', 'src')));
addpath(genpath(fullfile(cDirThis, '..', 'src')));

app = App();
