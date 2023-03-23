
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stegagnography/src/demo.dart';
import 'package:http/http.dart' as http;

class Details extends StatefulWidget {
  const Details(this.imageModel, {Key? key}) : super(key: key);

  final ImageModel imageModel;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

    late Uint8List imageBytes;
  
  @override
  Widget build(BuildContext context) {
    getSecretFile();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: 
        SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Text('PlainFile'),
              Container(child: Image.network(widget.imageModel.url), width: 400, height: 400,),
              Text('Hidden File'),
          
              FutureBuilder<Uint8List>(builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(child: Image.memory(snapshot.requireData), width: 400, height: 400,);
          
                }
                return const SizedBox();
              }, future: getSecretFile()),
              
              
              
            ],),
          ),
        )
      ),
    );
  }

  Future<Uint8List> getSecretFile() async {
    var client = http.Client();
    var filename = widget.imageModel.filename;
    var baseUrul = 'anant02.pythonanywhere.com';
    var url = Uri.http(baseUrul, '/extract', {'filename': filename});
    var response = await client.get(url);
    return response.bodyBytes;

  }
}