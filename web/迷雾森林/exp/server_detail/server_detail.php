<?php
/*
Plugin Name: 服务器信息
Version: 1.0.0
Plugin URL:
Description: 查看服务器详细信息
Author: jaeheng
Author URL: https://www.dkewl.com/
*/

!defined('EMLOG_ROOT') && exit('access deined!');

function server_detail_sidebar()
{
    echo '<a class="collapse-item" id="server_detail" href="plugin.php?plugin=server_detail">服务器信息</a>';
}


addAction('adm_menu_ext', 'server_detail_sidebar');