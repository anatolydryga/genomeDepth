# to run type : Rscript FamilyTypes.R  input_file_name.tsv
# on cmd line (Counts but not abundance is taken into account)

library(ggplot2)
library(RColorBrewer)
source("family_to_read.R")

input_file <- commandArgs(trailingOnly=TRUE)[1]
annotation_column <- commandArgs(trailingOnly=TRUE)[2]
useNAs <- commandArgs(trailingOnly=TRUE)[3]
#the options for use NAs are "useNA" or "noNA"

samples <- read.delim(input_file, stringsAsFactors=FALSE)

sample_family <- mapply(read_contig_annotation_sample, samples$files, samples$sample_name, 
        SIMPLIFY=FALSE, USE.NAMES=FALSE)
sample_family <- do.call(rbind, sample_family)


if(useNAs == "useNA"){
		     sample_family_count <- as.data.frame(table(
    			sample_family$sample_name, sample_family[,annotation_column], dnn=c("sample_name", annotation_column),
    			useNA= "ifany"))

		    levels(sample_family_count[,annotation_column]) <- c(levels(sample_family_count[,annotation_column]), "Other")
		    sample_family_count[,annotation_column][which(is.na(sample_family_count[,annotation_column]))] <- "Other"
} else {
	sample_family_count <- as.data.frame(table(
    		sample_family$sample_name, sample_family[,annotation_column], dnn=c("sample_name", annotation_column),
    		useNA= "no"))
}

n_family <- length(unique(sample_family_count[,annotation_column]))
colorPallete <- colorRampPalette(brewer.pal(12, "Paired"))

ggplot(data = sample_family_count, aes_string(x="sample_name", y="Freq", fill=annotation_column)) + 
    geom_bar(stat = "identity", colour="darkgreen") + 
    theme_bw() +  scale_fill_manual(values=colorPallete(n_family)) +
    theme(axis.text.x = element_text(angle = 90)) +
    ggtitle(paste(annotation_column," top NCBI annotation: counts",sep = ""))
ggsave(paste(annotation_column,"_types_counts_", useNAs, ".pdf", sep =""), scale=1.3)

ggplot(data = sample_family_count, aes_string(x="sample_name", y="Freq", fill=annotation_column)) +
    geom_bar(stat = "identity", colour="darkgreen", position = "fill") +
    theme_bw() +  scale_fill_manual(values=colorPallete(n_family)) +
    theme(axis.text.x = element_text(angle = 90)) +
    ggtitle(paste(annotation_column," top NCBI annotation: proportions",sep = ""))
ggsave(paste(annotation_column,"_types_proportions_", useNAs, ".pdf", sep =""), scale=1.3)

