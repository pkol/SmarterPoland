getEurostatRaw <-
function(kod = "educ_iste", rowRegExp=NULL, colRegExp=NULL) {
  adres <- paste("http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing?sort=1&file=data%2F",kod,".tsv.gz",sep="")
  tfile <- tempfile()
#  download and read file
  download.file(adres, tfile)
  dat <- read.table(gzfile(tfile), sep="\t", na.strings = ": ", header=FALSE, stringsAsFactors=FALSE)
  unlink(tfile)
  colnames(dat) <- as.character(dat[1,])
  dat <- dat[-1,]
  if (!is.null(rowRegExp)) {
    dat <- dat[grep(dat[,1], pattern=rowRegExp),,drop=FALSE]
  }
  if (!is.null(colRegExp)) {
    dat <- dat[,union(1, grep(colnames(dat), pattern=colRegExp)),drop=FALSE]
  }
  #  remove additional marks
  for (i in 2:ncol(dat)) {
    tmp <- sapply(strsplit(as.character(dat[,i]), split = ' '), `[`, 1)
    tmp[tmp==":"] = NA
    dat[,i] <-as.numeric(tmp)
  }
  dat
}
