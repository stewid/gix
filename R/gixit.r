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

gixit_tree <- function(tree_obj, path) {
    obj <- lookup(tree_obj@repo, tree_obj@id[1])

    for (i in seq_len(length(tree_obj))) {
        obj <- lookup(tree_obj@repo, tree_obj@id[i])

        if (is_blob(obj)) {
            xapr_index(
                path    = path,
                doc     = tree_obj@name[i],
                content = content(obj, split=FALSE),
                id      = paste0("Q", obj@sha))
        } else {
            gixit_tree(obj, path)
        }
    }
}

##' Index a git repository
##'
##' @rdname gixit-methods
##' @docType methods
##' @param path Path to the repository
##' @return invisible(NULL)
##' @keywords methods
setGeneric("gixit",
           signature = "path",
           function(path, ...)
           standardGeneric("gixit"))

##' @rdname gixit-methods
##' @param callbacks A list of callback functions to enable more
##' control over how blob's are indexed. Each list item, named by file
##' extension, is a function with the two arguments 'content' and
##' 'sha'.
##' @export
setMethod("gixit",
          signature(path = "character"),
          function(path, callbacks)
          {
              repo <- repository(path)

              ## List all objects in the repository
              odb <- odb_list(repo)

              ## Select only commits
              odb <- odb[sapply(odb, function(x) identical(x@type, "commit"))]

              for (i in seq_len(length(odb))) {
                  commit_obj <- lookup(repo, odb[[i]]@sha)
                  tree_obj <- tree(commit_obj)
                  gixit_tree(tree_obj, file.path(path, ".xapian"))
              }
          }
)
