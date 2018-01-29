
library(knitr)
print(sessionInfo())
Sys.getlocale("LC_CTYPE") # "English_Canada.1252"
getOption("encoding"); #"native.enc"



Sys.setlocale("LC_CTYPE", "russian") #"Russian_Russia.1251"
options(encoding = 'UTF-8')



dt <- data.frame(
  name=c("Борис Немцов","Martin Luter King"),
  year=c("2015","1968")
)

dt$name;
dt; kable(dt)
print(dt,encoding="windows-1251"); print(dt,encoding="UTF-8") #no effect

dt$name <- enc2utf8(as.character(dt$name))
dt; kable(dt)



#####################################33 #

library(rjson);library(ggplot2);require(magrittr);library(wrapr);
library(knitr)
require(magrittr);library(data.table);

print(sessionInfo())

#File: testing to undertand how russian coding is done Windows vs. Rstudio vs. data.table / kable

# NB: this file was saved with 1251 encoding, _after which_ Russian text was pasted into from web ! Otherwise all russian charecters show as ???

# http://blog.rolffredheim.com/2013/01/r-and-foreign-characters.html

Encoding(colnames(YOURDATAFRAME)) <- "UTF-8"
Encoding(dtInfo) <- "UTF-8"

# how to UTF-8 to 1251 in R
# https://tomizonor.wordpress.com/2013/04/17/file-utf8-windows/
# https://www.smashingmagazine.com/2012/06/all-about-unicode-utf8-character-sets


Sys.setlocale(,"russian")
Sys.setlocale(,"ru_RU")


#[1] "ru_RU/ru_RU/ru_RU/C/ru_RU/C"
test1 = c("привет","пока")

write(test1, file="test2.txt")



#THIS WORKS ####
Sys.setlocale("LC_CTYPE", "russian") #"Russian_Russia.1251"
options(encoding = 'UTF-8')

test2 = enc2utf8(c("привет","пока"))
write(test2, file="test2.txt")

dtInfo <- data.table(
  album=enc2utf8(c("Волна","Волна2")),
  text=c("ВолнаВолна","ВолнаВолна33") # it appears that when I paste  from web,it still saves in UTF-8.
)

dtInfo # <U+0412><U+043E><U+043B><U+043D><U+0430>
dtInfo$album # "Волна"
dtInfo$text # "Волна"
dtInfo # <U+0412><U+043E><U+043B><U+043D><U+0430>
print(dtInfo,encoding="windows-1251"); print(dtInfo,encoding="UTF-8") #no effect
dtInfo %>% kable() # <U+0412><U+043E><U+043B><U+043D><U+0430>




brr2rus <- function(x) { #<U+041D>  <=> Н
  as.character(parse(text = shQuote(gsub("<U\\+([A-Z0-9]+)>", "\\\\u\\1",x))))
}

as.character(parse(text = shQuote(gsub("<U\\+([A-Z0-9]+)>", "\\\\u\\1", "<U+041D>"))))


############################################ #
# test 1: Sys.setlocale and l10n_info ? ####
############################################ #

Sys.setlocale("LC_CTYPE", "russian") #"Russian_Russia.1251"
#Sys.setlocale("LC_CTYPE", "Russian_Russia.UTF-8") #?? OS reports request to set locale to "Russian_Russia.UTF-8" cannot be honored
#Sys.setlocale("LC_CTYPE", "Russian_Russia.utf8") #?? OS reports request to set locale to "Russian_Russia.UTF-8" cannot be honored

Sys.setlocale("LC_CTYPE", "english") # "English_United States.1252"
Sys.setlocale("LC_CTYPE", "English_Canada.1252")
Sys.getlocale("LC_CTYPE") # "English_Canada.1252"

l10n_info() # ==>`UTF-8` [1] FALSE   !!

############################################ #
# test 2: options(encoding='windows-1251') ? ####
############################################ #

Sys.getlocale("LC_CTYPE") # "English_Canada.1252"
getOption("encoding"); #"native.enc"

options(encoding = 'native.enc')
options(encoding = 'UTF-8')
options(encoding='windows-1251') # ==> use this one

#way 1a dtInfo  ####

options(encoding = 'native.enc')
options(encoding = 'UTF-8')

dtInfo <- data.table(
  album=enc2utf8(c("Волна","Волна2")),
  text=c("ВолнаВолна","ВолнаВолна33") # it appears that when I paste  from web,it still saves in UTF-8.
)

dtInfo$album # "Волна"
dtInfo$text # "Волна"
dtInfo # <U+0412><U+043E><U+043B><U+043D><U+0430>
print(dtInfo,encoding="windows-1251"); print(dtInfo,encoding="UTF-8") #no effect
dtInfo %>% kable() # <U+0412><U+043E><U+043B><U+043D><U+0430>

#however is do the same with
Sys.setlocale("LC_CTYPE", "russian") #"Russian_Russia.1251"
# I get Âîëíà !!
# and then I can this, and it works!

str <- dtInfo$album
iconv(str, "windows-1251", "UTF-8") #"Волна"

cols <- names(dtInfo)
colsRUS <- paste0(cols,".new")
dtInfo[, lapply(.SD,function(x) {iconv(x, "windows-1251", "UTF-8")}), .SDcols=cols]


#way 1b ####

options(encoding='windows-1251') # ==> use this one
dtInfo <- data.table(
  album="Волна",
  text.rus="ВолнаВолнаВолнаВолна" # it appears that when I paste  from web,it still saves in UTF-8.
)


dtInfo$album # "Волна"
dtInfo # <U+0412><U+043E><U+043B><U+043D><U+0430>
print(dtInfo,encoding="windows-1251"); print(dtInfo,encoding="UTF-8") #no effect


options(encoding='windows-1251') # ==> use this one

#way 2  lSongInfo <- list(); ####

lSongInfo <- list();
lSongInfo$album="ВолнаLLLL"
lSongInfo$text="ВолнаLLLВолнаВолнаВолна" # it appears that when I paste  from web,it still saves in UTF-8.

lSongInfo # ok

lSongInfo %>% kable()

dtInfo$album
dtInfo
print(dtInfo,encoding="windows-1251"); print(dtInfo,encoding="UTF-8") #no effect



# test 3: saving file in 'windows-1251'instead of UTF-8 ?-Didnot helpt either ####



options(encoding = 'UTF-8') # "Aieia". With Sys.setlocale("LC_CTYPE", "english") - "?????"
Sys.setlocale("LC_CTYPE", "russian"); options(encoding = 'UTF-8'); dtInfo #"Aieia".
Sys.setlocale("LC_CTYPE", "russian"); options(encoding = 'windows-1251'); dtInfo #"Aieia".
Sys.setlocale("LC_CTYPE", "english"); options(encoding = 'UTF-8'); dtInfo #<U+0412><U+043E><U+043B><U+043D>


# test 4: convert a character vector between encodings####

iconvlist()

Sys.getlocale("LC_CTYPE") # "English_Canada.1252"
getOption("encoding"); #"native.enc"

iconv("Волна", "ISO_8859-2", "UTF-8")
iconv("Волна", "ISO_8859-2", "windows-1251")
iconv("Волна", "UTF-8", "windows-1251") # "Âîëíà"

iconv("Волна", "UTF-8", "UTF-8") #"Волна"

str <- lSongInfo$album; str

iconv(str, "UTF-8", "windows-1251") %>%
  iconv("windows-1251", "UTF-8") #"Волна"


# test 5:  apply it !

dtInfo %>%  kable
#dtInfo %>% kable (encoding = "utf-8")


dt <- dtInfo

dd.kable <- function (dt) {
  str <- "| "; for(i in 1:ncol(dt))  str <- paste0(str,names(dt)[i]," | ") ; print(str)
  str <- "| "; for(i in 1:ncol(dt))   str <- paste0(str,":--------:", " | "); print(str)
  for(r in 1:nrow(dt)){
    str <- "| ";
    for(i in 1:ncol(dt)) str <- paste0(str,dt[i,r,with=F]," | ");
    print(str)
  }
}

str
paste0("|", dtInfo$album, "|", dtInfo$text.rus , "|")

#To achieve the same effect as dtInfo %>%  kable:

paste0("|", dtInfo$album, "|", dtInfo$text.rus , "|")

paste0("  # This works !
|", dtInfo$album, "|", dtInfo$text.rus , "|
|", dtInfo$album, "|", dtInfo$text.rus , "|
|", dtInfo$album, "|", dtInfo$text.rus , "|")



# knit as standalone ####


#knit_with_parameters('~/GitHub/Shri-Jobim/Shri-Jobim-D7-v0.2/ex-markdown.Rmd', encoding = 'UTF-8')


knit("index.Rmd")
knit_with_parameters("index.Rmd", encoding = "utf-8")
markdown::markdownToHTML("index.md", "index2-1251-utf-8.html")

knit_with_parameters("index.Rmd", encoding = "windows-1251")
markdown::markdownToHTML("index.md", "index2-1251-.html")
browseURL(paste("file://", file.path(getwd(), "test.html"), sep = ""))


#dtInfo - template
dtInfo <- data.table(
  album="?????",
  id="111",
  title.short="placeholder - ?????", # or list of
  # title.full="placeholder",
  # title.long="placeholder-?????- ?????", # quote ??
  # language="rus",
  # author.lyrics="DG",
  # author.music="DG", #
  # chords = "Am 4/4, E7 4/4",
  # text.eng="wave",
  text.rus="?????"
)


listAll <- list(title = "NA", album=NA, language=list("eng", "rus"), chordbot="")


dtAll <- data.table(  #dtDiscography
  title = NA, album=NA, language=NA, chordbot=NA
)


dtSongRecording <- data.table(
  id="0",
  title.short="placeholder",

  backing.track="",
  audio=""
)


dtAlbum - data.table(title.short, title.full)

#Way 1
song <- dtInfo
#Or Way 3 (best?) as csongInfo ? Class



#Way 2
song <- list()

song$album="jobim";
song$id="1";
song$title.short="?????"; # or list of
song$title.full="????? - Wave";
song$title.long="?????? ????? -
  ? ?? ??????? ??? ?????,
????? ?? ?????, ???? ? ???"; # quote ??
song$language="rus";
song$author.lyrics="DG";
song$author.music="DG"; #
song$chords = "Am 4/4; E7 4/4";
song$text.eng="Vou te contar, os olhos ";
song$text.rus="?????? ????? - \n ?? ??????? ??? "

#Way 2 - continued
song <- data.table(song)

kable(song[,.(title.long,text.eng)])
kable(song[,.(title.long,text.rus)])



