### Music163bot-Go  Docker 部署指南 (Definitive Docker Deployment Guide)

本指南旨在为优秀的开源项目 **Music163bot-Go** 提供一个详尽、易于遵循的 Docker 部署流程。

### Docker Hub仓库地址：https://hub.docker.com/r/smhw3565/music163bot-go-2

*   **项目版权归属**: 本项目由 **XiaoMengXinX** 开发，其官方 GitHub 仓库地址为：
    *   [https://github.com/XiaoMengXinX/Music163bot-Go](https://github.com/XiaoMengXinX/Music163bot-Go)
*   **指南目的**: 由于原项目并未提供官方 Docker 部署教程，本指南将帮助您轻松地将其容器化。您使用的 Docker 镜像是 `smhw3565/music163bot-go-2:latest`。

> **核心部署理念：配置先行！**
>
> 机器人需要读取包含您私人信息（如 Bot Token）的配置文件才能启动。因此，**在运行任何 Docker 命令之前，您必须先在服务器上创建并编辑好这个文件。**
>
> 该配置文件 **必须** 被命名为 `config.ini`，程序只会识别这个文件名。

---

#### 部署流程

##### **第一步：创建并配置 `config.ini` (最重要！)**

这是部署过程中最关键的一步。

1. **登录服务器，创建并进入工作目录：**

   ```bash
   # 我们将所有相关文件都存放在这里
   mkdir -p /home/music163bot
   cd /home/music163bot
   ```

2. **创建并编辑 `config.ini` 文件：**

   ```bash
   nano config.ini
   ```

3. **将以下内容粘贴到文件中，并修改为您自己的信息：**

   ```ini
   # 以下为必填项
   # 你的 Bot Token
   BOT_TOKEN = YOUR_BOT_TOKEN
   
   # 你的网易云 cookie 中 MUSIC_U 项的值（用于下载无损歌曲）
   MUSIC_U = YOUR_MUSIC_U
   
   
   # 以下为可选项
   # 自定义 telegram bot API 地址
   BotAPI = https://api.telegram.org
   
   # 设置 bot 管理员 ID, 用 “," 分隔
   BotAdmin = 115414,1919810
   
   # 是否开启 bot 的 debug 功能
   BotDebug = false
   
   # 自定义 sqlite3 数据库文件 （默认为 cache.db）
   Database = cache.db
   
   # 设置日志等级 [panic|fatal|error|warn|info|debug|trace] (默认为 info)
   LogLevel = info
   
   # 是否开启自动更新 (默认开启）, 若设置为 false 相当于 -no-update 参数
   AutoUpdate = true
   
   # 下载文件损坏是否自动重新下载 (默认为 true)
   AutoRetry = true
   
   # 最大自动重试次数 (默认为 3)
   MaxRetryTimes = 3
   
   # 下载超时时长 (单位秒, 默认为 60)
   DownloadTimeout = 60
   
   # 自定义下载反向代理
   ReverseProxy = 114.5.1.4:8080
   ```

   编辑完成后，按 `Ctrl+X` -> `Y` -> `Enter` 保存并退出。

##### **第二步：在相同目录下创建 `docker-compose.yml`**

您的配置文件已经就绪。现在，我们在**同一个目录** (`/home/music163bot`) 下创建用于一键部署的 `docker-compose.yml` 文件。已包含自定义 telegram bot API部署

1. **创建文件：**

   ```bash
   nano docker-compose.yml
   ```

2. **将以下内容完整粘贴进去：**

   ```yaml
   version: '3.8'
   
   services:
     music163bot:
       image: smhw3565/music163bot-go-2:latest
       container_name: music163bot
       restart: always
       volumes:
         - ./config.ini:/app/config.ini
         - ./log:/app/log
         - ./src:/app/src
       working_dir: /app
       depends_on:
         - telegram-bot-api
       networks:
         - bot-network
   
     telegram-bot-api:
       image: aiogram/telegram-bot-api:latest
       container_name: telegram-bot-api
       restart: always
       environment:
         TELEGRAM_API_ID: ""         # 您的 telegram_api_id
         TELEGRAM_API_HASH: ""       # 您的 telegram_api_hash
         TELEGRAM_BOT_API_MAX_FILE_SIZE: "2147483648"  # 2GB
         TELEGRAM_BOT_API_MAX_CONNECTIONS: "500"
       volumes:
         - telegram-bot-api-data:/var/lib/telegram-bot-api
       ports:
         - "8081:8081"
       networks:
         - bot-network
   
   volumes:
     telegram-bot-api-data:
   
   networks:
     bot-network:
   ```

   修改好必备信息后，保存并退出。

##### **第三步：一键启动**

所有准备工作均已完成！现在，您只需在当前目录 (`/home/music163bot`) 下执行一条命令，即可启动您的机器人。其他详细内容参考源项目地址：[https://github.com/XiaoMengXinX/Music163bot-Go](https://github.com/XiaoMengXinX/Music163bot-Go)

```bash
docker-compose up -d
```

至此，您的机器人已经成功在后台运行。您可以通过 `docker-compose logs -f` 命令查看实时日志，确保一切正常。 
