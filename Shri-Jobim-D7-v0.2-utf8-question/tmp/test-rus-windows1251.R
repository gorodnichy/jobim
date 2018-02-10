library(rjson);library(ggplot2);require(magrittr);
library(knitr)
require(magrittr);library(wrapr); library(data.table);

#File: testing to undertand how russian coding is done Windows vs. Rstudio vs. data.table / kable

# NB: this file was saved with 1251 encoding, _after which_ Russian text was pasted into from web ! Otherwise all russian charecters show as ???

# http://blog.rolffredheim.com/2013/01/r-and-foreign-characters.html

# how to UTF-8 to 1251 in R
# https://tomizonor.wordpress.com/2013/04/17/file-utf8-windows/
# https://www.smashingmagazine.com/2012/06/all-about-unicode-utf8-character-sets

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

#way 1a ####

options(encoding = 'native.enc')
options(encoding = 'UTF-8')

dtSongInfo <- data.table(
  album="Волна",
  text.rus="ВолнаВолнаВолнаВолна" # it appears that when I paste  from web,it still saves in UTF-8.
)

dtSongInfo$album # "Волна"
dtSongInfo # <U+0412><U+043E><U+043B><U+043D><U+0430>
print(dtSongInfo,encoding="windows-1251"); print(dtSongInfo,encoding="UTF-8") #no effect
dtSongInfo %>% kable() # <U+0412><U+043E><U+043B><U+043D><U+0430>

#however is do the same with
Sys.setlocale("LC_CTYPE", "russian") #"Russian_Russia.1251"
# I get Aieia !!
# and then I can this, and it works!

str <- dtSongInfo$album
iconv(str, "windows-1251", "UTF-8") #"Волна"

cols <- names(dtSongInfo)
colsRUS <- paste0(cols,".new")
dtSongInfo[, lapply(.SD,function(x) {iconv(x, "windows-1251", "UTF-8")}), .SDcols=cols]


#way 1b ####

options(encoding='windows-1251') # ==> use this one
dtSongInfo <- data.table(
  album="Волна",
  text.rus="ВолнаВолнаВолнаВолна" # it appears that when I paste  from web,it still saves in UTF-8.
)


dtSongInfo$album # "Волна"
dtSongInfo # <U+0412><U+043E><U+043B><U+043D><U+0430>
print(dtSongInfo,encoding="windows-1251"); print(dtSongInfo,encoding="UTF-8") #no effect


options(encoding='windows-1251') # ==> use this one

#way 2  lSongInfo <- list(); ####

lSongInfo <- list();
lSongInfo$album="ВолнаLLLL"
lSongInfo$text="ВолнаLLLВолнаВолнаВолна" # it appears that when I paste  from web,it still saves in UTF-8.

lSongInfo # ok

lSongInfo %>% kable()

dtSongInfo$album
dtSongInfo
print(dtSongInfo,encoding="windows-1251"); print(dtSongInfo,encoding="UTF-8") #no effect



# test 3: saving file in 'windows-1251'instead of UTF-8 ?-Didnot helpt either ####



options(encoding = 'UTF-8') # "Aieia". With Sys.setlocale("LC_CTYPE", "english") - "?????"
Sys.setlocale("LC_CTYPE", "russian"); options(encoding = 'UTF-8'); dtSongInfo #"Aieia".
Sys.setlocale("LC_CTYPE", "russian"); options(encoding = 'windows-1251'); dtSongInfo #"Aieia".
Sys.setlocale("LC_CTYPE", "english"); options(encoding = 'UTF-8'); dtSongInfo #<U+0412><U+043E><U+043B><U+043D>


# test 4: convert a character vector between encodings####

iconvlist()

Sys.getlocale("LC_CTYPE") # "English_Canada.1252"
getOption("encoding"); #"native.enc"

iconv("Волна", "ISO_8859-2", "UTF-8")
iconv("Волна", "ISO_8859-2", "windows-1251")
iconv("Волна", "UTF-8", "windows-1251") # "Aieia"

iconv("Волна", "UTF-8", "UTF-8") #"Волна"

str <- lSongInfo$album; str

iconv(str, "UTF-8", "windows-1251") %>%
  iconv("windows-1251", "UTF-8") #"Волна"


# test 5:  apply it !

dtSongInfo [ ] %>%  kable
#dtSongInfo %>% kable (encoding = "utf-8")

#To achieve the same effect as dtSongInfo %>%  kable:

paste0("|", dtSongInfo$album, "|", dtSongInfo$text.rus , "|")

paste0("  # This works !
|", dtSongInfo$album, "|", dtSongInfo$text.rus , "|
|", dtSongInfo$album, "|", dtSongInfo$text.rus , "|
|", dtSongInfo$album, "|", dtSongInfo$text.rus , "|")






knit_with_parameters('~/GitHub/Shri-Jobim/Shri-Jobim-D7-v0.2/ex-markdown.Rmd', encoding = 'UTF-8')


knit("index.Rmd")
knit_with_parameters("index.Rmd", encoding = "utf-8")
markdown::markdownToHTML("index.md", "index2-russian2-no-encoding.html")
browseURL(paste("file://", file.path(getwd(), "test.html"), sep = ""))


#dtSongInfo - template
dtSongInfo <- data.table(
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
song <- dtSongInfo
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

song$text.rus

# old.locale <- Sys.setlocale()
# Sys.setlocale("LC_CTYPE", "russian")
# Sys.setlocale(old.locale)
#
# encoding = "utf-8"
# Sys.setlocale("LC_CTYPE", "russian")
# knit("test.rmd", encoding = "utf-8")


  ????? - Wave
(??????: ?. ?????, ?????: ?. ?????????? )

if (T) {
text <- "
Закрой глаза -
И ты увидишь мир таким,
Каким он будет, есть и был,
Солнцем храним,
И все твои волнения вдруг
Рассеются как волны в океане.
"
}

2017

Wave

DM7     Bdim                  Am7  D7b9
Vou te contar, os olhos ja nao podem ver
GM7      Gm6           F#13 F#75+ B9 B7b9
Coisas que so o coracao pode entender
E9
Fundamental e' mesmo o amor
Bb7  A7          Dm7   A75+
E' impossivel ser feliz sozinho

DM7     Bdim                 Am7  D7b9
O resto e' mar, e' tudo que eu nem sei contar
GM7     Gm6          F#13 F#75+ B9 B7b9
Sao coisas lindas que eu tenho pra te dar
E9
Vem de mansinho a brisa e me diz
Bb7  A7          Dm7   G7
E' impossivel ser feliz sozinho


Gm7        C9     FM7
Da primeira vez e' a cidade
Fm7        Bb9        Gm7       A7b9(3) A7b9(6) A7b9(9)
Da segunda, o cais, a eternidade


DM7    Bdim                   Am7  D7b9
Agora eu ja sei da onda que se ergueu no mar
GM7           Gm6          F#13 F#75+ B9 B7b9
E das estrelas que esquecemos de contar
E9
O amor se deixa surpreender
Bb7   A7      Dm7     A75+
  Enquanto a noite vem nos envolver




Original played in Canada
https://youtu.be/e0mEAo3anwI

Audio: -1 track (accompaniment only)
drive.google.com/file/d/0B8AIVMjP8IzRT0N0aWE0ZV9Qbm8/view?usp=drivesdk

? ??????? drive.google.com - ?????.mp3
https://drive.google.com/file/d/0B8bu8TIv2xHiSEltdTRDTDBxaEE/view?usp=drivesdk

Learn to play it on guitar: youtube.com - Wave - Bossa Nova Guitar Lesson \#18: Advanced Phrase 137x
https://youtu.be/-KvhDcZu0FI

Guitar score and backing track
https://youtu.be/KNMttfYb5Qs
