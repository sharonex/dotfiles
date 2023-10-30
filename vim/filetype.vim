au BufRead,BufNewFile **nginx**.conf if &ft == '' | setfiletype nginx | endif
au BufRead,BufNewFile */.git/index if &ft == '' | so ~/.vim/git_status.vim | endif
