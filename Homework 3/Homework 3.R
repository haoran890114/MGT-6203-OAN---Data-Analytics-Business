setwd("C:/Users/D100793/Desktop/Georgia Tech/MGT 6203 OAN Data Analytics Business/Homework 3")

#DataExplorer package for exploratory data analysis 
#Useful Documentation- https://cran.r-project.org/web/packages/DataExplorer/vignettes/dataexplorer-intro.html
if (!require(DataExplorer)) install.packages("DataExplorer")
library(DataExplorer)

#dplyr - Data Wrangling Package. Check R Learning Guide for resources to quickly learn dplyr
if (!require(dplyr)) install.packages("dplyr")
library(dplyr)
data <- read.csv("KAG_data.csv", stringsAsFactors = FALSE)

data <- data %>% mutate(CTR = round(((Clicks / Impressions) * 100),4), 
                        CPC = ifelse(Clicks != 0, round(Spent / Clicks,4), Spent), 
                        CostPerConv_Total = ifelse(Total_Conversion !=0,round(Spent/Total_Conversion,4),Spent),
                        CostPerConv_Approved = ifelse(Approved_Conversion !=0,round(Spent/Approved_Conversion,4),Spent),
                        CPM = round((Spent / Impressions) * 1000, 2) )




#Q.1 Which ad (provide ad_id as the answer) among the ads that have the least CPC led to the most impressions?

q1 <- dplyr::arrange(data,CPC,desc(Impressions))
head(q1$ad_id,1)
# Answer 1121094


#Q.2 What campaign (provide compaign_id as the answer) had spent least efficiently on brand awareness on an average
#(i.e. most Cost per mille or CPM: use total cost for the campaign / total impressions in thousands)?

q2 <- dplyr::arrange(data,desc(CPM))
head(q2$campaign_id,1)
# Answer 936



##Q.3 Assume each conversion ('Total_Conversion') is worth $5, each approved conversion ('Approved_Conversion') is worth $50. ROAS (return on advertising spent) is revenue as a percentage of the advertising spent . 
##Calculate ROAS and round it to two decimals.
##Make a boxplot of the ROAS grouped by gender for interest = 15, 21, 101 (or interest_id = 15, 21, 101) in one graph. 
##Also try to use the function '+ scale_y_log10()' in ggplot to make the visualization look better 
##(to do so, you just need to add '+ scale_y_log10()' after your ggplot function). 
##The x-axis label should be 'Interest ID' while the y-axis label should be ROAS.  [8 points]

##HW3_Pt2_Q3_Hint

data <- data %>% mutate(ROAS = ifelse(Spent !=0.00,round((5.00*Total_Conversion +50.00*Approved_Conversion)/Spent*1.00,2),0.00))




##Q.4 Summarize the median and mean of ROAS by genders when campign_id == 1178.

q4 <- data %>% filter(campaign_id == 1178 ) %>% group_by(gender) %>% summarise(ROAS_Mean = mean(ROAS), ROAS_Median = median(ROAS))
  
#gender ROAS_Mean ROAS_Median
#<int>     <dbl>       <dbl>
#  1      0      2.49        1.13
#2      1      1.56        0.7 


if (!require(readr)) install.packages("readr")
library(readr)
if (!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)
if (!require(correlationfunnel)) install.packages("correlationfunnel")
library(correlationfunnel)
if (!require(DataExplorer)) install.packages("DataExplorer")
library(DataExplorer)
if (!require(WVPlots)) install.packages("WVPlots")
library(WVPlots)
if (!require(ggthemes)) install.packages("ggthemes")
library(ggthemes) 
if (!require(ROCR)) install.packages("ROCR")
library(ROCR)
if (!require(caret)) install.packages("caret")
library(caret)
if (!require(corrplot)) install.packages("corrplot")
library(corrplot)


advertising <- read.csv("advertising1.csv", stringsAsFactors = FALSE)
head(advertising,1)
#changing datatype to factor
advertising$Clicked.on.Ad <- as.factor(advertising$Clicked.on.Ad)
sapply(advertising, class)

#Q.5
#a) We aim to explore the dataset so that we can better choose a model to implement. 
#Plot histograms for at least 2 of the continuous variables in the dataset.
#Note it is acceptable to plot more than 2. [1 point]


hist(advertising$Area.Income)
hist(advertising$Daily.Internet.Usage)




#c) Plot boxplots for Age, Area.Income, Daily.Internet.Usage and Daily.Time.Spent.on.Site separated by the variable Clicked.on.Ad. 
#To clarify, we want to create 4 plots, each of which has 2 boxplots: 1 for people who clicked on the ad, 
#one for those who didn't. [2 points]


#Age vs Clicked On Ad
ggplot(data = advertising, mapping = aes(x = Clicked.on.Ad, y = Age)) + geom_boxplot() + labs(title = "Age vs Clicked On Ad")

#Area Income vs Clicked On Ad

ggplot(data = advertising, mapping = aes(x = Clicked.on.Ad, y = Area.Income)) + geom_boxplot() + labs(title = "Area Income vs Clicked On Ad")

#Daily Internet Usage vs Clicked On Ad
ggplot(data = advertising, mapping = aes(x = Clicked.on.Ad, y = Daily.Internet.Usage)) + geom_boxplot() + labs(title = "Daily Internet Usage vs Clicked On Ad")

#Daily Time Spent on Site vs Clicked On Ad
ggplot(data = advertising, mapping = aes(x = Clicked.on.Ad, y = Daily.Time.Spent.on.Site)) + geom_boxplot() + labs(title = "Daily Time Spent on Site vs Clicked On Ad")

#d) Based on our preliminary boxplots, would you expect an older person to be more likely to 
#click on the ad than someone younger? [2 points]

#Age vs Clicked On Ad
ggplot(data = advertising, mapping = aes(x = Clicked.on.Ad, y = Age)) + geom_boxplot()

## Looking at the Age vs Clicked On Ad Box Plot below, the median age of users clicking the Ad is higher than the Median age of users 
#not clicking the AD.The maximum age for users clicking the Ad is also higher than that of the ones not clicking the AD when outliers are ignored.
#From this we can conclude that the tendency of older person clicking the AD is higher.



#Q.6
#Part (a) [3 points]
#1. Make a scatter plot for Area.Income against Age. 
#Separate the datapoints by different shapes based on if the datapoint has clicked on the ad or not.

ggplot(data = advertising, mapping = aes(x = Age, y = Area.Income)) + geom_point(aes(shape = Clicked.on.Ad, color = Clicked.on.Ad))  + labs(title = "Age Vs. Area Income")

#2. Based on this plot, would you expect a 31-year-old person with an Area income of $62,000 to click on the ad or not?
# NO . Looking at the scatterplot, we observe that from the Age Group between 30 to 35 and income above 60,000, the number of clicks 
# ad has reduced. So I would not expect a 31-year-old person with an Area income of $62,000 to click on the ad.

#Q.6
#Part (b)
#1. Similar to part a), create a scatter plot for Daily.Time.Spent.on.Site against Age. 
#Separate the datapoints by different shapes based on if the datapoint has clicked on the ad or not.


ggplot(data = advertising, mapping = aes(x = Age, y = Daily.Time.Spent.on.Site)) + geom_point(aes(shape = Clicked.on.Ad, color = Clicked.on.Ad))  + labs(title = "Age Vs. Daily Time Spent on Site")


#2. Based on this plot, 
#would you expect a 50-year-old person who spends 60 minutes daily on the site to click on the ad or not?
#Yes.



