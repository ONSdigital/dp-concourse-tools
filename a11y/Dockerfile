FROM node:15.0.1

LABEL maintainer="daniel.walford@ons.gov.uk"

# Explicitly declare npm user is root (docker runs as root anyway) allows global package installation for npm, needed for @axe-core/cli
RUN npm --global config set user root

# Update apt then install wget to set up the Personal Package Archive (PPA) and unzip to install the Chromedriver
RUN apt update \
    && apt install -y wget unzip

# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Update the package list and install chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt update \
    && apt install -y google-chrome-stable

# Set up Chromedriver environment variable and create directory for it
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR -p

# Get the correct version of chromedriver 
# Not an ENV as this var is only exposed to this process not to the docker image
ARG CHROME_DRIVER_VERSION
RUN if [ -z "$CHROME_DRIVER_VERSION" ]; \
  then CHROME_MAJOR_VERSION=$(google-chrome --version | sed -E "s/.* ([0-9]+)(\.[0-9]+){3}.*/\1/") \
    && CHROME_DRIVER_VERSION=$(wget --no-verbose -O - "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_MAJOR_VERSION}"); \
  fi \
  && echo "Using chromedriver version: "$CHROME_DRIVER_VERSION \
  && wget --no-verbose -P $CHROMEDRIVER_DIR "https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip"

# Download and install correct Chromedriver for this version of chrome running
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

# Put Chromedriver into the PATH so it can be found by selenium (used in axe)
ENV PATH $CHROMEDRIVER_DIR:$PATH

# Finally we can get axe package
RUN npm install -g @axe-core/cli
