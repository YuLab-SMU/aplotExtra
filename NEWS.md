# aplotExtra 0.0.5.001

+ export `oncoplot_components()` as a reusable component interface for downstream oncoplot extensions (2026-07-15, Wed)
+ refactor `oncoplot()` to assemble panels from `oncoplot_components()` with native pipe syntax

# aplotExtra 0.0.5

+ add testthat infrastructure and unit tests for upset and funkyheatmap data functions (2026-07-13, Sun)
+ fix tidyselect deprecation: `.data$set` → `"set"` in `tidy_main_subsets()`
+ fix tidyselect deprecation: use `all_of()` for external column vector in `funky_data()`
+ remove unnecessary `require(ggstar)` inside `funky_point()`, since `ggstar` is already formally imported
+ fix `@title` of `upset_plot()` from "upsetplot2" to "upset_plot"
+ uncomment `check_pkg("maftools")` in `oncoplot()` for early, user-friendly error

# aplotExtra 0.0.4

+ add citation information (2025-06-12, Thu)
+ update `upset_plot` to allow setting color (2025-05-29, Thu)

# aplotExtra 0.0.3

+ import `xlab2()` and `ylab2()` from 'aplot' (2024-06-17, Mon)

# aplotExtra 0.0.2

+ update `upsetplot()` and rename to `upset_plot()` 

# aplotExtra 0.0.1

+ prototype version of `upsetplot()` from aplot (2023-08-04, Fri)
    - <https://github.com/YuLab-SMU/aplot/pull/34>
+ export `oncoplot()` (2023-07-19, Wed)
+ prototype of `oncoplot()` (2023-07-18, Tue)
  - with helper functions, `oncoplot_main()`, `oncoplot_sample()` and `oncoplot_gene()`
  - `print()` method for `oncoplot` object
  - `oncoplotGrob()` to convert `oncoplot` object to `grob`
+ extend `funky_point()` to support different shapes defined in the 'ggstar' package and extend `funky_bar()` to support grouped bar plot (2023-06-24, Sat, #29)
+ use `ggfun::theme_blinds()` for funky plots (2023-06-20, Tue)
+ `funky_heatmap()` and relative functions (2023-06-18, Sun)
  + `funky_text()`
  + `funky_point()`
  + `funky_bar()`
