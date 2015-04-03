library(testthat)
source("contig_to_read.R")

context("How many reads are mapped to the contigs.")

contig_read_count <- read_idxstats("sample_idxstats.txt")

test_that("return df with 4 columns: contig_name, read_length, mapped, unmapped", {
    expect_equal(colnames(contig_read_count), c("contig_name", "contig_length", "mapped", "unmapped"))
})

test_that("removes * row from the result", {
    expect_true( ! "*" %in% contig_read_count$contig_name)
})

test_that("correct sample file has 27 contigs.", {
    expect_equal(nrow(contig_read_count), 27)
    expect_equal(contig_read_count[1, 3], 0)
    expect_equal(contig_read_count[2, 3], 1291)
})
