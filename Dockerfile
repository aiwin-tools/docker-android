FROM aiwin/gradle-base

LABEL maintainer="javier.boo@aiwin.es"

ENV ANDROID_TARGET_SDK="28" \
    ANDROID_BUILD_TOOLS="28.0.3" \
    ANDROID_SDK_TOOLS="4333796" 

RUN apt-get --quiet update --yes && \
    apt-get --quiet install --yes --no-install-recommends wget tar unzip lib32stdc++6 lib32z1 libqt5widgets5 libqt5svg5 file build-essential && \
    apt-get --quiet clean --yes && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - && \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import - && \
    curl -sSL https://get.rvm.io | bash -s stable --ruby && \
    /bin/bash -l -c "gem install fastlane -NV"

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip && \
    unzip android-sdk.zip -d android-sdk-linux && \
    rm -v android-sdk.zip

ENV ANDROID_SDK_HOME $PWD/android-sdk-linux
ENV ANDROID_HOME $ANDROID_SDK_HOME

RUN $ANDROID_SDK_HOME/tools/bin/sdkmanager "platforms;android-${ANDROID_TARGET_SDK}" && \
    $ANDROID_SDK_HOME/tools/bin/sdkmanager "platform-tools" && \
    $ANDROID_SDK_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" && \
    yes | $ANDROID_SDK_HOME/tools/bin/sdkmanager --licenses && \
    $ANDROID_SDK_HOME/tools/bin/sdkmanager --update

RUN $ANDROID_SDK_HOME/tools/bin/sdkmanager "extras;android;m2repository" && \
    $ANDROID_SDK_HOME/tools/bin/sdkmanager "extras;google;google_play_services" && \
    $ANDROID_SDK_HOME/tools/bin/sdkmanager "extras;google;m2repository" && \
    yes | $ANDROID_SDK_HOME/tools/bin/sdkmanager --licenses && \
    $ANDROID_SDK_HOME/tools/bin/sdkmanager --update

RUN mkdir -p $ANDROID_SDK_HOME/platforms

ENV PATH ${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools:$PATH

COPY jacoco.gradle $GRADLE_HOME
