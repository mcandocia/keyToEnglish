f <- function(x) gsub('[^a-z]','', read.csv(x, header=FALSE, stringsAsFactors=FALSE)[,1,T])

# literature
wl_literature = f('data-raw/default_word_list.csv')
usethis::use_data(wl_literature, overwrite=TRUE)

# science
wl_science = f('data-raw/science_word_list.csv')
usethis::use_data(wl_science, overwrite=TRUE)

# animal
wl_animal = f('data-raw/animal_wiki_word_list.txt')
usethis::use_data(wl_animal, overwrite=TRUE)

# common 3000
wl_common = f('data-raw/common_5000.txt')
usethis::use_data(wl_common, overwrite=TRUE, internal=FALSE)

# freq 5663
wl_freq5663 = f('data-raw/freq_5663.txt')
usethis::use_data(wl_freq5663, overwrite=TRUE)

usethis::use_data_raw()
