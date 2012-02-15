
# Run all the map generations

# should standardize these and make a script that will change all the parts
# that need changing, ie, the station position, and the maps title

bash modmap.sh	 > map.ps
bash zoommap.sh	 > zoommap.ps
bash gebcomap.sh > gebcomap.ps



