import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  Uint8List? _image1;
  Uint8List? _image2;

  String? file1type;
  String? file2type;


  Future<void> _pickImage(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      setState(() {
        if (index == 1) {
          _image1 = result.files.first.bytes;
          file1type = result.files.first.extension;

        } else if (index == 2) {
          _image2 = result.files.first.bytes;
          file2type = result.files.first.extension;

        }
      });
    }
  }

  Future<void> _uploadImages() async {
    String apiUrl = 'http://anant02.pythonanywhere.com/hide';

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.fields['filetype'] = file2type ?? 'jpg';

    if (_image1 != null) {
      request.files.add(http.MultipartFile.fromBytes('carrier', _image1!, filename: 'image1.jpg'));
    }
    if (_image2 != null) {
      request.files.add(http.MultipartFile.fromBytes('message', _image2!, filename: 'image2.jpg'));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Images uploaded successfully');
    } else {
      print('Error uploading images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Upload Example')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(1),
                child: Text('Pick Image 1'),
              ),
              _image1 != null ? Image.memory(_image1!,  width: 200, height: 200): SizedBox(),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _pickImage(2),
                child: Text('Pick Image 2'),
              ),
              _image2 != null ? Image.memory(_image2!, width: 200, height: 200): SizedBox(),
      
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_image1 != null || _image2 != null) ? _uploadImages : null,
                child: Text('Upload Images'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}