#! /bin/bash

gmtset MEASURE_UNIT inch
gmtset PAPER_MEDIA archA+
gmtset ANOT_FONT Helvetica
gmtset LABEL_FONT Helvetica
gmtset HEADER_FONT Helvetica
gmtset ANOT_FONT_SIZE 8
gmtset LABEL_FONT_SIZE 8
gmtset HEADER_FONT_SIZE 10
gmtset FRAME_WIDTH 0.075
gmtset TICK_LENGTH 0.075
gmtset PAGE_ORIENTATION LANDSCAPE
gmtset COLOR_BACKGROUND 0/0/0
gmtset COLOR_FOREGROUND 255/255/255
gmtset COLOR_NAN 255/255/255
gmtset PLOT_DEGREE_FORMAT ddd:mm

# Make color image
# grdimage output.grd -JM7.0h -R-40.0/-36.0/23.0/27.0 -Coutput.cpt -P -Xc -Yc -K -V > map.ps 2>> output.log

# Make contour plot
# grdcontour output.grd -JM7.0h -R-40.0/-36.0/23.0/27.0 -C500 -A2500 -L-8298.0/-3808.0 -Wa1p -P -K -O -V >> map.ps 2>> output.log

calcrange(){
        echo  $1 $2 $3 | awk '{print $1-$3 "/" $1+$3 "/" $2-$3 "/" $2+$3}'
}

SITESYMBOL=B
SITENAME="Bay of Bengal"
POINT=(83.5 10)
# GRDCUT=80/95/5/25
GRDCUT=`calcrange ${POINT[*]} 5`
# Range=88.5/89.5/17.5/18.5
Range=`calcrange ${POINT[*]} 0.5`

####################
# Add etopo1 contours
# psclip -JM -R -K -O << ENDIN >> map.ps 2>> output.log
# -40 23
# -36 23
# -36 27
# -38.4 27
# -40 25.6
# -40 23
# ENDIN
# echo $TOPO
grdcut /usr/local/bathy/gebco/gebco_08.nc -GBoB_topo.grd -R$GRDCUT -fg
grdmath BoB_topo.grd NEG = BoB_topo-.grd

TOPO=BoB_topo-.grd
#  -L3808.0/8298.0
grdcontour $TOPO -JM7.0h -R$Range -C50 -A100 -Wa1p -T -P -K -V 
# psclip -C -K -O >> map.ps 2>> output.log
#===================


# add coastline
pscoast -JM7.0h -R$Range -Df -W3p,gray  -K -O -V 
					
# Make basemap
psbasemap -JM7.0h -R$Range -B10m/10m:."$SITENAME Bathymetry from GEBCO": -P -K -O -V

####################
# Add site symbol
psxy -JM7.0h -R -Sl0.5c/$SITESYMBOL -W255/0/0 -G255/0/0 -W255/0/0 -O << ENDIN 
${POINT[*]}
ENDIN
#===================

# Make color scale
# psscale -Coutput.cpt -D3.1719656392i/-0.5i/6.0i/0.15ih -B":Depth (m):" -P -O -V 

# vi: se nowrap tw=0 :

