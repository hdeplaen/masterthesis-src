function [train_out, test_out] = to_numeric(train_in, test_in, what_conversion)

assert(isa(what_conversion,'char'), 'what_conversion: not a function handle') ;

idx     = 1 ;                                                               % initial iteratino
idx_max = width(train_in) ;                                                 % end of table

while true
    if ~isa(table2array(train_in(1,idx)),'double')                          % if the type is not numeric
        [train_bin,test_bin,idx_bin] = feval( ...
            what_conversion,train_in(:,idx),test_in(:,idx)) ;               % change column to numeric
        
        switch idx
            case 1
                train_in    = [train_bin train_in(:,2:end)] ;               % replace new numeric column in table (training)
                test_in     = [test_bin   test_in(:,2:end)] ;               % replace new numeric column in table (testing)
            case idx_max
                train_in    = [train_in(idx-1,1) train_bin] ;               % replace new numeric column in table (training)
                test_in     = [test_in(idx-1,1)  test_bin] ;                % replace new numeric column in table (testing)
            otherwise
                train_in    = [train_in(:,1:idx-1) train_bin  ...
                    train_in(:,idx+1:end)] ;                                % replace new numeric column in table (training)
                test_in     = [test_in(:,1:idx-1)  test_bin ...
                    test_in(:,idx+1:end)] ;                                 % replace new numeric column in table (testing)
        end
        
        idx         = idx + idx_bin - 1 ;                                   % iteration spring
        idx_max     = idx_max + idx_bin - 1 ;                               % adapt new end of table
    end
    
    idx = idx + 1 ;                                                         % iterate
    
    if idx == idx_max ; break ; end
end

train_out = train_in ;
test_out = test_in ;

end
