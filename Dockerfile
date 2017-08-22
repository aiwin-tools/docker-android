FROM aiwin/gradle-base

LABEL maintainer="javier.boo@aiwin.es"

ENV ANDROID_TARGET_SDK="25" \
    ANDROID_BUILD_TOOLS="26.0.1" \
    ANDROID_SDK_TOOLS="3859397"

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes --no-install-recommends wget tar unzip lib32stdc++6 lib32z1 libqt5widgets5 libqt5svg5 file && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip && \
    unzip android-sdk.zip -d android-sdk-linux && \
    rm -v android-sdk.zip

ENV ANDROID_SDK_HOME $PWD/android-sdk-linux

RUN android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_TARGET_SDK}" && \
    android-sdk-linux/tools/bin/sdkmanager "platform-tools" && \
    android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" && \
    yes | android-sdk-linux/tools/bin/sdkmanager --licenses && \
    android-sdk-linux/tools/bin/sdkmanager --update

RUN android-sdk-linux/tools/bin/sdkmanager "extras;android;m2repository" && \
    android-sdk-linux/tools/bin/sdkmanager "extras;google;google_play_services" && \
    android-sdk-linux/tools/bin/sdkmanager "extras;google;m2repository" && \
    yes | android-sdk-linux/tools/bin/sdkmanager --licenses && \
    android-sdk-linux/tools/bin/sdkmanager --update

#RUN android-sdk-linux/tools/bin/sdkmanager "system-images;android-${ANDROID_TARGET_SDK};google_apis;x86" && \
#    yes | android-sdk-linux/tools/bin/sdkmanager --licenses && \
#    android-sdk-linux/tools/bin/sdkmanager --update && \
#    echo no | android-sdk-linux/tools/bin/avdmanager create avd -f -n test-x86 -k "system-images;android-${ANDROID_TARGET_SDK};google_apis;x86" --abi google_apis/x86

RUN android-sdk-linux/tools/bin/sdkmanager "system-images;android-${ANDROID_TARGET_SDK};google_apis;armeabi-v7a" && \
    yes | android-sdk-linux/tools/bin/sdkmanager --licenses && \
    android-sdk-linux/tools/bin/sdkmanager --update && \
    echo no | android-sdk-linux/tools/bin/avdmanager create avd -f -n test-arm -k "system-images;android-${ANDROID_TARGET_SDK};google_apis;armeabi-v7a" --abi google_apis/armeabi-v7a

# https://stackoverflow.com/a/44386974
RUN mkdir -p $ANDROID_SDK_HOME/platforms && \
    mkdir -p $HOME/scripts/android && \
    wget --quiet --output-document=$HOME/scripts/android/android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator && \
    chmod +x $HOME/scripts/android/android-wait-for-emulator

ENV SHELL /bin/bash
ENV PATH ${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools:$PATH
