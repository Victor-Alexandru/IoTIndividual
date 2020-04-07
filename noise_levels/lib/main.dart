import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  int _counter = 0;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  FirebaseStorage _storage = FirebaseStorage.instance;
  Timer timer;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => _saveTakenPhotoToFirebase());
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('--Powerd By Viena--')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: new Container(
        child: new Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text('$_counter', style: new TextStyle(fontSize: 60.0)),

            ],
          ),
        ),
      ),
    );
  }

//      FutureBuilder<void>(
//        future: _initializeControllerFuture,
//        builder: (context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.done) {
//            // If the Future is complete, display the preview.
//            return CameraPreview(_controller);
//          } else {
//            // Otherwise, display a loading indicator.
//            return Center(child: CircularProgressIndicator());
//          }
//        },
//      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.camera_alt),
//        // Provide an onPressed callback.
//        onPressed: () async {
////          _takePicture();
////          await _saveTakenPhotoToFirebase();
//        },
//      ),

  void _saveTakenPhotoToFirebase() async {
    //return the path with the taken photo on a temporary file or '' if it is an error
    String imagePath = await this._returnTakenPicturePath();
    if (imagePath != '') {
      File takenImage = File(imagePath);

      //Get the file from the image picker and store it
      //File image = await ImagePicker.pickImage(source: ImageSource.gallery);

      //Create a reference to the location you want to upload to in firebase
      StorageReference reference = _storage.ref().child("${DateTime.now()}");

      //Upload the file to firebase

      await reference.putFile(takenImage);

      setState(() {
        _counter += 1;
      });
    } else {
      print("Invalid path");
    }
  }

  Future<String> _returnTakenPicturePath() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      //DOCS
      //Initializes the camera on the device.
      //Throws a CameraException if the initialization fails.
      await _initializeControllerFuture;
      // Construct the path where the image should be saved using the
      // pattern package.
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      // Attempt to take a picture and log where it's been saved.
      await _controller.takePicture(path);

      return path;
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
      return '';
    }
  }
}
