


    dpkg --purge ttf-mscorefonts-installer

    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
    apt-get install -y ttf-mscorefonts-installer


