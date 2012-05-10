# Set paths 
SRCDIR = src
OUTDIR = pdfs

# Source files 
PROJDIRS := $(SRCDIR)
SRCFILES := $(shell find $(PROJDIRS) -type f -name "*.tex")
PDFFILES := $(patsubst %.tex,%.pdf,$(SRCFILES))

# Rules
all: $(PDFFILES)

.PHONY: all clean

%.pdf: %.tex
	./slides.sh $<
	rm -rf .*.tex_files

clean:
	rm -rf .*.tex_files
	rm -rf $(OUTDIR)/*.pdf
