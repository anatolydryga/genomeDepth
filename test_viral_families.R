library(testthat)

source("family_to_read.R")
source("contig_to_read.R")
source("viral_families.R")

context("Viral families for multiple samples.")

contig_annotation <- read_contig_annotation("sample_contig_annotation.txt")
fam_read_sample <- family_read_count_for_sample("sample_idxstats.txt", "Sample1", contig_annotation)

test_that("file has 3 columns", {
    expect_equal(ncol(fam_read_sample), 3)
})

test_that("last column is sample name and the same for all rows.", {
    expect_equal(length(unique(fam_read_sample$sample)), 1)
    expect_equal((fam_read_sample$sample)[1], "Sample1")
})

test_that("two samples are processed correctly", {
    samples <- data.frame(
        idxstats_file=c("sample_idxstats.txt", "sample_idxstats_2nd.txt"),
        sample_name=c("Sample1", "Sample2")
    )
    families <- viral_familes(samples, contig_annotation)

    expect_equal(ncol(families), 3)
    expect_equal(nrow(families), 8)
    expect_equal(length(unique(families$sample)), 2)
    expect_true("Sample1" %in% families$sample)
    expect_true("Sample2" %in% families$sample)
})


test_that("two contig samples are processed correctly", {
    samples <- data.frame(
        idxstats_file=c("sample_contig_annotation.txt", "sample_contig_annotation_2.txt"),
        sample_name=c("SampleFirst", "SampleSecond")
    )
    families <- viral_familes_contigs(samples)

    expect_equal(ncol(families), 3)
    expect_equal(nrow(families), 5 + 3)
    expect_equal(length(unique(families$sample)), 2)
    expect_true("SampleFirst" %in% families$sample)
    expect_true("SampleSecond" %in% families$sample)
})
