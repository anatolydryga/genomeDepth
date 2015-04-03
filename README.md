#Genome Coverage and Depth

## Coverage, Depth and Number of Reads mapped to Contigs

Number of reads mapped produced by samtools:

```bash
samtools idxstats file.bam > result_idxstats.dat
```

BAM file should be sorted and indexed.



## Family Read Count
```R
# only need to read once for specific set of contigs
contig_annotation <- read_contig_annotation(contig_annotation_file) 

# for each sample mapped to contigs:
# read file
contig_read_count <- read_contig_to_read_count(idxstats_file)
# merge 
contig_read_count_family <- add_family_annotation(contig_read_count, contig_annotation)
# summarize count for each family
family_read_count <- get_family_to_read_count(contig_read_count_family)
```

Or we can use a wrapper function for mulsiple samples:
```R

contig_annotation <- read_contig_annotation("sample_contig_annotation.txt")

samples <- data.frame(
    idxstats_file=c("sample_idxstats.txt", "sample_idxstats_2nd.txt"),
    sample_name=c("Sample1", "Sample2")
)

families <- viral_familes(samples, contig_annotation)

```

## Testing

run the following in R console:

```
library(testthat)
test_dir(".")
```
