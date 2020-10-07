markdown=$1
pandoc --number-sections -s -t docx --filter pandoc-crossref --filter pandoc-citeproc -o ${markdown%.*}.docx ${markdown%.*}.md
