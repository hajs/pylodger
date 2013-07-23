# Core

for recipe in recipes/sci/{blas,lapack,atlas,numpy,scipy}
do
  pkg=$(basename recipe)
  conda build recipe
  conda install $pkg
done



# Plotting

for recipe in recipes/gui/freetype recipes/sci/{matplotlib,pyproj,basemap}
do
  pkg=$(basename recipe)
  conda build recipe
  conda install $pkg
done



# Meteorolgy

for recipe in recipes/lib/{libjasper,libjpeg,libopenjpeg,libpng} recipes/sci/{gribapi,pygrib}
do
  pkg=$(basename recipe)
  conda build recipe
  conda install $pkg
done
