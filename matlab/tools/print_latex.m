function  print_latex(tab)

fopen(1) ;
[num_rows, num_columns] = size(tab) ;


for idx_col = 1:num_columns
    for idx_rows = 1:num_rows
        if mod(tab(idx_rows,idx_col),1) == 0
            fprintf('%i',tab(idx_rows,idx_col)) ;
        else
            fprintf('%2.2f',tab(idx_rows,idx_col)) ;
        end
        fprintf(' & ') ;
    end
    fprintf('\\\\ \n') ;
end


end

