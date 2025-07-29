#!/bin/bash
# lan-opt.sh - 自动优化主活动网卡的RPS/XPS和部分ethtool设置

set -e

BLACKLIST_REGEX="^(lo|veth|docker|br-|virbr|vmnet|tap|tun|wg)"

# 检查依赖命令
for cmd in ethtool ip awk grep; do
  if ! command -v $cmd >/dev/null 2>&1; then
    echo "❌ 缺少命令：$cmd，请安装后重试"
    exit 1
  fi
done

# 必须是root运行
if [ "$(id -u)" -ne 0 ]; then
  echo "❌ 必须使用root权限运行"
  exit 1
fi

# 获取首个物理活动网卡
MAIN_IFACE=$(ip -o link show up | awk -F': ' '{print $2}' | grep -Ev "$BLACKLIST_REGEX" | head -n1)

if [ -z "$MAIN_IFACE" ]; then
  echo "❌ 无法识别活动物理网卡"
  exit 1
fi

echo "🔧 正在优化网卡：$MAIN_IFACE"

# 动态生成CPU掩码（使用所有CPU）
NUM_CPUS=$(nproc)
CPU_MASK=$(printf "%x" $(( (1 << NUM_CPUS) - 1 )))

# 网卡队列路径
QUEUE_PATH="/sys/class/net/$MAIN_IFACE/queues"
if [ ! -d "$QUEUE_PATH" ]; then
  echo "❌ 找不到队列目录：$QUEUE_PATH"
  exit 1
fi

shopt -s nullglob

# 处理RX队列（RPS）
for RXQ in "$QUEUE_PATH"/rx-*; do
  RPS_FILE="$RXQ/rps_cpus"
  if [ -f "$RPS_FILE" ]; then
    if grep -q "$CPU_MASK" "$RPS_FILE" 2>/dev/null; then
      echo "  ✅ $RPS_FILE 已经是优化值 ($CPU_MASK)"
    elif echo "$CPU_MASK" > "$RPS_FILE" 2>/dev/null; then
      echo "  ✅ 设置 $RPS_FILE = $CPU_MASK"
    else
      echo "  ⚠️ 无法写入 $RPS_FILE (可能是内核限制)"
    fi
  fi
done

# 处理TX队列（XPS）
for TXQ in "$QUEUE_PATH"/tx-*; do
  XPS_FILE="$TXQ/xps_cpus"
  if [ -f "$XPS_FILE" ]; then
    if grep -q "$CPU_MASK" "$XPS_FILE" 2>/dev/null; then
      echo "  ✅ $XPS_FILE 已经是优化值 ($CPU_MASK)"
    elif echo "$CPU_MASK" > "$XPS_FILE" 2>/dev/null; then
      echo "  ✅ 设置 $XPS_FILE = $CPU_MASK"
    else
      echo "  ⚠️ 无法写入 $XPS_FILE (可能不支持XPS)"
    fi
  fi
done

shopt -u nullglob

# 优化中断绑定
echo "🔄 优化中断绑定..."
while read -r irq; do
  [ -z "$irq" ] && continue
  IRQ_NUM=${irq%%:*}
  IRQ_PATH="/proc/irq/$IRQ_NUM"
  AFFINITY_FILE="$IRQ_PATH/smp_affinity"
  
  if [ -f "$AFFINITY_FILE" ]; then
    CURRENT_AFFINITY=$(cat "$AFFINITY_FILE")
    if [ "$CURRENT_AFFINITY" != "$CPU_MASK" ]; then
      if echo "$CPU_MASK" > "$AFFINITY_FILE" 2>/dev/null; then
        echo "  ✅ 设置 IRQ $IRQ_NUM affinity = $CPU_MASK"
      else
        echo "  ⚠️ 无法设置 IRQ $IRQ_NUM affinity (可能是硬件限制)"
      fi
    else
      echo "  ✅ IRQ $IRQ_NUM 已经是优化值 ($CPU_MASK)"
    fi
  fi
done < <(grep "$MAIN_IFACE" /proc/interrupts)

# ethtool优化（忽略不支持的功能）
echo "⚙️ 应用ethtool优化..."
ETOOL_OPTS=(
  "gro off" "gso off" "tso off" "ufo off" 
  "rx off" "tx off" "sg off" "lro off"
)

for opt in "${ETOOL_OPTS[@]}"; do
  if ethtool -K "$MAIN_IFACE" $opt 2>/dev/null; then
    echo "  ✅ 设置 $opt"
  else
    echo "  ⚠️ 不支持 $opt (忽略)"
  fi
done

# 禁用WOL（唤醒局域网）
ethtool -s "$MAIN_IFACE" wol d 2>/dev/null && echo "  ✅ 禁用 WOL"

echo "✅ $MAIN_IFACE 优化完成"

# 显示摘要
echo
echo "📊 优化摘要："
echo "----------------------------------------"
echo "🔹 网卡: $MAIN_IFACE"
echo "🔹 CPU掩码: $CPU_MASK (${NUM_CPUS}核)"
echo "🔹 RPS设置: $(cat "$QUEUE_PATH/rx-0/rps_cpus" 2>/dev/null || echo "N/A")"
echo "🔹 中断分布:"
grep "$MAIN_IFACE" /proc/interrupts | while read -r line; do
  echo "   - $line"
done || echo "   ❌ 无中断信息"
echo "----------------------------------------"
