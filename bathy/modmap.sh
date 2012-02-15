#! /bin/bash

# This plots the multibeam data and also ETOPO data where there isn't MB
# data.

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

calcrange(){
        echo  $1 $2 $3 | awk '{print $1-$3 "/" $1+$3 "/" $2-$3 "/" $2+$3}'
}

# Make color image
# grdimage output.grd -JM7.0h -R-40.0/-36.0/23.0/27.0 -Coutput.cpt -P -Xc -Yc -K -V > map.ps 2>> output.log

# Make contour plot
# grdcontour output.grd -JM7.0h -R-40.0/-36.0/23.0/27.0 -C500 -A2500 -L-8298.0/-3808.0 -Wa1p -P -K -O -V >> map.ps 2>> output.log

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

# -L3808.0/8298.0
SITESYMBOL=B
SITENAME="Bay of Bengal"
POINT=(83.5 10)
Range=`calcrange ${POINT[*]} 2.5`

grdcontour $TOPO -JM7.0h -R$Range -C250 -A1000  -Wa1p -P -K -V 2>> output.log
# psclip -C -K -O >> map.ps 2>> output.log
#===================


# add coastline
pscoast -JM7.0h -R$Range -Df -W3p,gray  -K -O -V 2>> output.log
					
# Make basemap
psbasemap -JM7.0h -R$Range -B48m/48m:."$SITENAME Bathymetry from ETOPO-1": -P -K -O -V  2>> output.log

####################
# Add site symbol
psxy -JM7.0h -R -Sl0.5c/$SITESYMBOL -W255/0/0 -G255/0/0 -W255/0/0 -O << ENDIN 2>> output.log
${POINT[*]}
ENDIN
#===================

# Make color scale
# psscale -Coutput.cpt -D3.1719656392i/-0.5i/6.0i/0.15ih -B":Depth (m):" -P -O -V >> map.ps 	2>> output.log
	

# vi: se nowrap tw=0 :

