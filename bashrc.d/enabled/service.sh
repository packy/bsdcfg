#!bash - for syntax highlighting

complete -W "$(service -e | xargs basename)" service

