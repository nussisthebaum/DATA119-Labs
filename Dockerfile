# Use the rocker/shiny-verse image with R 4.4.1.  This is a shiny server
FROM rocker/shiny-verse:4.4.1

# Install system dependencies needed for R packages (refer to your manifest.json for hints)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3.10-venv \
    python3-pip \
    libpython3.10-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages using pip
# You'll need to create a requirements.txt file with your Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
    # Install any additional Python packages if not in requirements.txt
    # pip install --no-cache-dir some_other_python_package
    && rm /tmp/requirements.txt

# Create an R Renviron file to tell reticulate where Python is
# This helps reticulate find the Python 3.9 installed earlier
RUN echo "RETICULATE_PYTHON=/usr/bin/python3" >> /usr/local/lib/R/etc/Renviron

# Install the 'remotes' package first
RUN R -e "install.packages(\"remotes\", repos='https://cran.rstudio.com/', lib = \"/usr/local/lib/R/site-library\", Ncpus=as.integer(Sys.getenv('NCPUS')))"

# Now, install gradethis and learnr from GitHub, preventing interactive prompts
# These are the two packages that (June 2025) can't be installed from CRAN
RUN R -e 'remotes::install_github("rstudio/learnr", upgrade = "never", lib = "/usr/local/lib/R/site-library")' && \
    R -e 'remotes::install_github("rstudio/gradethis", upgrade = "never", lib = "/usr/local/lib/R/site-library")'

# Install R packages from your manifest.json
RUN R -e 'install.packages(c("Matrix", "R6", "Rcpp", "RcppTOML", \
    "backports", "base64enc", "bslib", "cachem", "checkmate", \
    "cli", "commonmark", "crayon", "diffobj", "digest", \
    "rmarkdown", "shiny", "reticulate", \
    "DBI", "KernSmooth", "MASS", "Matrix", "R6", "RColorBrewer", "ROCR", "RSQLite", "Rcpp", "RcppTOML", "askpass", "assertthat", "backports", "base64enc", "bit", "bit64", "bitops", "blob", "broom", "bslib", "caTools", "cachem", "callr", "cellranger", "checkmate", "cli", "clipr", "colorspace", "commonmark", "conflicted", "cpp11", "crayon", "curl", "cvAUC", "data.table", "dbplyr", "diffobj", "digest", "dplyr", "dtplyr", "ellipsis", "evaluate", "fansi", "farver", "fastmap", "fontawesome", "forcats", "fs", "gargle", "generics", "ggdendro", "ggplot2", "ggrepel", "glue", "googledrive", "googlesheets4", "gplots", "gtable", "gtools", "haven", "here", "highr", "hms", "htmltools", "htmlwidgets", "httpuv", "httr", "ids", "isoband", "jquerylib", "jsonlite", "kableExtra", "knitr", "labeling", "later", "latex2exp", "lattice", "learnr", "lifecycle", "litedown", "lubridate", "magrittr", "markdown", "memoise", "mgcv", "mime", "modelr", "munsell", "nlme", "openssl", "pillar", "pkgconfig", "plogr", "plyr", "png", "prettyunits", "processx", "progress", "promises", "ps", "purrr", "ragg", "rappdirs", "readr", "readxl", "rematch", "rematch2", "renv", "reprex", "reshape2", "reticulate", "rlang", "rmarkdown", "rprojroot", "rstudioapi", "rvest", "sass", "scales", "selectr", "shiny", "sortable", "sourcetools", "stringi", "stringr", "svglite", "sys", "systemfonts", "textshaping", "tibble", "tidyr", "tidyselect", "tidyverse", "timechange", "tinytex", "tzdb", "utf8", "uuid", "vctrs", "viridisLite", "vroom", "waldo", "withr", "xfun", "xml2", "xtable", "yaml"), \
    lib = "/usr/local/lib/R/site-library", \
    repos="https://cran.rstudio.com/")'

# Remove the rocker default index.html, which is a "Welcome to Shiny" page
RUN rm -f /srv/shiny-server/index.html

# Copy your Shiny app files into the container

RUN mkdir -p /srv/shiny-server/
COPY . /srv/shiny-server/

# Set ownership and permissions for the shiny user
RUN chown -R shiny:shiny /srv/shiny-server/ && \
    chmod -R 755 /srv/shiny-server/

# Help reticulate find ptyhon
ENV LD_LIBRARY_PATH="/usr/lib/python3.10/config-3.10-x86_64-linux-gnu/"

# Expose Shiny Server's default port
EXPOSE 3838

# Start the Shiny Server 
CMD ["/usr/bin/shiny-server"]
