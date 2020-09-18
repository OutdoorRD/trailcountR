.onLoad <- function(libname, pkgname) {
	reticulate::source_python(system.file("python",
										  "parse_ir.py",
										  package = "trailcountR", mustWork = TRUE),
							  envir=globalenv())

}



#' Parses a raw IR txt file into a csv.
#'
#' @param ir_file Name of raw IR file (do not include the path to file).
#' @param ir_dir Path to the directory containing raw IR file.
#' @param parsed_dir Path to directory where parsed csv should be written.
#' @param dump_dir Path to directory where potentially corrupt files
#' should be written.
#'
#' @return A parsed csv file.
#'
#' @export
#'
parse_ir <- function(ir_file, ir_dir, parsed_dir, dump_dir) {

	ir <- parse_ir_to_csv(ir_file = ir_file,
					ir_dir = ir_dir,
					parsed_dir = parsed_dir,
					dump_dir = dump_dir)

	return(NULL)
}
