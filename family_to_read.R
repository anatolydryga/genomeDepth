#' read contig annotation file

get_contig_annotation <- function(contig_annotation_file) {
    return(NULL)
}

#' for a given dataframe with info about how many reads are mapped to contig 
#' add viral family annotation
#' @return dataframe with 3 columns: contig name, number of reads mapped to contig, viral family.
#'
add_family_annotation <- function(contig_to_read_count, contig_annotation) {
    return(NULL)
}

#' for each family conts how many reads were mapped to the family. 
#' 
#' @return dataframe with 2 columns: family name, number of reads mapped to the family.
#' @seealso add_family_annotation
get_family_to_read_count <- function(contig_read_family) {
    return(NULL)
}
