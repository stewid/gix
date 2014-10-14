[![Build Status](https://travis-ci.org/stewid/gix.png)](https://travis-ci.org/stewid/gix)

# Introduction

`gix` is an R package that aims to index and search a Git repository
using the [Xapian](http://xapian.org/) search engine.

## Index a repository

Index the content of a git repository to documents with the Xapian
search engine. A `document` is the data returned from a search. The
indexing creates a database located in the `.xapian` folder in the
repository.


```r
library(gix)

## Index the 'gix' repository. (Current directory)
gixit(".", github = "stewid/gix")
```

## Search a repository


```r
## Search for author Widgren and display url to blob on GitHub
gix(".", "author:widgren")$url
```

```
##  [1] "https://github.com/stewid/gix/blob/c6fc2f018ee81cf973495dc359995cdac6fb4641/DESCRIPTION"
##  [2] "https://github.com/stewid/gix/blob/54f3f6f422a352184caf115dabe8567ed7295fd0/.Rbuildignore"
##  [3] "https://github.com/stewid/gix/blob/54f3f6f422a352184caf115dabe8567ed7295fd0/NAMESPACE"
##  [4] "https://github.com/stewid/gix/blob/54f3f6f422a352184caf115dabe8567ed7295fd0/NEWS"
##  [5] "https://github.com/stewid/gix/blob/54f3f6f422a352184caf115dabe8567ed7295fd0/README.md"
##  [6] "https://github.com/stewid/gix/blob/54f3f6f422a352184caf115dabe8567ed7295fd0/man/gix.Rd"
##  [7] "https://github.com/stewid/gix/blob/8906a4a3ddbb7cd29e33d47b37cdbf0f5ab70c2a/DESCRIPTION"
##  [8] "https://github.com/stewid/gix/blob/a489b0a4272be35043967b42e5caa6ed1b66ba26/.gitignore"
##  [9] "https://github.com/stewid/gix/blob/eca0aa4931fd0d6547841a7737fd3f4ec728f9d9/man/gixit-methods.Rd"
## [10] "https://github.com/stewid/gix/blob/7e5bac365cad12fc5a5e9cbd8f4030bb0ebb3031/DESCRIPTION"
```


```r
## Search for sha that starts with 'd7'
gix(".", "sha:d7*")[, c("sha", "url")]
```

```
##                                        sha
## 1 d7f105139782ab695d86613e343916f7372f4ac0
##                                                                                   url
## 1 https://github.com/stewid/gix/blob/1f25d61fff69361e748efbcf07b87846d81ecd1d/LICENSE
```

## Installation

The following two R packages must be installed:

 - [xapr](https://github.com/stewid/xapr)
 - [git2r](https://github.com/ropensci/git2r)

To install the development version of `gix`, it's easiest to use the
devtools package:


```r
# install.packages("devtools")
library(devtools)
install_github("stewid/gix")
```
Another alternative is to use `git` and `make`

```
$ git clone https://github.com/stewid/gix.git
$ cd gix
$ make install
```

**NOTE:** The package is in a very early development phase. Functions
and documentation may be incomplete and subject to
change. Suggestions, bugs, forks and pull requests are
appreciated. Get in touch.

# License

The `gix` package is licensed under the GPL (>= 2). See these files
for additional details:

- [LICENSE](LICENSE)     - `gix` package license
