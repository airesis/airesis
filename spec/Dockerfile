FROM airesis_airesis

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
    libqt5webkit5-dev \
    qt5-default \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ["bundle", "install", "--with=test","-j4"]