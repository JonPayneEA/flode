msg <- function(x, startup = FALSE) {
  if (startup) {
    if (!isTRUE(getOption("modellER.quiet"))) {
      rlang::inform(x, class = "packageStartupMessage")
    }
  } else {
    rlang::inform(x)
  }
}

#' List all packages in the tidyverse
#'
#' @param include_self Include tidyverse in the list?
#' @export
#' @examples
#' #tidyverse_packages()
modellER_packages <- function(include_self = TRUE) {
  raw <- utils::packageDescription("modellER")$Imports
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  names <- vapply(strsplit(parsed, "\\s+"), "[[", 1, FUN.VALUE = character(1))

  if (include_self) {
    names <- c(names, "modellER")
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
