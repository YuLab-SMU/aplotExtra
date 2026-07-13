# Tests for funkyheatmap.R data/theme functions ---------------------------------

# ---- funky_id ----

test_that("funky_id() adds id column from rownames when id is absent", {
  df <- data.frame(x = 1:3, y = 4:6)
  rownames(df) <- c("row1", "row2", "row3")
  res <- funky_id(df)
  expect_true("id" %in% colnames(res))
  expect_equal(res$id, c("row1", "row2", "row3"))
})

test_that("funky_id() preserves existing id column", {
  df <- data.frame(id = c("a", "b"), x = 1:2)
  res <- funky_id(df)
  expect_equal(res$id, c("a", "b"))
  expect_equal(ncol(res), 2)
})

# ---- funky_data ----

test_that("funky_data() pivots selected all-numeric columns to long format", {
  # After funky_id adds "id" as col 1, original cols shift right by 1
  df <- data.frame(expr1 = c(2.1, 3.5), expr2 = c(1.8, 4.2))
  rownames(df) <- c("BRCA1", "TP53")
  res <- funky_data(df, cols = c(2, 3))  # cols after id addition
  expect_s3_class(res, "data.frame")
  expect_named(res, c("id", "name", "value"))
  expect_equal(nrow(res), 4)  # 2 genes x 2 columns
  expect_setequal(unique(res$name), c("expr1", "expr2"))
})

test_that("funky_data() uses rownames as id and reverses factor levels", {
  df <- data.frame(x = 1:2, y = 3:4)
  rownames(df) <- c("g1", "g2")
  res <- funky_data(df, cols = 2)
  expect_true("id" %in% colnames(res))
  # factor levels should be reversed from original order
  expect_equal(levels(res$id), c("g2", "g1"))
})

test_that("funky_data() preserves cols2 columns (position relative to post-funky_id data)", {
  # After funky_id: columns are id, gene, expr, group (1,2,3,4)
  # cols=3 means expr is the data column; cols2=4 means keep group
  df <- data.frame(
    gene = c("A", "B"),
    expr = c(1, 2),
    group = c("case", "ctrl")
  )
  res <- funky_data(df, cols = 3, cols2 = 4)
  expect_true("group" %in% colnames(res))
  expect_equal(res$group, c("case", "ctrl"))
})

test_that("funky_data() sets id factor levels in reverse order of data rows", {
  df <- data.frame(
    gene = c("BRCA1", "TP53", "MYC"),
    expr = c(1, 2, 3)
  )
  rownames(df) <- c("BRCA1", "TP53", "MYC")
  res <- funky_data(df, cols = 2)
  expect_s3_class(res$id, "factor")
  expect_equal(levels(res$id), c("MYC", "TP53", "BRCA1"))
})

# ---- funky_fill_label ----

test_that("funky_fill_label() returns non-NULL for single col", {
  df <- data.frame(gene = 1:3, pval = c(0.01, 0.02, 0.03))
  ll <- funky_fill_label(df, cols = 2)
  expect_false(is.null(ll))
})

test_that("funky_fill_label() returns NULL for multiple cols", {
  df <- data.frame(gene = 1:3, a = 1:3, b = 4:6)
  expect_null(funky_fill_label(df, cols = c(2, 3)))
})

# ---- funky_theme ----

test_that("funky_theme() returns a ggplot2 theme object", {
  th <- funky_theme()
  expect_s3_class(th, "theme")
  expect_s3_class(th, "gg")
})

test_that("funky_theme() blanks axis.ticks.y and axis.text.y", {
  th <- funky_theme()
  expect_s3_class(th$axis.ticks.y, "element_blank")
  expect_s3_class(th$axis.text.y, "element_blank")
})

# ---- funky_setting ----

test_that("funky_setting() applies theme_blinds to each element of gglist", {
  suppressPackageStartupMessages(library(ggplot2))
  p1 <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
  p2 <- ggplot(mtcars, aes(hp, mpg)) + geom_point()
  gglist <- list(p1, p2)

  res <- funky_setting(gglist, options = NULL)
  expect_length(res, 2)
  expect_s3_class(res[[1]], "ggplot")
  expect_s3_class(res[[2]], "ggplot")
})

test_that("funky_setting() applies extra options when provided", {
  suppressPackageStartupMessages(library(ggplot2))
  p1 <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
  res <- funky_setting(list(p1), options = theme(plot.title = element_text(size = 20)))
  expect_s3_class(res[[1]], "ggplot")
})
