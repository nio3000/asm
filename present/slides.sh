call_dir=`pwd`
file=`basename $1`
t=.$file.tex_files
test -d $t || mkdir $t
cd $t
TEXINPUTS=:..:../headers:../images: pdflatex -shell-escape $1
TEXINPUTS=:..:../headers:../images: pdflatex -shell-escape $1
cp `basename $1 tex`pdf ../pdfs
cd $call_dir
