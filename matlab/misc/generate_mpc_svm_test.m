function [sol] = generate_mpc_svm_test(num_tests, num_features)
%GENERATE_SVM_TEST
%
% Author: Henri De Plaen, KU Leuven

if nargin==0
    num_tests = 200 ;
    num_features = 15 ;
end

coeffs = randi([-100 100],num_features+1,1)/100 ;
intercept = coeffs(end) ;
coeffs = coeffs(1:end-1) ;
tests = randi([-100 100],num_tests,num_features)/100 ;

csvwrite('svm_coeffs.csv',coeffs) ;
csvwrite('svm_intercept.csv', intercept) ;
csvwrite('svm_tests.csv',tests) ;

sol = zeros(num_tests,1) ;
for idx = 1:num_tests
    sol(idx) = tests(idx,:)*coeffs ;
end

sol = sol + intercept ;

disp(sol) ;

end

