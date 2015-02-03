#' read samtools idxstats and return how many reads mapped to each contig.
#' 
#' @parameter idxstats output file
#' file is produced by: samtools idxstats bamfile > idxstats_output 
#' @returns df with 2 columns: contig name, number of reads mapped to the contig.
get_contig_to_read_count <- function(idxstasts_file) {
    return(NULL)
}

