# HunNor-Service

## Public interface

### Autocomplete

#### Purpose

Provide a jQuery-compatible, JSON-encoded set of search suggestions.

#### URL

/pub/suggest

#### Parameters 

-  __lang__: restrict search to a single language
  - DEFAULT: all languages
  - available languages:
    - *hu*: Hungarian
    - *nb*: Norwegian (bokmål)
    - *nn*: Norwegian (nynorsk)
  - if __lang__ is set, each language must be added to the variable as to an array
  - e.g., to select Hungarian and Norwegian bokmål, use lang[]=hu&lang[]=nb
  - if __lang__ is defined with invalid values, the query will return no results
  - e.g., lang[]=de&lang[]=pl will return no results
- __term__: the form to search for; suggestions will begin with this string
- __limit__: specify number of suggestions for each language
  - will return at most 2 * __limit__ suggestions
  - if available, each language will give at least __limit__ suggestions
  - if the first language has less matching elemts, the second might give more than __limit__ to make the whole list 2 * __limit__ long
  - e.g., with a __limit__ of 4, you may 3 + 5 suggestions, if the first language has 3 matches, and the second has at least 5

