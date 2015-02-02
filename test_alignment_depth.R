library(testthat)
source('alignment_depth.R')

context("Genome Coverage and Depth")

coverage_histogram <- read_genomecov("sample_genomecov.txt")

test_that("can read correct file", {
    expect_equal(ncol(coverage_histogram), 5)
    expect_equal(nrow(coverage_histogram), 12)
})

test_that("column names are correct.", {
    expect_equal(colnames(coverage_histogram), 
        c("sequence", "depth", "num_bases", "length", "fraction"))
})

test_that("throw exception if file does not exist", {
    expect_error(read_genomecov("NOT_existing_file.txt"), "Genome Coverage file is not found.")
})

ave_depth <- average_depth(coverage_histogram)    

test_that("have 2 sequences and genome: 3 total. And 2 columns.", {
    expect_equal(nrow(ave_depth), 3)
    expect_equal(ncol(ave_depth), 2)
})

test_that("column names are correct.", {
    expect_equal(colnames(ave_depth), c("sequence", "ave_depth"))
})

test_that("sequences names are: 2,3 and genome.", {
    expect_equal(sort(as.character(ave_depth$sequence)), c("2", "3", "genome"))
})

test_that("average depth is correct", {
    expect_equal(ave_depth[ave_depth$sequence %in% "2", 2], 0.4533025) # only count nonzero data in sample file
})

coverage <- sequence_coverage(coverage_histogram)    

test_that("coverage for 2 sequences and genome.", {
    expect_equal(coverage[coverage$sequence %in% "2", 2], 0.894818)
})

test_that("coverage column names are correct.", {
    expect_equal(colnames(coverage), c("sequence", "coverage"))
})

distribution <- depth_distribution(coverage_histogram, "2") 

test_that("can produce depth distribution for existing sequence.", {
    expect_equal(nrow(distribution), 4) 
    expect_equal(ncol(distribution), 2) 
})

test_that("depth distribution names are correct", {
    distribution <- depth_distribution(coverage_histogram, "2") 
    expect_equal(colnames(distribution), c("depth", "fraction")) 
})

test_that("fails if sequence name is unknown..", {
    expect_error(depth_distribution(coverage_histogram, "NON_EXISTING_SEQUENCE"), 
        "Sequence is not found. Cannot call depth_distribution.")
})
