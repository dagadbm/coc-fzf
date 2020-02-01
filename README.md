fzf :heart: coc.nvim
===============

Use [fzf][fzf] instead of [coc.nvim][coc.nvim] built-in fuzzy finder.

Rationale
---------

Inspired by [Robert Buhren's functions][RobertBuhren] and [coc-denite][coc_denite] this plugin aims to use [fzf][fzf] for CocList sources when possible.

The goal is to keep the [coc.nvim][coc.nvim] style and leverage your [FZF Vim integration][fzf_vim_integration], such as layout, shortcuts, options etc.


Commands
---------

| Command                     | List                                                      |
| ---                         | ---                                                       |
| `:CocFzfListDiagnostics`    | Equvalent to :CocList diagnostics                         |
| `:BCocFzfListDiagnostics`   | Equvalent to :CocList diagnostics in the current buffer   |
| `:CocFzfListExtensions`     | Equvalent to :CocList extensions                          |


Vimrc Example
---------

```vim
nnoremap <silent> <space>a  :<C-u>CocFzfListDiagnostics<CR>
nnoremap <silent> <space>e  :<C-u>CocFzfListExtensions<CR>
```

License
-------

MIT

[fzf_vim_integration]: https://github.com/junegunn/fzf/blob/master/README-VIM.md
[fzf]:                 https://github.com/junegunn/fzf
[coc.nvim]:            https://github.com/neoclide/coc.nvim
[RobertBuhren]:        https://gist.github.com/RobertBuhren/02e05506255c667c0038ce74ee1cef96
[coc_denite]:          https://github.com/neoclide/coc-denite
