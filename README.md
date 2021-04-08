# powerpriors
Testing power priors for use with Multilevel Regression and Poststratification (MRP). 

Here MRP is being used to forecast vote share for Conservative Party in each UK electoral district (Constituency). The model uses survey data (Vote intention, Age, Education and Gender) as well as auxiallry data for each electoral district (Past vote share and Population density). 

This is a test to see whether it is possible - and to what extent we can improve accuracy - by using power priors with MRP. 

Accuracy here is the difference between estimates and actual vote for Conseravtive party in 2017. Accuracy measured with MAE and RMSE. 

Scripts are as follows: 

00_Utility
Includes functions called in code.
- Poststratification fucntion: this takes stan model and predicts with new data (i.e. the postratification frame). The function produces estiamtes of Conservative vote share in each UK small area (constituency), along with MAE and RMSE. This is a very slow function, as I manually sample from the model posterior for each parameter. In future versions I would poststratify directly in stan model generated quantities. Along these lines: https://mc-stan.org/docs/2_26/stan-users-guide/coding-mrp-in-stan.html

- Data_prep: this siimply loads current and historic data and prepares in correct format. The only input required for function is the scaling constant. 

01_Baseline model
Here I run a simple hierarchcial logistic model, calling stan_baseline model. Has weakly informative - normal(0,5)- priors on all parameters. 

02_Power priros
Here i run three Power Prior models. The models are identical to baseline mdoel, except for the power priros. 

03_Poststratification
Poststratify, i.e. produce small area estiamtes of Conserative Party vote share.

04_Accuracy_comparison
Merge all results into one frame and compare MAE and RMSE for all models. The results seem to indicate no benefit to using power priros. 

