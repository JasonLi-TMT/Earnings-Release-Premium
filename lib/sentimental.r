#from textfile in csv to sentimental features

#变成循环
sentimental=function(){
  
    output=c()
    temp=c("df1.csv","df2.csv")
    #这个名字要变长～～ 全部的放这里
    
    for (i in 1:length(temp)) {
    
        news =read_excel(temp[i], header = TRUE)
        #news <- read_excel("~/Downloads/Tutorial2/doc/news.xlsx")
        speech.list=news
        
        
        sentence.list=NULL
        for(i in 1:nrow(speech.list)){
          sentences=sent_detect(speech.list$fulltext[i],
                                endmarks = c("?", ".", "!", "|",";"))
          if(length(sentences)>0){
            emotions=get_nrc_sentiment(sentences)
            word.count=word_count(sentences)
            # colnames(emotions)=paste0("emo.", colnames(emotions))
            # in case the word counts are zeros?
            emotions=diag(1/(word.count+0.01))%*%as.matrix(emotions)
            sentence.list=rbind(sentence.list, 
                                cbind(speech.list[i,-ncol(speech.list)],
                                      sentences=as.character(sentences), 
                                      word.count,
                                      emotions,
                                      sent.id=1:length(sentences)
                                      )
            )
          }
        }
        
        output[i,1]=sum(sentence.list$word.count)
        output[i,2]=sum(sentence.list$anger)
        output[i,3]=sum(sentence.list$anticipation)
        output[i,4]=sum(sentence.list$disgust)
        output[i,5]=sum(sentence.list$fear)
        output[i,6]=sum(sentence.list$joy)
        output[i,7]=sum(sentence.list$sadness)
        output[i,8]=sum(sentence.list$surprise)
        output[i,9]=sum(sentence.list$trust)
        output[i,10]=sum(sentence.list$negative)
        output[i,11]=sum(sentence.list$positive)
    }
}
