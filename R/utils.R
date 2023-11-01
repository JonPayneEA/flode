msg <- function(x, startup = FALSE) {
  if (startup) {
    if (!isTRUE(getOption("flode.quiet"))) {
      rlang::inform(x, class = "packageStartupMessage")
    }
  } else {
    rlang::inform(x)
  }
}

#' List all packages in flode
#'
#' @param include_self Include flode in the list?
#' @export
#' @examples
#' #flodePackages()
flodePackages <- function(include_self = TRUE) {
  raw <- utils::packageDescription("flode")$Imports
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  names <- vapply(strsplit(parsed, "\\s+"), "[[", 1, FUN.VALUE = character(1))

  if (include_self) {
    names <- c(names, "flode")
  }

  names
}

invert <- function(x) {
  if (length(x) == 0) return()
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}


style_grey <- function(level, ...) {
  crayon::style(
    paste0(...),
    crayon::make_style(grDevices::grey(level), grey = TRUE)
  )
}
