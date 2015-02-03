#Genome Coverage and Depth

## Family Read Count
```R
# only need to read once for specific set of contigs
contig_annotation <- read_contig_annotation(contig_annotation_file) 

# for each sample mapped to contigs:
# read file
contig_read_count <- read_contig_to_read_count(idxstasts_file)
# merge 
contig_red_count_family <- add_family_annotation(contig_read_count, contig_annotation)
# summarize count for each family
family_read_count <- get_family_to_read_count(contig_red_count_family)
```

## Testing

run the following in R console:

```
test_dir(".")
```
