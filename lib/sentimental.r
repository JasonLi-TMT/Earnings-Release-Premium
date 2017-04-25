#from textfile in csv to sentimental features

library(syuzhet)

  temp=read_excel("news0216-0228.xlsx")
  colnames(temp)=c("date","fulltext")
  
  output=rep(NA,length(temp$date))
  output=data.frame(output,output,output,output,output,output,output,output,output,output,output,output)
  
  speech.list=temp
    
    sentence.list=NULL
    for(i in 1:nrow(speech.list)){
      emotions=get_nrc_sentiment(speech.list$fulltext[i])
      output[i,1]=word_count(speech.list$fulltext[i])
      #word.count=word_count(speech.list$fulltext[i])
      #emotions=diag(1/(word.count+0.01))%*%as.matrix(emotions)
      output[i,2]=(emotions$anger)/output[i,1]
      output[i,3]=(emotions$anticipation)/output[i,1]
      output[i,4]=(emotions$disgust)/output[i,1]
      output[i,5]=(emotions$fear)/output[i,1]
      output[i,6]=(emotions$joy)/output[i,1]
      output[i,7]=(emotions$sadness)/output[i,1]
      output[i,8]=(emotions$surprise)/output[i,1]
      output[i,9]=(emotions$trust)/output[i,1]
      output[i,10]=(emotions$negative)/output[i,1]
      output[i,11]=(emotions$positive)/output[i,1]
      output[i,12]=speech.list$date[i]
      }

