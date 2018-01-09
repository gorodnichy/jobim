library(rjson)
require(magrittr);library(wrapr); library(ggplot2);
library(data.table);
library(knitr)

#http://blog.rolffredheim.com/2013/01/r-and-foreign-characters.html

encoding = "utf-8"
Sys.setlocale("LC_CTYPE", "russian")
knit("test.rmd", encoding = "utf-8")

listAll <- list(title = "NA", album=NA, language=list("eng", "rus"), chordbot="")


dtAll <- data.table(  #dtDiscography
  title = NA, album=NA, language=NA, chordbot=NA
  )


#
dtSongInfo <- data.table(
  album="jobim",
  id="0",
  title.short="placeholder", # or list of
  title.full="placeholder",
  title.long="placeholder", # quote ??
  language="rus",
  author.lyrics="DG",
  author.music="DG", #
  chords = "Am 4/4, E7 4/4",
  text.eng="",
  text.rus=""
)

dtSongRecording <- data.table(
  id="0",
  title.short="placeholder",

  backing.track="",
  audio=""
)


dtAlbum - data.table(title.short, title.full)

song <- dtSongInfo
song <- list()

song$album="jobim";
song$id="1";
song$title.short="Волна"; # or list of
song$title.full="Волна - Wave";
song$title.long="Закрой глаза -
  и ты увидишь мир таким,
Каким он будет, есть и был"; # quote ??
song$language="rus";
song$author.lyrics="DG";
song$author.music="DG"; #
song$chords = "Am 4/4; E7 4/4";
song$text.eng="Vou te contar, os olhos ";
song$text.rus=text


song <- data.table(song)
kable(song[,.(title.long,text.eng)])
kable(song[,.(title.long,text.rus)])

text

old.locale <- Sys.setlocale()
Sys.setlocale("LC_CTYPE", "russian")
Sys.setlocale(old.locale)

encoding = "utf-8"
Sys.setlocale("LC_CTYPE", "russian")
knit("test.rmd", encoding = "utf-8")


1 Волна  | + | - | - | + |
  2 Не грусти | + | - | - | + |
  3 Самба пробуждения | + | - | - | + |
  4 зачем всё это? - | + | - | - | + |
  5 Грустно жить в мире одному | + | - | - | + |
  6 Жить как во сне - Vivo sonhado  | + | - | - | + |
  7 Медитация 1 (выше небес) | + | - | - | + |
  8 Медитация 2 (Волшебство) | + | - | - | + |
  9 Тихим теплым вечером | + | - | - | + |
  10 Корковадо | + | - | - | + |
  11 Самба одной ноты | + | - | - | + |
  12 Безчувственный | + | - | - | + |
  13 Дисгармония | + | - | - | + |
  14 РАДОСТЬ И ПЕЧАЛЬ (A FELICIDADE ) | + | - | - | + |
  15 вода жизни - Aqua de beber | + | - | - | + |
  16 динди | + | - | - | + |




  Волна - Wave
(Музыка: А. Жобим, Слова: Д. Городничий )

if (T) {
text <- "
Закрой глаза -
  и ты увидишь мир таким,
Каким он будет, есть и был,
солнцем храним,
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

С голосом drive.google.com - волна.mp3
https://drive.google.com/file/d/0B8bu8TIv2xHiSEltdTRDTDBxaEE/view?usp=drivesdk

Learn to play it on guitar: youtube.com - Wave - Bossa Nova Guitar Lesson \#18: Advanced Phrase 137x
https://youtu.be/-KvhDcZu0FI

Guitar score and backing track
https://youtu.be/KNMttfYb5Qs
