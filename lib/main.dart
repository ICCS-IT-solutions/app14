import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

void main()
{
    runApp(const DocScanApp());
}


//This is a demo app for testing a flutter document scanner package.

//Nothing too special. It needs access to the camera and gallery.
class DocScanApp extends StatefulWidget
{
    const DocScanApp({super.key});

    @override
    State<DocScanApp> createState() => _DocScanAppState();
}

class _DocScanAppState extends State<DocScanApp>
{ 
    final controller = DocumentScannerController();

    @override
    void initState()
    {
        super.initState();
    }

    @override 
    Widget build(BuildContext context)
    {
        return MaterialApp(
            theme: ThemeData(useMaterial3: false, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800)),
            home: Scaffold(
                appBar: AppBar(
                    title: const Text("Document scanner - prealpha")
                ),
                body: DocumentScanner(
                    controller: controller,
                    generalStyles: GeneralStyles(
                      showCameraPreview: false,
                      widgetInsteadOfCameraPreview: ElevatedButton(
                        onPressed: captureImage,
                        child: const Text("Scan"),
                      )
                    ),
                    onSave: (imageBytes) => Logger().i(imageBytes),
                )
            )
        );
    }

    Future<void> captureImage() async
    {
        final picker = ImagePicker();
        if(await Permission.camera.request().isGranted)
        {
            final pickedFile = await picker.pickImage(source: ImageSource.camera);
            if(pickedFile != null)
            {
                await controller.findContoursFromExternalImage(image: File(pickedFile.path));
            }
            else
            {
                Logger().e("No file selected.");
            }
        }
        else
        {
            Logger().e("Camera access rights not granted.");
        }
    }     
}