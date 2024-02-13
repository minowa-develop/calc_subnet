#!/bin/bash

# set CIDR
CIDR="${1}"
if [ ${#1} -eq 0 ] ; then
  # input cidr
  read -rp "input CIDR (exsample: xxx.xxx.xxx.xxx/yy)>" CIDR
fi

# 情報分割
PREFIX=${CIDR//*\//} # /より右側取得
ADDR_TMP=${CIDR//\/*/} # /より左側取得
ADDR=(${ADDR_TMP//./ }) # 配列化

# 対象のオクテットを取得(0はじまり)
TARGET_OCTET_INDEX=$((PREFIX/8))
TARGET_OCTET=${ADDR[TARGET_OCTET_INDEX]}

# 対象オクテット内のネットワークビット数
SUBNET_IN_OCTET=$((PREFIX%8))

# ネットワークビット数とホスト数の紐づけ
SUBNET_ADOPT=(256 128 64 32 16 8 4 2)
HOST_CNT=${SUBNET_ADOPT[SUBNET_IN_OCTET]}

# ネットワークアドレスとブロードキャストアドレス格納用作成
NETWORK_ADDRESS=("${ADDR[@]}")
BROADCAST_ADDRESS=("${ADDR[@]}")

# ネットワークアドレスとブロードキャストアドレスを計算
NETWORK_ADDRESS_IN_TERGET_OCTET=$(( TARGET_OCTET/HOST_CNT*HOST_CNT )) # ネットワークアドレス(対象オクテット)
NETWORK_ADDRESS[TARGET_OCTET_INDEX]=$NETWORK_ADDRESS_IN_TERGET_OCTET
BROADCAST_ADDRESS[TARGET_OCTET_INDEX]=$(( NETWORK_ADDRESS_IN_TERGET_OCTET+HOST_CNT-1 ))

# 対象オクテットより右側のオクテットを0か255で埋める
for i in $(seq $((TARGET_OCTET_INDEX+1)) 3); do
  NETWORK_ADDRESS[i]=0
  BROADCAST_ADDRESS[i]=255
done

# 結果表示(配列をアドレス表記に戻す)
echo "network address: $(echo ${NETWORK_ADDRESS[@]}|sed "s/ /./g")"
echo "broadcast address: $(echo ${BROADCAST_ADDRESS[@]}|sed "s/ /./g")"