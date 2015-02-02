#' read genome coverage file.
#'
#' genome coverage file is produced by:
#' samtools view -b bam_file | genomeCoverageBed -ibam stdin > genome_coverage.tsv
#'
#' @return dataframe with 5 columns
read_genomecov <- function(genome_coverage_file) {
    if ( ! file.exists(genome_coverage_file)) {
        stop("Genome Coverage file is not found.")
    }
    cov_hist <- read.delim(genome_coverage_file, header=FALSE, comment.char="#")
    if (ncol(cov_hist) != 5) {
        stop("Genome Coverage should have 5 columns.")
    }
    colnames(cov_hist) <- c("sequence", "depth", "num_bases", "length", "fraction")
    cov_hist
}

#' average depth for sequences of genome
#'
#' @return dataframe with two columns: seq name, average depth
#' 
average_depth <- function(genome_coverage) {
    genome_coverage$weighted_depth <- genome_coverage$depth * genome_coverage$fraction
    ave_depth <- aggregate(weighted_depth ~ sequence, genome_coverage, sum)
    colnames(ave_depth) <- c("sequence", "ave_depth")
    ave_depth
}

#' coverage for sequences of genome
#'
#' @return dataframe with two columns: seq name, coverage
#' 
sequence_coverage <- function(genome_coverage) {
    zero_coverage <- genome_coverage[ genome_coverage$depth == 0, ]
    coverage_df <- data.frame(
        sequence=zero_coverage$sequence,
        coverage=1 - zero_coverage$fraction
    )
    coverage_df
}

#' creates depth-frequncy distribution for sequence of interest
#'
depth_distribution <- function(genome_coverage, sequence_name) {
    if ( ! sequence_name %in% genome_coverage$sequence) {
        stop("Sequence is not found. Cannot call depth_distribution.")
    }
    sequence_of_interest <- genome_coverage[genome_coverage$sequence == sequence_name, ]
    depth_distribution <- data.frame(
        depth=sequence_of_interest$depth,
        fraction=sequence_of_interest$fraction
    ) 
    depth_distribution
}
