#--------------------------------------------------------------------------------------------------
run.scripts.in.this.folder <- function(pattern){
	
	successes <- warnings <- errors <- 0
	files <- list.files(pattern=pattern)
	N <- length(files)
	for(n in 1:N){
		file <- files[n]
		
		run = tryCatch(
			expr = {
				cat(paste0("#-----------------------------------\n"))
				cat(paste('Starting to run script:',file,'at',date(),"\n"))
				source(file)
				cat(paste0("#------------ run ",file,", succeed ✅\n"))
				successes <- successes + 1
				},
			error = function(e){ 
				cat(paste0("#------------ run ",file,", failed ❌\n"))
				print(e)
				return('e')
				},
			warning = function(w){
				cat(paste0("#------------ run ",file,", got warning ⚠️\n"))
				print(w)
				return('w')
				}
			)
		if(run=='e')errors <- errors +1
		if(run=='w')warnings <- warnings +1
		}
	cat(paste0("#----------------------------------------------------\n"));
	cat(paste0("summary of ",pattern, " R scripts\n", date()," \n "))
	cat(paste("❌:",errors,"/",N,"failed\n"))
	cat(paste("⚠️:",warnings,"/",N," completed with warnings \n"))
	cat(paste("✅:",successes,"/",N,"succeeded \n"))
	cat(paste0("#----------------------------------------------------\n"));
	}
#--------------------------------------------------------------------------------------------------