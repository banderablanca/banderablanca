# Bandera Blanca - es tiempo de ayudarnos.

Es un proyecto sin fines de lucro.

## Getting Started

```
flutter pub run build_runner watch --delete-conflicting-outputs
```
Create file `.env`
```
GOOGLE_MAPS_WEB_API_KEY=YOUR_API_KEY
```
Config `.vscode/launch.json`
```json
    "configurations": [
        {
            "name": "BB Dev",
            "request": "launch",
            "type": "dart",
            "args": [
                "--flavor",
                "dev"
            ],
            "env": {
                "MAPS_API_KEY": "YOUR_API_KEY",
                "GOOGLE_MAPS_WEB_API_KEY": "YOUR_API_KEY"
            },
        },
        ...
    ]
```


This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
