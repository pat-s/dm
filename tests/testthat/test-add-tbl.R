test_that("dm_add_tbl() works", {

  # is a table added?
  expect_identical(
    length(dm_get_tables(dm_add_tbl(dm_for_filter(), data_card_1()))),
    7L
  )

  # can I retrieve the tibble under its old name?
  expect_equivalent_tbl(
    tbl(dm_add_tbl(dm_for_filter(), data_card_1()), "data_card_1()"),
    data_card_1()
  )

  # can I retrieve the tibble under a new name?
  expect_equivalent_tbl(
    tbl(dm_add_tbl(dm_for_filter(), test = data_card_1()), "test"),
    data_card_1()
  )

  # use special names with :=
  expect_identical(
    names(dm_add_tbl(dm_for_filter(), dm := data_card_1(), repair := data_card_2())),
    c(names(dm_for_filter()), "dm", "repair")
  )

  # we accept even weird table names, as long as they are unique
  expect_equivalent_tbl(
    tbl(data_card_1() %>% dm_add_tbl(dm_for_filter(), .), "."),
    data_card_1()
  )

  # do I avoid the warning when piping the table but setting the name?
  expect_silent(
    expect_equivalent_tbl(
      dm_for_filter() %>% dm_add_tbl(new_name = data_card_1()) %>% tbl("new_name"),
      data_card_1()
    )
  )

  # adding more than 1 table:
  # 1. Is the resulting number of tables correct?
  expect_identical(
    length(dm_get_tables(dm_add_tbl(dm_for_filter(), data_card_1(), data_card_2()))),
    8L
  )

  # 2. Is the resulting order of the tables correct?
  expect_identical(
    src_tbls(dm_add_tbl(dm_for_filter(), data_card_1(), data_card_2())),
    c(src_tbls(dm_for_filter()), "data_card_1()", "data_card_2()")
  )

  # Is an error thrown in case I try to give the new table an old table's name if `repair = "check_unique"`?
  expect_dm_error(
    dm_add_tbl(dm_for_filter(), tf_1 = data_card_1(), repair = "check_unique"),
    "need_unique_names"
  )

  # are in the default case (`repair = 'unique'`) the tables renamed (old table AND new table) according to "unique" default setting
  expect_identical(
    dm_add_tbl(dm_for_filter(), tf_1 = data_card_1(), quiet = TRUE) %>% src_tbls(),
    c("tf_1...1", "tf_2", "tf_3", "tf_4", "tf_5", "tf_6", "tf_1...7")
  )

  expect_name_repair_message(
    expect_equivalent_dm(
      dm_add_tbl(dm_for_filter(), tf_1 = data_card_1(), repair = "unique"),
      dm_for_filter() %>%
        dm_rename_tbl(tf_1...1 = tf_1) %>%
        dm_add_tbl(tf_1...7 = data_card_1())
    )
  )

  # error in case table srcs don't match
  expect_dm_error(
    dm_add_tbl(dm_for_filter(), data_card_1_sqlite()),
    "not_same_src"
  )

  # adding tables to an empty `dm` works for all sources
  expect_equivalent_tbl(
    dm_add_tbl(dm(), test = data_card_1_sqlite())$test,
    data_card_1()
  )

  # can I use dm_select_tbl(), selecting among others the new table?
  expect_silent(
    dm_add_tbl(dm_for_filter(), tf_7_new = tf_7()) %>% dm_select_tbl(tf_1, tf_7_new, everything())
  )
})

test_that("dm_rm_tbl() works", {
  # removes a table
  expect_equivalent_dm(
    dm_rm_tbl(dm_for_filter_w_cycle(), tf_7),
    dm_for_filter()
  )

  # removes more than one table
  expect_equivalent_dm(
    dm_rm_tbl(dm_for_filter_w_cycle(), tf_7, tf_5, tf_3),
    dm_select_tbl(dm_for_filter(), tf_1, tf_2, tf_4, tf_6)
  )

  # fails when table name is wrong
  expect_error(
    dm_rm_tbl(dm_for_filter(), tf_9),
    class = "vctrs_error_subscript"
  )

  # select-helpers work for 'dm_rm_tbl()'
  expect_identical(
    dm_rm_tbl(dm_for_disambiguate(), everything()),
    empty_dm()
  )

  # corner case: not removing any table
  expect_identical(
    dm_rm_tbl(dm_for_disambiguate()),
    dm_for_disambiguate()
  )
})
