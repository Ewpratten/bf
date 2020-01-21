#! /bin/bash
# Evan Pratten's Bash BrainFuck compiler

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
gcc -S outp.c

# Clean up files
rm inp.bf
rm outp.c
