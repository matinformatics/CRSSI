# Install R version 4.5.0
FROM r-base:4.5.0

# Install Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev \
    libxml2-dev \
    libnlopt-dev \
    libudunits2-dev \
    libgeos-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libgdal-dev \
    git \
    libpython3-dev \
    python3-dev \
    python3-pip     
    
# Install Shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt) && \
    wget "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb
    
    
##### Install required python packages #####

### RUN pip install numpy chaospy pandas dill rpy2 multiprocess --break-system-packages    
    
##### Install R packages that are required ######
## CRAN packages
RUN R -e "install.packages(c('rsconnect', 'shiny', 'shinyjs', 'ggplot2', 'matrixStats', 'e1071', 'boot', 'leaps', 'randomForest', 'shinyjs', 'DT', 'class', 'caret', 'plotly', 'd3r', 'matrixStats', 'shinythemes', 'reshape2', 'truncnorm', 'stringr', 'dplyr', 'zoo', 'shinycssloaders', 'shinydashboard', 'purrr', 'readr', 'data.table'))"

ARG ACCESS_TOKEN
RUN git clone https://$ACCESS_TOKEN@github.com/prasven/CRSSI.git

# Get the app code and copy configuration files into the Docker image
### RUN git clone https://github.com/prasven/CRSSI.git
RUN cp CRSSI/shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN cp CRSSI/shiny-server.sh /usr/bin/shiny-server.sh
RUN rm -rf /srv/shiny-server/*
RUN rm CRSSI/shiny-server.*

RUN cp -r CRSSI/* /srv/shiny-server/
RUN rm -rf CRSSI

# Make the ShinyApp available at port 80
ENV R_HOME=/usr/lib/R
ENV PATH=/usr/lib/R:/usr/lib/R/bin:$PATH
EXPOSE 80
WORKDIR /srv/shiny-server
RUN chown shiny.shiny /usr/bin/shiny-server.sh && chmod 755 /usr/bin/shiny-server.sh

# Run the server setup script
CMD ["/usr/bin/shiny-server.sh"]
