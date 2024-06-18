#' can_be_num
#'
#' Return TRUE if a variable can be converted to a number and FALSE if not (supports float)
#' @param x is the input value
#' @examples
#'
#' print(can_be_num("34.677"))
#'
#' #[1] TRUE
#'
#' print(can_be_num("34"))
#'
#' #[1] TRUE
#'
#' print(can_be_num("3rt4"))
#'
#' #[1] FALSE
#'
#' print(can_be_num(34))
#'
#' #[1] TRUE
#'
#' @export

can_be_num <- function(x){

        regex_spe_detect <- function(inpt){

                fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
                  
                  ptrn <- grep(ptrn_fill, inpt_v)

                  while (length(ptrn) > 0){
                   
                    ptrn <- grep(ptrn_fill, inpt_v)

                    idx <- ptrn[1] 
                    
                    untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
                   
                    pre_val <- inpt_v[(idx - 1)]

                    inpt_v[idx] <- pre_val

                    if (untl > 0){
                    
                      for (i in 1:untl){
                        
                        inpt_v <- append(inpt_v, pre_val, idx)
                        
                      }
                      
                    }

                  ptrn <- grep(ptrn_fill, inpt_v)
                    
                  }
                  
                  return(inpt_v)
                  
                }

           inpt <- unlist(strsplit(x=inpt, split=""))

           may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")

           pre_idx <- unique(match(x=inpt, table=may_be_v))

           pre_idx <- pre_idx[!(is.na(pre_idx))]

           for (el in may_be_v[pre_idx]){

                   for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){

                           inpt <- append(x=inpt, values="\\", after=(i-1))

                   }

           }

        
           return(paste(inpt, collapse=""))

    }
    
    if (typeof(x) == "double"){

            return(TRUE)

    }else{

        vec_bool <- c()

        v_ref <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".")    

        v_wrk <- unlist(str_split(x, ""))

        alrd <- TRUE

        for (i in 1:length(v_wrk)){ 

                if (v_wrk[i] == "." & alrd){ 

                        vec_bool <- append(vec_bool, 1) 

                        alrd <- FALSE

                }else{

                        vec_bool <- append(vec_bool, sum(grepl(pattern=regex_spe_detect(v_wrk[i]), x=v_ref))) 

                }

        }

        if (sum(vec_bool) == length(vec_bool)){

                return(TRUE)

        }else{

                return(FALSE)

        }

    }

}

#' letter_to_nb
#'
#' Allow to get the number of a spreadsheet based column by the letter ex: AAA = 703
#' @param letter is the letter (name of the column)
#' @examples
#'
#' print(letter_to_nb("rty"))
#'
#' #[1] 12713
#'
#' @export

letter_to_nb <- function(letter){
  
  l <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
         "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
  
  nb = 0
  
  nch <- nchar(letter) - 1
  
  for (i in 0:nch){
    
    x <- str_sub(letter, nchar(letter) - i, nchar(letter) - i)
    
    x <- tolower(x)
    
    nb <- nb + match(x, l) * 26 ** i
    
  }
  
  return(nb)
  
}

#' nb_to_letter
#'
#' Allow to get the letter of a spreadsheet based column by the number ex: 703 = AAA
#' 
#' @param x is the number of the column 
#' @examples
#'
#' print(nb_to_letter(5))
#'
#' [1] "e"
#'
#' print(nb_to_letter(27))
#'
#' [1] "aa"
#' 
#' print(nb_to_letter(51))
#'
#' [1] "ay"
#'
#' print(nb_to_letter(52))
#'
#' [1] "az"
#' 
#' print(nb_to_letter(53))
#'
#' [1] "ba"
#'
#' print(nb_to_letter(675))
#'
#' [1] "yy"
#'
#' print(nb_to_letter(676))
#'
#' [1] "yz"
#'
#' print(nb_to_letter(677))
#'
#' [1] "za"
#'
#' print(nb_to_letter(702))
#'
#' [1] "zz"
#'
#' print(nb_to_letter(703))
#'
#' [1] "aaa"
#'
#' print(nb_to_letter(18211))
#'
#' [1] "zxk"
#'
#' print(nb_to_letter(18277))
#'
#' [1] "zzy"
#'
#' print(nb_to_letter(18278))
#'
#' [1] "zzz"
#'
#' print(nb_to_letter(18279))
#'
#' [1] "aaaa"
#'
#' @export

nb_to_letter <- function(x){
  rtn_v <- c()
  cnt = 0
  while (26 ** cnt <= x){
    cnt = cnt + 1
    reste <- x %% (26 ** cnt)
    if (reste != 0){
      if (reste >= 26){ reste2 <- reste / (26 ** (cnt - 1)) }else{ reste2 <- reste }
      rtn_v <- c(rtn_v, letters[reste2])
    }else{
      reste <- 26 ** cnt
      rtn_v <- c(rtn_v, letters[26])
    }
    x = x - reste
  }
  return(paste(rtn_v[length(rtn_v):1], collapse = ""))
}

#' is_divisible
#'
#' Takes a vector as an input and returns all the elements that are divisible by all choosen numbers from another vector.
#'
#' @param inpt_v is the input vector
#' @param divisible_v is the vector containing all the numbers that will try to divide those contained in inpt_v
#' @examples
#'
#'  print(is_divisible(inpt_v=c(1:111), divisible_v=c(2, 4, 5)))
#'
#'  #[1]  20  40  60  80 100
#'
#' @export

is_divisible <- function(inpt_v=c(), divisible_v=c()){

        cnt = 1

        while (length(inpt_v) > 0 & cnt < (length(divisible_v) + 1)){

                inpt_v <- inpt_v[(inpt_v %% divisible_v[cnt]) == 0]

                cnt = cnt + 1

        }

        return(inpt_v)

}

#' isnt_divisible
#'
#' Takes a vector as an input and returns all the elements that are not divisible by all choosen numbers from another vector.
#'
#' @param inpt_v is the input vector
#' @param divisible_v is the vector containing all the numbers that will try to divide those contained in inpt_v
#' @examples
#'
#'  print(isnt_divisible(inpt_v=c(1:111), divisible_v=c(2, 4, 5)))
#'
#' # [1]   1   3   7   9  11  13  17  19  21  23  27  29  31  33  37  39  41  43  47
#' #[20]  49  51  53  57  59  61  63  67  69  71  73  77  79  81  83  87  89  91  93
#' #[39]  97  99 101 103 107 109 111
#'
#' @export

isnt_divisible <- function(inpt_v=c(), divisible_v=c()){

        cnt = 1

        while (length(inpt_v) > 0 & cnt < (length(divisible_v) + 1)){

                inpt_v <- inpt_v[(inpt_v %% divisible_v[cnt]) != 0]

                cnt = cnt + 1

        }

        return(inpt_v)

}

#' dcr_untl 
#' 
#' Allow to get the final value of a incremental or decremental loop. 
#'
#' @param strt_val is the start value
#' @param cr_val is the incremental (or decremental value)
#' @param stop_val is the value where the loop has to stop
#' @examples
#'
#' print(dcr_untl(strt_val=50, cr_val=-5, stop_val=5))
#'
#' #[1] 9
#'
#' print(dcr_untl(strt_val=50, cr_val=5, stop_val=450))
#'
#' #[1] 80
#' 
#' @export

dcr_untl <- function(strt_val, cr_val, stop_val=0){

        cnt = 1

        if (cr_val < 0){

            while ((strt_val + cr_val) > (stop_val)){

                strt_val = strt_val + cr_val

                cnt = cnt + 1

            }

        }else{

            while ((strt_val + cr_val) < (stop_val)){

                strt_val = strt_val + cr_val

                cnt = cnt + 1

            }

        }

        return(cnt)

}

#' dcr_val
#'
#' Allow to get the end value after an incremental (or decremental loop)
#' 
#' @param strt_val is the start value
#' @param cr_val is the incremental or decremental value
#' @param stop_val is the value the loop has to stop
#' @examples
#'
#' print(dcr_val(strt_val=50, cr_val=-5, stop_val=5))
#'
#' #[1] 5
#' 
#' print(dcr_val(strt_val=47, cr_val=-5, stop_val=5))
#' 
#' #[1] 7
#' 
#' print(dcr_val(strt_val=50, cr_val=5, stop_val=450))
#' 
#' #[1] 450
#' 
#' print(dcr_val(strt_val=53, cr_val=5, stop_val=450))
#' 
#' #[1] 448
#' 
#' @export

dcr_val <- function(strt_val, cr_val, stop_val=0){

        cnt = 1

        if (cr_val < 0){

            while ((strt_val + cr_val) > (stop_val + cr_val / 2)){

                strt_val = strt_val + cr_val

                cnt = cnt + 1

            }

        }else{

            while ((strt_val + cr_val) < (stop_val + cr_val / 2)){

                strt_val = strt_val + cr_val

                cnt = cnt + 1

            }

        }

        return(strt_val)

}

#' power_to_char
#'
#' Convert a scientific number to a string representing normally the number.
#'
#' @param inpt_v is the input vector containing scientific number, but also other elements that won't be taken in count
#' @examples 
#'
#' print(power_to_char(inpt_v = c(22 * 10000000, 12, 9 * 0.0000002)))
#'
#' [1] "2200000000" "12"         "0.0000018" 
#'
#' @export

power_to_char <- function(inpt_v = c()){
  fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
     ptrn <- grep(ptrn_fill, inpt_v)
     while (length(ptrn) > 0){
       ptrn <- grep(ptrn_fill, inpt_v)
       idx <- ptrn[1] 
       untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
       pre_val <- inpt_v[(idx - 1)]
       inpt_v[idx] <- pre_val
       if (untl > 0){
         for (i in 1:untl){
           inpt_v <- append(inpt_v, pre_val, idx)
         }
       }
     ptrn <- grep(ptrn_fill, inpt_v)
     }
     return(inpt_v)
  }
  inpt_v <- as.character(inpt_v)
  better_split <- function(inpt, split_v = c()){
    for (split in split_v){
      pre_inpt <- inpt
      inpt <- c()
      for (el in pre_inpt){
        inpt <- c(inpt, unlist(strsplit(x = el, split = split)))
      }
    }
    return(inpt)
  }
  for (el in 1:length(inpt_v)){
    if (grepl(pattern = "^(((\\d{1,}\\.)\\d{1,})|\\d{1,})e\\+\\d{1,}$", x = inpt_v[el])){
      idx <- el
      el <- better_split(inpt = inpt_v[el], split_v = c("\\+", "e", "\\."))
      inpt_v[idx] <- paste0(paste(el[1:(length(el) - 1)], collapse = ""), 
                           paste(fillr(inpt_v = c("0", paste0("...", (as.numeric(el[length(el)]) - 1)))), collapse = "")) 
    }else if (grepl(pattern = "^(((\\d{1,}\\.)\\d{1,})|\\d{1,})e-\\d{1,}$", x = inpt_v[el])){
      idx <- el
      el <- better_split(inpt = inpt_v[el], split_v = c("\\-", "e", "\\."))
      zeros <- fillr(inpt_v = c("0", paste0("...", as.numeric(el[length(el)]))))
      zeros[2] <- "."
      inpt_v[idx] <- paste0(paste(zeros, collapse = ""),
                            paste(el[1:(length(el) - 1)], collapse = ""))
    }
  }
  return(inpt_v)  
}

