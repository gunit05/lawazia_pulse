# Fix Jackson missing classes
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.jackson.**

# Fix OpenTelemetry
-keep class io.opentelemetry.** { *; }
-dontwarn io.opentelemetry.**

# Fix Google AutoValue
-keep class com.google.auto.value.** { *; }
-dontwarn com.google.auto.value.**

# Keep annotations
-keepattributes *Annotation*