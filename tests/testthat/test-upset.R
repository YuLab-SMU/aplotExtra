# Tests for upset.R data functions -------------------------------------------

test_that("overlap() computes setdiff of intersect(idx) vs union(-idx)", {
  lst <- list(
    A = c("a", "b", "c", "d"),
    B = c("b", "c", "d", "e"),
    C = c("c", "d", "e", "f")
  )

  # A only (intersect of A, minus union of B,C)
  expect_setequal(overlap(lst, 1), "a")
  # B only
  expect_setequal(overlap(lst, 2), character(0))
  # C only
  expect_setequal(overlap(lst, 3), "f")
  # A & B intersection
  expect_setequal(overlap(lst, c(1, 2)), c("b"))
  # A & C intersection
  expect_setequal(overlap(lst, c(1, 3)), character(0))
  # B & C intersection
  expect_setequal(overlap(lst, c(2, 3)), "e")
  # A & B & C intersection
  expect_setequal(overlap(lst, c(1, 2, 3)), c("c", "d"))
})

test_that("overlap() handles edge cases", {
  # Single set
  lst1 <- list(A = letters[1:5])
  expect_setequal(overlap(lst1, 1), letters[1:5])

  # Empty set
  lst2 <- list(A = character(0), B = letters[1:3])
  expect_setequal(overlap(lst2, 1), character(0))
  expect_setequal(overlap(lst2, 2), letters[1:3])

  # Fully overlapping sets
  lst3 <- list(A = 1:3, B = 1:3)
  expect_setequal(overlap(lst3, 1), character(0))
  expect_setequal(overlap(lst3, 2), character(0))
  expect_setequal(overlap(lst3, c(1, 2)), as.character(1:3))
})

test_that("get_all_subsets_ids() returns slash-separated indices", {
  lst <- list(A = 1:3, B = 2:4, C = 3:5)
  ids <- get_all_subsets_ids(lst)
  expect_equal(ids[1], "1")
  expect_equal(ids[2], "2")
  expect_equal(ids[3], "3")
  expect_equal(ids[4], "1/2")
  expect_equal(ids[7], "1/2/3")
  expect_length(ids, 7)  # 2^3 - 1
})

test_that("get_all_subsets_names() returns slash-separated set names", {
  lst <- list(X = 1:3, Y = 2:4)
  nms <- get_all_subsets_names(lst)
  expect_equal(nms, c("X", "Y", "X/Y"))
})

test_that("get_all_subsets_items() returns list of character vectors", {
  lst <- list(A = c("a", "b", "c"), B = c("b", "c", "d"))
  items <- get_all_subsets_items(lst)
  expect_type(items, "list")
  expect_length(items, 3)  # 2^2 - 1
  expect_setequal(items[[1]], "a")
  expect_setequal(items[[2]], "d")
  expect_setequal(items[[3]], c("b", "c"))
})

test_that("get_all_subsets() returns a tibble with id/name/item/size columns", {
  # A: 1,2,3,4,5; B: 3,4,5,6,7
  # A-only = {1,2} = 2; B-only = {6,7} = 2; A&B = {3,4,5} = 3
  lst <- list(A = 1:5, B = 3:7)
  res <- get_all_subsets(lst)
  expect_s3_class(res, "tbl_df")
  expect_named(res, c("id", "name", "item", "size"))
  expect_equal(res$name, c("A", "B", "A/B"))
  expect_equal(res$id, c("1", "2", "1/2"))
  expect_equal(res$size, c(2, 2, 3))
})

test_that("tidy_main_subsets() returns list of main/top/left data", {
  lst <- list(A = 1:5, B = 3:7)
  res <- tidy_main_subsets(lst,
    nintersects = NULL,
    order.intersect.by = "size",
    order.set.by = "size",
    remove_empty_intersects = TRUE
  )
  expect_type(res, "list")
  expect_named(res, c("top_data", "left_data", "main_data"))

  # left_data: one row per set, with size
  expect_equal(nrow(res$left_data), 2)
  expect_equal(unname(res$left_data$size), c(5, 5))
  expect_setequal(as.character(res$left_data$set), c("A", "B"))

  # top_data: one row per intersection
  expect_equal(nrow(res$top_data), 3)  # A-only, B-only, A&B
  expect_setequal(res$top_data$size, c(2, 2, 3))

  # main_data: expanded id -> set mapping
  main_ids <- unique(as.character(res$main_data$id))
  expect_length(main_ids, 3)
})

test_that("tidy_main_subsets() respects nintersects", {
  lst <- list(A = 1:5, B = 3:7)
  res <- tidy_main_subsets(lst, nintersects = 2,
    order.intersect.by = "size",
    order.set.by = "size"
  )
  expect_equal(nrow(res$top_data), 2)
})

test_that("tidy_main_subsets() accepts order.intersect.by = 'name'", {
  lst <- list(A = 1:5, B = 3:7)
  res <- tidy_main_subsets(lst,
    nintersects = NULL,
    order.intersect.by = "name",
    order.set.by = "size"
  )
  # ordering by name with fct_reorder (non-numeric key) — verifies no error
  expect_equal(nrow(res$top_data), 3)
  expect_setequal(as.character(res$top_data$name), c("A", "B", "A/B"))
})

test_that("tidy_main_subsets() handles remove_empty_intersects = FALSE", {
  lst <- list(A = 1:5, B = 3:7)
  res <- tidy_main_subsets(lst,
    nintersects = NULL,
    order.intersect.by = "size",
    order.set.by = "size",
    remove_empty_intersects = FALSE
  )
  expect_equal(nrow(res$top_data), 3)  # no empty to remove in this case
})
