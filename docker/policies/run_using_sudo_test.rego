package appshield.DS010

test_basic_denied {
	r := deny with input as {"stages": {"alpine:3.5": [
		{
			"Cmd": "from",
			"Value": ["alpine:3.5"],
		},
		{
			"Cmd": "run",
			"Value": ["apk add --update py2-pip"],
		},
		{
			"Cmd": "run",
			"Value": ["sudo pip install --upgrade pip"],
		},
		{
			"Cmd": "cmd",
			"Value": [
				"python",
				"/usr/src/app/app.py",
			],
		},
	]}}

	count(r) == 1
	r[_] == "Shouldn't use sudo in Dockerfile"
}

test_chaining_denied {
	r := deny with input as {"stages": {"alpine:3.5": [
		{
			"Cmd": "from",
			"Value": ["alpine:3.5"],
		},
		{
			"Cmd": "run",
			"Value": ["RUN apk add bash && sudo pip install --upgrade pip"],
		},
	]}}

	count(r) == 1
	r[_] == "Shouldn't use sudo in Dockerfile"
}

test_multi_vuls_denied {
	r := deny with input as {"stages": {"alpine:3.5": [
		{
			"Cmd": "from",
			"Value": ["alpine:3.5"],
		},
		{
			"Cmd": "run",
			"Value": ["RUN sudo pip install --upgrade pip"],
		},
		{
			"Cmd": "run",
			"Value": ["RUN apk add bash && sudo pip install --upgrade pip"],
		},
	]}}

	count(r) == 1
	r[_] == "Shouldn't use sudo in Dockerfile"
}

test_basic_allowed {
	r := deny with input as {"stages": {"alpine:3.3": [
		{
			"Cmd": "from",
			"Value": ["alpine:3.5"],
		},
		{
			"Cmd": "run",
			"Value": ["apk add --update py2-pip"],
		},
		{
			"Cmd": "run",
			"Value": ["apt-get install sudo"],
		},
		{
			"Cmd": "cmd",
			"Value": ["python", "/usr/src/app/app.py"],
		},
	]}}

	count(r) == 0
}
