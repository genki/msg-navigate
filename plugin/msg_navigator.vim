" plugin/msg_navigator.vim

if exists('g:loaded_msg_navigator_plugin')
  finish
endif
let g:loaded_msg_navigator_plugin = 1

" FileType が msg のときに自動的にセットアップを行う
augroup msg_navigator_setup
  autocmd!
  autocmd FileType msg call msg_navigator#Setup()
augroup END

" セットアップ関数
function! msg_navigator#Setup()
  " コマンドを定義
  command! -buffer MsgCycleNext call msg_navigator#MsgCycleNext()
  command! -buffer MsgCyclePrev call msg_navigator#MsgCyclePrev()

  " キーマッピングを設定
  nnoremap <buffer> <silent> ]m :MsgCycleNext<CR>
  nnoremap <buffer> <silent> [m :MsgCyclePrev<CR>
endfunction
