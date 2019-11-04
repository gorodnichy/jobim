require(magrittr);library(wrapr); library(ggplot2);library(data.table);
library(knitr)

# Way 1 using dt #### 
dtSongTemplate <- data.table(
  album="«Мои Цветы» (Детский альбом)",   
  title="placeholder", # or list of
  author.lyrics="DG",   author.music="DG", #
  chords = "-",   text.eng="",   
  text.rus="
  dfsdfsdf
  sdfdsf"
)


dtSongTemplate2 <- data.table(
  album="«Мои Цветы» (Детский альбом)",   
  title="placeholder2", # or list of
  author.lyrics="DG",   author.music="DG", #
  chords = "-",   text.eng="",   
  text.rus="
  dfsdfsdf2
  sdfdsf2"
)

dtAlbum <- NULL
dtAlbum <- rbind(dtAlbum,dtSongTemplate)
dtAlbum <- rbind(dtAlbum,dtSongTemplate2)
dtAlbum

dtAlbum %>% nrow()
dtAlbum[1]$author.lyrics


# Way 1 using list #### 

songTemplate <- list(
  album="«Мои Цветы» (Детский альбом)",   
  title="placeholder", # or list of
  author.lyrics="DG",   author.music="DG", #
  chords = "-",   text.eng="",   
  text.rus="
  dfsdfsdf
  sdfdsf"
)


song2 <- list(
  album="«Мои Цветы» (Детский альбом)",   
  title="placeholder2", # or list of
  author.lyrics="DG",   author.music="DG", #
  chords = "-",   text.eng="",   
  text.rus="
  dfsdfsdf2
  sdfdsf2"
)




album <- list()
album[[1]] <- song
album[[2]] <- song2

album %>% length()
album[[1]]$author.lyrics



