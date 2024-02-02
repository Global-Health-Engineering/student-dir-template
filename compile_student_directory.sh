#!/bin/sh

# remove the compiled directory if it is there
rm -rf student_dir

# make the new compiled directory
mkdir student_dir

# copy content from the `template` directory into the final one except for README.md files and some Mac specific files
rsync -av \
    --exclude 'README.md'\
    --exclude '.DS_Store'\
    ./template/* \
    ./student_dir

# make a list of all markdown files
md_files=$(find template -type f -name "README.md")

# iterate through all markdown file locations
for md_file in $md_files; do
    # get a list of paths to compiled pdf files
    temp="${md_file/README.md/README.pdf}"
    pdf_file="${temp/template/student_dir}"
    
    # compile the pdfs with pandoc
    echo "Compiling ${pdf_file} file."
    pandoc $md_file \
        -V geometry:papersize=a4 \
        -V geometry:margin=2 \
        --number-section \
        --from=gfm \
        --pdf-engine=wkhtmltopdf \
        --dpi 300 \
        --output $pdf_file
done

exit 0;
