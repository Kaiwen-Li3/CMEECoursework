
# Feedback on Project Structure, Workflow, and Code Structure

**Student:** Kaiwen Li

---

## General Project Structure and Workflow

- **Directory Organization**: The project is well-organized, with weekly folders (`Week1`, `Week2`, `Week3`, `Week4`) and structured subfolders (`code`, `data`, `results`) within each week. There is an extra directory - `CMEE-Group-2-Coursework`! 
- **README Files**: The root-level README file provides essential information about the project, but the `Week3` folder lacks a README file. Adding a README here would help clarify the week’s focus and describe specific dependencies and scripts in that week.

### Suggested Improvements:
1. **Add README for Week3**: A README file in the `Week3` directory would provide an overview of the week’s content and dependencies, improving accessibility for new users.
2. **Expand Documentation**: Expanding the root README with usage examples and dependencies for the primary scripts (e.g., `datavisualisation.R`, `preallocate.R`) would clarify expected inputs and outputs.

## Code Structure and Syntax Feedback

### R Scripts in `Week3/code`

1. **functionswithconditionals.R**: The code provides functions to check numerical properties. However, a syntax error in the `is.even` function prevents it from running correctly. Revising the line structure and testing each function would ensure functionality.
2. **datavisualisation.R**: Good use of visualizations with base R functions. Adding comments explaining each step would improve readability, especially for plots with complex configurations like multi-panel and overlapping histograms.
3. **sample.R**: Demonstrates looping and vectorization. Adding inline comments to describe the purpose of each function would enhance clarity.
4. **iris.R**: Effectively uses `tapply` and `by` for summarizing data. Including comments on `replicate()` and `runif()` functions would explain the code’s purpose.
5. **vectorize1.R**: The script compares looping with vectorized functions well. Correcting minor formatting issues (e.g., consistent spacing) would improve readability.
6. **debugging.R**: Contains error handling with `try()` but would benefit from adding `tryCatch()` for more structured error handling. Comments explaining each step would further clarify the debugging process.
7. **apply1.R**: Demonstrates the use of `apply()` for row and column calculations. Adding a description for each calculation would make it easier to follow.
8. **datamanagement.R**: Contains functions for data wrangling. Error messages related to package installations (`ragg`, `httpgd`) could be resolved by specifying packages in README. Including comments on each transformation (e.g., melting data) would enhance readability.
9. **ggplot.R**: Provides visualizations using ggplot2 but shows deprecation warnings for `qplot()`. Consider replacing `qplot()` with `ggplot()` to avoid future compatibility issues.
10. **boilerplate.R**: A basic function template. Adding explanations for return values and argument types would clarify the purpose of the function.
11. **apply2.R**: Effectively demonstrates applying functions with conditional logic on matrix rows. Adding comments to explain the `apply()` function would improve understanding.
12. **errorsanddebugging.R**: Shows the use of `browser()` for debugging. Adding a `#` comment before `browser()` would prevent it from running in production scripts.
13. **browse.R**: Contains an exponential growth simulation with `browser()` for debugging. As in `errorsanddebugging.R`, consider commenting out `browser()` for production readiness.
14. **preallocate.R**: Effectively demonstrates the performance impact of preallocation. Adding a description of timing differences in the comments would illustrate the benefits of preallocation.

### General Code Suggestions

- **Consistency**: Ensure consistent spacing and indentation across scripts (e.g., `functionswithconditionals.R`) for improved readability.
- **Error Handling**: Several scripts (`datamanagement.R`, `debugging.R`) include error handling but could benefit from more structured handling with `tryCatch()`.
- **Comments**: Adding comments to clarify complex functions, especially where multiple libraries are used (`datamanagement.R`, `datavisualisation.R`), would enhance readability.

---
