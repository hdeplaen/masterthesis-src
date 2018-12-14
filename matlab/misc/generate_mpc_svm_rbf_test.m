function [sol, sig2] = generate_mpc_svm_rbf_test(num_tests, num_features, num_sv)
%GENERATE_SVM_TEST
%
% Author: Henri De Plaen, KU Leuven

if nargin==0
    num_sv = 15 ;
    num_tests = 200 ;
    num_features = 5 ;
end

sv = randi([-100 100],num_sv,num_features)/100 ;
coeffs = randi([-100 100],num_sv+1,1)/100 ;
intercept = coeffs(end) ;
coeffs = coeffs(1:end-1) ;
tests = randi([-100 100],num_tests,num_features)/100 ;
%sig2 = (1e+2*randn(1,1))^2 ;
sig2 = 200 ;


csvwrite('svm_rbf_sv.csv',sv) ;
csvwrite('svm_rbf_coeffs.csv',coeffs) ;
csvwrite('svm_rbf_intercept.csv', intercept) ;
csvwrite('svm_rbf_tests.csv',tests) ;
csvwrite('svm_rbf_sig2.csv',sig2) ;

sol = zeros(num_tests,1) ;
transf_test = zeros(num_sv,1) ;
for idx1 = 1:1
    for idx2 = 1:num_sv
        transf_test(idx2) = exp(-sum((tests(idx1,:)-sv(idx2,:)).^2)/sig2)
    end
    sol(idx1) = transf_test'*coeffs
end

sol = sol + intercept ;

disp(sol) ;

end

