// import 'package:flutter/material.dart';
// import 'dart:io';
// import '../controllers/image_controller.dart';
// import '../models/image_model.dart';
//
// class HomeView extends StatefulWidget {
//   @override
//   _HomeViewState createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   final ImageController _imageController = ImageController();
//   File? _image;
//   ImageModel? _result;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Teachable Machine Flutter')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image != null ? Image.file(_image!) : Text('No image selected.'),
//             SizedBox(height: 16),
//             _result != null ? Text('Class: ${_result!.className}\nConfidence: ${_result!.confidence}') : Container(),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final image = await _imageController.pickImage();
//                   if (image != null) {
//                     print('Image path: ${image.path}');
//                     final result = await _imageController.classifyImage(image);
//                     setState(() {
//                       _image = image;
//                       _result = result;
//                     });
//                   }
//                 } catch (e) {
//                   print('Error in onPressed: $e');
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: Text('Error'),
//                         content: Text(e.toString()),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('OK'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//               child: Text('Pick and Classify Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:io';
import '../controllers/image_controller.dart';
import '../models/image_model.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ImageController _imageController = ImageController();
  File? _image;
  ImageModel? _result;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teachable Machine Classifier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  _image!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text(
                    'No image selected.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 24),
              _isLoading
                  ? CircularProgressIndicator()
                  : _result != null
                  ? Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Result',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Class: ${_result!.className}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Confidence: ${_result!.confidence.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
                  : Container(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    final image = await _imageController.pickImage();
                    if (image != null) {
                      print('Image path: ${image.path}');
                      final result = await _imageController.classifyImage(image);
                      setState(() {
                        _image = image;
                        _result = result;
                        _isLoading = false;
                      });
                    } else {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } catch (e) {
                    print('Error in onPressed: $e');
                    setState(() {
                      _isLoading = false;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Pick and Classify Image',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
