latex.lm <- function(object, file="", math.env=c("$","$"),
                     estimates="none", abbreviate = TRUE, abbrev.length=8, digits=3) {
  # Get and format IV names
  co <- c("Int", names(object$coefficients)[-1])
  co.n <-  gsub("p.*)", "", co)
  if(abbreviate == TRUE) {
    co.n <- abbreviate(gsub("p.*)", "", co), minlength=abbrev.length)
  }
  # Get and format DV
  m.y <- strsplit((as.character(object$call[2])), " ~ ")[[1]][1]
  # Write coefficent labels
  b.x <- paste("\\beta_{", co.n ,"}", sep="")
  # Write error term
  e <- "\\epsilon_i"
  # Format coefficint x variable terms
  m.x <- sub("}Int","}", paste(b.x, co.n, " + ", sep="", collapse=""))
  # If inline estimates convert coefficient labels to values
  if(estimates == "inline") {
    m.x <- sub("Int", "",
               paste(round(object$coefficients,digits=digits), co.n, " + ", sep="",
                     collapse=""))
    m.x <- gsub("\\+ \\-", "-", m.x)
  }
  # Format regression equation
  eqn <- gsub(":", " \\\\\\times ", paste(math.env[1], m.y, " = ",
                                          m.x, e, sep=""))
  # Write the opening math mode tag and the model
  cat(eqn, file=file)
  # If separae estimates format estimates and write them below the model
  if(estimates == "separate") {
    est <- gsub(":", " \\\\\\times ", paste(b.x, " = ",
                                            round(object$coefficients, digits=digits), ", ", sep="", collapse=""))
    cat(", \\\\ \n \\text{where }", substr(est, 1, (nchar(est)-2)), file=file)
  }
  # Write the closing math mode tag
  cat(math.env[2], "\n", file=file)
}
