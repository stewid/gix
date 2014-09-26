## gix, search a Git repository using the Xapian search engine.
## Copyright (C) 2014 Stefan Widgren
##
##  gix is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  gix is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License along
##  with this program; if not, write to the Free Software Foundation, Inc.,
##  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

##' Search a git repository
##'
##' @rdname gix-methods
##' @docType methods
##' @param path Path to the repository
##' @param query The search query
##' @return :TODO:DOCUMENTATION:
##' @keywords methods
setGeneric("gix",
           signature = c("path", "query"),
           function(path, query)
           standardGeneric("gix"))

##' @rdname gix-methods
##' @export
setMethod("gix",
          signature(path = "character", query = "character"),
          function(path, query)
          {
              repo <- repository(path)
              xsearch(
                  path     = file.path(workdir(repo), ".xapian"),
                  query    = query,
                  prefix   = data.frame(
                      field  = c("author", "sha"),
                      prefix = c("A", "XSHA")),
                  wildcard = TRUE)
          }
)
