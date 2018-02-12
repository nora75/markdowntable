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
if !exists('g:markdowntable_cellspaces')
    let g:markdowntable_cellspaces = 4
endif
if !exists('g:markdowntable_Stringpriority')
    let g:markdowntable_Stringpriority = [';',':',',','.']
endif
if !exists('g:markdowntable_noalign')
    let g:markdowntable_noalign = 1
endif
if !exists('g:markdowntable_untableString')
    let g:markdowntable_untableString = ' '
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
            let lnum = a:1
        else
            let lnum = a:1
            type = 'v'
        endif
        let tmp = split(a:3,'\s')
        if len(tmp) < 2
            call s:echoWarn('Please set two values to make raw and column')
            return
        elseif type(tmp[0]) != 1 &&type(tmp[1]) != 1
            call s:echoWarn('Please set number')
            return
        elseif tmp[0] < 0 || tmp[1] < 0
            call s:echoWarn('Please set pluss values')
            return
        else
            let row = tmp[0]
            let column = tmp[1]
        endif
    endif
    let tableSpaces = repeat(' ',g:markdowntable_cellspaces).'|'
    let tableLine = '|'.repeat(tableSpaces,column)
    let table = repeat([tableLine],row+1)
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
        let StringP  = s:tableChar("Type only enter,if don't want to arbitrary String\nInput String with space")
        if StringP == -1
            return
        elseif StringP == ''
            let StringP = deepcopy(g:markdowntable_Stringpriority)
        else
            let StringP = split(StringP,'\s')
        endif
        if a:0 > 1
            let [line1,line2] = [a:2,a:3]
        else
            let [line1,line2] = [line("'["),line("']")]
        endif
        let bang = g:markdowntable_noalign
        let mode = a:1
    else
        let [line1,line2] = [a:1,a:2]
        if a:3 == '!'
            let bang = 0
        else
            let bang = 1
        endif
        if a:5 != ''
            let StringP = split(join(deepcopy(a:000[4:]),"\s"),'')
        else
            let StringP = deepcopy(g:markdowntable_Stringpriority)
        endif
        let mode = a:4
    endif
    let setline = []
    let i = line1
    while i <= line2
        let k = getline(i)
        if k =~ '\M\S\.\+'
            break
        endif
        let i+=1
    endwhile
    let leftwhite = matchstr(getline(i),'\M^\s\+')
    if mode ==# 'All'
        let StringP = sort(StringP)
        let StringP = uniq(StringP)
        let hasSep = count(StringP,'|')
        if hasSep == 0
            call remove(StringP,index(StringP,'|'))
        endif
        for lnum in range(i,line2)
            let curline = s:getCurline(lnum)
            if curline ==# 'con'
                continue
            endif
            if hasSep == 0
                let curline = s:escapeSep(curline)
            endif
            for String in StringP
                let curline = s:changeTable(curline,String)
            endfor
            call add(setline,curline)
        endfor
    else
        for lnum in range(i,line2)
            let curline = s:getCurline(lnum)
            if curline ==# 'con'
                continue
            endif
            let aflist = split(curline,'\M\[^\\]\zs\|\\\.\zs')
            let StringDetect = []
            for String in StringP
                call add(StringDetect,count(aflist,String))
            endfor
            let max = max(StringDetect)
            let max = index(StringDetect,max)
            if max < 0
                let max = 0
            endif
            exe 'let String = StringP['.max.']'
            if String != '|'
                let curline = s:escapeSep(curline)
            endif
            let curline = s:changeTable(curline,String)
            call add(setline,curline)
        endfor
    endif
    echomsg string(setline)
    if bang && i != line2 && len(setline) != 0
        let bars = ' '.repeat('-',g:markdowntable_cellspaces).' |'
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
    call s:echored('ToTable'.mode.' works successfully')
endfunc

func! markdowntable#UnTable(type,...) abort
    if a:type =~ '\M^l\|b\|c\.\+$'
        if a:0 > 1
            let [line1,line2] = [a:1,a:2]
        else
            let [line1,line2] = [line("'["),line("']")]
        endif
        let String = s:tableChar("Type only enter,If you don't want to set any String\nInput String")
        if String == -1
            return
        elseif String !=# ''
            if stridx(String,"\s") != -1 && stridx(String,"\s") != 0
                let String = strcharpart(String,1,stridx(String,"\s"))
            endif
        endif
    else
        let [line1,line2] = [a:1,a:2]
        if a:3 != ''
            if stridx(a:3,"\s") != -1
                let String = strcharpart(a:3,0,stridx(a:3,"\s"))
            else
                let String = a:3
            endif
        else
            let String = g:markdowntable_untableString
        endif
    endif
    let setline = []
    let i = line1
    while i <= line2
        let k = getline(i)
        if k =~ '\M\S\.\+'
            break
        endif
        let i+=1
    endwhile
    let leftwhite = matchstr(getline(i),'\M^\s\+')
    let curline = s:retText(i,String)
    if curline !=# 'con'
        call add(setline,curline)
    endif
    let curline = getline(i+1)
    if curline !~ '\M^\s\*|\(\s\*:\?-\+:\?\s\*|\s\*\)\+$'
        let curline = s:retText(i+1,String)
        if curline !=# 'con'
            call add(setline,curline)
        endif
    endif
    for lnum in range(i+2,line2)
        let curline = s:retText(lnum,String)
        call add(setline,curline)
    endfor
    call map(setline,'leftwhite.v:val')
    silent call append(line2,setline)
    silent exe line1.','.line2.'delete _'
    call s:echored('UnTable works successfully')
endfunc

func! s:echoWarn(msg)
    echohl WarnigMsg
    redraw!
    echomsg a:msg
    echohl None
    return -1
endfunc

func! s:echored(msg)
    echohl None
    redraw!
    echomsg a:msg
    return
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

func! s:getCurline(lnum) abort
    let curline = matchstr(getline(a:lnum),'\M\S\.\*')
    if curline == ''
        return 'con'
    elseif curline =~ '\M\s\*$'
        let ridx = matchend(curline,'\M\s\*$')
    else
        let ridx = len(curline)
    endif
    let curline = strcharpart(curline,0,ridx)
    return curline
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

func! s:changeTable(curline,String) abort
    let curline = a:curline
    let aflist = split(curline,'\M\[^\\'.a:String.']\+\zs\|\(\\\.\zs\)\|'.a:String.'\zs')
    let k = 0
    while k < len(aflist)
        if aflist[k] =~# '\M\\'.a:String
            let aflist[k] = a:String
        elseif aflist[k] =~# '\M'.a:String
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
        if aflist[k] == '|'
            let aflist[k] = '\|'
        endif
        let k += 1
    endwhile
    return join(aflist,'')
endfunc

func! s:changeText(curline,String) abort
    let aflist = split(a:curline,'\M\[^\\|]\+\zs\|\(\\\.\zs\)\||\s\*\zs')
    let k = 0
    while k < len(aflist)
        if aflist[k] =~ '\M\\\.'
            let aflist[k] = matchstr(aflist[k],'\M\\\zs\.')
        elseif aflist[k] =~ '\M\s\*|\s\*'
            if k != 0 && aflist[k-1] =~ '\M\s\+$'
                let ridx = match(aflist[k-1],'\M\s\+$')
                let aflist[k-1] = strcharpart(aflist[k-1],0,ridx)
            endif
            let aflist[k] = a:String
        endif
        let k += 1
    endwhile
    return join(aflist,'')
endfunc

func! s:retText(lnum,String) abort
    let curline = matchstr(getline(a:lnum),'\M\S\.\*')
    if curline == ''
        return 'con'
    elseif curline =~ '\M|\s\*$'
        let ridx = match(curline,'\M\S\s\*|\s\*$')
    else
        let ridx = match(curline,'\M\S\s\*$')
    endif
    if curline =~ '\M^|'
        let lidx = match(curline,'\M|\s\*\zs')
    else
        let lidx = 0
    endif
    let curline = strcharpart(curline,lidx,ridx)
    return s:changeText(curline,a:String)
endfunc

func! markdowntable#ToTableOp(type,...) abort
    call markdowntable#ToTable('l','')
endfunc

func! markdowntable#ToTableAll(type,...) abort
    call markdowntable#ToTable('l','All')
endfunc

func! markdowntable#UnTableOp(type,...) abort
    call markdowntable#UnTable('l')
endfunc

let &cpo = s:savecpo
unlet s:savecpo
