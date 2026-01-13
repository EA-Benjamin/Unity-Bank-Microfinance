# RISK PREDICTION ANALYSIS

This project analyzes customer loan for Unity microfinance bank.

## Objective
The goal of this project is to help Unity microfinance bank understand it's client repayment rate, factors influencing loan repayment (eg monthly income, loan size, age etc), and predict loan repayment probabilities 

## Tools Used
- SQL (MySQL) – Data exploration, Data cleaning, Data transformation
- Excel - Prediction analysis using logistic regression
- Tableau – Data visualization and dashboard creation
- Pdf – Business documentation and reporting

## Methodology
- Explored the nature of the dataset using statements like:
  describe data
  
- Performed Exploratory Data Analysis (EDA) and Data Quality Dimension (DQD) checks
  select Distinct gender from data, select * from data where age =''
  
- Cleaned and transformed the data using SQL queries
- Exported the cleaned dataset for visualization
- Carried out predictive model using regression in Microsoft Excel
- Built interactive Tableau dashboards to present insights and predict loan repayment

## Key Insights
Total loan disbursed: $2.583B 
• Total loan repaid: $818M 

• Unpaid balance: $1.764B 

• Default rate: 63.74% (Male: 64.42%, Female: 63.08%)

• Previous loan default was a huge factor influencing loan repayment. A previous loan default increase the probability of non-repayment for future loans.
Also, loan repayment tenure also had a negative effect on loan repayment i.e the longer the time to repay loan, the higher the probability of defaulting.

## Author
Emilefo Benjamin
