#from textfile in csv to sentimental features

library(syuzhet)

  #temp=read_excel("news0216-0228.xlsx",col_names = FALSE)
  #temp=read_excel("news050116-022817.xlsx",col_names = FALSE)
  temp <- read_excel("~/Downloads/Tutorial2/doc/news data-2.xlsx", sheet = "HL", col_names = FALSE)
  colnames(temp)=c("date","fulltext")
  
  output=rep(NA,length(temp$date))
  output=data.frame(output,output,output,output,output,output,output,output,output,output,output,output)
  colnames(output)=c("date","word_count","anger", "anticipation", "disgust", "fear" ,"joy" ,"sadness", "surprise","trust", "negative", "positive")
  speech.list=temp
    
    sentence.list=NULL
    for(i in 1:nrow(speech.list)){
      emotions=get_nrc_sentiment(speech.list$fulltext[i])
      output[i,2]=word_count(speech.list$fulltext[i])
      #word.count=word_count(speech.list$fulltext[i])
      #emotions=diag(1/(word.count+0.01))%*%as.matrix(emotions)
      output[i,3]=(emotions$anger)
      output[i,4]=(emotions$anticipation)
      output[i,5]=(emotions$disgust)
      output[i,6]=(emotions$fear)
      output[i,7]=(emotions$joy)
      output[i,8]=(emotions$sadness)
      output[i,9]=(emotions$surprise)
      output[i,10]=(emotions$trust)
      output[i,11]=(emotions$negative)
      output[i,12]=(emotions$positive)
      output[i,1]=as.character(speech.list$date[i])
    }
    zhengli=rep(0,length(unique(output$date)))
    zhengli=data.frame(zhengli,zhengli,zhengli,zhengli,zhengli,zhengli,zhengli,zhengli,zhengli,zhengli,zhengli,zhengli)
    zhengli[,1]=unique(output$date)
    colnames(zhengli)=c("date","word_count","anger", "anticipation", "disgust", "fear" ,"joy" ,"sadness", "surprise","trust", "negative", "positive")
    for(i in 1:nrow(zhengli)){
      token=zhengli[i,1]
      
      for(j in 1:nrow(output)){
        if(output[j,1]==token){
          zhengli[i,2]=zhengli[i,2]+output[j,2]
          zhengli[i,3]=zhengli[i,3]+output[j,3]
          zhengli[i,4]=zhengli[i,4]+output[j,4]
          zhengli[i,5]=zhengli[i,5]+output[j,5]
          zhengli[i,6]=zhengli[i,6]+output[j,6]
          zhengli[i,7]=zhengli[i,7]+output[j,7]
          zhengli[i,8]=zhengli[i,8]+output[j,8]
          zhengli[i,9]=zhengli[i,9]+output[j,9]
          zhengli[i,10]=zhengli[i,10]+output[j,10]
          zhengli[i,11]=zhengli[i,11]+output[j,11]
          zhengli[i,12]=zhengli[i,12]+output[j,12]
        }
      }
    }
