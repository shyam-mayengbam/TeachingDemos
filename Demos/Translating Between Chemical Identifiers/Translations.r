#load necessary functions
#install background packages
install.packages("devtools");install.packages("RJSONIO")
library(devtools);library(RJSONIO)

#install packages for translations
# The Chemical Translation System
install_github(repo = "CTSgetR", username = "dgrapov")
library(CTSgetR)

#for the Chemical Identifier Resolver (CIR) 
install_github(repo = "CIRgetR", username = "dgrapov")
library(CIRgetR)

#InchiKeys used for example
id<-c("ZKHQWZAMYRWXGA-KQYNXXCUSA-N", "BAWFJGJZGIEFAR-NNYOXOHSSA-O","QNAYBMKLOCPYGJ-REOHCLBHSA-N") 
#create.csv to simulate loading fromm .csv (file written to current directory, getwd())
write.csv(data.frame(InchiKey=id),file="InchIKeys.csv",row.names=FALSE) #create.csv to simulate loading fromm .csv
#upload .csv 
id<-read.csv(file="InchIKeys.csv",header=TRUE)

# Goal: translate from inchiKeys to ChemSpider Ids 

#use Chemical Identifier Resolver (CIR) by the CADD Group at the NCI/NIH
results<-CIRgetR(id,to= "chemspider_id",return.all=FALSE) 

#use the Chemical Translation System
results2<-CTSgetR(id,from="InChIKey",to="ChemSpider",parallel=FALSE)

#are there any differences between two results?
miss.match<-!as.matrix(results2)%in%as.matrix(results)|!as.matrix(results)%in%as.matrix(results2)
paste(sum(miss.match),"difference(s) between results",sep=" ") 
data.frame(CIR= results[,1], CTS = results2[,1])[miss.match,]#two different records for both are Alanine

#CTS (but not CIR) can be used to generate InChI key/code from identifier
CSid<-results[miss.match,] # convert CIR ChemSpider Id to inChiKey
results3<-CTSgetR(CSid,from="ChemSpider",to="InChIKey",parallel=FALSE)

#compare keys
<<<<<<< HEAD
if(as.matrix(results3)==as.matrix(id[miss.match,,drop=FALSE]))cat("codes match!","\n") else cat("codes DO NOT match!","\n")
=======
if(results3==id[miss.match])cat("codes match!","\n") else cat("codes DO NOT match!","\n")
>>>>>>> 527fe4c248ad2040b68cecee54e55a80e05bade5

#here is a more advanced example for translating from one ID to many
##translate InchI Key to allpossible options available in CIR
CIR.options<-c("smiles", "names", "iupac_name", "cas", "inchi", "stdinchi", "inchikey", "stdinchikey",
		"ficts", "ficus", "uuuuu", "image", "file", "mw", "monoisotopic_mass","chemspider_id",
		"pubchem_sid", "chemnavigator_sid", "formula", "chemnavigator_sid")		
	
all.results.CIR<-sapply(1:length(CIR.options), function(i)
	{
		cat(CIR.options[i],"\n")
		CIRgetR(id=id,to=CIR.options[i],return.all=FALSE)
	})
names(all.results.CIR)<-CIR.options	
all.results.CIR<-data.frame(all.results.CIR )# object


#get all possible options from CTS
CTS.options<-CTS.options()
CTS.options # see options
id<-results2
all.results.CTS<-sapply(1:length(CTS.options), function(i)
	{
		cat(CTS.options[i],"\n")
		CTSgetR(id=id,to=CTS.options[i],from="ChemSpider")
	})
names(all.results.CTS)<-CTS.options	
all.results.CTS<-data.frame(all.results.CTS) # object

#calculate % error for each querry as a percent of asked translations
CIR.error<-round(((sum(unlist(all.results.CIR)=="<h1>Page not found (404)</h1>")/length(unlist(id))))/length(CIR.options)*100,0)
CTS.error<-round((sum(unlist(all.results.CTS)=="error")/length(unlist(id)))/length(CTS.options)*100,0)
data.frame(CIR.error=CIR.error,CTS.error=CTS.error)
#choose best
<<<<<<< HEAD
best<-c("all.results.CIR","all.results.CTS")[which.min(c(CIR.error,CTS.error))[1]] # [1] for tie breaker
cat("Best results: ",best, "\n")
=======
best<-c("all.results.CIR","all.results.CTS")[which.min(c(CIR.error,CST.error))[1]] # [1] for tie breaker

>>>>>>> 527fe4c248ad2040b68cecee54e55a80e05bade5
#save the best result to a .csv 
write.csv(get(best),file="best translation.csv")

#get image for querry using CIR
<<<<<<< HEAD
#get image URL from InchIKey
id<-"ZKHQWZAMYRWXGA-KQYNXXCUSA-N"
image.url<-as.character(unlist(CIRgetR(id,to= "image",return.all=FALSE) ))
download.file(image.url,"image.gif")
install.packages("caTools")
library(caTools)
gif <- read.gif(image.url, verbose = TRUE, flip = TRUE)
par(pin=c(2,2)) # change this for multiple gif results
=======
download.file("http://cactus.nci.nih.gov/chemical/structure/ZKHQWZAMYRWXGA-KQYNXXCUSA-N/image","image.gif")
install.packages("caTools")
library(caTools)
gif <- read.gif(image.url, verbose = TRUE, flip = TRUE)
par(pin=c(2,2))
>>>>>>> 527fe4c248ad2040b68cecee54e55a80e05bade5
image(gif$image, col = gif$col, main = gif$comment, frame.plot=FALSE,xaxt="n", yaxt="n") 


