# MarkdownTable.vim

THIS PLUGIN IS NOT COMPLETED YET.  
Plugin's mapping or command may change in the future.  

## Description

This is my first plugin.  
This plugin provides command to make empty markdown table.  
You can convert plain text to markdown table.  
You can use comannd and mapping only in markdown files.  

**Note**  
This plugin is made for me. So if you install this plugin, it may occur some problems.  
I don't know how minimum vim-version move this function.  
I know don't work in VI and work well in larger than Vim 8.0.  

## Usage

You can use Command or Mapping.  

### Commands

You can use these commands on markdown file.   

+ TableMake

    This command makes empty table.  
    You can set how many rows and columns.  
    This command adjust indents automatically.  

    How to use:  

    ```
    :TableMake {row} {column}
    ```

    + Example

        Input  

        ```
        :TableMake 2 4
        ```

        Output  

        ```
        |    |    |    |    |
        |----|----|----|----|
        |    |    |    |    |
        |    |    |    |    |
        ```

+ ToTable

    You can use this command with no args to convert plain text to table.  
    This command recognize which symbol to convert to separator(|) by g:symbolPriority.  
    You can type {symbols} as list to which symbol is separator manually.  
    If you use this command with bang(!),the command recognize first line as table header and add alignment line.  
    This command adjust indents automatically.and delete empty lines.  

    How to use:  

    ```
    :ToTable [{symbols}]
    ```

    + Example

        Input  
        <code>:ToTable \s</code> with select area.

        Before  

        ```
        nnoremap <buffer><silent> <Plug>
        nnoremap <buffer><silent> <Plug>
        nnoremap <buffer><silent> <Plug>
        vnoremap <buffer><silent> <Plug>

        vnoremap <buffer><silent> <Plug>
        vnoremap <buffer><silent> <Plug>
        ```

        After  

        ```
        | nnoremap | <buffer><silent> | <Plug> |
        | nnoremap | <buffer><silent> | <Plug> |
        | nnoremap | <buffer><silent> | <Plug> |
        | vnoremap | <buffer><silent> | <Plug> |
        | vnoremap | <buffer><silent> | <Plug> |
        | vnoremap | <buffer><silent> | <Plug> |
        ```

+ ToTableAll

    You can use this command to convert plain text to table.  
    A differs from all symbol convert to separator(|) in terms of :ToTable.  
    If you use this command with !(bang),the command recognize first line as table header and add alignment line.  
    This command adjust indents automatically.and delete empty lines.  

    How to use:  

    ```
    :ToTableAll [{symbols}]
    ```

    + Example

        Input  

        ```
        :ToTableAll ; : <
        ```

        Before  

        ```
        nnoremap ;buffer:silent<Plug
        nnoremap ;buffer:silent<Plug
        nnoremap ;buffer:silent<Plug
        vnoremap ;buffer:silent<Plug
        vnoremap ;buffer:silent<Plug
        vnoremap ;buffer:silent<Plug
        ```

        After  

        ```
        | nnoremap  | buffer | silent | Plug |
        | nnoremap  | buffer | silent | Plug |
        | nnoremap  | buffer | silent | Plug |
        | vnoremap  | buffer | silent | Plug |
        | vnoremap  | buffer | silent | Plug |
        | vnoremap  | buffer | silent | Plug |
        ```

### Mapping

+ \<Leader>tm

    call :TableMake command.  
    You can input row and column.  

    You can change default key mapping on your <code>.vimrc</code>.  
    If you only use mapping in markdown file.
    Use filetype-plugin or autocommand in your <code>.vimrc</code> and use <buffer> option.  
    You can disable default mapping to change g:markdowntable_disableMap.  

    ```
    nmap <Space>tt <Plug>(Markdowntable_tablemake)
    vmap <Space>tt <Plug>(Markdowntable_tablemake)
    ```

+ \<Leader>tt

    call :ToTable command.  
    You can input symbols.  

    You can change default key mapping on your <code>.vimrc</code>.  
    If you only use mapping in markdown file.
    Use filetype-plugin or autocommand in your <code>.vimrc</code> and use <buffer> option.  
    You can disable default mapping to change g:markdowntable_disableMap.  

    ```
    nmap <Space>tt <Plug>(Markdowntable_totable)
    vmap <Space>tt <Plug>(Markdowntable_totable)
    ```

+ \<Leader>ta

    call :ToTableAll command.  
    You can input symbols.  

    You can change default key mapping on your <code>.vimrc</code>.  
    If you only use mapping in markdown file.
    Use filetype-plugin or autocommand in your <code>.vimrc</code> and use <buffer> option.  
    You can disable default mapping to change g:markdowntable_disableMap.  

    ```
    nmap <Space>ta <Plug>(Markdowntable_totableall)
    vmap <Space>ta <Plug>(Markdowntable_totableall)
    ```

## Customization

+ White spaces between cell's separator(|)

    You can customize how much white spaces between separator(|) by changing this variable.  
    If you change this value,header's '-' quantity is auto changing too.  
    **Note**  
    You can set minus and zero,it means no spaces.  
    Default: 4  

    Example: set 8 spaces.

    ```
    g:markdowntable_cellSpaces = 8
    ```

+ Symbol priorities of :ToTable and :ToTableAll command

    You can customize which symbol is to convert by this variable.  
    Set symbol priorities by list,left value is higher than right.  
    By default, this variable is set below.  

    ```
    let g:markdowntable_symbolPriority = [';', ':', ',', '.']
    ```

    You can set own priorities of symbol by variable.  

    Example: set priority "|" → "," → "."  

    ```
    let g:markdowntable_symbolPriority = ["|", ",", "."]  
    ```

+ Make header or no header always when use :ToTable and :ToTableAll mapping

    If you want to make header always in mapping of :ToTable or :ToTableAll, You can set this value true(not zero) to make header always.  
    Default: false(0)  

    Example:  

    ```
    let g:markdowntable_toTableHeader = 1
    ```

+ Disable default mapping

    You can change this variable true(not zero) to disable all default mappings.  
    Default: false(0)  

    Example:  

    ```
    let g:markdowntable_disableMap = 1
    ```

## Todo

Implement list in the future.  

+ Add :UnTable command

    This command is opposite operation by :ToTable.  
    Convert table to plain text.  
    This command will be a part of :ToggleTable.  

+ Add :ToggleTable command and mapping

    This command can toggle table.  
    Convert table to sentence,and sentence to table.  
    :ToTable mappping is deleted and change to this command mapping when this command added.  
    Mapping is deleted but,:ToTable command is available.  
    This command is implemented after :UnTable command.  

+ Movement mapping for table

    Easy to move to the table header and alignment-line.  
    When cursor is on the table,move to the header or alignment-line of current row.  

+ Add auto adjust cell amount to maximum row.  

+ Support repeat.vim?

+ Syntax-highlighting

    Highlight header and aliment line.Also normal table column.  
    Normal table column highlighting is different by row alignment.  
    Such as right is ...,center is ...  

+ Auto add table separater when insert mode

    At last line when editing table, auto add last and first table separater('|') when you type enter.  
    I don't know how to implement this.  

