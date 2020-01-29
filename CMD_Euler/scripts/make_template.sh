make_template() (
	local PROBLEM_NUMBER
	local LANGUAGE

	validate_args() {
		curl --head 'https://learnxinyminutes.com/docs/${LANGUAGE}/' 2>/dev/null | grep -q '404 Not Found' && return 1
	}

	generate_template() {
		COMMENT_CHAR=$(curl https://learnxinyminutes.com/docs/${LANGUAGE}/ 2>/dev/null | grep -m 1 'omment' | sed -e 's/<[^>]*>//g; s/^[ \t]*//' | sed 's/ .*//' | tr -d A-Z | tr -d a-z)
	}

	main() {
		LANGUAGE="${1,,}"
		PROBLEM_NUMBER="$2"
		validate_args ${LANGUAGE}
		generate_template
	}

	main $@
)

make_template $@
