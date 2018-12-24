clear all ; clc ;
load knn-1-tris.mat ;

acc = mean(acc_,3) ;
tp = mean(tp_,3) ;
tn = mean(tn_,3) ;
fp = mean(fp_,3) ;
fn = mean(fn_,3) ;

classes_order = [2 3 1 5 4] ;

results = zeros(5,5,4) ;


for idx = 1:length(classes_order)
    cl = classes_order(idx) ;
    results(1,idx,1) = acc(1,1,1,cl) ;
    results(2,idx,1) = tp(1,1,1,cl) ;
    results(3,idx,1) = tn(1,1,1,cl) ;
    results(4,idx,1) = fp(1,1,1,cl) ;
    results(5,idx,1) = fn(1,1,1,cl) ;
    
    results(1,idx,2) = acc(5,1,1,cl) ;
    results(2,idx,2) = tp(5,1,1,cl) ;
    results(3,idx,2) = tn(5,1,1,cl) ;
    results(4,idx,2) = fp(5,1,1,cl) ;
    results(5,idx,2) = fn(5,1,1,cl) ;
    
    results(1,idx,3) = acc(1,5,1,cl) ;
    results(2,idx,3) = tp(1,5,1,cl) ;
    results(3,idx,3) = tn(1,5,1,cl) ;
    results(4,idx,3) = fp(1,5,1,cl) ;
    results(5,idx,3) = fn(1,5,1,cl) ;
    
    results(1,idx,4) = acc(5,5,1,cl) ;
    results(2,idx,4) = tp(5,5,1,cl) ;
    results(3,idx,4) = tn(5,5,1,cl) ;
    results(4,idx,4) = fp(5,5,1,cl) ;
    results(5,idx,4) = fn(5,5,1,cl) ;
end

disp(results*100) ;