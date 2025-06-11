

run:  
	docker run --rm -p 3838:3838 shiny119labs

build:
	docker build -t shiny119labs  .

shell:
	docker run --rm -it shiny119labs -w /srv/shiny-server/  /bin/bash
