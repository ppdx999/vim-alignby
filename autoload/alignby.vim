" Count 3byte-char as two 
function! s:strlenX(text)
	let single_multi_total = strlen(a:text)
	if &ambiwidth !=# 'double'
		return single_multi_total
	endif
	let total_by_byte = strlen(substitute(a:text, '.', 'x','g'))
	if (single_multi_total == total_by_byte)
		return total_by_byte
	else
		let n_multi_byte = (single_multi_total - total_by_byte) / 2
		let n_single_byte = single_multi_total - (n_multi_byte * 3)
		return n_single_byte + (n_multi_byte * 2)
	endif
endfunction


function! alignby#Main(mode, char)
	if a:mode !=# 'V'
		echo 'This function should be called in V mode'
		return
	endif

	" Get Selected Text and assign it into a variable
    let lineStart = getpos("'<")[1]
    let lineEnd = getpos("'>")[1]
    let lines = getline(lineStart, lineEnd)
	let nLines = len(lines)

	" Prepare a list to store the maximum length of the string in each column.
	let cellLengths = []
	let nCellLengths = 0
	for i in range(0, nLines-1)
		if matchstr(lines[i], a:char) ==# "" | continue | endif
		let thisCellLength = len(split(lines[i], a:char, 1))
		if thisCellLength > nCellLengths
			let nCellLengths = thisCellLength
		endif
	endfor
	for i in range(0, nCellLengths-1)
		let cellLengths = add(cellLengths, 0)
	endfor

	for i in range(0, nLines-1)
		if matchstr(lines[i], a:char) ==# "" | continue | endif

		let strList = split(lines[i], a:char , 1)
		let nStrList = len(split(lines[i], a:char , 1)) 

		for j in range(0, nStrList-1)
			let nStr = s:strlenX(strList[j])
			if nStr > cellLengths[j]
				let cellLengths[j] = nStr
			endif
		endfor
	endfor

	" Adds whitespace based on the 'cellLength' value. And write it to buffer. 
	for i in range(0, nLines-1)
		if matchstr(lines[i], a:char) ==# "" | continue | endif

		let strList = split(lines[i], a:char , 1)
		let nStrList = len(split(lines[i], a:char , 1)) 

		for j in range(0, nStrList-1)
			let nAddSpace = cellLengths[j] - s:strlenX(strList[j]) 
			for k in range(0, nAddSpace-1)
				let strList[j] .= ' '
			endfor
		endfor
		let lines[i] = join(strList, a:char)
		"let lines[i] = substitute(lines[i], '\\t', '\t', 'g')
		call setline(lineStart + i, lines[i])
	endfor
endfunction
