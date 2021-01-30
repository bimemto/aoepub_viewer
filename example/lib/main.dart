import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aoepub_viewer/aoepub_viewer.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String text = '';

  void _incrementCounter(BuildContext context) {
    setUpCrypt(context);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void setUpCrypt(BuildContext context) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, "app");
    ByteData data = await rootBundle.load("assets/testBase64.enc");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    // final key = encrypt.Key.fromUtf8('44BZgdKgL2BZdxK144BZgdKgL2BZdxK1');
    // final iv = encrypt.IV.fromUtf8('44BZgdKgL2BZdxK1');

    // final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    // final encrypted = encrypter.decryptBytes(encrypt.Encrypted(bytes), iv: iv);
    // var tmpPath = join(directory.path, "decrypt.epub");
    // await File(tmpPath).writeAsBytes(encrypted);

    final tmpPath = await decryptFile(dbPath);

    AoepubViewer.setConfig(
      themeColor: Theme.of(context).errorColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: false,
      enableTts: true,
    );
    AoepubViewer.open(tmpPath);
    AoepubViewer.debugStream.listen((event) {
      print("debug reading time: " + event.toString());
    });
  }

  Future<String> decryptFile(filePath) async {
    //'filePath' contains the php encrypted video file.
    var encodedKey = 'NDRCWmdkS2dMMkJaZHhLMTQ0QlpnZEtnTDJCWmR4SzE=';
    var encodedIv = 'NDRCWmdkS2dMMkJaZHhLMQ==';
    var encryptedBase64EncodedString = new File(filePath).readAsStringSync();
    var decoded = base64.decode(encryptedBase64EncodedString);
    final key1 = encrypt.Key.fromBase64(encodedKey);
    final iv = encrypt.IV.fromBase64(encodedIv);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key1, mode: encrypt.AESMode.cbc));
    final decrypted =
        encrypter.decryptBytes(encrypt.Encrypted(decoded), iv: iv);
    final filename = '${basenameWithoutExtension(filePath)}.epub';
    final directoryName = dirname(filePath);
    final newFilePath = join(directoryName, filename);
    var newFile = new File(newFilePath);
    await newFile.writeAsBytes(decrypted);
    return newFilePath;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Title'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Expanded(
              child: Text(
                '$text',
                style: TextStyle(fontSize: 8),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
