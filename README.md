# Electricity Counter

The application allows you to proportionally divide the payments for the electricity taken according to the invoice and the actual electricity consumption. (Division into high tariff, low tariff and fixed part).

## Restriction
Application is designed for windows only.


## Getting Started


firebase_options.dart file should be created in the lib folder with the following content:
```dart
const apiKey = '...';
const appId = '...';
const messagingSenderId = '...';
const projectId = '...';

flutter pub run build_runner build --delete-conflicting-outputs
