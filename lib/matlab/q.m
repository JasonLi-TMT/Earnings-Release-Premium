%% earning announcement data 
outputform = 'dd-mmm-yyyy';
earnings = readtable('06-17 Earnings release.xlsx'); 
earnings.Date = datetime(earnings.Date,'ConvertFrom','excel');
earnings.Date = datestr(earnings.Date,outputform);


%% for each annoucement, we need to know the date and ticker 
% earning announcement date 
announcementdate = cellstr(table2array( earnings(:,'Date')));

% extract & adjust the form of tickers from earning
tickers_earnings = table2array(earnings(:,'Ticker'));
[n_row, n_col] = size(earnings);
for i = 1:n_row
    ticker = tickers_earnings{i};
    ticker = strsplit(ticker, ' '); 
    ticker = ticker{1};
    tickers_earnings{i} = ticker;
end

%% try one indicator 
% read price to sales ratio 
ptsr = readtable('price_to_sales_ratio.xlsx'); 
ptsr.Date = datetime(ptsr.Date,'ConvertFrom','excel');
ptsr.Date = datestr(ptsr.Date,outputform);
ptsr.Date = datenum(ptsr.Date);

% extract & adjust the form of tickers and date from ptsr
tickers_ptsr = ptsr.Properties.VariableNames;
tickers_ptsr = tickers_ptsr(2:1001);
for i = 1:1000
    ticker_tmp = tickers_ptsr{i};
    ticker_tmp = ticker_tmp(1:length(ticker_tmp)-8);
    tickers_ptsr{i} = ticker_tmp;
end
ptsr.Properties.VariableNames = ['Date' tickers_ptsr];


%% desire matrix 39034*(6*4)
% for each announcement, we need to find the one with same sticker and date
% find the info of 6 days before and after announcement date for that
% sticker


%%
all_ret = nan(n_row, 24);
for i = 1:n_row
    if mod(i, 1000) == 0
        disp(i)
    end
    earning_date = announcementdate{i};
    ticker = tickers_earnings{i};
    ret_1earning = nan(6, 4);
    for gap = 1:6
        pre_earning_date = compute_transact_date(earning_date, gap, 'pre');
        post_earning_date = compute_transact_date(earning_date, gap, 'post');
        ret_1earning(gap, 1) = data_daylevel(pre_earning_date,ticker, ptsr); 
        ret_1earning(gap, 2) = data_daylevel(post_earning_date, ticker, ptsr);
        ret_1earning(gap, 3) = ret_1earning(gap, 1);
        ret_1earning(gap, 4) = ret_1earning(gap, 2);
    end
    all_ret(i, :) = ret_1earning(:);
end












