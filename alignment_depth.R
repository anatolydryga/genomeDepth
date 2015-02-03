#' read genome coverage file.
#'
#' genome coverage file is produced by:
#' samtools view -b bam_file | genomeCoverageBed -ibam stdin > genome_coverage.tsv
#'
#' @return dataframe with 5 columns
#' described at http://bedtools.readthedocs.org/en/latest/content/tools/genomecov.html
read_genomecov <- function(genome_coverage_file) {
    if ( ! file.exists(genome_coverage_file)) {
        stop("Genome Coverage file is not found.")
    }
    cov_hist <- read.delim(genome_coverage_file, header=FALSE, comment.char="#")
    if (ncol(cov_hist) != 5) {
        stop("Genome Coverage should have 5 columns.")
    }
    colnames(cov_hist) <- c("contig_name", "depth", "num_bases", "length", "fraction")
    cov_hist
}

#' average depth for contigs.
#'
#' @return dataframe with two columns: seq name, average depth
#' average_depth = sum depth*fraction, where we sum over all observed depth for a given contig
#' 
average_depth <- function(genome_coverage) {
    genome_coverage$weighted_depth <- genome_coverage$depth * genome_coverage$fraction
    ave_depth <- aggregate(weighted_depth ~ contig_name, genome_coverage, sum)
    colnames(ave_depth) <- c("contig_name", "ave_depth")
    ave_depth
}

#' coverage for contigs.
#'
#' @return dataframe with two columns: contig name, coverage
#' 
#' coverage is defined as portion of genome that is covered 1 or more times
contig_coverage <- function(genome_coverage) {
    zero_coverage <- genome_coverage[ genome_coverage$depth == 0, ]
    coverage_df <- data.frame(
        contig_name=zero_coverage$contig_name,
        coverage=1 - zero_coverage$fraction
    )
    coverage_df
}

#' creates depth-frequency distribution for contig of interest
#'
#' see https://github.com/arq5x/bedtools-protocols/blob/master/bedtools.md
depth_distribution <- function(genome_coverage, contig_name) {
    if ( ! contig_name %in% genome_coverage$contig_name) {
        stop("contig_name is not found. Cannot call depth_distribution.")
    }
    contig_of_interest <- genome_coverage[genome_coverage$contig_name == contig_name, ]
    depth_distribution <- data.frame(
        depth=contig_of_interest$depth,
        fraction=contig_of_interest$fraction
    ) 
    depth_distribution
}
