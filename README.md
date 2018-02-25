# markdowntable

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

    Make empty table.  
    You can set how many rows and columns.  
    In visual-mode, delete selected a
    In visual-mode.delete select area and make empty table.  

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

Convert plain text to markdown table.  
Recognize which String to convert to separator(|) by g:StringPriority.  
You can type {String} as list to select which String is separator manually.  
Recognize first line as header and add alignment line.  
If you use this command with bang(!), don't make alignment line.
Adjust indents automatically.and delete empty lines.  

How to use:  

```
:ToTable [{String}...]
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
    | ---- | ---- | ---- |
    | nnoremap | <buffer><silent> | <Plug> |
    | nnoremap | <buffer><silent> | <Plug> |
    | vnoremap | <buffer><silent> | <Plug> |
    | vnoremap | <buffer><silent> | <Plug> |
    | vnoremap | <buffer><silent> | <Plug> |
    ```

+ ToTableAll

Convert plain text to markdown table.  
A differs from all String convert to separator(|) in terms of :ToTable.  
Other thing is same as :ToTable.  

How to use:  

```
:ToTableAll [{String}...]
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
    | ---- | ---- | ---- | ---- |
    | nnoremap  | buffer | silent | Plug |
    | nnoremap  | buffer | silent | Plug |
    | vnoremap  | buffer | silent | Plug |
    | vnoremap  | buffer | silent | Plug |
    | vnoremap  | buffer | silent | Plug |
    ```

+ :UnTable

    Convert table to plain text.  
    Delete alignment line, if it exists.  
    Convert separator('|') to g:markdowntable_untableString.  
    Default convert to a space.  

    How to use:  

    ```
    :UnTable
    ```

    + Example

        Input  

        ```
        :UnTable
        ```

        Before

        ```
        | nnoremap  | buffer | silent | Plug |
        | nnoremap  | buffer | silent | Plug |
        | nnoremap  | buffer | silent | Plug |
        | vnoremap  | buffer | silent | Plug |
        | vnoremap  | buffer | silent | Plug |
        | vnoremap  | buffer | silent | Plug |
        ```

        After  

        ```
        nnoremap ;buffer:silent<Plug
        nnoremap ;buffer:silent<Plug
        nnoremap ;buffer:silent<Plug
        vnoremap ;buffer:silent<Plug
        vnoremap ;buffer:silent<Plug
        vnoremap ;buffer:silent<Plug
        ```

+ :ToggleTable

    This command can toggle table.  
    Convert table to plain text,and plain text to table.  

    Note: This command count table or plain text lines of selected and decide to convert to table or plain text.  

### Mapping

Disabled all mapping in default.  
If you want to enable these mapping, define g:markdowntable_enablemap.  

+ \<Leader>tm

    call :TableMake command.  
    You can input row and column.  
    You can change default key mapping on your <code>.vimrc</code>.  
    If you only use mapping in markdown file.
    Use filetype-plugin or autocommand in your <code>.vimrc</code> and use <buffer> option.  

    ```
    nmap <Space>tt <Plug>(markdowntable_tablemake)
    vmap <Space>tt <Plug>(markdowntable_tablemake)
    ```

+ \<Leader>ta

    call :ToTableAll command.  
    You can input String.  
    You can change default key mapping on your <code>.vimrc</code>.  
    If you only use mapping in markdown file.
    Use filetype-plugin or autocommand in your <code>.vimrc</code> and use <buffer> option.  

    ```
    nmap <Space>ta <Plug>(markdowntable_totableall)
    vmap <Space>ta <Plug>(markdowntable_totableall)
    ```

+ \<Leader>tu

    call :UnTable command.  
    You can change default key mapping on your <code>.vimrc</code>.  
    If you only use mapping in markdown file.
    Use filetype-plugin or autocommand in your <code>.vimrc</code> and use <buffer> option.  

    ```
    nmap <Space>tu <Plug>(markdowntable_untable)
    vmap <Space>tu <Plug>(markdowntable_untable)
    ```

+ \<Leader>tt

    call :ToggleTable command.  

    You can change default key mapping on your <code>.vimrc</code>.  
    If you only use mapping in markdown file.
    Use filetype-plugin or autocommand in your <code>.vimrc</code> and use <buffer> option.  

    ```
    nmap <Space>tt <Plug>(markdowntable_toggletable)
    vmap <Space>tt <Plug>(markdowntable_toggletable)
    ```

## Customize

+ White spaces between cell's separator(|)

    You can customize how much white spaces between separator(|) by changing this variable.  
    If you change this value,header's '-' quantity is auto changing too.  
    **Note**  
    You can set minus and zero,it means no spaces.  
    Default: 4  

    Example: set 8 spaces.

    ```
    g:markdowntable_cellspaces = 8
    ```

+ Change String priorities of :ToTable and :ToTableAll command

    You can customize which String is to convert by this variable.  
    Set String priorities by list,left value is higher than right.  
    By default, this variable is set below.  

    ```
    let g:markdowntable_Stringpriority = [';', ':', ',', '.']
    ```

    You can set own priorities of String by variable.  

    Example: set priority '|' → ',' → '.'  

    ```
    let g:markdowntable_Stringpriority = ['|', ',', '.']  
    ```

+ Don't make alinment line always when use mapping of :ToTable and :ToTableAll

    If you don't want to make alignment line,set this variable to true.  
    Default: false(0)  

    Example:  

    ```
    let g:markdowntable_noalign = 1
    ```

+ Enable default mapping

    You can define this variable to enable all default mappings.  

    Example:  

    ```
    let g:markdowntable_enablemap = 1
    ```

+ Want to convert separator to specific String

    You can change convert separator('|') to specific char by define this variable.  
    Default: ' ' (space)  

    Example:  

    ```
    let g:markdowntable_untableString = ','
    ```

## Todo

Implement list in the future.  

+ Delete empty cell automatically

    Delete empty cell such as '|  |' in all table commands automatically.  
    All table commands - :ToTable,:ToTableAll,:UnTable(,:ToggleTable).  

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

