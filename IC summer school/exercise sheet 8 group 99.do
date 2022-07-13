use "icfforworkbook_3.dta", clear

*2a
gen exp1=exp/1000
reg exp1 lincome size maininc ib1.region
predict res, residual
predict fit, xb
gen fitsq = fit^2
gen fitcu = fit^3
gen fitqa = fit^4
reg res lincome size maininc ib1.region fitsq fitcu fitqa
test fitsq fitcu fitqa
*2b
reg exp1 lincome size maininc ib1.region fitsq fitcu fitqa
test fitsq fitcu fitqa
* because suppose there is misspecification Y=ax+e in the original regression, so E(Y|X)= ax+e, e= bx + δ1*fitsq+δ2*fitcu+δ3*fitqa. So in the (a) we regress e=bx+ δ1*fitsq+δ2*fitcu+δ3*fitqa. In (b), we simply have Y=(a+b)x+δ1*fitsq+δ2*fitcu+δ3*fitqa. Because of collinearity, test δ1=δ2=δ3=0 have the same result.
*2c
reg exp1 linc size maininc ib1.region
ovtest
* In all of (a) (b) (c), we reject the H0 (H0: Model has no omitted variables) and say there is a misspecification of the model.
*2d
gen ressq = res^2
gen lincomesq=lincome^2
reg ressq lincome size maininc ib1.region lincomesq sizesq
test lincome size maininc 2.region 3.region 4.region 5.region 6.region lincomesq sizesq
reg exp1 lincome size maininc ib1.region
hettest (lincome size maininc 2.region 3.region 4.region 5.region 6.region lincomesq sizesq), rhs fstat
*2e
reg ressq fit
test fit
reg exp1 lincome size maininc ib1.region
hettest, fstat
*2f
reg ressq fit
scalar nr2=e(N)*e(r2)
scalar list nr2
reg exp1 lincome size maininc ib1.region
ivhettest, fitlev nr2
*2g
reg exp1 lincome size maininc ib1.region, robust
reg exp1 lincome size maininc ib1.region
* from this we can see that the robust standard errors are different from the OLS standard errors, this is because of the heteroscedasticity that we tested from (d) and (e). (in (d) and (e), we rejected the H0 (H0: Constant variance - homoskedasticity))
*2h
sktest res
kdensity res, normal
*The residuals from (1) is right skewed comparing with normal distribution 


use "AngristKrueger91.dta", clear
*3a
ivreg2 LWKLYWGE AGEQ YR20 YR21 ( EDUC = QTR1_20 QTR1_21 QTR2_20 QTR2_21 QTR3_20 QTR3_21 ), first
reg LWKLYWGE EDUC AGEQ YR20 YR21
* By comparing the IV estimation and the OLS estimation, we can find that the coefficients for independent variables are different, which is caused by the endogeneity of the variable EDUC.
*3b
ivreg2 LWKLYWGE AGEQ YR20 YR21 ( EDUC = QTR1_20 QTR1_21 QTR2_20 QTR2_21 QTR3_20 QTR3_21 ), first
predict res_iv, residuals
reg res_iv QTR1_20 QTR1_21 QTR2_20 QTR2_21 QTR3_20 QTR3_21 AGEQ YR20 YR21
test QTR1_20 QTR1_21 QTR2_20 QTR2_21 QTR3_20 QTR3_21
return list
scalar J=r(F)*r(df)
scalar list
display chi2tail(5,J)
* We do not reject the null hypothesis (H0: exogeneity of instuments), so instrument exogeneity condition satisfied.
*3c
reg EDUC AGEQ YR20 YR21 QTR1_20 QTR1_21 QTR2_20 QTR2_21 QTR3_20 QTR3_21
predict res_ir, residuals
reg LWKLYWGE res_ir EDUC AGEQ YR20 YR21
test res_ir