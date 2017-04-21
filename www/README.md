    # Get the NLNet data with something like:
    #
    # wget --timeout=9 --wait=2 --random-wait --level=inf --html-extension \
    # --recursive --domains=nlnet.nl --no-clobber --tries=2 \
    # --user-agent='Searsia' --html-extension --restrict-file-names=windows \
    # --reject=jpg,js,css,png,gif,doc,docx,jpeg,pdf,mp3,avi,mpeg,txt,ico \
    # http://www.nlnet.nl
    #
    # find www.nlnet.nl -name "*.1.html" -exec rm \{\} \;
    # find www.nlnet.nl/ -name "*.html" -exec ./remove_if_dir_exists.pl \{\} \;

    find www.nlnet.nl/ -name "*.html" -exec ./get_main_column.pl \{\} \; | sort -r | sed -e 's/"prior":[0-9\.]\+,//' >tmp.json
    cat header.json tmp.json footer.json >nlnet.json 
    # cat nlnet.json | python -m json.tool
    jsonlint-php nlnet.json
