if exists('g:loaded_alignby')
	finish
endif
let g:loaded_alignby = 1

let s:key = get(g:, 'alignby_leader_key', '<leader>=')
let s:char_list = get(g:, 'alignby_char_list', ['\|', '\\', '&', ',', '#', '=', '+', ':', ';', ')'])

for char in s:char_list
	execute 'vnoremap <buffer> <unique> ' . s:key . char  . ' :<c-u>call alignby#Main(visualmode(), ''' . char .''')<CR>'
endfor
