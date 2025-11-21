plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.cleanArchitecture"
    compileSdk = flutter.compileSdkVersion
     ndkVersion = "28.2.13676358"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.cleanArchitecture"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "pl.leancode.patrol.PatrolJUnitRunner"
        testInstrumentationRunnerArguments["clearPackageData"] = "true"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    flavorDimensions += "default"

    productFlavors {
        create("production") {
            dimension = "default"
            resValue("string", "app_name", "CleanArchitecture")
        }
        create("staging") {
            dimension = "default"
            applicationIdSuffix = ".stg"
            versionNameSuffix = ".stg"
            resValue("string", "app_name", "CleanArchitecture.STG")
        }
        create("development") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            versionNameSuffix = ".dev"
            resValue("string", "app_name", "CleanArchitecture.DEV")
        }
    }

    testOptions {
        execution = "ANDROIDX_TEST_ORCHESTRATOR"
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    androidTestUtil("androidx.test:orchestrator:1.5.1")
}
