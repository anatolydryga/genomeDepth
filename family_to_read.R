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
#' @param idxstats produced by read_idxstats(filename)
#'
#' @return dataframe with 3 columns: contig name(contig_name), 
#' number of reads mapped to contig(read_count), viral family(family).
add_family_annotation <- function(idxstats, contig_annotation) {
    contig_family <- contig_annotation[ , c("contig_name", "family")]
    contig_to_read_count <- idxstats[ , c("contig_name", "mapped")] 
    names(contig_to_read_count) <- c("contig_name", "read_count")
    contig_read_family <- merge(contig_to_read_count, contig_family, all.x=TRUE)
    contig_read_family
}

#' for each family conts how many reads were mapped to the family. 
#' 
#' @return dataframe with 2 columns: family name, number of reads mapped to the family.
#' @seealso add_family_annotation
get_family_to_read_count <- function(contig_read_family) {
    if (sum(is.na(contig_read_family$family)) == length(contig_read_family$family)) { # all NAs and nothing else
        no_family_annotation <- sum(contig_read_family$read_count[is.na(contig_read_family$family)])
        return(data.frame(family="UNKNOWN", read_count=no_family_annotation))
    }
    with_family_annotation <- aggregate(read_count ~ family, contig_read_family, sum)
    with_family_annotation$family <- as.character(with_family_annotation$family)
    no_family_annotation <- sum(contig_read_family$read_count[is.na(contig_read_family$family)])
    family_read <- rbind(with_family_annotation, 
        data.frame(family="UNKNOWN", read_count=no_family_annotation))
    family_read$family <- as.factor(family_read$family)
    family_read
}

#' for each family counts how many contigs mapped to the family.
#'
#' @param contig_annotation df
#' @return dataframe with 2 columns: family name, number of contigs mapped to the family.
get_family_to_contig_count <- function(contig_annotation) {
    # aux read_count column added to use get_family_to_read_count f
    fam_count <- data.frame(read_count=c(1.0), family=contig_annotation$family) 
    get_family_to_read_count(fam_count)
}

#' aux function that adds sample name to get_family_to_contig_count df
family_contig_count_for_sample <- function(contig_annotation, sample_name) {
    family_count <- get_family_to_contig_count(contig_annotation)
    family_count$sample <- sample_name
    family_count
}
