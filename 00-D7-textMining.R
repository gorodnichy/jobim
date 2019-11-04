



library(data.table)

#library(spacyr) connect to NLP python

library(ggplot2)
#library(ggthemes); #library(RColorBrewer)
theme_set(theme_minimal())
#   p_theme =  theme_bw(); #   # theme_minimal(); theme_economist(); theme_economist_white();# g+p_theme

library(tidyverse)
library(tidytext)


filename <- "01-Two-Lives-book.Rmd" # "01-amor-a.Rmd"



# > 1.0 stackoverfloor approach: Read .Rmd file and split into sections ####

if (F) {
  # from my stackoverfloor question question


  if (F) { # - Way #1 I used it in my StakeOverfloor question
    library(readtext)
    dt <- readtext(filename) %>% data.table()
    strEntireText <- dt[1,1]
  }


  ## A df where each line is a row in the rmd file.

  raw <- data_frame(text = read_lines(filename))

  ## We don't want to mark R comments as sections.
  d7.detect_codeblocks <- function(text) {
    blocks <- text %>%
      str_detect("```") %>%
      cumsum()

    blocks %% 2 != 0
  }


  #extract information, such as headers, using regex patterns. ####
  df <-
    raw %>%
    mutate(
      code_block = detect_codeblocks(text),
      section = text %>%
        str_match("^# .*") %>%
        str_remove("^#+ +"),
      section = ifelse(code_block, NA, section),
      subsection = text %>%
        str_match("^## .*") %>%
        str_remove("^#+ +"),
      subsection = ifelse(code_block, NA, subsection)
    ) %>%
    fill(section, subsection)

  #to glue the text together within sections/subsections,
  ## then just group by them and flatten the text.

  dtSongs <- df %>%
    group_by(section, subsection) %>%
    slice(-1) %>%                           # remove the header
    summarize(
      text = text %>%
        str_flatten(" ") %>%
        str_trim()
    ) %>%
    ungroup() %>%
    data.table()


  for(i in 1:nrow(dtSongs)){
    cat(i)
    print(dtSongs[i]$section)
    print(dtSongs[i]$subsection)
    print(dtSongs[i]$text)
    dd.getKey()
  }

  dtSongs[c(4,5,8,13, 15,17,19,21) ]$text %>% str_c() %>% str_wrap()

  dtSongs[c(4,5,8,13, 15,17,19,21) ]$subsection

}

# > 2.0 tidytext approach #### #####################################


wordsTechnical <- c("blockquote", "pre", "cite", "жобим", "стихи",
                    "диньджи", "ча", "de", "beber",
                    "agua", "aqua", "camara", "camara",
                    "что", #"как",  "когда"
                    "и", "в", "с", "у","о", "o","б","к", "д",
                    "по", "под",
                    "на", "из", "за", "же", "что", "б")

# 2.1 Extract words ####


d7.getWords<- function(filename) {

  text <- read_lines(filename)
  text_df <- data_frame(line = 1:length(text), text = text)

  dt_tidy_books <- text_df %>%
    unnest_tokens(word, text) %>% data.table()



  #dt_tidy_books <- dt_tidy_books[str_length(word)>1]
  #  dt_tidy_books <- dt_tidy_books[str_length(word)<12]
  dt_tidy_books <- dt_tidy_books[!(word %in% wordsTechnical)]

  #  dt_tidy_books[, .N, word][N>1][order(str_length(word))][1:100]
  dt_tidy_books[, .N, word][N>1][order(N)] %>% print()


  # 2.1.  words stats ####

  dt_tidy_books %>%
    count(word, sort = TRUE) %>%
    filter(n > 2) %>%
    mutate(word = reorder(word, n)) %>%
    ggplot(aes(word, n)) +
    geom_col() +
    xlab(NULL) +
    coord_flip()



  # 2.2. Wordclouds ####


  library(wordcloud)

  dt_tidy_books %>%
    #  anti_join(stop_words) %>%
    count(word) %>%
    with(wordcloud(word, n, min.freq=2,
                   random.order=F, random.color=F, ordered.colors=T,
                   colors=brewer.pal(8, "Dark2"),
                   rot.per=0.0

    ))


  return(dt_tidy_books)
}

#tidy_books <- getWords("01-amor-a.Rmd")




# 2.3.  comparative plots ####

#View(tidy_books)
plotComperativePlots(tidy_books,tidy_books2 ) {

  frequency <- bind_rows(mutate(tidy_books, author = "amour"),
                         mutate(tidy_books2, author = "ocean")) %>%
    #  mutate(word = str_extract(word, "[a-z']+")) %>%
    count(author, word) %>%
    group_by(author) %>%
    mutate(proportion = n / sum(n)) %>%
    select(-n) %>%
    spread(author, proportion) %>%
    gather(author, proportion, `amour`:`amour`)

  library(scales)

  # expect a warning about rows with missing values being removed
  g <- ggplot(frequency, aes(x = proportion, y = `ocean`, color = abs(`ocean` - proportion))) +
    geom_abline(color = "gray40", lty = 2) +
    geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
    geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
    scale_x_log10(labels = percent_format()) +
    scale_y_log10(labels = percent_format()) +
    scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
    facet_wrap(~author, ncol = 2) +
    theme(legend.position="none") +
    labs(y = "«Ocean» (About Life)", x = "«Grand amor» (About Love)" )

  print(g)
}

# >> 5 "text mining Russian R" #####


# 5.1 no http://datascience-enthusiast.com/R/twitter.html ####

#import positive and negative words; data can be downloaded from
# https://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html






# 5.2 www.aot.ru

# https://academic.oup.com/dsh/article/32/suppl_1/i17/2755123


# 5.3 https://stackoverflow.com/questions/47339479/sentiment-analysis-text-analytics-in-russian-cyrillic-languages ####


d7.get_sentiment_rus <- function(char_v, method="custom", lexicon=NULL, path_to_tagger = NULL, cl = NULL, language = "english") {
  language <- tolower(language)
  russ.char.yes <- "[\u0401\u0410-\u044F\u0451]"
  russ.char.no <- "[^\u0401\u0410-\u044F\u0451]"

  if (is.na(pmatch(method, c("syuzhet", "afinn", "bing", "nrc",
                             "stanford", "custom"))))
    stop("Invalid Method")
  if (!is.character(char_v))
    stop("Data must be a character vector.")
  if (!is.null(cl) && !inherits(cl, "cluster"))
    stop("Invalid Cluster")
  if (method == "syuzhet") {
    char_v <- gsub("-", "", char_v)
  }
  if (method == "afinn" || method == "bing" || method == "syuzhet") {
    word_l <- strsplit(tolower(char_v), "[^A-Za-z']+")
    if (is.null(cl)) {
      result <- unlist(lapply(word_l, get_sent_values,
                              method))
    }
    else {
      result <- unlist(parallel::parLapply(cl = cl, word_l,
                                           get_sent_values, method))
    }
  }
  else if (method == "nrc") {
    #    word_l <- strsplit(tolower(char_v), "[^A-Za-z']+")
    word_l <- strsplit(tolower(char_v), paste0(russ.char.no, "+"), perl=T)
    lexicon <- dplyr::filter_(syuzhet:::nrc, ~lang == tolower(language),
                              ~sentiment %in% c("positive", "negative"))
    lexicon[which(lexicon$sentiment == "negative"), "value"] <- -1
    result <- unlist(lapply(word_l, get_sent_values, method,
                            lexicon))
  }
  else if (method == "custom") {
    #    word_l <- strsplit(tolower(char_v), "[^A-Za-z']+")
    word_l <- strsplit(tolower(char_v), paste0(russ.char.no, "+"), perl=T)
    result <- unlist(lapply(word_l, get_sent_values, method,
                            lexicon))
  }
  else if (method == "stanford") {
    if (is.null(path_to_tagger))
      stop("You must include a path to your installation of the coreNLP package.  See http://nlp.stanford.edu/software/corenlp.shtml")
    result <- get_stanford_sentiment(char_v, path_to_tagger)
  }
  return(result)
}

# 5.4 https://stats.stackexchange.com/questions/9674/how-to-remove-stopwords-with-russian-documents ####


if (F) {

  library("tm")

  # import text files in corpus text – ok
  c_txt <- Corpus((DirSource(directory = ".", pattern ="txt",
                             encoding = "UTF-8")), readerControl = list(language = "rus"))

  # convert to Lower Case – ok
  txt_cl <- tm_map(c_txt, tolower)

  # remove Stopwords - not working
  txt_cl <- tm_map(txt_t, removeWords, stopwords("russian"))

  #I am inspecting the file russian.dat which is located in the subdirectory tm\stopwords


}


############################################################################################ #

# >>>> Useful functions for text ####

# . Word cloud generator in R : One killer function to do everything you need ####
# from http://www.sthda.com/english/wiki/print.php?id=159



#  R code of rquery.wordcloud function

#++++++++++++++++++++++++++++++++++
# rquery.wordcloud() : Word cloud generator
# - http://www.sthda.com
#+++++++++++++++++++++++++++++++++++
# x : character string (plain text, web url, txt file path)
# type : specify whether x is a plain text, a web page url or a file path
# lang : the language of the text
# excludeWords : a vector of words to exclude from the text
# textStemming : reduces words to their root form
# colorPalette : the name of color palette taken from RColorBrewer package,
# or a color name, or a color code
# min.freq : words with frequency below min.freq will not be plotted
# max.words : Maximum number of words to be plotted. least frequent terms dropped

# value returned by the function : a list(tdm, freqTable)
d7.rquery.wordcloud <- function(x, type=c("text", "url", "file"),
                             lang="english", excludeWords=NULL,
                             textStemming=FALSE,  colorPalette="Dark2",
                             min.freq=3, max.words=200)
{
  library("tm")
  library("SnowballC")
  library("wordcloud")
  library("RColorBrewer")

  if(type[1]=="file") text <- readLines(x)
  else if(type[1]=="url") text <- html_to_text(x)
  else if(type[1]=="text") text <- x

  # Load the text as a corpus
  docs <- Corpus(VectorSource(text))
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove stopwords for the language
  docs <- tm_map(docs, removeWords, stopwords(lang))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Remove your own stopwords
  if(!is.null(excludeWords))
    docs <- tm_map(docs, removeWords, excludeWords)
  # Text stemming
  if(textStemming) docs <- tm_map(docs, stemDocument)
  # Create term-document matrix
  tdm <- TermDocumentMatrix(docs)
  m <- as.matrix(tdm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  # check the color palette name
  if(!colorPalette %in% rownames(brewer.pal.info)) colors = colorPalette
  else colors = brewer.pal(8, colorPalette)
  # Plot the word cloud
  set.seed(1234)
  wordcloud(d$word,d$freq, min.freq=min.freq, max.words=max.words,
            random.order=FALSE, rot.per=0.35,
            use.r.layout=FALSE, colors=colors)

  invisible(list(tdm=tdm, freqTable = d))
}


# . Download and parse webpage ####
d7.html_to_text<-function(url){
  library(RCurl)
  library(XML)
  # download html
  html.doc <- getURL(url)
  #convert to plain text
  doc = htmlParse(html.doc, asText=TRUE)
  # "//text()" returns all text outside of HTML tags.
  # We also don’t want text such as style and script codes
  text <- xpathSApply(doc, "//text()[not(ancestor::script)][not(ancestor::style)][not(ancestor::noscript)][not(ancestor::form)]", xmlValue)
  # Format text vector into one character string
  return(paste(text, collapse = " "))
}


# >>>> additional refs: ####

# . library(RYandexTranslate) ####

library(RYandexTranslate)
ls("package:RYandexTranslate")

api_key <- "trnsl.1.1.20180601T211053Z.1884dfdd1d3ac73a.88a2944748f3b9eb15eb9c198d1ccc29630d48f4"

directions=get_translation_direction(api_key)
directions

# Error: lexical error: invalid char in json text
data=detect_language(api_key,text="how are you?")
data

data=translate(api_key,text="how are you?",lang="en-hi")
data

############################################################################################ #


# >> Related to: DLwR-s6.1-RNN-for-text.R
# related to Text Mining with Deep Learning (RNN) Tutorials
#
if (F) {

  # http://www.rpubs.com/mukul13/rword2vec ----

  library(devtools)
  install_github("mukul13/rword2vec")
  library(rword2vec)
  ls("package:rword2vec")

  model=word2vec(train_file = "text8",output_file = "vec.bin",binary=1) # Crushes here

}

# >>>>  RStudio Tensorflow for text ####


# See also: Studio Tensorflow 7 Keras for text ####

# DLwR-s3-IMDB_sentimentBinary+wiresClassification+housepriceReression
# DLwR-s6.1-RNN-for-text.R
# RStudio-keras-02-text-imdb.R
# RStudio-keras-02b-tweets-kerasformula.R

# 2> https://rpubs.com/pjmurphy/265713 -  Basic Text Mining in R , Philip Murphy, PhD, 4/4/2017 ####



############################################################################################ #
# 3> library(udpipe) ####
# Text Analysis in R made easy with Udpipe
# https://towardsdatascience.com/easy-text-analysis-on-abc-news-headlines-b434e6e3b5b8 -
############################################################################################ #

library(udpipe)

#model <- udpipe_download_model(language = "russian")
udmodel_russian <- udpipe_load_model(file = 'russian-ud-2.0-170801.udpipe')


model <- udpipe_download_model(language = "english")
udmodel_english <- udpipe_load_model(file = 'english-ud-2.0-170801.udpipe')


############################################################################################ #
# 4> http://kenbenoit.net/pdfs/text_analysis_in_R.pdf ####






############################################################################################ #
# 5> http://www.rdatamining.com/ - RDataMining.com: R and Data Mining ####
# http://www2.rdatamining.com/uploads/5/7/1/3/57136767/rdatamining-book.pdf






# 0> Create your own text dataset - to play with ####


library(tidyverse)
library(data.table)

dirSlova <- "c:\\Users\\Computer\\Documents\\_CODES\\_OPEN\\D7\\tutorials\\vse-slova\\"
filename <- paste0(dirSlova,"2010-entre-ciel-et-terre.Rmd")

if (F) { # - Way #1 I used it in my StakeOverfloor question
  library(readtext)
  df <- readtext(filename);  dt <- df %>% data.table()
  strEntireText <- dt[1]$text
  # Creates one LOOOONG string: > names(dt)   [1] "doc_id" "text"
}


## We don't want to mark R comments as sections.
d7.detect_codeblocks <- function(text) {
  blocks <- text %>%
    str_detect("```") %>%
    cumsum()
  blocks %% 2 != 0
}

## A df where each line is a row in the rmd file.

text2 = read_lines(filename); raw <- data_frame(text = text2)


#raw1 <- raw %>% mutate (text = ifelse(str_length(text)==0),"\n", text)

dt <- raw %>% data.table()
dt[str_length(text)==0, text:="\n"]
dt[text=="\n"]

dt <-
  dt %>%
  mutate(
    code_block = d7.detect_codeblocks(text),
    section = text %>%
      str_match("^# .*") %>%
      str_remove("^#+ +"),
    section = ifelse(code_block, NA, section),
    subsection = text %>%
      str_match("^## .*") %>%
      str_remove("^#+ +"),
    subsection = ifelse(code_block, NA, subsection)
  ) %>%
  tidyr::fill(section, subsection)


#to glue the text together within sections/subsections,
## then just group by them and flatten the text.

dtChapters <- dt %>%
  group_by(section, subsection) %>%
  slice(-1) %>%                           # remove the header
  summarize(
    text = text %>%
      str_flatten(" ") %>%
      str_trim()
  ) %>%
  ungroup() %>%
  data.table()

dtChapters[c(1) ]$section 
dtChapters[c(1) ]$subsection 
dtChapters[c(1) ]$text %>% str_c() %>% str_wrap()

i=2
for(i in 1:nrow(dtChapters)){
  cat(i)
  print(dtChapters[i]$section)
  print(dtChapters[i]$subsection)
  #print(dtChapters[i]$text)
  dtChapters[c(1) ]$text %>% str_c() %>% str_wrap() %>% print
  
  cat(glue::glue("\n\n# Section: {dtChapters[i]$section} \n \n"))
  
  cat(glue::glue("Subsection: {dtChapters[i]$subsection}. \n \n"))
  
  cat(glue::glue("{dtChapters[i]$text}"))
  print(knitr::kable(dtCutX))
  
  
  if (readline("continue? ") == 'n') break
}



# # Using glue() #####
# 
# ```{r echo=F, results='asis'} 
# 
# library(glue); library(ggplot2)
# 
# dt <- ggplot2::diamonds %>% data.table()
# for (cutX in unique(dt$cut)) {
#   dtCutX <- dt[cut==cutX, lapply(.SD,mean), .SDcols=5:7]
#   
#   cat(glue::glue("\n\n# Section: The Properties of Cut {cutX} \n \n"))
#   cat(glue::glue("This Section describes the properties of cut {cutX}. \n Table below shows its mean values:\n"))
#   
#   cat(glue::glue("\n\nThe largest carat value for cut {cutX} is {dt[cut=='Ideal', max(carat)]}\n"))
#   print(knitr::kable(dtCutX))
#   print("***\n\n")
# }
# ```
# 



# . Assign your text dataset to samples to be use in tutorial excercises above ####

samples <- dtChapters$text[-1]
samples <- samples[-1]

#



