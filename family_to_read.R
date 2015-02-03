#' read contig annotation file
read_contig_annotation <- function(contig_annotation_file) {
    if ( ! file.exists(contig_annotation_file)) {
        stop("contig annotation file is not found.")
    }
    contig_annotation <- read.delim(contig_annotation_file)
    if ( ! "family" %in% colnames(contig_annotation)) {
        stop("Contig annotation should have family column.")
    }
    contig_annotation$contig_name <- as.character(contig_annotation$contig_name)
    contig_annotation
}

#' for a given dataframe with info about how many reads are mapped to contig 
#' add viral family annotation
#'
#' @return dataframe with 3 columns: contig name(contig_name), 
#' number of reads mapped to contig(read_count), viral family(family).
add_family_annotation <- function(contig_to_read_count, contig_annotation) {
    contig_family <- contig_annotation[, c("contig_name", "family")]
    contig_read_family <- merge(contig_to_read_count, contig_family, all.x=TRUE)
    contig_read_family
}

#' for each family conts how many reads were mapped to the family. 
#' 
#' @return dataframe with 2 columns: family name, number of reads mapped to the family.
#' @seealso add_family_annotation
get_family_to_read_count <- function(contig_read_family) {
    with_family_annotation <- aggregate(read_count ~ family, contig_read_family, sum)
    with_family_annotation$family <- as.character(with_family_annotation$family)
    no_family_annotation <- sum(contig_read_family[is.na(contig_read_family$family), 2])
    family_read <- rbind(with_family_annotation, 
        data.frame(family="UNKNOWN", read_count=no_family_annotation))
    family_read$family <- as.factor(family_read$family)
    family_read
}
