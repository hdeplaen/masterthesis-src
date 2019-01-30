function varargout = load_kdd(varargin)
%LOAD_KDD Loads KDD data
%   Author: HENRI DE PLAEN

%% PRELIMINARIES
assert(nargin==2) ;

data_set = varargin{1} ;
classes_red = varargin{2} ;

%% LOAD DATA
benchmark_path = '../benchmark/' ;                                          % path of the benchmarking data-sets

switch data_set                                                             % choose data-sets
    case 'nsl-kdd'
        local_path = 'NSL-KDD/' ;                                           % subpath of chosen data-set
        trainXY = readtable([benchmark_path local_path 'KDDTrain+.txt']) ;  % filename of the training set
        testXY  = readtable([benchmark_path local_path 'KDDTest+.txt']) ;   % filename of the test set
        
        %SELECT SETS
        trainX = trainXY(:,1:end-2) ;                                               % select training set features
        trainY = trainXY(:,end-1) ;                                                 % select training set classes
        testX = testXY(:,1:end-2) ;                                                 % select test set features
        testY = testXY(:,end-1) ;                                                   % select test set classes
    case 'kdd-cup-99'
        error('support implementation under construction') ;
        local_path = 'KDD-CUP-99/' ;                                           % subpath of chosen data-set
        trainX = readtable([benchmark_path local_path 'kddcup.data.corrected']) ;  % filename of the traning set
        testX  = readtable([benchmark_path local_path 'KDDTest+.txt']) ;   % filename of the test set
        
    otherwise
        error('Benchmark dataset not recognized') ;
end

%% CONVERT DATA TABLES TO NUMERICAL MATRICES
%SPECIALIZED TREATING OF CATEGORCIAL DATA
% PROTOCOL
idx = 2 ;
[train_bin,test_bin,idx_protocol] = protocol2bin(trainX(:,idx),testX(:,idx)) ;               % change column to numeric

trainX    = [trainX(:,1:idx-1) train_bin trainX(:,idx+1:end)] ;                                % replace new numeric column in table (training)
testX     = [testX(:,1:idx-1)  test_bin  testX(:,idx+1:end)] ;                                 % replace new numeric column in table (testing)

%TERMINATION FLAG
% idx = 4 + idx_protocol - 1 ;
% [train_bin,test_bin,~] = flag2bin(trainX(:,idx),testX(:,idx)) ;               % change column to numeric
% 
% trainX    = [trainX(:,1:idx-1) train_bin trainX(:,idx+1:end)] ;                                % replace new numeric column in table (training)
% testX     = [testX(:,1:idx-1)  test_bin  testX(:,idx+1:end)] ;                                 % replace new numeric column in table (testing)

%GENERAL TREATING OF CATEGORICAL DATA
[trainX, testX] = to_numeric(trainX, testX, 'cat2freq') ;                   % or 'cat2bin'

%% REDUCE OUTPUT CLASSES
trainY = table2cell(trainY) ;                                               % convert classes training to char cells
testY = table2cell(testY) ;                                                 % convert classes testing to chat cells

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
testX = table2array(testX) ;                                                % training features to numeric array
trainX = table2array(trainX) ;                                              % test features to numeric array

% transform time
%trainX(:,1) = log(trainX(:,1)+1) ;
%testX(:,1) = log(testX(:,1)+1) ;

varargout{1} = trainX(1:100000,:) ;
varargout{2} = trainY(1:100000) ;
varargout{3} = trainX(100001:end,:) ;
varargout{4} = trainY(100001:end) ;

% varargout{1} = trainX ;
% varargout{2} = trainY ;
% varargout{3} = testX ;
% varargout{4} = testY ;

end