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

wl_nouns_concrete = f('data-raw/mc_lists/concrete_nouns.txt')
wl_nouns_concrete_plural = f('data-raw/mc_lists/concrete_nouns_plural.txt')
wl_adjectives_visual = f('data-raw/mc_lists/adjectives_visual_property.txt')
wl_verbs_transitive_present = f('data-raw/mc_lists/verbs_transitive_present.txt')
wl_adjectives_nonorigin = f('data-raw/mc_lists/adjectives_nonorigin.txt')
wl_verbs_transitive_infinitive = f('data-raw/mc_lists/verbs_transitive_infinitive.txt')
wl_verbs_transitive_gerund = f('data-raw/mc_lists/verbs_transitive_gerund.txt')

usethis::use_data(wl_nouns_concrete, overwrite=TRUE)
usethis::use_data(wl_nouns_concrete_plural, overwrite=TRUE)
usethis::use_data(wl_adjectives_visual, overwrite=TRUE)
usethis::use_data(wl_verbs_transitive_present, overwrite=TRUE)
usethis::use_data(wl_adjectives_nonorigin, overwrite=TRUE)
usethis::use_data(wl_verbs_transitive_infinitive, overwrite=TRUE)
usethis::use_data(wl_verbs_transitive_gerund, overwrite=TRUE)

# multi word lists
wml_long_sentence = list(
  adj0=wl_adjectives_nonorigin,
  adj1=wl_adjectives_visual,
  noun1=wl_nouns_concrete,
  verb=wl_verbs_transitive_present,
  adj2=wl_adjectives_visual,
  noun2=wl_nouns_concrete_plural
)

usethis::use_data(wml_long_sentence, overwrite=TRUE)


wml_animals = list(
  sizes=f('data-raw/mc_lists/sizes.txt'),
  colors=f('data-raw/mc_lists/colors.txt'),
  animals=f('data-raw/mc_lists/animals.txt'),
  of='of',
  attributes=f('data-raw/mc_lists/attributes.txt')
)
usethis::use_data(wml_animals, overwrite=TRUE)

wml_cutephysics = list(
  amounts=f('data-raw/mc_lists/enumeration.txt'),
  physics_nouns=f('data-raw/mc_lists/physics_nouns_plural.txt'),
  of='of',
  adjective=f('data-raw/mc_lists/adjectives_long.txt'),
  cute_nouns=f('data-raw/mc_lists/cute_nouns_plural.txt')
)
usethis::use_data(wml_cutephysics, overwrite=TRUE)

# use data raw
usethis::use_data_raw()
