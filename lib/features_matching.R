load('fin_feature.Rdata')
load('text_feature.Rdata')


### Aggregrate text & numerical features together
# Load all data & do basic cleaning
# setwd('/Users/AaronWang/Desktop/NEWS')
# AKS = read.table('AKS.txt', header = T, sep = ',', as.is = T)
# AMD = read.table('AMD.txt', header = T, sep = ',', as.is = T)
# CLF = read.table('CLF.txt', header = T, sep = ',', as.is = T)
# EXEL = read.table('EXEL.txt', header = T, sep = ',', as.is = T)
# NVDA = read.table('NVDA.txt', header = T, sep = ',', as.is = T)
# PES = read.table('PES.txt', header = T, sep = ',', as.is = T)
# TROX = read.table('TRDX.txt', header = T, sep = ',', as.is = T)
# UNT = read.table('UNT.txt', header = T, sep = ',', as.is = T)
# X_news = read.table('X.txt', header = T, sep = ',', as.is = T)
# AROC = read.table('AROC.txt', header = T, sep = ',', as.is = T)
# ARRY = read.table('ARRY.txt', header = T, sep = ',', as.is = T)
# CDE = read.table('CDE.txt', header = T, sep = ',', as.is = T)
# FCX = read.table('FCX.txt', header = T, sep = ',', as.is = T)
# HL = read.table('HL.txt', header = T, sep = ',', as.is = T)
# MEET = read.table('MEET.txt', header = T, sep = ',', as.is = T)
# SN = read.table('SN.txt', header = T, sep = ',', as.is = T)
# SXC = read.table('SXC.txt', header = T, sep = ',', as.is = T)
# TRGP = read.table('TRGP.txt', header = T, sep = ',', as.is = T)
# tx_feature = list(EXEL, CLF, PES, AKS, AMD, X_news, UNT, NVDA, TROX, CDE, FCX, ARRY, AROC, SXC, SN, CDE, TRGP, CDE, MEET, HL)
# save(tx_feature, file = 'text_feature.Rdata')
#
# setwd('/Users/AaronWang/Desktop/raw_data')
# earning = read.xls('06-17 Earnings release.xlsx', sheet = 1, header = T, as.is = T)
# earning.sub = earning[,c('Ticker', 'Date', 'Estimate', 'Surprise')]
# earning.sub$Ticker = as.character(earning.sub$Ticker)
# earning.sub$Date = as.character(earning.sub$Date)
# earning.sub$Ticker = substr(earning.sub$Ticker, 0, nchar(as.character(earning.sub$Ticker))-3)
# dy = read.xls("dy.xlsx", sheet = 1, header = F, as.is = T)
# ebitg = read.xls("ebitg.xlsx", sheet = 1, header = T, as.is = T)
# ev2ebitda = read.xls("ev2ebitda.xlsx", sheet = 1, header = T, as.is = T)
# m2b = read.xls("m2b.xlsx", sheet = 1, header = T, as.is = T)
# pb = read.xls("pb.xlsx", sheet = 1, header = T, as.is = T)
# pe = read.xls("pe.xlsx", sheet = 1, header = T, as.is = T)
# pf = read.xls("pf.xlsx", sheet = 1, header = T, as.is = T)
# ps = read.xls("ps.xlsx", sheet = 1, header = T, as.is = T)
# price = read.xls('closing_price.xlsx', sheet = 1, header = T, as.is = T)
# col.name = colnames(dy)
# colnames(ebitg) = col.name
# a = colnames(ev2ebitda)
# colnames(ev2ebitda) = c('date', substr(a[-1], 0, nchar(a[-1])-10))
# colnames(m2b) = col.name
# colnames(pb) = col.name
# colnames(pe) = col.name
# colnames(pf) = col.name
# colnames(ps) = col.name
# colnames(price) = col.name


### Select 20 stocks with the highest momentum
# mom = read.csv('momentum.csv', header = F)
# mom = - mom
N = nrow(mom)
sel = 35659:39034 # start from 05/01/2016 due to data availability
earning.sel = earning[sel,]
mom.sel = mom[sel,'V25']
tickers.sel = gsub(' US', '', as.character(earning.sel$Ticker))
ord.momen = order(mom.sel, decreasing = T)
tickers20 = as.character(tickers.sel[ord.momen[1:20]]) 
dates20 = as.character(earning.sel$Date[ord.momen[1:20]]) 
earning20 = data.frame(ticker = tickers20, date = dates20, stringsAsFactors = F)
# save(earning.sub, mom, dy, ebitg, ev2ebitda, m2b, pb, pe, pf, ps, price, file = 'fin_feature.Rdata')


### Core function to aggrerate data
getdata = function(tk, tx_df, dt, row_in_momen){
    # tk: stock ticker; 
    # tx_df: data.frame storing features generate from text; 
    # dt: date of the earning anouncement day
    tx_df = data.frame(ticker = tk, tx_df)
    dates = tx_df$date
    idxs = c()
    for (d in dates)
        idxs = c(idxs, which(dy$date == d))
    dy0 = as.numeric(dy[idxs, tk])
    ebitg0 = as.numeric(ebitg[idxs, tk])
    ev2ebitda0 = as.numeric(ev2ebitda[idxs, tk])
    m2b0 = as.numeric(m2b[idxs, tk])
    pb0 = as.numeric(pb[idxs, tk])
    pe0 = as.numeric(pe[idxs, tk])
    pf0 = as.numeric(pf[idxs, tk])
    ps0 = as.numeric(ps[idxs, tk])
    tx_df = data.frame(tx_df, dy = dy0, ebitg = ebitg0, ev2ebitda = ev2ebitda0, m2b = m2b0, pb = pb0, pe = pe0, pf = pf0, ps = ps0)
    
    mom0 = unname(unlist(mom[row_in_momen,c(1:6, 25, 7:12)]))
    dts = as.Date((dt-6):(dt+6), origin = "1970-01-01")
    df.mom0 = data.frame(mom = mom0, date = as.character(dts), days = -6:6, stringsAsFactors = F)
    days_from_earning_day = -6
    tx_df = merge(tx_df, df.mom0)
    
    # Compute & append estimate
    est_earning = as.character(earning.sub[row_in_momen, 'Estimate'])
    est_earning = gsub(',', '', est_earning)
    est_earning = gsub('\\(', '', est_earning)
    est_earning = gsub('\\)', '', est_earning)
    est_earning = as.numeric(est_earning)
    est_earning = rep(est_earning, nrow(tx_df))
    tx_df = data.frame(tx_df, est_earning = est_earning)
    
    # Compute & append surprise
    # surprise = as.character(earning.sub[earning.sub$Ticker == tk & as.Date(earning.sub$Date, origin = ori, format = '%m/%d/%Y') == dt, 'Surprise'])
    surprise = as.character(earning.sub[row_in_momen, 'Surprise'])
    surprise = gsub(',', '', surprise)
    surprise = gsub('\\(', '', surprise)
    surprise = gsub('\\)', '', surprise)
    surprise = as.numeric(surprise)
    surprise = rep(surprise, nrow(tx_df))
    tx_df = data.frame(tx_df, surprise = surprise)
    
    # Calculate return
    # 1. Add prices of the dates with text data
    tx_dts = tx_df$date
    p_list = c()
    for (d in tx_dts){
        p_list = c(p_list, price[price$date == d, tk])
    }
    # 2. Add one more non-NA price on both sides of the current price sequence
    nx_dt = dates_in_range[length(dates_in_range)] + 1
    while (is.na(price[price$date == nx_dt, tk]))
        nx_dt = nx_dt + 1
    p_list = c(p_list, price[price$date == nx_dt, tk])
    pr_dt = dates_in_range[1] - 1
    while (is.na(price[price$date == pr_dt, tk]))
        pr_dt = pr_dt - 1
    p_list = c(price[price$date == pr_dt, tk], p_list)
    # 3. Compute return
    return_01 = rep(NA, length(p_list)-1)
    i = 2
    while (i <= length(p_list)){
        if (is.na(p_list[i])){
            i2 = i + 1
            while (is.na(p_list[i2]))
                i2 = i2 + 1
            label = p_list[i2]/p_list[i-1] - 1
            for (j in i:i2)
                return_01[j-1] = label
            i = i2 + 1
        }
        else{
            return_01[i-1] = p_list[i]/p_list[i-1] - 1
            i = i + 1
        }
    }
    tx_df = data.frame(tx_df, ret_yesterday = return_01[-(length(return_01))], y.return01 = as.numeric(return_01[-1] > 0))
    
    # Drop features with too many NaN values
    drops_col = c('ebitg')
    return(tx_df[,!(names(tx_df) %in% drops_col)])
}

all.df = data.frame()
for (i in 1:20){
    tk = earning20$ticker[i]
    dt = as.Date(earning20$date[i], origin="1970-01-01", format = '%m/%d/%Y')
    row_in_momen = ord.momen[i] + 35659 - 1
    all.df = rbind(all.df, getdata(tk, tx_feature[[i]][,-1], dt, row_in_momen))
}

write.csv(all.df, 'all_features4.csv')
