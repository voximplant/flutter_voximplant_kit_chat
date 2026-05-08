/*
 * Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.
 */

plugins {
    id("com.android.library")
    id("kotlin-android")
}

android {
    namespace = "com.voximplant.voximplant_kit_chat"

    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        minSdk = 21
    }
}

dependencies {
    implementation("com.voximplant:android-kit-chat-core:1.3.0")
    implementation("com.voximplant:android-kit-chat-ui:1.3.1")
}
