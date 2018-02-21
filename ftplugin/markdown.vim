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
if !exists(':UnTable')
    command! -nargs=? -bang -range -buffer UnTable call markdowntable#UnTable('v',<line1>,<line2>,<q-args>)
endif
if !exists(':ToggleTable')
    command! -nargs=? -bang -range -buffer ToggleTable call markdowntable#ToggleTable('v',<line1>,<line2>)
endif

nnoremap <buffer><silent> <Plug>(markdowntable_tablemake) :<C-u>set opfunc=markdowntable#TableMake<Bar>exe 'norm! '.v:count1.'g@_'<CR>
nnoremap <buffer><silent> <Plug>(markdowntable_totable) :<C-u>set opfunc=markdowntable#ToTableOp<CR>g@
nnoremap <buffer><silent> <Plug>(markdowntable_totableall) :<C-u>set opfunc=markdowntable#ToTableAll<CR>g@
vnoremap <buffer><silent> <Plug>(markdowntable_tablemake) :<C-u>call markdowntable#TableMake('v')<CR>
vnoremap <buffer><silent> <Plug>(markdowntable_totable) :<C-u>call markdowntable#ToTable('l','',line("'<"),line("'>"))<CR>
vnoremap <buffer><silent> <Plug>(markdowntable_totableall) :<C-U>call markdowntable#ToTable('l','All',line("'<"),line("'>"))<CR>
nnoremap <buffer><silent> <Plug>(markdowntable_untable) :<C-u>call markdowntable#UnTableOp<CR>g@
vnoremap <buffer><silent> <Plug>(markdowntable_untable) :<C-u>call markdowntable#UnTable('l',line("'<"),line("'>"))<CR>
nnoremap <buffer><silent> <Plug>(markdowntable_toggletable) :<C-u>call markdowntable#toggletableOp<CR>g@
vnoremap <buffer><silent> <Plug>(markdowntable_toggletable) :<C-u>call markdowntable#toggletable('l',line("'<"),line("'>"))<CR>

if exists('g:markdowntable_enableMap')
    if !hasmapto('<Plug>(markdowntable_tablemake)')
        nmap <buffer> <Leader>tm <Plug>(markdowntable_tablemake)
        vmap <buffer> <Leader>tm <Plug>(markdowntable_tablemake)
    endif
    if !hasmapto('<Plug>(markdowntable_totableall)')
        nmap <buffer> <Leader>ta <Plug>(markdowntable_totableall)
        vmap <buffer> <Leader>ta <Plug>(markdowntable_totableall)
    endif
    if !hasmapto('<Plug>(markdowntable_untable)')
        nmap <buffer> <Leader>tu <Plug>(markdowntable_untable)
        vmap <buffer> <Leader>tu <Plug>(markdowntable_untable)
    endif
    if !hasmapto('<Plug>(markdowntable_toggletable)')
        nmap <buffer> <Leader>tt <Plug>(markdowntable_toggletable)
        vmap <buffer> <Leader>tt <Plug>(markdowntable_toggletable)
    endif
endif

let &cpo = s:savecpo
unlet s:savecpo
