# aplot 0.0.1

+ prototype version of `upsetplot()` from aplot (2023-08-04, Fri)
    - <https://github.com/YuLab-SMU/aplot/pull/34>
+ export `oncoplot()` (2023-07-19, Wed)
+ prototype of `oncoplot()` (2023-07-18, Tue)
  - with helper functions, `oncoplot_main()`, `oncoplot_sample()` and `oncoplot_gene()`
  - `print()` method for `oncoplot` object
  - `oncoplotGrob()` to convert `oncoplot` object to `grob`
+ control space between subplots (2023-07-15, Sat, #31)
+ `gglistGrob()` to convert a 'gglist' object to a 'gtable' object (2023-06-26, Mon)
+ `<=` to add ggplot component to each of the plots stored in a "gglist" object (2023-06-26, Mon)
+ extend `funky_point()` to support different shapes defined in the 'ggstar' package and extend `funky_bar()` to support grouped bar plot (2023-06-24, Sat, #29)
+ mv `theme_no_margin()` to the 'ggfun' package (2023-06-24, Sat)
+ use `ggfun::theme_blinds()` for funky plots (2023-06-20, Tue)
+ `funky_heatmap()` and relative functions (2023-06-18, Sun)
  + `funky_text()`
  + `funky_point()`
  + `funky_bar()`
