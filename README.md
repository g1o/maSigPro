# maSigPro
This is a Fork from the read-only mirror of the Bioconductor SVN repository. Package Homepage: http://bioconductor.org/packages/devel/bioc/html/maSigPro.html Contributions: http://bioinfo.cipf.es/. Bug Reports: https://support.bioconductor.org/p/new/post/?tag_val=maSigPro.

I added a bit of parallelization to the T.fit (as T.fitP) and p.vector (as p.vectorP), This improves the speed by a lot if you can use many cpus and have like 180k transcripts from an RNA-seq.
