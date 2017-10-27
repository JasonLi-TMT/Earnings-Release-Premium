# Project Title: Earnings Release Premium Strategy 

+ Project summary: Using the stock market data and data science methodologies (including NLP, predictive modeling and classification model ) to generate strategy. Major steps are: 
	+ Select the major investing horizon as the days befor and after earning release. 
	+ Using a classification model to predict whether it would be a wise choice to long or short. 
	+ Using NLP to use the related earning release date information, building up the advanced model on how to trade.
	
+ Executive Summary: We combined core value of 8 published articles related to Earnings Release and improve it with machine learning strategy. Finally, we got two models: 
	+ long-before earning release
	+ short-after earning release
 
+ The model is based on one assumption:
	+ Before earning release, stocks with strong momentum will attract people to buy since people believe that the Earnings Report exceed expectations, the price will increase in a short period. And after earning release, some people will cash in and the price will drop in a short period. In summary, long before Earning release, short after it.
 
+ Our model could tell you, if you long the stock before earning announcement, whether you could a positive return. If you short the stock after earning announcement, whether you could get a positive return.
 
+ Initially, we use 1000 stocks data in 10 years, got 963 K observation and use forward stepwise to select the most important two factors which are momentum. This step is to find a pattern of stocks which are sensitive to Earning announcement.

+ Based on the pattern we found in step 1, we selected fewer observations and use machine learning model to do classification and got 0.88 accurate rate with Random Forest

**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
