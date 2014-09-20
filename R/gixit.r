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

##' Index a git repository
##'
##' @rdname gixit-methods
##' @docType methods
##' @param path Path to the repository
##' @param ... Additional arguments affecting the indexing
##' ##' @return invisible(NULL)
##' @keywords methods
setGeneric("gixit",
           signature = "path",
           function(path, ...)
           standardGeneric("gixit"))

##' @rdname gixit-methods
##' @param callbacks A list of callback functions to enable more
##' control over how blob's are indexed. Each list item, named by file
##' extension, is a function with the two arguments 'content' and
##' 'sha'. Note: not implemented yet.
##' @param github Optional repository address in the format
##' 'username/repo'. Generates a link to the content on github in the
##' document area. Default is NULL.
##' @return invisible NULL
##' @export
setMethod("gixit",
          signature(path = "character"),
          function(path,
                   callbacks = NULL,
                   github    = NULL)
          {
              repo <- repository(path)

              ## List all objects in the repository
              blobs <- odb_blobs(repo)

              ## :TODO:FIXME: Design a default index plan. Blobs might
              ## contain duplicate entries for each sha with different
              ## path and name. For now, index only the content of
              ## unique sha's.
              blobs <- blobs[!duplicated(blobs$sha),]

              content <- sapply(seq_len(nrow(blobs)), function(i) {
                  content(lookup(repo, blobs$sha[i]), split = FALSE)
              })

              if (is.null(github)) {
                  doc <- blobs$sha
              } else {
                  ## Create a link to the content on github
                  doc <- paste0("https://github.com/",
                                github,
                                "/blob/",
                                blobs$commit,
                                ifelse(nchar(blobs$path) > 0,
                                       paste0("/", blobs$path, "/"),
                                       "/"),
                                blobs$name)
              }

              xapr_index(
                  path    = file.path(path, ".xapian"),
                  doc     = doc,
                  content = content,
                  id      = paste0("Q", blobs$sha))

              invisible(NULL)
          }
)
