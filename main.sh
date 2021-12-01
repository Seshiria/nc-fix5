#!/bin/sh
echo "修复nextcloud更新卡在步骤5的小工具"
echo "使用本工具前请先手动更新一次nextcloud"
echo "指定路径请配置环境变量"export WPATH=/""
WPATH=${WPATH:-$(pwd)}
echo "当前搜寻路径为：${WPATH}"
echo "开始查找更新"
STEOFILE=$(find "${WPATH}" -type f -name .step)
case $(echo "${STEOFILE}" | wc -l) in
0)
    echo "找不到对应的更新文件！"
    echo "请确认设置了正确的操作目录，当前操作目录为：${WPATH}"
    exit 1
    ;;
1)
    ;;
*)
    echo "找到多于一个的更新目录，请清空更新缓存"
    exit 1
    ;;
esac
if grep \"step\"\:5 "${STEOFILE}" > /dev/null ; then
    if grep \"state\":\"start\" "${STEOFILE}" > /dev/null ; then
        echo "step文件检查通过"
    else
        echo "当前nextcloud更新并没有开始运行或者已经运行完毕。下面为调试信息"
        cat "${STEOFILE}"
        dirname "${STEOFILE}"
        exit 1
    fi
else
    echo "当前nextcloud更新并不是在第五阶段，无法修复"
    cat "${STEOFILE}"
    dirname "${STEOFILE}"
fi
echo "验证更新文件"
UPATH=$(dirname "${STEOFILE}")
UFILE=${UPATH}/downloads/*.zip
case $(ls "${UFILE}"|wc -l) in
1)
    LOACL_SHA=$(sha512sum "${UFILE}"|awk -F "\ " '{print $1}')
    _NAME=$(basename "${UFILE}")
    ONLINME_SHA=$(wget -q -O- https://download.nextcloud.com/server/releases/"${_NAME}".sha512|awk -F "\ " '{print $1}')
    if [ "$ONLINME_SHA" = "$LOACL_SHA" ]; then
        echo "哈希检查通过，正在写入信息"
        echo -e "{\"state\":\"end\",\"step\":5}" > "${STEOFILE}"
        echo "写入完成，请重新执行nextcloud的更新操作，现在nextcloud更新会从第五步继续"
        exit 0
    else
        echo "哈希对比出错，错误的更新文件"
        echo "待更新的文件： ${_NAME}"
        echo "本地sha512： ${LOACL_SHA}"
        echo "远端sha512： ${ONLINME_SHA}"
        echo "需要手动下载对应的更新文件到指定位置"
        echo "可以尝试以下操作：------------------"
        echo "rm ${UPATH}/downloads/*.zip"
        echo "wget -P ${UPATH}/downloads/ https://download.nextcloud.com/server/releases/${_NAME}"
    fi
;;
*)
    echo "下载目录错误,不存在更新文件或存在多个更新文件。"
    ls "${UFILE}"
esac



