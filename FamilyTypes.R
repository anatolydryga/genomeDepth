# to run type : Rscript FamilyTypes.R  input_file_name.tsv
# on cmd line (Counts but not abundance is taken into account)

library(ggplot2)
library(RColorBrewer)
source("family_to_read.R")

input_file <- commandArgs(trailingOnly=TRUE)[1]

samples <- read.delim(input_file, stringsAsFactors=FALSE)

sample_family <- mapply(read_contig_annotation_sample, samples$files, samples$sample_name, 
        SIMPLIFY=FALSE, USE.NAMES=FALSE)
sample_family <- do.call(rbind, sample_family)

sample_family_count <- as.data.frame(table(
    sample_family$sample_name, sample_family$family, dnn=c("sample_name", "family")))

n_family <- length(unique(sample_family_count$family))
colorPallete <- colorRampPalette(brewer.pal(12, "Paired"))

ggplot(data = sample_family_count, aes(x=sample_name, y=Freq, fill=family)) + 
    geom_bar(stat = "identity", colour="darkgreen") + 
    theme_bw() +  scale_fill_manual(values=colorPallete(n_family)) +
    theme(axis.text.x = element_text(angle = 90)) +
    ggtitle("Viral Family  Composition")
ggsave("Viral_types.pdf", scale=1.3)
