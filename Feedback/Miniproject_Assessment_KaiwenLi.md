# Miniproject Feedback and Assessment

## Report

**"Guidelines" below refers to the MQB report [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) [here](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html) (which were provided to the students in advance).**

**Title:** “Gompertz models outperform linear models when fit to bacterial population growth, amplified on chemically undefined growth media”

- **Introduction (15%)**  
  - **Score:** 11/15  
  - Compares linear vs. Gompertz, referencing real vs. synthetic media. Could more explicitly state the research question or hypothesis.

- **Methods (15%)**  
  - **Score:** 12/15  
  - Data cleaning, classification of mediums, and the approach of using the linear slope as rmax for Gompertz are explained. More references to best practices for parameter-fitting might help.

- **Results (20%)**  
  - **Score:** 15/20  
  - Table 2 is well presented, showing Gompertz “wins” in most subsets, though linear occasionally outperforms. A bit more analysis of residuals or temperature interactions might help.

- **Tables/Figures (10%)**  
  - **Score:** 6/10  
  - Mentions a sample figure and references some tables, but minimal textual integration. The [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) emphasize thorough figure/table referencing in text.

- **Discussion (20%)**  
  - **Score:** 14/20  
  - Interprets why Gompertz dominates, with linear having occasional success in certain synthetic conditions. Could expand on method limitations or next steps.

- **Style/Structure (20%)**  
  - **Score:** 14/20  
  - Standard structure with mostly clear writing. Some transitions may be abrupt. More consistent citations recommended.

**Summary:** Great coverage of data cleaning and model-fitting rationale. Additional numeric detail about subsets and deeper discussion of limitations would make it stronger.

**Report Score:** 72  


---
## Computing

### Project Structure & Workflow

**Strengths**

* `run_miniproject.sh` cleanly drives data preparation and model fitting/analysis in order.

* `DataPreparation.R` (data cleaning and ID generation) and `Model_Fitting_Analysis.R` (linear vs Gompertz fits, AIC/BIC comparisons, plotting) have single responsibilities.

**Suggestions**

1. **Shell Script Robustness**:

   * Use a portable shebang and strict modes:

     ```bash
     #!/usr/bin/env bash
     set -euo pipefail
     ```
   * Ensure the script runs from project root (e.g. `cd "$(dirname "$0")"`).
   * Redirect logs for reproducibility: `Rscript ... 2>&1 | tee results/pipeline.log`.
   * Parameterize paths (e.g. allow `--data-dir` or environment variables) to increase flexibility.
  
2. **Reproducible Environments**:

   * Use **renv** (or `packrat`) in the R codebase, snapshotting exact package versions instead of ad-hoc installation in the shell script.
   * If Python is employed elsewhere, include `requirements.txt` or `environment.yml` for consistency.

---

### README File

**Strengths**

* Concise overview of the project’s aim: comparing linear vs Gompertz fits across bacterial growth experiments.
* Lists workflow steps and key R package dependencies.

**Suggestions**

1. Provide explicit commands to reproduce the environment and run the pipeline:

   ```bash
   git clone <repo>
   cd <repo>
   bash run_miniproject.sh
   ```
2. Replace inline package list with a reference to `renv.lock`, and instruct `renv::restore()` in README.
3. Show where raw versus output files reside and what each script reads/writes.
4. Cite the source of `LogisticGrowthData.csv` .
5. Add a LICENSE file and author contact/email at the top.

---

### Code Structure & Syntax

####  DataPreparation.R

* Omit `rm(list = ls())`; rely on fresh R sessions started by the shell driver.
* Replace hard-coded relative paths with `here::here("data", "LogisticGrowthData.csv")`.
* Use `dplyr` chains (`%>%`) to filter and transform, encapsulating cleaning steps in functions such as `clean_data()`.
* Generate a numeric ID with `dplyr::group_indices()` on the key columns rather than manual factor conversion.
* After filtering, check that each ID still meets the minimum point threshold and report any dropped experiments.

####  Model\_Fitting\_Analysis.R

* Extract repeated logic into named functions:

  * `fit_linear(df)` returns an `lm` object and its AIC/BIC.
  * `fit_gompertz(df, start_vals)` returns an `nlsLM` object or `NULL` on failure.
  * `compare_models(lm_res, gom_res)` encapsulates AIC/BIC comparison logic.
  * `plot_fit(df, lm_res, gom_res)` builds and returns a `ggplot` object.
* Instead of a `for` loop with `rbind()`, split data by `ID_num`, map over each subset with `purrr::map()`, and bind results with `bind_rows()`.
* Pre-allocate a list to collect fit results and plots, avoiding repetitive `rbind` in loops (which is O(n²)).
* Call `set.seed(123)` just before sampling in each model fit to ensure reproducibility of starting values.
* Supply `lower=` and `upper=` to `nlsLM()` to constrain parameters (e.g. `N_0 > 0`, `K > N_0`, `r_max > 0`).
* In `tryCatch`, route errors to a log file or structured list rather than only console messages, enabling post-run diagnostics.
* Replace `aggregate()` with `dplyr::summarize()` for more readable and chainable grouping:

  ```r
  summary_results <- results %>%
    group_by(Environment, Model) %>%
    summarize(AIC_wins = sum(AIC_wins), BIC_wins = sum(BIC_wins))
  ```

####  run\_miniproject.sh

* **Shebang & Safety**:

  ```bash
  #!/usr/bin/env bash
  set -euo pipefail
  ```
*  Add `cd "$(dirname "$0")"` so paths resolve relative to the script file.
* Capture both stdout and stderr:

  ```bash
  bash run_miniproject.sh 2>&1 | tee results/pipeline.log
  ```
* Support `--data-dir` and `--results-dir` as flags for greater flexibility.

---

### NLLS Fitting Approach

**Strengths**

* Using the linear model’s slope and data extrema to seed Gompertz fits is a good heuristic...

**Suggestions**

1. Leverage **nls.multstart** for built-in multi-start sampling, bounds, and parallelization:

   ```r
   nls_multstart(
     log_PopBio ~ gompertz_model(Time, r_max, K, N0, t_lag),
     data = df,
     iter = 50,
     start_lower = c(r_max = 0, K = max(df$log_PopBio)/2, N0 = min(df$log_PopBio)/2, t_lag = 0),
     start_upper = c(r_max = 2, K = max(df$log_PopBio)*2, N0 = min(df$log_PopBio)*2, t_lag = max(Time)),
     supp_errors = "Y"
   )
   ```
2. Constrain fits to biologically plausible ranges. Report any parameters hitting bounds as potential red flags.
3. Record convergence messages and residual standard errors per fit, summarizing patterns of failures.
4. Compute Akaike weights to quantify relative model support and plot their distribution across experiments.
5. For rigorous performance assessment, implement leave-one-timepoint-out Cross-Validation or k-fold Cross-Validation on timepoints to test predictive accuracy beyond AIC/BIC.

---

### Summary

Your pipeline is functional and clear. Strengthening directory conventions, reproducibility via `renv`, modular code refactoring, bounded multi-start fitting, and structured logging would make the workflow more robust and maintainable.

**Score: 71**

---

## Overall Score: (72 + 71)/2 = 71.5