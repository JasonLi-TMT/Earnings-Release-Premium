function [ ret_val ] = data_daylevel(start_date,security_ticker, security_dataset)
% @return ret_val day-level-data of the transaction of a given security
%
% @param start_date: the start & ending date of the transaction. data type: datetime.
% @param security_ticker: the ticker of the security we are interested in.
% @param security_dataset: the whole dateset to retreat the price data. 
%
% Example: data_daylevel('15-Apr-2009', 'CHK', stocks_data)
    
    ticker_exist = sum(strcmp(security_ticker, security_dataset.Properties.VariableNames));
    if ~ticker_exist
        ret_val = nan;
        return
    end
    start_info = table2array(security_dataset(security_dataset.Date == start_date, security_ticker));
    if isempty(start_info)
        ret_val = nan;
        return
    end
    ret_val = start_info;
 
    
end

