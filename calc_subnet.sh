#!/bin/bash

# input cidr
read -p "input CIDR (exsample: xxx.xxx.xxx.xxx/yy)>" CIDR

# ��񕪊�
PREFIX=$(echo "$CIDR" | sed "s:.*\/::g")
ADDR_TMP=$(echo "$CIDR" | sed "s:/.*::g")
ADDR=(${ADDR_TMP//./ })

# �Ώۂ̃I�N�e�b�g���擾(0�͂��܂�)
TARGET_OCTED_INDEX=$(($PREFIX/8))
TARGET_OCTED=${ADDR[$TARGET_OCTED_INDEX]}

# �ΏۃI�N�e�b�g���̃z�X�g�r�b�g��
SUBNET_IN_OCTED=$(($PREFIX%8))

# �z�X�g�r�b�g���ƃz�X�g���̕R�Â�
declare -A SUBNET_ADOPT=(
  ["0"]=256
  ["1"]=128
  ["2"]=64
  ["3"]=32
  ["4"]=16
  ["5"]=8
  ["6"]=4
  ["7"]=2
)
NETWORK_ADDRESS=(${ADDR[@]})
BLOADCAST_ADDRESS=(${ADDR[@]})

# �l�b�g���[�N�A�h���X�ƃu���[�h�L���X�g�A�h���X���v�Z
NETWORK_ADDRESS_IN_TERGET_OCTED=$(( $TARGET_OCTED/${SUBNET_ADOPT[${SUBNET_IN_OCTED}]}*${SUBNET_ADOPT[${SUBNET_IN_OCTED}]} ))
NETWORK_ADDRESS[$TARGET_OCTED_INDEX]=$NETWORK_ADDRESS_IN_TERGET_OCTED
BLOADCAST_ADDRESS[$TARGET_OCTED_INDEX]=$(( ${NETWORK_ADDRESS_IN_TERGET_OCTED}+${SUBNET_ADOPT[${SUBNET_IN_OCTED}]}-1 ))

# �ΏۃI�N�e�b�g���E���̃I�N�e�b�g��0��255�Ŗ��߂�
for i in {3..0} ; do
  if [ $i -eq ${TARGET_OCTED_INDEX} ];then
    break
  fi
  NETWORK_ADDRESS[$i]=0
  BLOADCAST_ADDRESS[$i]=255
done

# show result
function show_address {
  NAME="$1"
  shift
  address=$(echo $@|sed "s/ /./g")
  echo "${NAME} address: ${address}"
}
show_address "network" "${NETWORK_ADDRESS[@]}"
show_address "bloadcast" "${BLOADCAST_ADDRESS[@]}"