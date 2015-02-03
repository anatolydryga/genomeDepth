#' read samtools idxstats and return how many reads mapped to each contig.
#' 
#' @parameter idxstats output file
#' file is produced by: samtools idxstats bamfile > idxstats_output 
#' @returns df with 2 columns: contig name(contig_name), number of reads mapped to the contig(read_count).
read_contig_to_read_count <- function(idxstasts_file) {
    if ( ! file.exists(idxstasts_file)) {
        stop("idxstats file is not found.")
    }
    contig_read_count <- read.delim(idxstasts_file, header=FALSE)
    if (ncol(contig_read_count) != 4) {
        stop("File format incorrest: idxstats file shuld have 4 columns.")
    }
    contig_read_count <- contig_read_count[-nrow(contig_read_count), c(1, 3)]
    colnames(contig_read_count) <- c("contig_name", "read_count")
    contig_read_count
}

