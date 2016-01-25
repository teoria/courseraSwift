library(shinydashboard)
library(quanteda)  
library(data.table)


n_bigram <- readRDS("ngram_2.rds")
n_trigram <- readRDS("ngram_3.rds")
n_quadigram <- readRDS("ngram_4.rds")


getWord <- function(palavras){
        wds = palavras$ngram
        previsao = sapply(strsplit(wds,split="_"), function(x)tail(x ,1) )
        previsao
}




searchWord <- function(text_ngram, base,type){
        
        tokens<- tokenize(toLower(text_ngram), removePunct = TRUE, removeNumbers=TRUE, simplify=TRUE)
        ngram_token <- ngrams(tokens, n = type)
        
        texto <- paste("^",ngram_token,"_" , sep="") 
        print( texto )
        indices<-grep(texto,base$ngram, perl=TRUE, value=FALSE)
        palavras <- head( base[indices,] , 3 ) 
        
        print(palavras)
        palavras
}



nextWords <- function(sentence){
        
        splitSequence <-strsplit(sentence, " ")[[1]]
        tri <- paste(tail(splitSequence, 3), collapse=" ")
        bi  <- paste(tail(splitSequence, 2), collapse=" ")
        uni <- paste(tail(splitSequence, 1), collapse=" ")
        
        print(length(splitSequence))
        if(length(splitSequence)==3){
                palavras <- searchWord( tri, n_quadigram, 3 )
                
                if(nrow(palavras) != 0){
                        print(">>>> quad")
                        previsao = getWord(palavras)
                        return(previsao)
                }        
        }
        
        
        if(length(splitSequence)>=2){
                palavras <- searchWord( bi, n_trigram ,2)
                
                if(nrow(palavras) != 0){
                        print(">>>>> tri")
                        previsao = getWord(palavras)
                        return(previsao)
                }
        }
        
        
        palavras <- searchWord( uni, n_bigram ,1)
        
        if(nrow(palavras) != 0){
                print(">>>>> bi")
                previsao = getWord(palavras)
                return(previsao)
        }
        
}
 
shinyServer( 
        function(input, output, session) {
       
       
        output$result <- renderText( { 
                        words <- toupper( nextWords(input$texto) )
                        paste0(  words , collapse = " | " ) 
                        } )
              
        }
)