# Roberta_LCA

Linear mixed-effects model (LME) analysis code associated with the study:

**“Food craving-like episodes during pregnancy are mediated by brain responses to the newly evolved endocrine organ placenta.”**  
Published in *Nature Metabolism* (2022).  
DOI: [10.1038/s42255-022-00557-1](https://doi.org/10.1038/s42255-022-00557-1)

---

## Overview

This repository contains analysis scripts and supporting resources for the linear mixed-effects model analyses reported in the paper.  
The code is intended to support transparency and reproducibility of the statistical results.

> **Note:** This repository focuses on LME-related analyses (referred to as `Roberta_LCA`).

---

## Repository structure

Structure (input data/results not provide here):

```text
Roberta_LCA/
├── scripts/
│   ├── Pheatmap.R
│   ├── PCA.R
│   ├── LCA.R
│   └── LCA_other.R
└── README.md
```

These scripts provide the PCA and heatmap exploratory analyses together with the primary and complementary LME analyses used to evaluate the study hypotheses.

---

## Methods summary

The main statistical framework uses **linear mixed-effects models** to account for repeated measures and inter-individual variability.

Typical model components include:
- **Fixed effects**: predictors of interest (e.g., condition, time, covariates)
- **Random effects**: participant-level intercepts/slopes where appropriate
- **Inference**: model coefficients, confidence intervals, and significance tests
- **Model checking**: residual diagnostics and sensitivity analyses

Please refer to the manuscript and supplementary materials for full model specifications and variable definitions.

---

## Requirements

Recommended environment:

- **R** (>= 4.1)
- R packages (as used in scripts), typically including:
  - `lme4`
  - `lmerTest`
  - `tidyverse`
  - `emmeans`
  - `broom.mixed`
  - `performance`
  - `ggplot2`

Install example:

```r
install.packages(c(
  "lme4", "lmerTest", "tidyverse",
  "emmeans", "broom.mixed", "performance", "ggplot2"
))
```

---

## Citation

If you use this repository, please cite:

Haddad-Tóvolli, R., Ramírez, S., Muñoz-Moreno, E. et al. Food craving-like episodes during pregnancy are mediated by accumbal dopaminergic circuits. Nat Metab 4, 424–434 (2022). https://doi.org/10.1038/s42255-022-00557-1

---

## Contact

Repository maintainer: **@elenu**  
For scientific questions, please refer to the corresponding author information in the publication.
