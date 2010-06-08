
# ensure iptables.up.rules

# ensure /etc/network/if-pre-up.d/iptables
BRING_UP_IPTABLES = <<-END
!/bin/sh
/sbin/iptables-restore < /etc/iptables.up.rules
END

# apply iptables-restore < /etc/iptables.up.rules 
