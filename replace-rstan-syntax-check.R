# modified version of function initially written by Mike Lawrence
check_cmdstanr_syntax <- function (file, pedantic = FALSE) {
  if (!requireNamespace("fs", quietly = TRUE)) {
    stop("Please install the 'fs' package using 'install.packages('fs')'")
  }
  if (!requireNamespace("stringr", quietly = TRUE)) {
    stop("Please install the 'stringr' package using 'install.packages('stringr')'")
  }
  if (!requireNamespace("processx", quietly = TRUE)) {
    stop("Please install the 'processx' package using 'install.packages('processx')'")
  }
  check_wd <- fs::dir_create('syntax_check')
  code_file <- fs::path(file)
  mod_name <- fs::path_ext_remove(code_file)
  stanc_syntax_check_run = processx::run(
    command = fs::path(cmdstanr::cmdstan_path(), cmdstanr:::stanc_cmd()),
    args = c(
      code_file,
      "--include-paths",
      ".",
      if (pedantic) "--warn-pedantic",
      "--warn-uninitialized",
      "--name",
      mod_name,
      "--o",
      tempfile()
    ),
    wd = fs::path_dir(check_wd),
    error_on_status = FALSE
  )
  stderr <- stanc_syntax_check_run$stderr
  syntax_check_passed <- !((stderr != "") | (stanc_syntax_check_run$stdout != ""))
  if (!syntax_check_passed) {
    stanc_syntax_check_run$stdout = stringr::str_remove_all(stanc_syntax_check_run$stdout, stringr::fixed("./"))
    stanc_syntax_check_run$stdout = stringr::str_replace_all(stanc_syntax_check_run$stdout, "Info: ", "\nInfo:\n")
    cat(paste0("\033[34m", stanc_syntax_check_run$stdout), "\n\n", sep = "")
    cat(paste0("\033[31m", stanc_syntax_check_run$stderr), "\n",  sep = "")
  }
  else {
    cat(paste0("\033[34m","  ✓ Syntax check passed\n"))
  }
  if (sys.parent() == 0) {
    return(invisible(NULL))
  }
  else {
    return(invisible(syntax_check_passed))
  }
}

if (length(find.package("rstan", quiet = TRUE))) {
  rstan_rstudio_stanc_code = "function (filename) {return(check_cmdstanr_syntax(filename))}"
  utils::assignInNamespace("rstudio_stanc", eval(parse(text = rstan_rstudio_stanc_code)), 
                           ns = "rstan", envir = as.environment("package:rstan"))
  
  rstan_stanc_builder_code = "function (file) {return(invisible(NULL))}"
  utils::assignInNamespace("stanc_builder", eval(parse(text = rstan_stanc_builder_code)), 
                           ns = "rstan", envir = as.environment("package:rstan"))
}
