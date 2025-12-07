plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")    // важно
}

android {
    namespace = "com.example.recipes_app" // смени ако твојот package е поинаков
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.recipes_app" // смени ако твојот package е поинаков
        minSdk = maxOf(21, flutter.minSdkVersion) // Firebase бара најмалку 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Add your release signing config кога ќе имаш keystore
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
        debug {
            // остави default
        }
    }
}

flutter {
    source = "../.."
}

// Дополнителни зависности на ниво на module ако ти требаат нативно
// За FlutterFire обично НЕ е потребно да додаваш тука, плагините ги носат зависностите.
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.6.0"))
    // пример нативен analytics SDK
    // implementation("com.google.firebase:firebase-analytics")
}
