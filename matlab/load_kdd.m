function varargout = load_kdd(varargin)
%LOAD_KDD Loads KDD data
%   Author: HENRI DE PLAEN

%% PRELIMINARIES
assert(nargin==2) ;

data_set = varargin{1} ;
classes_red = varargin{2} ;

%% LOAD DATA
benchmark_path = '../benchmark/' ;

switch data_set
    case 'nsl-kdd'
        local_path = 'NSL-KDD/' ;
        trainXY = readtable([benchmark_path local_path 'KDDTrain+.txt']) ;
        testXY  = readtable([benchmark_path local_path 'KDDTest+.txt']) ;
    otherwise
        error('Benchmark dataset not recognized') ;
end

%% CONVERT DATA TABLES TO NUMERICAL MATRICES
% [train_bin,test_bin] = cat2bin(trainXY.Var2,testXY.Var2) ;
% testXY = [testXY(:,1) test_bin testXY(:,3:end)] ;
% trainXY = [trainXY(:,1) train_bin trainXY(:,3:end)] ;
% 
% % [train_bin,test_bin] = cat2bin(trainXY.Var3,testXY.Var3) ;
% % testXY = [testXY(:,1:4) test_bin testXY(:,6:end)] ;
% % trainXY = [trainXY(:,1:4) train_bin trainXY(:,6:end)] ;
% % 
% % [train_bin,test_bin] = cat2bin(trainXY.Var4,testXY.Var4) ;
% % testXY = [testXY(:,1:70) test_bin testXY(:,72:end)] ;
% % trainXY = [trainXY(:,1:70) train_bin trainXY(:,72:end)] ;
% 
% testXY = [testXY(:,1:4) testXY(:,7:end)] ;
% trainXY = [trainXY(:,1:4) trainXY(:,7:end)] ;

[train_bin,test_bin] = cat2num(trainXY.Var2,testXY.Var2) ;
testXY = [testXY(:,1) test_bin testXY(:,3:end)] ;
trainXY = [trainXY(:,1) train_bin trainXY(:,3:end)] ;

[train_bin,test_bin] = cat2num(trainXY.Var3,testXY.Var3) ;
testXY = [testXY(:,1:2) test_bin testXY(:,4:end)] ;
trainXY = [trainXY(:,1:2) train_bin trainXY(:,4:end)] ;

[train_bin,test_bin] = cat2num(trainXY.Var4,testXY.Var4) ;
testXY = [testXY(:,1:3) test_bin testXY(:,5:end)] ;
trainXY = [trainXY(:,1:3) train_bin trainXY(:,5:end)] ;


%TABLES TO MATRICES
trainX = trainXY(:,1:end-2) ; trainY = trainXY(:,end-1) ;
testX = testXY(:,1:end-2) ; testY = testXY(:,end-1) ;

%% REDUCE OUTPUT CLASSES
trainY = table2cell(trainY) ;
testY = table2cell(testY) ;

if classes_red
    trainY(strcmp(trainY,'back')) = {'dos'} ;
    trainY(strcmp(trainY,'buffer_overflow')) = {'u2r'} ;
    trainY(strcmp(trainY,'ftp_write')) = {'r2l'} ;
    trainY(strcmp(trainY,'guess_passwd')) = {'r2l'} ;
    trainY(strcmp(trainY,'imap')) = {'r2l'} ;
    trainY(strcmp(trainY,'ipsweep')) = {'probe'} ;
    trainY(strcmp(trainY,'land')) = {'dos'} ;
    trainY(strcmp(trainY,'loadmodule')) = {'u2r'} ;
    trainY(strcmp(trainY,'multihop')) = {'r2l'} ;
    trainY(strcmp(trainY,'neptune')) = {'dos'} ;
    trainY(strcmp(trainY,'nmap')) = {'probe'} ;
    trainY(strcmp(trainY,'perl')) = {'u2r'} ;
    trainY(strcmp(trainY,'phf')) = {'r2l'} ;
    trainY(strcmp(trainY,'pod')) = {'dos'} ;
    trainY(strcmp(trainY,'portsweep')) = {'probe'} ;
    trainY(strcmp(trainY,'rootkit')) = {'u2r'} ;
    trainY(strcmp(trainY,'satan')) = {'probe'} ;
    trainY(strcmp(trainY,'smurf')) = {'dos'} ;
    trainY(strcmp(trainY,'spy')) = {'r2l'} ;
    trainY(strcmp(trainY,'teardrop')) = {'dos'} ;
    trainY(strcmp(trainY,'warezclient')) = {'r2l'} ;
    trainY(strcmp(trainY,'warezmaster')) = {'r2l'} ;
    trainY(strcmp(trainY,'apache2')) = {'dos'} ;
    trainY(strcmp(trainY,'httptunnel')) = {'r2l'} ;
    trainY(strcmp(trainY,'mailbomb')) = {'dos'} ;
    trainY(strcmp(trainY,'mscan')) = {'probe'} ;
    trainY(strcmp(trainY,'named')) = {'r2l'} ;
    trainY(strcmp(trainY,'processtable')) = {'dos'} ;
    trainY(strcmp(trainY,'ps')) = {'u2r'} ;
    trainY(strcmp(trainY,'saint')) = {'probe'} ;
    trainY(strcmp(trainY,'sendmail')) = {'r2l'} ;
    trainY(strcmp(trainY,'snmpgetattack')) = {'r2l'} ;
    trainY(strcmp(trainY,'snmpguess')) = {'r2l'} ;
    trainY(strcmp(trainY,'sqlattack')) = {'u2r'} ;
    trainY(strcmp(trainY,'udpstorm')) = {'dos'} ;
    trainY(strcmp(trainY,'worm')) = {'dos'} ;
    trainY(strcmp(trainY,'xlock')) = {'r2l'} ;
    trainY(strcmp(trainY,'xsnoop')) = {'r2l'} ;
    trainY(strcmp(trainY,'xterm')) = {'u2r'} ;
    
    testY(strcmp(testY,'back')) = {'dos'} ;
    testY(strcmp(testY,'buffer_overflow')) = {'u2r'} ;
    testY(strcmp(testY,'ftp_write')) = {'r2l'} ;
    testY(strcmp(testY,'guess_passwd')) = {'r2l'} ;
    testY(strcmp(testY,'imap')) = {'r2l'} ;
    testY(strcmp(testY,'ipsweep')) = {'probe'} ;
    testY(strcmp(testY,'land')) = {'dos'} ;
    testY(strcmp(testY,'loadmodule')) = {'u2r'} ;
    testY(strcmp(testY,'multihop')) = {'r2l'} ;
    testY(strcmp(testY,'neptune')) = {'dos'} ;
    testY(strcmp(testY,'nmap')) = {'probe'} ;
    testY(strcmp(testY,'perl')) = {'u2r'} ;
    testY(strcmp(testY,'phf')) = {'r2l'} ;
    testY(strcmp(testY,'pod')) = {'dos'} ;
    testY(strcmp(testY,'portsweep')) = {'probe'} ;
    testY(strcmp(testY,'rootkit')) = {'u2r'} ;
    testY(strcmp(testY,'satan')) = {'probe'} ;
    testY(strcmp(testY,'smurf')) = {'dos'} ;
    testY(strcmp(testY,'spy')) = {'r2l'} ;
    testY(strcmp(testY,'teardrop')) = {'dos'} ;
    testY(strcmp(testY,'warezclient')) = {'r2l'} ;
    testY(strcmp(testY,'warezmaster')) = {'r2l'} ;    
    % following entries on sole test set
    testY(strcmp(testY,'apache2')) = {'dos'} ; 
    testY(strcmp(testY,'httptunnel')) = {'r2l'} ;
    testY(strcmp(testY,'mailbomb')) = {'dos'} ;
    testY(strcmp(testY,'mscan')) = {'probe'} ;
    testY(strcmp(testY,'named')) = {'r2l'} ;
    testY(strcmp(testY,'processtable')) = {'dos'} ;
    testY(strcmp(testY,'ps')) = {'u2r'} ;
    testY(strcmp(testY,'saint')) = {'probe'} ;
    testY(strcmp(testY,'sendmail')) = {'r2l'} ;
    testY(strcmp(testY,'snmpgetattack')) = {'r2l'} ;
    testY(strcmp(testY,'snmpguess')) = {'r2l'} ;
    testY(strcmp(testY,'sqlattack')) = {'u2r'} ;
    testY(strcmp(testY,'udpstorm')) = {'dos'} ;
    testY(strcmp(testY,'worm')) = {'dos'} ;
    testY(strcmp(testY,'xlock')) = {'r2l'} ;
    testY(strcmp(testY,'xsnoop')) = {'r2l'} ;
    testY(strcmp(testY,'xterm')) = {'u2r'} ;
end

%% RETURN
testX = table2array(testX) ; 
%testY = table2array(testY) ;
trainX = table2array(trainX) ; 
%trainY = table2array(trainY) ;

% transform time
trainX(:,1) = log(trainX(:,1)+1) ;
testX(:,1) = log(testX(:,1)+1) ;

varargout{1} = trainX ; varargout{2} = trainY ;
varargout{3} = testX ; varargout{4} = testY ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = cat2bin(varargin)
%CAT2BIN Converts a categrocial cell list (of string) to a binary table
%   Author: HENRI DE PLAEN


%% PRELIMINARIES
assert(nargin==2) ; assert(nargout==2) ;
train_cat = varargin{1} ;
test_cat = varargin{2} ;

%% CONVERSION
unique_poss = unique(train_cat) ;

l_train = length(train_cat) ;
l_test = length(test_cat) ;

idx_max = length(unique_poss) ;

%prealloc
train_bin = zeros(l_train,idx_max) ;
test_bin = zeros(l_test,idx_max) ;

for idx = 1:idx_max
    train_bin(:,idx) = strcmp(train_cat,unique_poss(idx)) ;
    test_bin(:,idx) = strcmp(test_cat,unique_poss(idx)) ;
end

%% RETURN 
varargout{1} = array2table(train_bin,'VariableNames',unique_poss) ;
varargout{2} = array2table(test_bin,'VariableNames',unique_poss) ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = cat2num(varargin)
%CAT2BIN Converts a categrocial cell list (of string) to a binary table
%   Author: HENRI DE PLAEN


%% PRELIMINARIES
assert(nargin==2) ; assert(nargout==2) ;
train_cat = varargin{1} ;
test_cat = varargin{2} ;

%% CONVERSION
unique_poss = unique(train_cat) ;

l_train = length(train_cat) ;
l_test = length(test_cat) ;

train_num = zeros(l_train,1) ;
test_num = zeros(l_test,1) ;

idx_max = length(unique_poss) ;

for idx = 1:idx_max
    train_num(strcmp(train_cat,unique_poss(idx))) = idx ;
    test_num(strcmp(test_cat,unique_poss(idx))) = idx ;
end

%% RETURN 
varargout{1} = array2table(train_num,'VariableNames',unique_poss(1)) ;
varargout{2} = array2table(test_num,'VariableNames',unique_poss(1)) ;

end
