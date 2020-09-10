# keyToEnglish

The `keyToEnglish` package provides a function to create an easy-to-remember hash of a field by using a traditional hashing function, and then mapping substrings of the hash to a list of words.

The simplest way to use the package is by using the default word list, `wl_common`, and hasing fields as follows:

    keyToEnglish(1:5)
    # [1] "ProcedureCombAdmitCountryVoice"           "ParentPericarpNotionPompousTreat"        
    # [3] "BuckSlackenReflectPublicationDeaden"      "AssociatedAldehydePastDisgraceOppressive"
    # [5] "CrimsonHeelParasiteWritBenefit"  
    
You can also provide your own word list to the `word_list` parameter of `keyToEnglish()`.

There are additional functions for building word lists in the package, but I haven't documented/exported most of them, apart from `corpus_to_word_list()`, which takes a list of files and builds a word list by reading them. It can also parse JSON, too, which can be useful for API-retrieved data.
    
**Why would anyone need this?** The main reason I could think of is being able to remember a string or other value that has been anonymized while reducing the chance of a collision. 

By default, there are 5 phrases with 16^3 combinations, which is about `1.15 * 10^18`. This should be somewhat safe up until 100 million values, where it becomes more likely you will see collisions. If you increase it to 8, then it is safe to about 13 trillion values.
