FROM rocker/r-ver:4.5.0

# Install Ubuntu packages needed to build and run common R packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo gdebi-core pandoc git \
    libcurl4-openssl-dev libssl-dev libxml2-dev \
    libcairo2-dev libxt-dev libnlopt-dev libudunits2-dev \
    libgeos-dev libgdal-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    libpython3-dev python3-dev python3-pip \
    automake autoconf libtool make pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install all needed R packages
RUN R -e "install.packages(c('rsconnect', 'shiny', 'shinyjs', 'ggplot2', 'matrixStats', 'e1071', 'boot', \
    'leaps', 'randomForest', 'shinyjs', 'DT', 'class', 'caret', 'plotly', 'shinythemes', 'reshape2', \
    'truncnorm', 'stringr', 'dplyr', 'zoo', 'shinycssloaders', 'shinydashboard', 'data.table', 'xgboost', \
    'mlbench', 'broom', 'shinyWidgets', 'shinyalert'))"

# Copy configuration and app (adjust paths as needed)
#COPY CRSSI/CRSSI/shiny-server.conf /etc/shiny-server/shiny-server.conf
#COPY CRSSI/CRSSI/shiny-server.sh   /usr/bin/shiny-server.sh
COPY CRSSI/CRSSI/ui.R        /srv/shiny-server/
COPY CRSSI/CRSSI/server.R        /srv/shiny-server/

# Environment variables
ENV R_HOME=/usr/lib/R
ENV PATH=/usr/lib/R:/usr/lib/R/bin:$PATH

# Permissions
#RUN chmod 755 /usr/bin/shiny-server.sh

# Expose port
EXPOSE 3838

# Run the app directly with shiny (no shiny-server needed for a single app)
#CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=3838)"]
#CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=3838, launch.browser=FALSE, options=list(shiny.http2=FALSE))"]
CMD ["R", "-e", "options(shiny.http2=FALSE, shiny.launch.browser=FALSE); shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=3838)"]

