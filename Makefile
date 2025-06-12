

run:  
	docker run --rm -p 3838:3838 shiny119labs

build:
	docker build -t shiny119labs  .

shell:
	docker run --rm  -w /srv/shiny-server/ -it shiny119labs /bin/bash
