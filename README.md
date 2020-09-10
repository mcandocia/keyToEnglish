# keyToEnglish

The `keyToEnglish` package provides a function to create an easy-to-remember hash of a field by using a traditional hashing function, and then mapping substrings of the hash to a list of words.

## Installation

Currently, it is available on GitHub, but it should hopefully be available on CRAN soon.

It can be installed from GitHub via

    install.packages('devtools')
    devtools::install_github("mcandocia/keyToEnglish")
    
*Note: this should ideally be done from a new R session.*
    
When on CRAN, it can be installed with

    install.packages('keyToEnglish')

## Usage

The simplest way to use the package is by using the default word list, `wl_common`, and having fields as follows:

    keyToEnglish(1:5)
    # [1] "ProcedureCombAdmitCountryVoice"           "ParentPericarpNotionPompousTreat"        
    # [3] "BuckSlackenReflectPublicationDeaden"      "AssociatedAldehydePastDisgraceOppressive"
    # [5] "CrimsonHeelParasiteWritBenefit"  
    
You can also provide your own word list to the `word_list` parameter of `keyToEnglish()`.


    
**Why would anyone need this?** The main reason I could think of is being able to remember a string or other value that has been anonymized while reducing the chance of a collision. 

There are also additional functions for building word lists in the package, but I haven't documented/exported most of them, apart from `corpora_to_word_list()`, which takes a list of files and builds a word list by reading them. It can also parse JSON, too, which can be useful for API-retrieved data.

    # example loading files from a directory
    my_word_list = corpora_to_word_list(
      dir('/some/directory/with/text/files'),
      max_size=16^4
    )
    
    # example loading JSON files downloaded from Wikipedia
    my_word_list = corpora_to_word_list(
      dir('/some/directory/with/json/files'),
      max_size=16^4,
      json_path=c('query','export','*')
    )


By default, there are 5 phrases with 16^3 combinations, which is about `1.15 * 10^18`. This should be somewhat safe up until 100 million values, where it becomes more likely you will see collisions. If you increase it to 8, then it is safe to about 13 trillion values.

## Future

* Improved text-cleaning capabilities
* More word-lists
* More options for creating phrase hashes from `keyToEnglish()`
* Expose some common data-downloading functions (e.g., Project Gutenberg, Wikipedia API)

## Author

Max Candocia 

## License 

GPL (>= 2)

Word lists from Michael Wehar's repository are under public domain.
