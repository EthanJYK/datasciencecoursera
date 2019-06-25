# Functions

#------------------------------------------------------------------------------#
# skip gram with stopword removal: 2gram, 3skip 
sw <- c(stopwords("en"), "one", "two", "three", "four", "five",
        "six", "seven", "eight", "nine", "zero", "num", "nth",
        "first", "second", "third", "https", "emailadd")

init1 <- c("I", "It", "The", "You", "If")
init2 <- c("I", "The", "We", "So", "And", "It", "What", "This", "When")
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# cleanse input texts
cleanse_input <- function(x){
    # urls to https
    x <- gsub("(https?://|HTTP[Ss]?://)?([\\w]{2,}\\.)?[\\w]{2,}\\.[A-Z-a-z]{2,3}(/\\w+)*/?( |$|\\W)", " https ", x, perl=T) 
    
    # expressions
    x <- gsub("(^| )%", " some", x, perl = T) # % to some
    x <- gsub("(.)\\1{2,}", "$1", x, perl=T) # aaaa bbb ooo ...
    x <- gsub("([Bb]/[Cc]|\\b[Cc]uz\\b)", "because", x)
    x <- gsub("[Ss]/[Oo]", "Shout out", x)
    x <- gsub("[Ww]/[Oo]", "Without", x)
    x <- gsub("[Ww]/", "with ", x)
    x <- gsub("\\b([Uu]|[Yy][Aa])\\b", "you", x)
    x <- gsub("(^| )[Uu][Rr] ", " your ", x)
    x <- gsub("(^| )[Dd][Aa] ", " the ", x)
    x <- gsub("(^| )[Tt](hx|thanx)", " thanks", x)
    x <- gsub("[Gg]onna", "going to", x)
    x <- gsub("[Gg]ottah?", "got to", x)
    x <- gsub("[Aa]fterall", "after all", x)
    x <- gsub("\\b[Aa]lot\\b", "a lot", x)
    x <- gsub("[Aa]tthe", "at the", x)
    x <- gsub("[Pp]lz", "please", x)
    x <- gsub("[Oo]utta", "ought to", x)
    x <- gsub("[Gg]ettin\\b", "getting", x)
    x <- gsub("[Ll]ookin\\b", "looking", x)
    x <- gsub("[Ff]reakin\\b", "freaking", x)
    x <- gsub("[Rr]ockin\\b", "rocking", x)
    x <- gsub("[Tt]alkin\\b", "talking", x)
    x <- gsub("[Cc]hillin\\b", "chilling", x)
    x <- gsub("[Ww]atchin\\b", "watching", x)
    x <- gsub("[Ll]ovin\\b", "loving", x)
    x <- gsub("[Ff]eelin\\b", "feeling", x)
    x <- gsub("[Ww]orkin\\b", "working", x)
    x <- gsub("[Ww]alkin\\b", "walking", x)
    x <- gsub("[Ss]omethin\\b", "something", x)
    x <- gsub("\\b[Ll]emme\\b", "let me", x)
    x <- gsub("\\b[Dd]oin\\b", "doing", x)
    x <- gsub("\\b[Gg]oin\\b", "going", x)
    x <- gsub("[Ee]verytime", "every time", x)
    x <- gsub("[Bb]tw\\b", "by the way", x)
    x <- gsub("[Aa]sap\\b", "as soon as possible", x)
    x <- gsub("[Ii]ma\\b", "I'm going to", x)
    
    # common typos
    x <- gsub("\\b[Dd]ont", "don't", x)
    x <- gsub("\\b[Dd]idnt", "didn't", x)
    x <- gsub("[Aa]int", "ain't", x)
    x <- gsub("[Ww]ont", "won't", x)
    x <- gsub("\\b[Cc]ant\\b", "can't", x)
    x <- gsub("[Dd]oesnt", "doesn't", x)
    x <- gsub("[Hh]avent", "haven't", x)
    x <- gsub("[Ii]snt", "isn't", x)
    x <- gsub("[Ha]asnt", "hasn't", x)
    x <- gsub("[Ww]asnt", "wasn't", x)
    x <- gsub("[Ww]erent", "weren't", x)
    x <- gsub("[Nn]othin\\b", "nothing", x)
    x <- gsub("[Ww]ouldnt", "wouldn't", x)
    x <- gsub("[Cc]ouldnt", "couldn't", x)
    x <- gsub("[Nn]eedntb", "needn't", x)
    x <- gsub("[Ss]houldnt", "shouldn't", x)
    x <- gsub("[Ww]ould(ve|'?a+)", "would've", x)
    x <- gsub("[Ss]hould(ve|'?a+)", "should've", x)
    x <- gsub("[Cc]ould(ve|'?a+)", "could've", x)
    x <- gsub("[Mm]ight(ve|'?a+)", "might've", x)
    x <- gsub("\\b[Ll][Oo][Ll]\\b", "", x)
    
    # &s
    x <- gsub(" & ", " and ", x) # & to and
    
    # @s
    x <- gsub("[\\w\\-_\\.]{3,}@[\\w\\-_]{2,}\\.[A-Za-z]{2,3}([A-Za-z]{2})?", "emailadd", x, perl=T) # emails
    
    # -_s
    x <- gsub("[-_]", " ", x)
    
    # possesive 's -> remove
    x <- gsub("(?<![Hh][Ee]|[Ii][Tt]|[Hh][Ee][Rr][Ee]|[Hh][Oo][Ww]|[Ww][Hh][Oo]|[Ww][Hh][Aa][Tt]|[Ww][Hh][Ee][Nn]|[Ww][Hh][Ee][Rr][Ee]|[Ww][Hh][Yy])'[Ss]", "", x, perl=T)
    
    return(x)
} 
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# predict.word function

predict.word <- function(x){
    # 1. split
    x <- na.omit(unlist(strsplit(x, "(?<!Mr\\.|Mrs\\.|Dr\\.|Ms\\.|St\\.|Jr\\.|Ph\\.D\\.)(?<=[;!?\\.])[\"\']?\\s+(?=[A-Za-z$:;])", perl=T)))
    x <- x[length(x)]
    
    # 2. cleanse
    x <- cleanse_input(x)
    
    # 3. token - unlist input
    t <- tokens(tolower(x), what = "word", remove_numbers = TRUE, remove_punct = TRUE,
                remove_symbols = TRUE, remove_twitter = TRUE)
    x <- t$text1; x[-which(x %in% wordpool)] <- "unk"
    xs <- tokens_remove(t, sw, padding = FALSE)$text1; xs[-which(xs %in% wordpool)] <- "unk"
    l <- length(x)
    
    # input values by count
    x5 <- paste(x[max((l-3),0):l], collapse = " ")
    x4 <- paste(x[max((l-2),0):l], collapse = " ")
    x3 <- paste(x[max((l-1),0):l], collapse = " ")
    x2 <- x[l]
    #xs1 <-xs[max(length(xs)-1,0)]
    xs2 <-xs[max(length(xs)-2,0)]
    
    # search table
    r3 <- dt3[x3, on="V1"]
    rs2 <- dts[xs2, on="V1"]
    
    ## core
    rc <- r3[r3$V2 %in% rs2$V2][,2:3] 
    rc$KN <- rc$KN + rs2[V2 %in% rc$V2]$P
    setorder(rc, -KN)
    # rc$V2[1:5] # test
    unique(na.omit(c(dt5[x5, on="V1"]$V2[1:3], 
                     dt4[x4, on="V1"]$V2[1:4], 
                     rc$V2[1:3], 
                     r3[order(-KN)]$V2[1:5], 
                     dt2[x2, on="V1"]$V2[1:5], 
                     dt2["unk", on="V1"]$V2[1:5]))
           )[1:5]
}
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# complete word function
complete.word <- function(x) {
    l <- unlist(strsplit(x, " "))
    text <- l[length(l)]
    t <- tolower(text)
    edit_dist <- stringdist(t, dt1$V2)
    min_edit_dist <- min(edit_dist, 2)
    if (min_edit_dist == 0) {
        target <- dt1$V2[edit_dist == 0]
        a <- unique(na.omit(c(target, dt1[grep(paste("^", target, sep=""), dt1$V2)][order(-KN)]$V2[1:5])))
    } else {
        a <- na.omit(c(dt1[edit_dist == 1][order(-KN)]$V2, dt1[edit_dist == 2][order(-KN)]$V2, t)[1:5])
    }
    a <- a[!is.na(a)]
    ifelse(substr(text, 1, 1) %in% LETTERS, a <- firstup(a), a)
    return(a)
}
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Capitalize the first alphabet of a string
firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    return(x)
}
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Run prediction!
run <- function(x){
    t <- substr(x, nchar(x)-2, nchar(x))
    if (t == ""| t == " +") {init1
    } else if (grepl(".?[\\.\\?!][\"']? +", t)) {sample(init2, 5)
    } else if (grepl("[^ ]?[^\\.\\?!] +", t)) {predict.word(x) #nonblank+[non.,!?]+ 
    } else complete.word(x)
}
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Paste results
paster <- function(x, y){
    t <- substr(x, nchar(x), nchar(x))
    if (y %in% c(",", ".")) {
        r <- paste(gsub(" +$", "", x), y, " ", sep="")
    } else if (y == " "| t == " "| t == "" ){
        r <- paste(x, y, " ", sep = "")
    } else {
        e <- unlist(gregexpr(" ", x))
        r <- paste(substr(x, 1, e[length(e)]), y, " ", sep="")
    }
    return(r)
}
#------------------------------------------------------------------------------#