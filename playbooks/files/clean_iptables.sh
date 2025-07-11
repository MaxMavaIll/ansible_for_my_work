for chain in $(iptables -L | grep '^Chain' | awk '{print $2}'); do
    iptables -X $chain 2>/dev/null || echo "Не вдалося видалити $chain"
done