#' read samtools idxstats and return how many reads mapped/unmapped to each contig.
#' 
#' @parameter idxstats output file
#' file is produced by: samtools idxstats bamfile > idxstats_output 
#' @returns df with 4 columns: contig name(contig_name), contig_length,
#' number of reads mapped to the contig(mapped), number of reads unmapped to the contig(unmapped).
read_idxstats <- function(idxstasts_file) {
    if ( ! file.exists(idxstasts_file)) {
        stop("idxstats file is not found.")
    }
    idx <- read.delim(idxstasts_file, header=FALSE)
    if (ncol(idx) != 4) {
        stop("File format incorrest: idxstats file shuld have 4 columns.")
    }
    idx <- idx[ -nrow(idx), ] # remove last row with *
    colnames(idx) <- c("contig_name", "contig_length", "mapped", "unmapped")
    idx
}

