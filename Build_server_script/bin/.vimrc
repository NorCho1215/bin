:map <F5>  printk("Nor debug ~~ \n");
"pen and close all the three plugins on the same time
nmap <F8>   :TrinityToggleAll<CR>

" Open and close the srcexpl.vim separately
nmap <F7>   :TrinityToggleSourceExplorer<CR>

" Open and close the taglist.vim separately
nmap <F6>  :TrinityToggleTagList<CR>

" Open and close the NERD_tree.vim separately
nmap <F9>  :TrinityToggleNERDTree<CR>
nmap <F10> i printk("Nor debug  ~~ %s: ++\n", __FUNCTION__);
nmap <F11> i NvOsDebugPrintf("Nor debug ~~ \n");
nmap <F12> i ALOGE("Nor debug ~~ %s\n",__FUNCTION__);
""set mouse=a
set t_Co=256
""colorscheme tropikos
""colorscheme harlequin
colorscheme hybrid 
""colorscheme pychimp
