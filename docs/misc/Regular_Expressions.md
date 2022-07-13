# Regular Expression

### Shell Regex #1 (regexr.com/)
`\b(<shell_name>)`
* Look for any single words (between word boundaries) that match the token(s) in the
capturing group.

/`\b(bash|sh)`/ matches:
/usr/bin/`sh` --login -i          1977
/usr/bin/csh --login -i           1978
/usr/bin/tcsh --login -i          1983
/usr/bin/ksh --login -i           1983
/usr/bin/ash --login -i           1989
/usr/bin/`bash` --login -i        1989
/usr/bin/zsh --login -i           1990
/usr/bin/dash --login -i          1997

/`\b(zsh)`/ matches:
/usr/bin/sh --login -i            1977
/usr/bin/csh --login -i           1978
/usr/bin/tcsh --login -i          1983
/usr/bin/ksh --login -i           1983
/usr/bin/ash --login -i           1989
/usr/bin/bash --login -i          1989
/usr/bin/`zsh` --login -i         1990
/usr/bin/dash --login -i          1997


### Shell Regex #2 (regexr.com/)

/`\b\w{0,6}sh|koi`/
* Look for any single words (between word boundaries) with (a quantifier range
of, in this case) 0 to 6 word characters preceding the token 'sh', or, any single
words that matches the token 'koi'.

This regex matches:
/usr/bin/`sh` --login -i            1977
/usr/bin/`csh` --login -i           1978
/usr/bin/`tcsh` --login -i          1983
/usr/bin/`ksh` --login -i           1983
/usr/bin/`ash` --login -i           1989
/usr/bin/`bash` --login -i          1989
/usr/bin/`zsh` --login -i           1990
/usr/bin/`dash` --login -i          1997
/usr/bin/`pdksh` --login -i         1999
/usr/bin/`posh` --login -i          200?
/usr/bin/`mksh` --login -i          2002
/usr/bin/`fish` --login -i          2005
/usr/bin/`yash` --login -i          2007
/usr/bin/`loksh` --login -i         2013
/usr/bin/`oksh` --login -i          2015
/usr/bin/`elvish` --login -i        2016
/usr/bin/`xonsh` --login -i         2016
/usr/bin/`osh` --login -i           2016
/usr/bin/`mrsh` --login -i          2018
/usr/bin/`crush` --login -i         2019
/usr/bin/modernish --login -i       2019
/usr/bin/`koi` --login -i           2020 oct
/usr/bin/`123456sh` --login -i
/usr/bin/nonexistentsh --login -i


### Shell Regex # (regexr.com/)