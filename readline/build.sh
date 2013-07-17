#patch -p1 < $RECIPE_DIR/readline-link-ncurses.patch 
./configure --prefix=$PREFIX
make
make install

