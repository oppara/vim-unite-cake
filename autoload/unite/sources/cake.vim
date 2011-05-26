let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
" @TODO"
call unite#util#set_default('g:unite_source_cake_ignore_pattern',
      \'^\%(/\|\a\+:/\)$\|\%(^\|/\)\.\.\?$\|empty$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$')
"}}}

let s:places =[
      \ {'name' : 'app'        , 'path' : '/app'                        } ,
      \ {'name' : 'test'       , 'path' : '/app/tests'                  } ,
      \ {'name' : 'controller' , 'path' : '/app/controllers'            } ,
      \ {'name' : 'model'      , 'path' : '/app/models'                 } ,
      \ {'name' : 'view'       , 'path' : '/app/views'                  } ,
      \ {'name' : 'config'     , 'path' : '/app/config'                 } ,
      \ {'name' : 'component'  , 'path' : '/app/controllers/components' } ,
      \ {'name' : 'behavior'   , 'path' : '/app/models/behaviors'       } ,
      \ {'name' : 'helper'     , 'path' : '/app/views/helpers'          } ,
      \ {'name' : 'vendor'     , 'path' : '/app/vendors'                } ,
      \ {'name' : 'plugin'     , 'path' : '/app/plugins'                } ,
      \ {'name' : 'lib'        , 'path' : '/app/libs'                   } ,
      \ {'name' : 'locale'     , 'path' : '/app/locale'                 } ,
      \ {'name' : 'datasource' , 'path' : '/app/models/datasources'     } ,
      \ {'name' : 'shell'      , 'path' : '/app/vendors/shells'         } ,
      \ {'name' : 'js'         , 'path' : '/app/webroot/js'             } ,
      \ {'name' : 'css'        , 'path' : '/app/webroot/css'            } ,
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
  let dir = finddir("app" , ".;")
  if dir == "" | return "" | endif
  return  dir . "/../"
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

