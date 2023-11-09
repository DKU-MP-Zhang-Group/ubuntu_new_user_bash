# ubuntu_new_user_bash
作为科研用途服务器管理员，为了便利操作需要：
## 管理员新建用户脚本
### 功能
1. 用户名批量和逐个配置可选择
2. 权限(docker 用户组)
3. 安装miniconda（脚本）
4. 创建workspace文件夹
5. 配置代理
6. 新用户创建/mnt/sdb下的数据存储文件夹
## 管理员第一次运行脚本
1. 运行之前：
    - 安装git lfs: `sudo apt install git-lfs -y && git lfs install`
    - 安装expect: `sudo apt install tcl tk expect -y`
    - 临时设置代理: `export https_proxy=http://10.200.13.85:3128 && http_proxy=http://10.200.13.85:3128`
    - clone本仓库:  `git clone https://github.com/DKU-MP-Zhang-Group/ubuntu_new_user_bash.git`
### 功能
1. 安装远程桌面（脚本）
2. 挂载nas
    - 同时修改fstab
      - nas77: `10.200.14.77:/lz97-leizhang /mnt/nas_77/ nfs defaults 0 0`
      - 
3. 修改主机名，并通过PS1设置完全展示主机名， 同步修改/etc/skel/下的`.bashrc`文件(PS1中\h ——> \H, 显示全部主机名)
4. 安装需要的软件：tmux, thefuck(修改bash), docker
5. 文件夹权限：/mnt/sdb
## 新用户第一次运行脚本
1. 修改密码
2. 配置git
## 同步脚本
1. 同步不同服务器之间的设置
    - 不同新用户文件设置：/etc/skel/下
## 基本使用文档
## 机房准入权限
## 修改ubuntu与root用户密码

