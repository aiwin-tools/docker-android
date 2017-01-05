docker-android
================

[Docker](https://www.docker.com/) image of [Android SDK](https://developer.android.com) with necessary tools for build our projects

Usage
--------------

    docker run -it --rm --name my-android-project -v "$PWD":/usr/src/myandroid -w /usr/src/myandroid aiwin/android-base:latest ./gradlew assembleDebug


Build
--------------

Run `build.sh` script to build and push the image to default location

    aiwin/android-base:latest

If you want to build and push the image to diferent location, define the following
variables before the execution of the script:

- REPOSITORY. Docker repository
- REGISTRY. Docker registry
- TAG. Tag or version

By default, `ANDROID_TARGET_SDK`, `ANDROID_BUILD_TOOLS`, `ANDROID_SDK_TOOLS` values are
taken from `Dockerfile`. If you want to build the image with another version of
these dependencies, define one or more of the following variables before the
execution of the script:

- ANDROID_TARGET_SDK. An integer designating the API Level that the application targets
- ANDROID_BUILD_TOOLS. Build Tools is a component of the Android SDK required for building Android application code
- ANDROID_SDK_TOOLS. It includes the complete set of development and debugging tools for the Android SDK
