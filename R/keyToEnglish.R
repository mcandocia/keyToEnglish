#require(openssl)
#require(stringr)


#' Corpora to Word List
#'
#' Converts a collection of documents to a word list
#' @export
#'
#' @param paths Paths of plaintext documents
#' @param ascii_only Will omit non-ascii characters if TRUE
#' @param custom_regex If not NA, will override ascii_only and
#'                     this will determine what a valid word
#'                     consists of
#' @param max_word_length Maximum length of extracted words
#' @param min_word_count Minimum number of ocurrences for a
#'                       word to be added to word list
#' @param stopword_fn Filename containing stopwords to use or a list of
#'                    stopwords (if length > 1)
#' @param max_size Maximum size of list
#' @param min_word_length Minimum length of words
#' @param output_file File to write list to
#' @param json_path If input text is JSON, then it will be parsed as such
#'                  if this is a character of JSON keys to follow
#' @return A `character` vector of words
corpora_to_word_list <- function(
  paths,
  ascii_only=TRUE,
  custom_regex=NA,
  max_word_length=20,
  stopword_fn=DEFAULT_STOPWORDS,
  min_word_count=5,
  max_size = 16^3,
  min_word_length=3,
  output_file=NA,
  json_path=NA
){
  corpora = unlist(lapply(
    paths,
    function(x) readChar(x, file.info(x)$size)
  ))

  if (!is.na(json_path)){
    json_data = lapply(corpora, jsonlite::fromJSON)
    corpora = lapply(
      json_data,
      function(x){
        for (key in json_path){
          x = x[[key]]
        }
        x
      }
    )

  }
  corpora = tolower(gsub('[-_*.?,":\\\\/\']',' ', corpora))
  if (custom_regex){
    tokenized_corpora = stringr::str_extract_all(
      corpora,
      custom_regex
    )
  } else if (ascii_only){
   tokenized_corpora = stringr::str_extract_all(
     corpora,
     '[a-z]+'
   )
  } else {
    tokenized_corpora = stringr::str_extract_all(
      corpora,
      '\\d+'
    )
  }

  if (is.na(stopword_fn[1])){
    stopwords = character(0)
  } else if (length(stopword_fn) > 1){
    stopwords = stopword_fn
  } else {
    stopwords = utils::read.csv(stopword_fn, stringsAsFactors=FALSE)[,1,T]
  }
  filtered_tokenized_corpora = lapply(
    tokenized_corpora,
    function(x){
      x = x[nchar(x) >= min_word_length & nchar(x) <= max_word_length]
      x = x[!x %in% c(stopwords, paste0(stopwords, 's'), paste0(stopwords, 'es'))[seq_len(3*length(stopwords))]]
      return(x)
    }
  )

  word_table = table(unlist(filtered_tokenized_corpora))
  word_table = word_table[word_table >= min_word_count]
  word_table = sort(word_table, decreasing=TRUE)[1:min(max_size, length(word_table))]

  words = names(word_table)

  if (!is.na(output_file)){
    utils::write.table(
      data.frame(word=words),
      file=output_file,
      quote=FALSE,row.names=FALSE, col.names=FALSE
    )
  }

  return(words)
}

#' Key to English
#'
#' Hashes field to sequence of words from a list.
#' @export
#' @param x - field to hash
#' @param hash_function `character` name of hash function or hash `function` itself,
#'                       returning a hexadecimal character
#' @param phrase_length `numeric` of words to use in each hashed key
#' @param corpus_path `character` path to word list, as a single-column text file with one
#'                    word per row
#' @param word_list `character` list of words to use in phrases
#' @param hash_subsection_size `numeric` length of each subsection of hash to use for word index. 16^N
#'                              unique words can be used for a size of N. This value times
#'                              phrase_length must be less than or equal to the length of the
#'                              hash output.
#' @param sep `character` separator to use between each word.
#' @param word_trans A `function`, `list` of functions, or 'camel' (for CamelCase). If
#'                   a list is used, then the index of the word of each phrase is
#'                   mapped to the corresponding function with that index,
#'                   recycling as necessary
#'
#' @param suppress_warning `logical` value indicating if warning of non-character
#'                                   input should be suppressed
#'
#' @return `character` vector of hashed field resembling phrases
#'
#' @examples
#' # hash the numbers 1 through 5
#' keyToEnglish(1:5)
#'
#' # alternate upper and lowercase, 3 words only
#' keyToEnglish(1:5, word_trans=list(tolower, toupper), phrase_length=3)
keyToEnglish <- function(
  x,
  hash_function='md5',
  phrase_length=5,
  corpus_path=NA,
  word_list=wl_common,
  hash_subsection_size=3,
  sep='',
  word_trans='camel',
  suppress_warning=FALSE
){
  KTI_METHOD_LIST=list(
    md5=openssl::md5,
    md4=openssl::md4,
    sha256=openssl::sha256,
    sha1=openssl::sha1,
    sha2=openssl::sha2,
    sha224=openssl::sha224
  )

  if (!is.character(x)){
    if (!suppress_warning) warning('Converting input to character')
    x = as.character(x)
  }

  trans_funcs = list()
  for (i in seq_along(word_trans)){
    if (class(word_trans) == 'function'){
      word_trans_function = word_trans
    } else {
      if (class(word_trans[[i]]) == 'function')
        word_trans_function = word_trans[[i]]
      else if (is.na(word_trans[[i]]))
        word_trans_function = identity
      else if (word_trans == 'camel')
        word_trans_function = stringr::str_to_title
      else
        word_trans_function = get(word_trans)
    }
    trans_funcs[[i]] = word_trans_function
  }

  if (class(hash_function) != 'function')
    hash_function = KTI_METHOD_LIST[[hash_function]]

  split_hashes = stringr::str_extract_all(
    hash_function(x),
    sprintf('.{%s}', hash_subsection_size)
  )

  if (is.na(word_list[1])){
    word_list = utils::read.csv(corpus_path, header=FALSE)[,1,T]
  }
  n_words = length(word_list)

  seq_idx = seq_len(phrase_length)

  #print(trans_funcs)

  if (length(trans_funcs) > 1){
    word_trans_function <- function(x, i){
      sapply(i, function(j) trans_funcs[[1 + (j-1) %% length(trans_funcs)]](x[j]))
    }

    new_keys = unlist(lapply(
      split_hashes,
      function(x) paste(word_trans_function(word_list[strtoi(paste0('0x', x[seq_idx])) %% n_words], seq_idx), collapse=sep)
    ))
  } else {

    new_keys = unlist(lapply(
      split_hashes,
      function(x) paste(word_trans_function(word_list[strtoi(paste0('0x', x[seq_idx])) %% n_words]), collapse=sep)
    ))
  }
  return(new_keys)
}

