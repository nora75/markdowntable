" Vim global plugin for markdown table functions
" Last Change: 2018 Jan 22
" Maintainer: NORA75
" Licence: MIT
" Add Command,Mapping and Autocommand

if exists('b:did_markdowntable')
    finish
endif
let b:did_markdowntable=1
let s:savecpo = &cpo
set cpo&vim

if !exists(':TableMake')
    command! -nargs=+ -range -buffer TableMake call markdowntable#TableMake('c',<line1>,<line2>,<q-args>)
endif
if !exists(':ToTable')
    command! -nargs=? -bang -range -buffer ToTable call markdowntable#ToTable('v',<line1>,<line2>,<q-bang>,'',<q-args>)
endif
if !exists(':ToTableAll')
    command! -nargs=? -bang -range -buffer ToTableAll call markdowntable#ToTable('v',<line1>,<line2>,<q-bang>,'All',<q-args>)
endif

nnoremap <buffer><silent> <Plug>(Markdowntable_tablemake) :<C-u>set opfunc=markdowntable#TableMake<Bar>exe 'norm! '.v:count1.'g@_'<CR>
nnoremap <buffer><silent> <Plug>(Markdowntable_totable) :<C-u>set opfunc=markdowntable#ToTableOp<CR>g@
nnoremap <buffer><silent> <Plug>(Markdowntable_totableall) :<C-u>set opfunc=markdowntable#ToTableAll<CR>g@
vnoremap <buffer><silent> <Plug>(Markdowntable_tablemake) :<C-u>call markdowntable#TableMake('v')<CR>
vnoremap <buffer><silent> <Plug>(Markdowntable_totable) :<C-u>call markdowntable#ToTable('l',line("'<"),line("'>"),'')<CR>
vnoremap <buffer><silent> <Plug>(Markdowntable_totableall) :<C-U>call markdowntable#ToTable('l',line("'<"),line("'>"),'All')<CR>

if exists('g:markdowntable_disableMap')
    if !hasmapto('<Plug>(Markdowntable_tablemake)')
        nmap <buffer> <Leader>tm <Plug>(Markdowntable_tablemake)
        vmap <buffer> <Leader>tm <Plug>(Markdowntable_tablemake)
    endif
    if !hasmapto('<Plug>(Markdowntable_totable)')
        nmap <buffer> <Leader>tt <Plug>(Markdowntable_totable)
        vmap <buffer> <Leader>tt <Plug>(Markdowntable_totable)
    endif
    if !hasmapto('<Plug>(Markdowntable_totableall)')
        nmap <buffer> <Leader>ta <Plug>(Markdowntable_totableall)
        vmap <buffer> <Leader>ta <Plug>(Markdowntable_totableall)
    endif
endif

let &cpo = s:savecpo
unlet s:savecpo
