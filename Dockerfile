FROM python:3-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dumb-init \
    git \
    libstdc++6 \
    libgcc1 \
    libz1 \
    zlib1g \
    libncurses5 \
    libffi-dev \
    libssl-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
    openjdk-8-jdk-headless \
    virtualenv \
    wget \
    unzip \
    fdroidserver \
    zlib1g-dev \
    aapt \
    android-libaapt \
    android-libbase \
    android-libutils \
    android-libandroidfw \
    android-sdk \
    android-sdk-common \
    android-sdk-build-tools \
    android-sdk-build-tools-common \
    android-platform-tools-base \
    android-sdk-platform-tools \
    android-sdk-platform-tools-common \
    dalvik-exchange \
    zipalign \
    split-select \
    aidl \
    dexdump \
    dalvik-exchange \
    proguard-cli \
    android-libdex \
    maven \
    gradle \
    adb \
    libandroid-dex-java \
    libgradle-android-plugin-java \
    apktool \
    apksigner \
    signapk && \
    rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME=/usr/lib/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

RUN mkdir -p /data/fdroid/repo && \
    mkdir -p /opt/playmaker

COPY README.md setup.py pm-server /opt/playmaker/
COPY playmaker /opt/playmaker/playmaker

WORKDIR /opt/playmaker
RUN pip3 install . && \
    cd /opt && rm -rf playmaker

RUN groupadd -g 999 pmuser && \
    useradd -m -u 999 -g pmuser pmuser
RUN chown -R pmuser:pmuser /data/fdroid && \
    chown -R pmuser:pmuser /opt/playmaker
USER pmuser

VOLUME /data/fdroid
WORKDIR /data/fdroid

EXPOSE 5000

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/python3", "-u", "/usr/local/bin/pm-server", "--fdroid", "--debug"]
