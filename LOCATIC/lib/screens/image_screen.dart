import 'dart:io';
import 'package:flutter/material.dart';
import  'image_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> with WidgetsBindingObserver {
  late final ImageModel _model;
  bool _detectPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    _model = ImageModel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  // This block of code is used in the event that the user
  // has denied the permission forever. Detects if the permission
  // has been granted when the user returns from the
  // permission system screen.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _detectPermission &&
        (_model.imageSection == ImageSection.noStoragePermissionPermanent)) {
      _detectPermission = false;
      _model.requestFilePermission();
    } else if (state == AppLifecycleState.paused &&
        _model.imageSection == ImageSection.noStoragePermissionPermanent) {
      _detectPermission = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<ImageModel>(
        builder: (context, model, child) {
          Widget widget;

          switch (model.imageSection) {
            case ImageSection.noStoragePermission:
              widget = ImagePermissions(
                  isPermanent: false, onPressed: _checkPermissionsAndPick);
              break;
            case ImageSection.noStoragePermissionPermanent:
              widget = ImagePermissions(
                  isPermanent: true, onPressed: _checkPermissionsAndPick);
              break;
            case ImageSection.browseFiles:
              widget = PickFile(onPressed: _checkPermissionsAndPick);
              break;
            case ImageSection.imageLoaded:
              widget = ImageLoaded(file: _model.file!);
              break;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Handle permissions'),
            ),
            body: widget,
          );
        },
      ),
    );
  }

  /// Check if the pick file permission is granted,
  /// if it's not granted then request it.
  /// If it's granted then invoke the file picker
  Future<void> _checkPermissionsAndPick() async {
    final hasFilePermission = await _model.requestFilePermission();
    if (hasFilePermission) {
      try {
        await _model.pickFile();
      } on Exception catch (e) {
        debugPrint('Error when picking a file: $e');
        // Show an error to the user if the pick file failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred when picking a file'),
          ),
        );
      }
    }
  }
}

/// This widget will serve to inform the user in
/// case the permission has been denied. There is a
/// variable [isPermanent] to indicate whether the
/// permission has been denied forever or not.
class ImagePermissions extends StatelessWidget {
  final bool isPermanent;
  final VoidCallback onPressed;

  const ImagePermissions({
    Key? key,
    required this.isPermanent,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              right: 16.0,
            ),
            child: Text(
              'Read files permission',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              right: 16.0,
            ),
            child: const Text(
              'We need to request your permission to read '
                  'local files in order to load it in the app.',
              textAlign: TextAlign.center,
            ),
          ),
          if (isPermanent)
            Container(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 24.0,
                right: 16.0,
              ),
              child: const Text(
                'You need to give this permission from the system settings.',
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            padding: const EdgeInsets.only(
                left: 16.0, top: 24.0, right: 16.0, bottom: 24.0),
            child: ElevatedButton(
              child: Text(isPermanent ? 'Open settings' : 'Allow access'),
              onPressed: () => isPermanent ? openAppSettings() : onPressed(),
            ),
          ),
        ],
      ),
    );
  }
}

/// This widget is simply the button to select
/// the image from the local file system.
class PickFile extends StatelessWidget {
  final VoidCallback onPressed;

  const PickFile({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
    child: ElevatedButton(
      child: const Text('Pick file'),
      onPressed: onPressed,
    ),
  );
}

/// This widget is used once the permission has
/// been granted and a file has been selected.
/// Load the image and display it in the center.
class ImageLoaded extends StatelessWidget {
  final File file;

  const ImageLoaded({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 196.0,
        height: 196.0,
        child: ClipOval(
          child: Image.file(
            file,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
