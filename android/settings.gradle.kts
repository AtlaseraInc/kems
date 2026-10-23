// Fix for AGP AndroidLocationsException when both ANDROID_PREFS_ROOT and ANDROID_USER_HOME are present in environment
try {
    val processEnv = Class.forName("java.lang.ProcessEnvironment")
    val field = processEnv.getDeclaredField("theEnvironment")
    field.isAccessible = true
    @Suppress("UNCHECKED_CAST")
    val map = field.get(null) as? MutableMap<Any, Any>
    map?.keys?.removeIf { key -> key.toString() == "ANDROID_PREFS_ROOT" }

    val caseInsensitiveField = processEnv.getDeclaredField("theCaseInsensitiveEnvironment")
    caseInsensitiveField.isAccessible = true
    @Suppress("UNCHECKED_CAST")
    val caseMap = caseInsensitiveField.get(null) as? MutableMap<Any, Any>
    caseMap?.keys?.removeIf { key -> key.toString() == "ANDROID_PREFS_ROOT" }
} catch (_: Exception) {
}

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    //noinspection AndroidGradlePluginVersion
    id("com.android.application") version "8.11.1" apply false
    //noinspection NewerVersionAvailable
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

include(":app")
