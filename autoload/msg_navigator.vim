" autoload/msg_navigator.vim

if exists('g:loaded_msg_navigator')
  finish
endif
let g:loaded_msg_navigator = 1

function! msg_navigator#GetAlternateMsgFiles()
  let l:current_file = expand('%:p')         " 現在のファイルの絶対パス
  let l:current_filename = expand('%:t')     " 現在のファイル名
  let l:parent_dir = fnamemodify(l:current_file, ':h')         " 親ディレクトリ
  let l:grandparent_dir = fnamemodify(l:parent_dir, ':h')      " 祖父ディレクトリ

  " 祖父ディレクトリの直下のサブディレクトリから同名のファイルを検索
  let l:glob_pattern = l:grandparent_dir . '/*/' . fnameescape(l:current_filename)
  let l:msg_files = glob(l:glob_pattern, 0, 1)

  " 現在のファイルをリストから除外
  call remove(l:msg_files, index(l:msg_files, l:current_file))

  " ファイルが見つからない場合は現在のファイルのみのリストを返す
  if empty(l:msg_files)
    echo "同名のファイルが見つかりませんでした。"
    return [l:current_file]
  endif

  " 親ディレクトリ名でソート
  let l:sorted_files = sort(l:msg_files, {a, b ->
        \ fnamemodify(fnamemodify(a, ':h'), ':t') <# fnamemodify(fnamemodify(b, ':h'), ':t') ? -1 : 1})

  " 現在のファイルを先頭に追加
  call insert(l:sorted_files, l:current_file, 0)

  return l:sorted_files
endfunction

function! msg_navigator#GetMsgFileIndex()
  if !exists('b:msg_file_list') || !exists('b:msg_current_index')
    " リストとインデックスを初期化
    let b:msg_file_list = msg_navigator#GetAlternateMsgFiles()
    let b:msg_current_index = index(b:msg_file_list, expand('%:p'))
  endif
  return b:msg_current_index
endfunction

function! msg_navigator#MsgCycleNext()
  let l:index = msg_navigator#GetMsgFileIndex()
  let l:list_len = len(b:msg_file_list)
  let l:new_index = (l:index + 1) % l:list_len
  let l:new_file = b:msg_file_list[l:new_index]

  " 現在のファイルのリストと新しいインデックスを一時変数に保存
  let l:file_list = b:msg_file_list
  let l:current_index = l:new_index

  " 新しいファイルを開く
  execute 'edit ' . fnameescape(l:new_file)

  " 新しいバッファでバッファローカル変数を再設定
  let b:msg_file_list = l:file_list
  let b:msg_current_index = l:current_index
endfunction

function! msg_navigator#MsgCyclePrev()
  let l:index = msg_navigator#GetMsgFileIndex()
  let l:list_len = len(b:msg_file_list)
  let l:new_index = (l:index - 1 + l:list_len) % l:list_len
  let l:new_file = b:msg_file_list[l:new_index]

  " 現在のファイルのリストと新しいインデックスを一時変数に保存
  let l:file_list = b:msg_file_list
  let l:current_index = l:new_index

  " 新しいファイルを開く
  execute 'edit ' . fnameescape(l:new_file)

  " 新しいバッファでバッファローカル変数を再設定
  let b:msg_file_list = l:file_list
  let b:msg_current_index = l:current_index
endfunction
