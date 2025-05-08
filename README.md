# Real Estate App - Flutter
## Environment Setup (macOS / Apple Silicon)

This project is built with Flutter 2.10.5 and targets Android API 30–33. Please follow the steps below to set up your environment correctly.

1. Flutter SDK
Install Flutter 2.10.5:
`curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_2.10.5-stable.zip`
`unzip flutter_macos_2.10.5-stable.zip`

Add it to your PATH:
`export PATH="$PATH:/Users/your_name/flutter/bin"`

Confirm:
`flutter --version`
The output should be like: Flutter 2.10.5 • Dart 2.16.x

2. Java Development Kit (JDK)
- Required: Java 11 & Java 17
- Set environment:

Example:
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export PATH="$JAVA_HOME/bin:$PATH"

Confirm:
java -version
You need to configure to ensure you can change between jdk 11 and jdk 17. 
Some configuration in the following steps need jdk 17. 
But the project needed jdk 11 to be run, because this project was built years ago and used Flutter 2.x. 
Flutter 2.x + Gradle plugin 7.0.2 only support JDK 8 ~ 11.

3. Android SDK (via Android Studio)
Automated selected

4. Gradle Configuration

Open android/gradle/wrapper/gradle-wrapper.properties and ensure:

distributionUrl=https\://services.gradle.org/distributions/gradle-7.0.2-all.zip

Open android/build.gradle and ensure:

classpath 'com.android.tools.build:gradle:7.0.2'


5. AndroidManifest Fix (for API 31+)

In android/app/src/main/AndroidManifest.xml, make sure your <activity> includes:

android:exported="true"


6. Final Steps

flutter clean
flutter pub get
flutter run


This setup ensures compatibility with older Flutter versions and newer Android targets.
For API integrations and feature development, continue working inside the lib/ and android/ folders.


## Env for APIs
Flutter:
Flutter 2.10 + flutter_stripe: 2.2.0 + Java 11


## Resources
- Preview video: https://youtu.be/11u0KeymAAs
- Support my work: https://www.patreon.com/sangvaleap
  
- [My Twitter](https://twitter.com/sangvaleap)
- [My Patreon](https://www.patreon.com/sangvaleap)
- [My Linkedin](https://www.linkedin.com/in/sangvaleap-vanny-353b25aa/)


<img width="600" alt="Screen Shot 2022-01-05 at 6 43 05 PM" src="https://user-images.githubusercontent.com/86506519/148213269-45f3ba01-d059-43f2-85c4-1d31543f06f5.png">
<img width="600" alt="Screen Shot 2022-01-05 at 6 43 24 PM" src="https://user-images.githubusercontent.com/86506519/148213286-e2f3c5f4-581f-4011-afb5-4e702f5724d7.png">
<img width="600" alt="Screen Shot 2022-01-05 at 6 43 45 PM" src="https://user-images.githubusercontent.com/86506519/148213292-078c3fe6-ad7d-4e04-adfe-23b1656dfa14.png">
<img width="599" alt="Screen Shot 2022-01-05 at 6 44 48 PM" src="https://user-images.githubusercontent.com/86506519/148213300-b765d20b-7bb2-49ea-b290-b923f660e9c7.png">
<img width="600" alt="Screen Shot 2022-01-05 at 6 45 16 PM" src="https://user-images.githubusercontent.com/86506519/148213303-7f83c8b7-7736-4e3e-91c7-377b93fd79c5.png">
<img width="601" alt="Screen Shot 2022-01-05 at 6 44 06 PM" src="https://user-images.githubusercontent.com/86506519/148213295-77f7f1cf-bfd0-49c2-a7a1-65e204964c20.png">
<img width="600" alt="Screen Shot 2022-01-05 at 6 44 22 PM" src="https://user-images.githubusercontent.com/86506519/148213298-090fc88d-7e10-4ee0-ae1b-87e06bcf7f35.png">
