#! /bin/bash

# Evan Pratten's Bash BrainFuck to sstv compiler

# Duplicate input file
cat $1 >inp.bf

# Strip comments
sed -i -e 's/[A-Za-z]*//g' inp.bf

# Incr and decr break the simple sed. Use temps instead
sed -i -e 's/+/%/g' inp.bf
sed -i -e 's/-/$/g' inp.bf

# Handle regex for all parts of file
sed -i -e 's/>/++ptr;/g' inp.bf
sed -i -e 's/</--ptr;/g' inp.bf
sed -i -e 's/%/++*ptr;/g' inp.bf
sed -i -e 's/\$/--*ptr;/g' inp.bf
sed -i -e 's/\./putchar(*ptr);/g' inp.bf
sed -i -e 's/,/*ptr=getchar();/g' inp.bf
sed -i -e 's/\[/while (*ptr){/g' inp.bf
sed -i -e 's/\]/}/g' inp.bf

# Create a temp file with first half of the C wrapper
echo "#include <stdio.h>" >outp.c
echo "int main(int argc, char const *argv[]) {char array[30000] = {0};char *ptr = array;" >>outp.c

# Add generated C code
cat inp.bf >>outp.c

# Add C footer
echo "return *ptr;}" >>outp.c

# Compile to binary
gcc outp.c

# Generate an image from the binary
python3 -c 'import argparse 
import numpy as np 
from PIL import Image 
ap =argparse.ArgumentParser ()
ap.add_argument ("file",help ="File to convert to image")
ap.add_argument ("-w","--width",help ="Image wrap/width in px",default =100 )
args =ap.parse_args ()
args.width =int (args.width )
try :
    with open (args.file ,"rb")as fp :
        file =fp.read ()
        fp.close ()
except :
    print ("File error")
    exit (1 )
def divAt (OO00O0OO0OOO0O00O ,O0OO000O0OOOO0O0O ):
    for O00OOO00O0OOO00O0 in range (0 ,len (OO00O0OO0OOO0O00O ),O0OO000O0OOOO0O0O ):
        yield OO00O0OO0OOO0O00O [O00OOO00O0OOO00O0 :O00OOO00O0OOO00O0 +O0OO000O0OOOO0O0O ]
img =divAt (file ,args.width )
output =[]
for row in img :
    ro =[]
    for col in row :
        px =max (min (col ,255 ),0 )
        ro.append ((0 ,px ,0 ))
    output.append (ro )
output =output [:-1 ]
oi =Image.fromarray (np.array (output ,dtype =np.uint8 ))
oi.save ("./output.png")' a.out

# Convert the bmp to sstv
python3 -m pysstv output.png output.wav --resize

# Clean up files
rm inp.bf
rm outp.c
rm output.png
