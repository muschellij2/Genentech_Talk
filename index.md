---
title: 'Robust Lesion Segmentation on MRI of Patients with Multiple Sclerosis'
author: "John Muschelli, PhD - Johns Hopkins Bloomberg School of Public Health<br/> http://johnmuschelli.com/Genentech_Talk_MS.html"
date: "April 30, 2018"
output:
  ioslides_presentation:
    css: custom.css
    keep_md: yes
    mathjax: local
    self_contained: no
    widescreen: yes
bibliography: refs.bib
---


<script type="text/x-mathjax-config">
MathJax.Hub.Config({ TeX: { extensions: ["color.js"] }});
</script>













## Overview of Work/Research

<div style='font-size: 28pt;'>
- Segmentation/Classification of:
    - White Matter Lesions in Multiple Sclerosis
    - Brain vs. Skull (CT)
    - Brain Hemorrhage/Stroke (CT) 
- R Package Development/"Data Science"
- Neuroimaging and R (Neuroconductor Project)
</div>

## Overview of Work/Research

<div style='font-size: 28pt;'>
- Segmentation/Classification of:
    - **White Matter Lesions in Multiple Sclerosis**
    - Brain vs. Skull (CT)
    - Brain Hemorrhage/Stroke (CT) 
- R Package Development
- Neuroimaging and R (Neuroconductor Project)
</div>


# Lesion Segmentation of MS

## Public Dataset with Lesion Segmentation

* "A novel public MR image dataset of multiple sclerosis patients with lesion segmentations based on multi-rater consensus" [@msdata]
  - Data Published at http://lit.fe.uni-lj.si/tools.php?lang=eng
  - 30 subjects with MRI (3T Siemens Trio)
  - Manually segmented by 3 expert raters 
  - Creative-Commons Attribution (CC-BY)
  
## Demographic Data

<div id="wrap">
<div id="left_col">

Variable                       Overall       
-----------------------------  --------------
n                              30            
Age (mean (sd))                39.27 (10.12) 
EDSS (mean (sd))               2.61 (1.88)   
Lesion_Volume (mean (sd))      17.40 (16.13) 
MS_Subtype (%)                               
Clinically Isolated Syndrome   2 (6.7)       
Progressive-relapsing          1 (3.3)       
Relapsing-remitting            24 (80.0)     
Secondary-progressive          2 (6.7)       
Unspecified                    1 (3.3)       
sex = M (%)                    7 (23.3)      
</div>
<div id="right_col"  style='font-size: 24pt;'>

- On many different therapies (9 no therapy)
- Relatively young (so WML not likely due to aging)

</div>

</div>

## Imaging Data

* 2D T1 (TR=2000ms, TE=20ms, TI=800ms) and after gadolinium
* 2D T2 (TR=6000ms, TE=120ms), 3D FLAIR (TR=5000ms, TE=392ms, TI=1800 ms)
    - Fluid attenuated inversion recovery - reduce signal of fluids
- All had flip angle of 120$^{\circ}$

</div>
<div>
<img src="figure/overlay.png" style="width:100%;  display: block; margin: auto;" alt="OVERLAY">
</div>


<!-- The obtained median DSC values were 0.85 and 0.82 for -->
<!-- intra- and inter-rater variability using manual tools, while -->
<!-- the respective values obtained with the semi-automated -->
<!-- tools were 0.92 and 0.89. -->




## Terminology: Neuroimaging to Data/Statistics

<div style="font-size: 26pt">
* Segmentation ⇔ classification 
* Image ⇔ 3-dimensional array
* Mask/Region of Interest ⇔ binary (0/1) image 
* Registration ⇔  Spatial Normalization/Standarization
    - "Lining up" Brains
</div>


# An Image Processing Pipeline in R



## Image Representation: voxels (3D pixels)
<div class="columns-2">
<img src="figure/Zoom_Ventricle.png"  style="width:100%;  display: block; margin: auto;">
<br>
<img src="figure/movie_final.gif" style="width:80%;  inline; display: block; margin: auto;" loop=infinite>

<p style='font-size: 10pt;'></p>
</div>

## Step 1: Create Predictors for each Sequence <img src="figure/ms_covariates.png" style="width:75%; display: block; margin: auto;" alt="Preds">  

## Data Structure for One Patient <br/> <img src="figure/ms_voxel_stacking.png" style="width:70%;  display: block; margin: auto;" alt="MISTIE LOGO">  

---

<div class="container"> 
<div id="left_col2"> 
  <h2>Step 2: Aggregate Data</h2>
  Training Data Structure
  
  * Stack together 15 randomly selected patients
  * Train model/classifier on this design matrix
  
  </div>    
  <div id="right_col2">
  <img src="figure/Large_Design_Matrix_small.jpg" style="width:45%;  display: block; margin: auto;" alt="MISTIE LOGO">  
  </div> 
</div>


## Step 3: Fit Models / Classifier

Let $y_{i}(v)$ be the presence / absence of ICH for voxel $v$ from person $i$.  

General model form: 
$$
 P(Y_{i}(v) = 1)  \propto f(X_{i}(v))
$$

## Models Fit on the Training Data

- Logistic Regression: \(f(X_{i}(v)) = \text{expit} \left\{ \beta_0 + \sum_{k= 1}^{p} x_{i, k}(v)\beta_{k}\right\}  \)
- Random Forests [@ranger, @breiman2001random]
<div class="centerer">
\(f(X_{i}(v)) \propto\) <img src="figure/Random_Forest.png" style="width:40%;inline;" alt="MISTIE LOGO">
</div>

## Predicted Volume Estimates True Volume <img src="figure/Reseg_Volume_Logistic.png" style="width:55%;  display: block; margin: auto;" alt="Reseg">

## Predicted Volume Estimates True Volume <img src="figure/Reseg_Volume_Comparison.png" style="width:55%;  display: block; margin: auto;" alt="Reseg">

## Patient with Median Overlap in Validation Set

<img src="figure/Reseg_Figure_DSI_Quantile_050_No_DSI.png" style="width:500px;  display: block; margin: auto;" alt="MISTIE LOGO"> 

## R Package

- `smri.process` - on GitHub and Neuroconductor
  - relies on other Neuroconductor (not CRAN) packages
  - 




## Conclusions of Stroke Analyses

<div style="font-size: 24pt">

- We can segment ICH volume from CT scans <br><br>
- We can create population-level ICH distributions <br/><br/>
- Voxel-wise regression can show regions associated with severity <br/><br/>

</div>


## Conclusions of Stroke Analyses

<div style="font-size: 24pt">

- We can segment ICH volume from CT scans
    - **Incorporate variability of estimated volume**
- We can create population-level ICH distributions
    - **Uncertainty measures of this**
- Voxel-wise regression can show regions associated with severity
    - **Validate these regions (MISTIE III)**
    - **Scalar on image regression** 

</div>

# Neuroimaging and R

## Authored R Packages:

<div id="wrap">
<div id="left_col">

- **fslr** <p style='font-size: 12pt;'>(Muschelli, John, et al. "fslr: Connecting the FSL Software with R." R JOURNAL 7.1 (2015): 163-175.)</p>
- brainR <p style='font-size: 12pt;'>(Muschelli, John, Elizabeth Sweeney, and Ciprian Crainiceanu. "brainR: Interactive 3 and 4D Images of High Resolution Neuroimage Data." R JOURNAL 6.1 (2014): 42-48.)</p>
- extrantsr
- ichseg <p style='font-size: 12pt;'>Muschelli, John, et al. "PItcHPERFeCT: Primary intracranial hemorrhage probability estimation using random forests on CT." NeuroImage: Clinical 14 (2017): 379-390.</p>
- dcm2niir
- matlabr
- spm12r


</div>
<div id="right_col">

- itksnapr
- papayar
- WhiteStripe
- oasis
- SuBLIME
- googleCite
- diffr
- rscopus
- glassdoor

</div>
</div>




## Number of Downloads (CRAN packages)

From the `cranlogs` R package:







<!--html_preserve--><div id="htmlwidget-9d9cbddc6ce173e59d9b" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-9d9cbddc6ce173e59d9b">{"x":{"filter":"none","data":[["rscopus","diffr","matlabr","neurobase","WhiteStripe","brainR","fslr","neurohcp","cifti","gcite","kirby21.fmri","gifti","freesurfer","glassdoor","spm12r","kirby21.t1","fedreporter","kirby21.base","papayar","stapler","neurovault"],[9989,7517,9265,7455,9396,13855,17427,1630,2211,2529,2242,2243,3656,1080,5549,2603,1056,3082,3495,546,296],[109,78,72,63,61,52,50,42,40,39,37,36,33,30,30,29,27,27,25,20,0]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>Package<\/th>\n      <th>All Time<\/th>\n      <th>Last Week<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"t","autoWidth":true,"columnDefs":[{"className":"dt-center","targets":0},{"className":"dt-right","targets":[1,2]}],"order":[],"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->




# Thank You
