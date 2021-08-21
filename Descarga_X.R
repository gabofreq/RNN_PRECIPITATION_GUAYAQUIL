library(RNetCDF)
library(raster)
library(maptools)
library(sp)
library(readxl)
library(rgeos)
library(lubridate)
Sys.setlocale("LC_TIME", "English")
Sys.setenv(TZ = "EST")

BASE = read_excel("BASE.xlsx")
BASE$FECHA = as.Date(BASE$FECHA)
mes = month(max(BASE$FECHA,na.rm = T),label = T,abbr = T)
anio = year(max(BASE$FECHA,na.rm = T))
fname = paste0("https://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCDC/.ERSST/.version5/.sst/Y/%2830S%29%2830N%29RANGEEDGES/X/%28160W%29%2860W%29RANGEEDGES/T/%28Jan%201915%29%28",mes,"%20",anio,"%29RANGEEDGES/data.nc")
download.file(fname,destfile = "data.nc", mode = 'wb')
#ERSST version 5 (160W to 60W,30S to 30N), resolucion 1 Grado, 100 km
SST=RNetCDF::read.nc(RNetCDF::open.nc("data.nc"))
#Que empieza en -180
SST$X=SST$X-180
#funcion para rotar una matriz
rot=function(x) t(apply(x,2,rev))
SSTF=lapply(1:dim(SST$sst)[3],function(i)  raster(rot(rot(rot(SST$sst[,,i])))))
#Creo el vector de tiempo
Tiempo=as.character(seq(as.Date("1915-01-01"),by = "month", len=nrow(BASE)))

n=dim(SST$sst)[3]
for(i in 1:n)
{
  extent(SSTF[[i]])=extent(min(SST$X),max(SST$X),min(SST$Y),max(SST$Y))
  proj4string(SSTF[[i]])=CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
  names(SSTF[[i]])=str_c("SST",Tiempo[i],sep="_")
}

RR=BASE$RR
#Se reemplaza cada valor de la matriz por cada valor de precipitacion
MA=SSTF
for(i in 1:n) MA[[i]][!is.na(MA[[i]])]=RR[i]
#Para conocer la correlacion espacial observada
ccf_raster=function(x,y)
{
  I=dim(x[[1]])[1]
  J=dim(x[[1]])[2]
  N=length(x)
  X=array(c(sapply(1:N, function(i) as.matrix(x[[i]]))), dim = c(I,J,N))
  Y=array(c(sapply(1:N, function(i) as.matrix(y[[i]]))), dim = c(I,J,N))
  COR=raster(t(sapply(1:I, function(i) sapply(1:J, function(j) cor(x=X[i,j,],y=Y[i,j,])))))
  extent(COR)=extent(x[[1]])
  proj4string(COR)=CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
  return(COR)
}

COR=ccf_raster(SSTF[(1:n)],MA[(1:n)])
#0.7 representa la correlacion en donde la isolinea es mayor, osea la mayor correlacion con el poligono
CORMAYOR=rasterToPolygons(COR,fun = function(x) x >= 0.7)
PCORMAYOR=gUnaryUnion(CORMAYOR)
#Ahora grafico la isolinea con correlacion 0.7
plot(COR)
contour(COR, levels=round(quantile(COR,c(0.05,0.95)),2),labcex = 1, col=c("#990000","blue"),add=TRUE,lwd=2)
lines(PCORMAYOR,col="green")
#Ahora cortamos esa zona con el poligono con mayor correlacion
SSTS = do.call(c,lapply(1:n, function(x) mean(as.matrix(mask(crop(SSTF[[x]],PCORMAYOR),PCORMAYOR)),na.rm=T)))
cor(RR,SSTS)
#Vamos a Guardar todo en un solo archivo
BASE=tibble(Fecha=Tiempo,RR=RR,SST=SSTS)
writexl::write_xlsx(BASE,"DATA.xlsx",col_names = T)
