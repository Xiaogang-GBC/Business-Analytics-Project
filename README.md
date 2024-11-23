# Output of Code Execution
[1] "Cleaned Dataset Summary:"
    REF_DATE        GEO             Age.group             Sex           
 Min.   :2018   Length:2520        Length:2520        Length:2520       
 1st Qu.:2019   Class :character   Class :character   Class :character  
 Median :2020   Mode  :character   Mode  :character   Mode  :character  
 Mean   :2020                                                           
 3rd Qu.:2021                                                           
 Max.   :2022                                                           
     VALUE       
 Min.   : 14.40  
 1st Qu.: 47.70  
 Median : 57.80  
 Mean   : 56.63  
 3rd Qu.: 68.50  
 Max.   :144.40  
[1] "\nNumber of observations after cleaning:"
[1] 2520
[1] "Summary Statistics:"
    REF_DATE        GEO             Age.group             Sex           
 Min.   :2018   Length:2520        Length:2520        Length:2520       
 1st Qu.:2019   Class :character   Class :character   Class :character  
 Median :2020   Mode  :character   Mode  :character   Mode  :character  
 Mean   :2020                                                           
 3rd Qu.:2021                                                           
 Max.   :2022                                                           
     VALUE       
 Min.   : 14.40  
 1st Qu.: 47.70  
 Median : 57.80  
 Mean   : 56.63  
 3rd Qu.: 68.50  
 Max.   :144.40  
[1] "\nUnique values in each category:"
[1] "Years covered:"
[1] 2018 2019 2020 2021 2022
[1] "\nGeographic regions:"
 [1] "Canada"                          "Atlantic provinces"             
 [3] "Newfoundland and Labrador"       "Prince Edward Island"           
 [5] "Nova Scotia"                     "New Brunswick"                  
 [7] "Quebec"                          "Ontario"                        
 [9] "Prairie provinces"               "Manitoba"                       
[11] "Saskatchewan"                    "Alberta"                        
[13] "British Columbia"                "Québec, Quebec"                 
[15] "Montréal, Quebec"                "Ottawa-Gatineau, Ontario/Quebec"
[17] "Toronto, Ontario"                "Winnipeg, Manitoba"             
[19] "Calgary, Alberta"                "Edmonton, Alberta"              
[21] "Vancouver, British Columbia"    
[1] "\nAge groups:"
[1] "15 years and over" "15 to 24 years"    "25 to 54 years"   
[4] "25 to 34 years"    "35 to 44 years"    "45 to 54 years"   
[7] "55 to 64 years"    "65 years and over"
[1] "Training set dimensions:"
[1] 2018    5
[1] "Testing set dimensions:"
[1] 502   5
[1] "Training Linear Regression Model..."
+ Fold1: intercept=TRUE 
- Fold1: intercept=TRUE 
+ Fold2: intercept=TRUE 
- Fold2: intercept=TRUE 
+ Fold3: intercept=TRUE 
- Fold3: intercept=TRUE 
+ Fold4: intercept=TRUE 
- Fold4: intercept=TRUE 
+ Fold5: intercept=TRUE 
- Fold5: intercept=TRUE 
Aggregating results
Fitting final model on full training set

Call:
lm(formula = .outcome ~ ., data = dat)

Residuals:
    Min      1Q  Median      3Q     Max 
-20.567  -2.910  -0.197   2.571  32.522 

Coefficients:
                                       Estimate Std. Error t value Pr(>|t|)    
(Intercept)                          -1.245e+03  1.653e+02  -7.530 7.66e-14 ***
REF_DATE                              6.291e-01  8.183e-02   7.688 2.34e-14 ***
`GEOAtlantic provinces`              -1.113e+01  7.405e-01 -15.036  < 2e-16 ***
`GEOBritish Columbia`                -5.232e+00  7.444e-01  -7.029 2.85e-12 ***
`GEOCalgary, Alberta`                 3.572e+00  7.505e-01   4.760 2.08e-06 ***
GEOCanada                            -5.007e+00  7.349e-01  -6.813 1.26e-11 ***
`GEOEdmonton, Alberta`               -1.086e+00  7.525e-01  -1.443  0.14915    
GEOManitoba                          -9.409e+00  7.570e-01 -12.428  < 2e-16 ***
`GEOMontréal, Quebec`                -6.948e+00  7.294e-01  -9.527  < 2e-16 ***
`GEONew Brunswick`                   -1.211e+01  7.406e-01 -16.348  < 2e-16 ***
`GEONewfoundland and Labrador`       -9.220e+00  7.429e-01 -12.411  < 2e-16 ***
`GEONova Scotia`                     -1.140e+01  7.506e-01 -15.191  < 2e-16 ***
GEOOntario                           -4.041e+00  7.313e-01  -5.526 3.70e-08 ***
`GEOOttawa-Gatineau, Ontario/Quebec`  3.810e+00  7.404e-01   5.145 2.93e-07 ***
`GEOPrairie provinces`               -2.359e+00  7.483e-01  -3.152  0.00164 ** 
`GEOPrince Edward Island`            -1.245e+01  7.384e-01 -16.858  < 2e-16 ***
GEOQuebec                            -8.696e+00  7.366e-01 -11.805  < 2e-16 ***
`GEOQuébec, Quebec`                  -3.484e+00  7.443e-01  -4.682 3.04e-06 ***
GEOSaskatchewan                      -6.092e+00  7.594e-01  -8.021 1.77e-15 ***
`GEOToronto, Ontario`                -3.120e+00  7.330e-01  -4.257 2.17e-05 ***
`GEOVancouver, British Columbia`     -3.667e+00  7.347e-01  -4.991 6.52e-07 ***
`GEOWinnipeg, Manitoba`              -8.380e+00  7.466e-01 -11.224  < 2e-16 ***
`Age.group15 years and over`          3.509e+01  4.622e-01  75.919  < 2e-16 ***
`Age.group25 to 34 years`             3.313e+01  4.580e-01  72.333  < 2e-16 ***
`Age.group25 to 54 years`             4.552e+01  4.611e-01  98.709  < 2e-16 ***
`Age.group35 to 44 years`             4.946e+01  4.573e-01 108.153  < 2e-16 ***
`Age.group45 to 54 years`             5.476e+01  4.644e-01 117.926  < 2e-16 ***
`Age.group55 to 64 years`             4.240e+01  4.602e-01  92.126  < 2e-16 ***
`Age.group65 years and over`          2.678e+01  4.624e-01  57.914  < 2e-16 ***
SexFemales                           -8.281e+00  2.822e-01 -29.344  < 2e-16 ***
SexMales                              8.550e+00  2.835e-01  30.159  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 5.181 on 1987 degrees of freedom
Multiple R-squared:  0.9258,    Adjusted R-squared:  0.9247 
F-statistic: 826.1 on 30 and 1987 DF,  p-value: < 2.2e-16

[1] "Training Random Forest Model..."
+ Fold1: mtry=2 
- Fold1: mtry=2 
+ Fold1: mtry=3 
- Fold1: mtry=3 
+ Fold1: mtry=4 
- Fold1: mtry=4 
+ Fold2: mtry=2 
- Fold2: mtry=2 
+ Fold2: mtry=3 
- Fold2: mtry=3 
+ Fold2: mtry=4 
- Fold2: mtry=4 
+ Fold3: mtry=2 
- Fold3: mtry=2 
+ Fold3: mtry=3 
- Fold3: mtry=3 
+ Fold3: mtry=4 
- Fold3: mtry=4 
+ Fold4: mtry=2 
- Fold4: mtry=2 
+ Fold4: mtry=3 
- Fold4: mtry=3 
+ Fold4: mtry=4 
- Fold4: mtry=4 
+ Fold5: mtry=2 
- Fold5: mtry=2 
+ Fold5: mtry=3 
- Fold5: mtry=3 
+ Fold5: mtry=4 
- Fold5: mtry=4 
Aggregating results
Selecting tuning parameters
Fitting mtry = 4 on full training set
  mtry
3    4
[1] "Training XGBoost Model..."
+ Fold1: eta=0.3, max_depth=1, gamma=0, colsample_bytree=0.6, min_child_weight=1, subsample=0.50, nrounds=150 
<ignored some warnings here>
- Fold5: eta=0.4, max_depth=3, gamma=0, colsample_bytree=0.8, min_child_weight=1, subsample=1.00, nrounds=150 
Aggregating results
Selecting tuning parameters
Fitting nrounds = 150, max_depth = 3, eta = 0.4, gamma = 0, colsample_bytree = 0.8, min_child_weight = 1, subsample = 1 on full training set
    nrounds max_depth eta gamma colsample_bytree min_child_weight subsample
108     150         3 0.4     0              0.8                1         1
[1] "Model Performance Metrics:"
                     Model     RMSE R_squared
lm.RMSE  Linear Regression 6.133420 0.8977453
rf.RMSE      Random Forest 9.789834 0.8085754
xgb.RMSE           XGBoost 4.531073 0.9452666
Saving 7 x 7 in image
> 
