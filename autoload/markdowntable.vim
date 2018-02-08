" Vim global plugin for markdown table functions
" Last Change: 2018 Jan 22
" Maintainer: NORA75
" Licence: MIT
" autoload
" General Functions

if exists('g:loaded_markdowntable')
    finish
endif
let g:loaded_markdowntable = 1
let s:savecpo = &cpo
set cpo&vim
if !exists('g:markdowntable_cellSpaces')
    let g:markdowntable_cellSpaces = 4
endif
if !exists('g:markdowntable_symbolPriority')
    let g:markdowntable_symbolPriority = [';',':',',','.']
endif
if !exists('g:markdowntable_toTableHeader')
    let g:markdowntable_toTableHeader = 0
endif

func! markdowntable#TableMake(type,...) abort
    let type = a:type
    if type != 'c'
        let lnum = type == 'v' ? (line('.')-1 ? line('.')-1 : 1) : line('.')
        let row = s:makeChar('Input row')
        if row <= 0 || type(row) != 0
            call s:echoWarn('Command is cancelled')
            return
        endif
        redraw!
        let column = s:makeChar('row: '.row."\n".'Input column')
        if column <= 0 || type(column) != 0
            call s:echoWarn('Command is cancelled')
            return
        endif
        echo 'column: '.column
        redraw!
    else
        if a:1 == a:2
            let lnum = a:1-1 ? a:1-1 : 0
        else
            let lnum = a:1
            type = 'v'
        endif
        if a:0 < 4
            call s:echoWarn('Please set two values to make raw and column')
            return
        elseif a:3 < 0 || a:4 < 0
            call s:echoWarn('Please set pluss values')
            return
        else
            let row = a:1
            let column = a:2
        endif
    endif
    let tableSpaces = ' '.repeat(' ',g:markdowntable_cellSpaces).'|'
    let tableLine = '|'.repeat(tableSpaces,row)
    let table = repeat([tableLine],column+1)
    let tableHeader = substitute(tableLine,'\M ','-','g')
    call insert(table,tableHeader,1)
    let leftwhite = matchstr(getline(lnum),'\M^\s\+')
    call map(table,'leftwhite.v:val')
    if type == 'v'
        silent '<,'>delete _
    endif
    silent call append(lnum,table)
    echo 'Created table,row:'.row.' column:'.column
endfunc

func! markdowntable#ToTable(type,...) abort
    if a:type ==# 'l'
        let symbolP  = s:tableChar("If you don't want to set symbols,type only enter\nInput symbols with space")
        if symbolP == -1
            return
        elseif symbolP == ''
            let symbolP = deepcopy(g:markdowntable_symbolPriority)
        else
            let symbolP = split(symbolP,'\s')
        endif
        let [line1,line2] = [line("'["),line("']")]
        let bang = g:markdowntable_toTableHeader
        let mode = a:1
    else
        let [line1,line2] = [a:1,a:2]
        if a:3 == '!'
            let bang = 1
        else
            let bang = 0
        endif
        if a:5 != ''
            let symbolP = split(join(deepcopy(a:000[4:]),"\s"),'')
        else
            let symbolP = deepcopy(g:markdowntable_symbolPriority)
        endif
        let mode = a:4
    endif
    let setline = []
    let i = line1
    while 1 <= line2
        let k = getline(i)
        if k =~ '\M^\.\+$'
            break
        endif
        let i+=1
    endwhile
    let leftwhite = matchstr(getline(line1),'\M^\s\+')
    if mode ==# 'All'
        for lnum in range(i,line2)
            let curline = matchstr(getline(lnum),'\M\S\.\*\ze\s\*$')
            if curline == ''
                continue
            endif
            if count(symbolP,'|')
                let curline = s:escapeSep(curline)
            endif
            for symbol in symbolP
                let curline = s:changeTable(symbol,curline)
            endfor
            call add(setline,curline)
        endfor
    else
        for lnum in range(i,line2)
            let curline = matchstr(getline(lnum),'\M\S\.\*\ze\s\*$')
            if curline == ''
                continue
            endif
            let aflist = split(curline,'\M\[^\\]\zs\|\\\.\zs')
            let symbolDetect = []
            for symbol in symbolP
                call add(symbolDetect,count(aflist,symbol))
            endfor
            let max = max(symbolDetect)
            let max = index(symbolDetect,max)
            if max < 0
                let max = 0
            endif
            exe 'let symbol = symbolP['.max.']'
            if symbol != '\M|'
                let curline = s:escapeSep(curline)
            endif
            let curline = s:changeTable(symbol,curline)
            call add(setline,curline)
        endfor
    endif
    if bang && i != line2
        let bars = ' '.repeat('-',g:markdowntable_cellSpaces).' |'
        let j = 0
        let k = 1
        while k > 0
            let k = match(setline[0],' |',k+1)
            let j += 1
        endwhile
        let align = '|'.repeat(bars,j-1)
        call insert(setline,align,1)
    endif
    call map(setline,'leftwhite.v:val')
    silent call append(line2,setline)
    silent exe line1.','.line2.'delete _'
    echomsg 'ToTable'.mode.' works successfully'
endfunc

func! s:echoWarn(msg)
    echohl WarnigMsg
    redraw!
    echomsg a:msg
    echohl None
    return -1
endfunc

func! s:makeChar(msg) abort
    let msg = a:msg.': '
    let ret = input(msg)
    return str2nr(ret)
endfunc

func! s:getChar() abort
    try
        let c = getchar()
        if c =~ '^\d\+$'
            let c = nr2char(c)
        endif
        if c =~ "\<Esc>"
            throw 'Interrupt'
        elseif c =~ "\<Enter>"
            let c = 'en'
        elseif c =~ "\<BS>"
            let c = 'bs'
        endif
    catch
        let c = 'Er'
    endtry
    return c
endfunc

func! s:tableChar(msg) abort
    let msg = a:msg.': '
    let ret = []
    while 1
        redraw!
        echon msg.join(ret,'')
        let c = s:getChar()
        try
            if len(c) < 2
                call add(ret,c)
            else
                if c ==# 'bs'
                    silent! call remove(ret, -1)
                elseif c ==# 'en'
                    break
                else
                    return -1
                endif
            endif
        endtry
    endwhile
    return join(ret,'')
endfunc

func! s:changeTable(symbol,curline) abort
    let curline = a:curline
    let aflist = split(curline,'\M\[^\\'.a:symbol.']\+\zs\|\(\\\.\zs\)\|'.a:symbol.'\zs')
    let k = 0
    while k < len(aflist)
        if aflist[k] =~# '\M\\'.a:symbol
            let aflist[k] = a:symbol
        elseif aflist[k] =~# '\M'.a:symbol
            if k != 0 && aflist[k-1] !~ '\M\s$'
                let aflist[k] = ' |'
            else
                let aflist[k] = '|'
            endif
            if (k+1) != len(aflist) && aflist[k+1] !~ '\M^\s'
                let aflist[k] .= ' '
            endif
        endif
        let k += 1
    endwhile
    let curline = join(aflist,'')
    if aflist[0] =~ '\M^|\s'
        let curline = curline
    elseif aflist[0] =~ '\M^|\S\+'
        let curline = '| '.strcharpart(curline,1,len(curline))
    elseif aflist[0] =~ '\M^\S'
        let curline = '| '.curline
    else
        let curline = '|'.curline
    endif
    if aflist[-1] !~ '\M\[^\\]|\s\*$'
        let curline .= ' |'
    endif
    return curline
endfunc

func! s:escapeSep(curline) abort
    let aflist = split(a:curline,'\M\[^\\|]\+\zs\|\(\\\.\zs\)\||\zs')
    let k = 0
    while k < len(aflist)
        if aflist[k] == '\M|'
            let aflist[k] = '\M\|'
        endif
        let k += 1
    endwhile
    return join(aflist,'')
endfunc

func! markdowntable#ToTableOp(type,...) abort
    call markdowntable#ToTable('l','')
endfunc

func! markdowntable#ToTableAll(type,...) abort
    call markdowntable#ToTable('l','All')
endfunc

let &cpo = s:savecpo
unlet s:savecpo
