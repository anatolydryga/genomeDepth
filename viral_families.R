#' for a given samples, find viral families
#' 
#' @param sample dataframe with 2 columns: idxstats_file, sample_name.
#' @param contig annotation for list of contigs that were used in mapping.
#'
#' @return dataframe with 3 columns: family, read_count, sample name.
#' 
viral_families <- function(samples, contig_annotation) {
    
    samples_char <- data.frame(lapply(samples, as.character), stringsAsFactors=FALSE)
    
    families <- apply(samples_char, 1, 
        function(x, annotation) { family_read_count_for_sample(x[1], x[2], annotation)}, contig_annotation)
    
    do.call("rbind", families)
}


#' for a given annotation of contigs per samples, find viral families counts for each sample
#' 
#' @param sample dataframe with 2 columns: contig_annotation, sample_name.
#'
#' @return dataframe with 3 columns: family, contig_count, sample name.
#' 
viral_families_contigs <- function(annotation_samples) {
    
    samples_char <- data.frame(lapply(annotation_samples, as.character), stringsAsFactors=FALSE)
    
    families <- apply(samples_char, 1, 
        function(x) { family_contig_count_for_sample(read_contig_annotation(x[1]), x[2])})
    
    do.call("rbind", families)
}


#' aux function that return dataframe described in @see viral_families for a given sample.
family_read_count_for_sample <- function(idxstats_file, sample_name, contig_annotation) {
    # read file
    contig_read_count <- read_contig_to_read_count(idxstats_file)
    # merge 
    contig_read_count_family <- add_family_annotation(contig_read_count, contig_annotation)
    # summarize count for each family
    family_read_count <- get_family_to_read_count(contig_read_count_family)

    family_read_count$sample <- sample_name

    family_read_count
}
