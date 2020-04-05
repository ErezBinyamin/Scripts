# Command line utility that uses curl to
# Retrieve the n'th Project euler problem

# @param  <Int>     Problem number
# @return <String>  Text content of n'th project Euler problem
main_get_euler()(
	get_euler() {
		local BASE_URL="https://projecteuler.net/problem="
		local TMP=/tmp/euler.html
		local ERRVAL=0

		printf "\n\nFROM URL: ${BASE_URL}$1"
		printf "\n__________________________________________________________\n"
		curl -s "${BASE_URL}${1}" | grep -A 999 '<div class="problem_content" role="problem">' | sed -n '/<div id="footer" class="noprint">/q;p' | sed 's/<[^>]*>//g'
		ERRVAL=$?
		printf "\n__________________________________________________________\n\n"
		return $ERRVAL
	}

	[ -z $1 ] && echo "USAGE: get_euler <Problem number>" && return 1
	dpkg -s curl &> /dev/null || printf "\nYou must install curl:\nsudo apt-get install curl\n"
	dpkg -s curl &> /dev/null || return 1
	get_euler $1
	return $?
)

nc -w 3 -z 8.8.8.8 53 && main_get_euler $1 || echo "ERROR No Network connection!"
