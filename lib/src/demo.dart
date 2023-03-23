import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stegagnography/src/details.dart';
import 'package:stegagnography/src/sample_feature/signin.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDrW5Jf4alnyWyQkutdHPzgsNqjd7C8gVE",
      authDomain: "stagno-71ae1.firebaseapp.com",
      databaseURL: "https://stagno-71ae1-default-rtdb.firebaseio.com",
      projectId: "stagno-71ae1",
      storageBucket: "stagno-71ae1.appspot.com",
      messagingSenderId: "280924138784",
      appId: "1:280924138784:web:6a96613020de632eedfb45"
    )
  );
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Cloud Storage Images'),
        ),
        body: SignInPage(),
      ),
    );
  }
}

class ImagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('bdeg ');

    return Scaffold(
      body: FutureBuilder<List<ImageModel>>(
        future: fetchImageUrls(),
        builder: (BuildContext context, AsyncSnapshot<List<ImageModel>> snapshot) {
          print('connection ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<ImageModel> imageUrls = snapshot.data!;
            return ListView.builder(
              itemCount: imageUrls.length,
        
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Details(imageUrls[index])));
                  },
            
                  child: Container(
                    height: 400,
                    width: 200,
                    margin: EdgeInsets.all(16),
                    
                    child: Image.network(imageUrls[index].url)),
                );
              },
              padding: EdgeInsets.all(8.0),
            );
          }
        },
      ),
    );
  }
}


class ImageModel {

  final String url;
  final String filename;

  ImageModel(this.url, this.filename);  


}

Future<List<ImageModel>> fetchImageUrls() async {
  List<ImageModel> imageUrls = [];

  final storageReference = FirebaseStorage.instance.ref('/uploads');
  final ListResult result = await storageReference.list();
  final List<Reference> allFiles = result.items;

  for (final file in allFiles) {
    final String url = await file.getDownloadURL();
    final String filename = file.name;
    imageUrls.add(ImageModel(url, filename));
  }


  return imageUrls;
}
