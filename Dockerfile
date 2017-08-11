FROM aiwin/gradle-base

LABEL maintainer="javier.boo@aiwin.es"

ENV ANDROID_TARGET_SDK="25" \
    ANDROID_BUILD_TOOLS="25.0.1" \
    ANDROID_SDK_TOOLS="25.2.3"

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes --no-install-recommends wget tar unzip lib32stdc++6 lib32z1 libqt5widgets5 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/tools_r${ANDROID_SDK_TOOLS}-linux.zip && \
    unzip android-sdk.zip -d android-sdk-linux && \
    rm -v android-sdk.zip

RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter android-${ANDROID_TARGET_SDK} && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter platform-tools && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS}

RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository

RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter sys-img-x86-google_apis-${ANDROID_TARGET_SDK} && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter sys-img-armeabi-v7a-google_apis-${ANDROID_TARGET_SDK} && \
    echo no | android-sdk-linux/tools/android create avd -n test-x86 -t android-${ANDROID_TARGET_SDK} --abi google_apis/x86 && \
    echo no | android-sdk-linux/tools/android create avd -n test-arm -t android-${ANDROID_TARGET_SDK} --abi google_apis/armeabi-v7a

RUN mkdir -p $HOME/scripts/android && \
    wget --quiet --output-document=$HOME/scripts/android/android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator && \
    chmod +x $HOME/scripts/android/android-wait-for-emulator

ENV ANDROID_HOME $PWD/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$HOME/scripts/android:$PATH
