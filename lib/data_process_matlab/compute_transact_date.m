function [ transact_date ] = compute_transact_date(current_date, gap, post_or_pre)
% @return transact_date: the transaction date (bussiness day) which is several days before/after the current date.
%
% @param current_date
% @param gap: the number of days from current date to the target transaction date
% @param post_or_pre: whether we are interested in the date before/after 

    if strcmp(post_or_pre, 'post')
        step = 1;
    elseif strcmp(post_or_pre, 'pre')
        step = -1;
    end 
    transact_date = current_date;
    for k = 1:gap                     
        transact_date=datestr(busdate(transact_date, step));
    end
    
end

