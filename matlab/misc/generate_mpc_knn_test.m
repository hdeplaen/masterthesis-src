function [best_class, best_dist] = generate_mpc_knn_test(feature_size, num_sample, num_classes)
%GENERATE_KNN_TEST
%
% Author: Henri De Plaen, KU Leuven

vecs = randi([-100 100],num_sample,feature_size)/100 ;      % training vectors
classes = randi([1 num_classes],num_sample,1) ;             % training classes
test_vec = randi([-100 100],1,feature_size)/100 ;           % testing vector

csvwrite('training_vec.csv',vecs) ;
csvwrite('training_classes.csv', classes) ;
csvwrite('testing_vec.csv',test_vec) ;

dist = (vecs(:,1)-test_vec(1)).^2 + (vecs(:,2)-test_vec(2)).^2 ;
[best_dist,idx_min] = min(dist) ;

best_class = classes(idx_min) ;

disp(best_class) ;
disp(best_dist) ;

end

