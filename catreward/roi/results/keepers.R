simple_dm_box <- c("box_value_acc", "box_value_acc_exp",
             "box_rpe_acc", "box_rpe_gl", 
             "box_rpe_acc_exp", "box_rpe_gl_exp", 
             "box_acc", "box_acc_exp", 
             "box_gl", "box_gl_exp")

simple_dm_nobox <- c("value_acc", "value_acc_exp", 
               "rpe_acc", "rpe_gl", 
               "rpe_acc_exp", "rpe_gl_exp", 
               "acc", "acc_exp", 
               "gl", "gl_exp")

sim <- c("box_exp", 
         "box_exp_exp_opp", 
         "box_exp_opp", 
         "box_gauss", 
         "box_gauss_gauss_opp", 
         "box_gauss_opp",
         "box_rdis")

response <- c
anarois <- c(
         "Cingulate_Gyrus_anterior_division",
         "Cingulate_Gyrus_posterior_division",
         "Cuneal_Cortex",
         "Frontal_Medial_Cortex",
         "Left_Accumbens",
         "Left_Caudate",
         "Left_Hippocampus",
         "Left_Putamen",
         "Middle_Frontal_Gyrus",
         "Precuneous_Cortex",
         "Right_Accumbens",
         "Right_Caudate",
         "Right_Hippocampus",
         "Right_Putamen",
         "Superior_Frontal_Gyrus")

anarois_bilat <- c(
         "Cingulate_Gyrus_anterior_division",
         "Cingulate_Gyrus_posterior_division",
         "Cuneal_Cortex",
         "Frontal_Medial_Cortex",
         "Accumbens",
         "Caudate",
         "Hippocampus",
         "Putamen",
         "Middle_Frontal_Gyrus",
         "Precuneous_Cortex",
         "Superior_Frontal_Gyrus")

#> source("~/Code/fmri/catreward/roi/results/analysis.R"); box_s <- analysis('box_s_roi_result_scores', keepbox)
#[1] "Overall mean AIC / BIC was 2092.84205124818 / 2158.05978586824"

# WINNER.
#> source("~/Code/fmri/catreward/roi/results/analysis.R"); box_c <- analysis('box_c_roi_result_scores', keepbox)
#[1] "Overall mean AIC / BIC was 2091.44741376874 / 2109.99653039484"

#> source("~/Code/fmri/catreward/roi/results/analysis.R"); nobox_s <- analysis('nobox_s_roi_result_scores', keepnobox)
#[1] "Overall mean AIC / BIC was 2091.88071870979 / 2131.01775572894"

#> source("~/Code/fmri/catreward/roi/results/analysis.R"); nobox_c <- analysis('nobox_c_roi_result_scores', keepnobox)
#[1] "Overall mean AIC / BIC was 2090.77879296868 / 2104.97846155837"

# ALSO TRY
#> source("~/Code/fmri/catreward/roi/results/analysis.R"); sub_c <- analysis('box_c_subtime_roi_result_scores', keepbox)
#[1] "Overall mean AIC / BIC was 2091.4116762478 / 2109.96079287388"

#> source("~/Code/fmri/catreward/roi/results/analysis.R"); fir_s <- analysis('box_s_fir_roi_result_scores', keepbox)
#[1] "Overall mean AIC / BIC was 2108.60876789308 / 2173.82650251314"
