---
title: "Fixed Effects Model on Stock Market Sentiment Data"
author: "Sathwik Kamath"
date: "`r Sys.Date()`"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# 📘 Project Overview
This analysis investigates the influence of online sentiment on stock performance using **Fixed Effects Panel Models**. The datasets include:

- `Merged_NIFTY50.csv`: Sentiment and return data for NIFTY50 companies
- `Merged_Smallcap.csv`: Sentiment and return data for NIFTY Smallcap 50 companies

The same fixed effect model is applied to both datasets to ensure consistency and comparability.

---

# 📦 Load Required Libraries
```{r libraries}
library(tidyverse)
library(plm)
library(readr)
library(dplyr)
library(lmtest)
library(sandwich)
```

---

# 📂 Load and Prepare Data

```{r load_data}
# Replace paths with actual file locations if running locally
df_nifty <- read_csv("Merged_NIFTY50.csv")
df_smallcap <- read_csv("Merged_Smallcap.csv")

# Combine into one dataset with a group label
df_nifty$Group <- "NIFTY50"
df_smallcap$Group <- "Smallcap"

# Merge datasets
merged_df <- bind_rows(df_nifty, df_smallcap)

# Convert necessary columns to factor
merged_df$Channel_Name <- as.factor(merged_df$Channel_Name)
merged_df$Month <- as.factor(merged_df$Month)
merged_df$Group <- as.factor(merged_df$Group)
```

---

# 🧠 Fixed Effects Model Definition
We model **Abnormal Return** as a function of views, subscribers, sentiment scores, and interactions. We control for fixed effects by `Channel_Name` and `Month`.

```{r fixed_effect_model}
# Define panel data structure
pdata <- pdata.frame(merged_df, index = c("Channel_Name", "Month"))

# Build the fixed effects model
fe_model <- plm(Abnormal_Return ~ log(Views) + log(Subscriber_Count) + avg_compound +
                  BERTPositive_Interaction + BERTNegative_Interaction + BERTNeutral_Interaction,
                data = pdata, model = "within")

# Summary of the model
summary(fe_model)
```

---

# 📊 Model Diagnostics
```{r model_diagnostics}
# Robust standard errors
coeftest(fe_model, vcov = vcovHC(fe_model, type = "HC1"))
```

---

# ✅ Conclusion
- This script uses a **Fixed Effects Model** to test the relationship between sentiment and stock returns.
- The same model is applied to **both NIFTY50 and Smallcap** datasets.
- Fixed effects help control for unobserved heterogeneity across YouTube channels and months.

> 📌 This `.Rmd` is ready for GitHub and reproducible analysis. Replace file paths as needed when running locally.
