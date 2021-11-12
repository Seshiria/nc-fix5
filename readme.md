# nextcloud update step 5 

这个工具修复nextcloud的更新在第五步骤卡住的问题。

如果你使用nextcloud的web出现下面这个问题

````
Verifying integrity
Parsing response failed.
Show detailed response
````

![webstop](/img/webstop.png)

或者命令行工具卡在这个位置

````
[ ] Verify integrity ...PHP Fatal error:  Allowed memory size of 134217728 bytes exhausted (tried to allocate 166462960 bytes) in phar:///webapps/www/updater/updater.phar/lib/Updater.php on line 637
````



![shellstop](/img/shellstop.png)

就可以使用这个工具进行修复。



## 使用方法

脚本依赖：wget，sha512sum等。在docker的alpine容器上测试通过。

**注意：使用本工具前请先备份好自己的数据，并且需要在web或者命令行界面进行一次更新操作**

先下载本项目的main.sh

然后在命令行运行

````shell
#如果nextcloud的data目录在当前目录的子目录，就直接运行即可
sh main.sh
#如果要指定目录请使用
#export WPATH=包含nextcoud data的目录
#比如
export WPATH=/
sh main.sh
````
**如果你审查了脚本确定符合你想要的效果可以直接执行**

````shell
 wget -O - https://raw.githubusercontent.com/Seshiria/nc-fix5/master/main.sh |sh
 #或者
 curl https://raw.githubusercontent.com/Seshiria/nc-fix5/master/main.sh |sh
 ````

等命令行执行完毕无报错后，可以**重新**运行nextcloud的更新程序，会从第五步继续开始

![webfix](/img/webfix.png)

![webfix](/img/shelfix.png)

## 问题原因和修复原理

大概是nextcloud官方利用纯php实现来进行文件验证，占用大量内存导致php出错。

这个工具用shell代替验证文件过程和把正确的状态写入对应文件。
