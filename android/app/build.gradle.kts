plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.fantasyforest.fantasy_forest_wiki_text"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.fantasyforest.fantasy_forest_wiki_text"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    tasks.register("renameApk") {
        doLast {
            val oldFile = file("build/app/outputs/flutter-apk/app-release.apk")
            val newFile = file("build/app/outputs/flutter-apk/FantasyForestsGuidanceDemo_v${defaultConfig.versionName}.apk")
            if (oldFile.exists()) {
                oldFile.renameTo(newFile)
            }
        }
    }

    afterEvaluate {
        tasks.named("assembleRelease") {
            finalizedBy("renameApk")
        }
    }
}

flutter {
    source = "../.."
}
