library(testthat)
source("family_to_read.R")
source("contig_to_read.R")

context("How many reads are mapped to the families.")

contig_annotation <- read_contig_annotation("sample_contig_annotation.txt")

test_that("can read contig file", {
    expect_equal(nrow(contig_annotation), 15)    
    expect_equal(ncol(contig_annotation), 13)    
})

test_that("one of the columns is family", {
    expect_true("family" %in% colnames(contig_annotation))
})

test_that("contig name column is a character", {
    expect_equal(class(contig_annotation$contig_name), "character")
})

contig_to_read_count <- read_contig_to_read_count("sample_idxstats.txt")
contig_read_family <- add_family_annotation(contig_to_read_count, contig_annotation)

test_that("can merge contig to read and contig annotation dataframes", {
    expect_equal(nrow(contig_read_family), nrow(contig_to_read_count))  
    expect_equal(ncol(contig_read_family), 3)  
})

test_that("all contigs from contig to read count survive", {
    expect_equal(sort(contig_to_read_count$contig_name), sort(contig_read_family$contig_name))  
})

test_that("merged df has correct names.", {
    expect_equal(colnames(contig_read_family), c("contig_name", "read_count", "family"))  
})

test_that("merged df has correct names.", {
    expect_equal(colnames(contig_read_family), c("contig_name", "read_count", "family"))  
})

test_that("annotation added when possible", {
    expect_equal(sum( ! is.na(contig_read_family$family)), 8)
    expect_equal(as.character(contig_read_family[contig_read_family$contig_name %in% "1", 3]),
        "Myoviridae")
    expect_equal(as.character(contig_read_family[contig_read_family$contig_name %in% "5", 3]), 
        "Siphoviridae")
    expect_true(is.na(contig_read_family[contig_read_family$contig_name %in% "10", 3]))
})

family_read <- get_family_to_read_count(contig_read_family)

test_that("produces dataframe with 2 columns: family and read count", {
    expect_equal(colnames(family_read), c("family", "read_count"))
})

test_that("if no family annotation exists creates family UNKNOWN.", {
    expect_true("UNKNOWN" %in% family_read$family)
})

test_that("family and read count values are correct", {
    expect_equal(family_read[family_read$family %in% "Myoviridae", 2], 0)
    expect_equal(family_read[family_read$family %in% "Podoviridae", 2], 2)
    expect_equal(family_read[family_read$family %in% "Siphoviridae", 2], 1631)
    expect_equal(family_read[family_read$family %in% "UNKNOWN", 2], 376)
})


