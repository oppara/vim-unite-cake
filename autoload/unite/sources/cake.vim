let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
" @TODO"
call unite#util#set_default('g:unite_source_cake_ignore_pattern',
      \'^\%(/\|\a\+:/\)$\|\%(^\|/\)\.\.\?$\|empty$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$')
"}}}

let s:places =[
      \ {'name' : 'app'        , 'path' : '/src'                        } ,
      \ {'name' : 'test'       , 'path' : '/tests'                      } ,
      \ {'name' : 'controller' , 'path' : '/src/Controller'             } ,
      \ {'name' : 'model'      , 'path' : '/src/Model'                  } ,
      \ {'name' : 'view'       , 'path' : '/src/View'                   } ,
      \ {'name' : 'template'   , 'path' : '/src/Template'               } ,
      \ {'name' : 'config'     , 'path' : '/config'                     } ,
      \ {'name' : 'component'  , 'path' : '/src/Controller/Component'   } ,
      \ {'name' : 'behavior'   , 'path' : '/src/Model/Behavior'         } ,
      \ {'name' : 'entity'     , 'path' : '/src/Model/Entity'           } ,
      \ {'name' : 'table'      , 'path' : '/src/Model/Table'            } ,
      \ {'name' : 'helper'     , 'path' : '/src/Views/Helper'           } ,
      \ {'name' : 'vendor'     , 'path' : '/vendor'                     } ,
      \ {'name' : 'plugin'     , 'path' : '/plugins'                    } ,
      \ {'name' : 'shell'      , 'path' : '/src/Shell'                  } ,
      \ {'name' : 'js'         , 'path' : '/webroot/js'                 } ,
      \ {'name' : 'css'        , 'path' : '/webroot/css'                } ,
      \  ]

let s:source = {}


function! s:source.gather_candidates(args, context)
  return s:create_sources(self.path)
endfunction

" cakephp/command
"   history
"   [command] cake

let s:source_command = {}



function! unite#sources#cake#define()
  return map(s:places ,
        \   'extend(copy(s:source),
        \    extend(v:val, {"name": "cake/" . v:val.name,
        \   "description": "candidates from history of " . v:val.name}))')
endfunction


function! s:create_sources(path)
  let root = s:cake_root()
  if root == "" | return [] | end
  let files = map(split(globpath(root . a:path , '**') , '\n') , '{
        \ "name" : fnamemodify(v:val , ":t:r") ,
        \ "path" : v:val
        \ }')

  let list = []
  for f in files
    if isdirectory(f.path) | continue | endif

    if g:unite_source_cake_ignore_pattern != '' &&
          \ f.path =~  string(g:unite_source_cake_ignore_pattern)
        continue
    endif


    call add(list , {
          \ "abbr" : substitute(f.path , root . a:path . '/' , '' , ''),
          \ "word" : substitute(f.path , root . a:path . '/' , '' , ''),
          \ "kind" : "file" ,
          \ "action__path"      : f.path ,
          \ "action__directory" : fnamemodify(f.path , ':p:h:h') ,
          \ })
  endfor

  return list
endfunction


function! s:cake_root()
  let dir = finddir("src" , ".;")
  if dir == "" | return "" | endif
  return  dir . "/../"
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

