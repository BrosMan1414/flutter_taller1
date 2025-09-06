import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller 1',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _title = "Hola, Flutter";


  void _cambiarTitulo() {
  setState(() {
    if (_title == "Hola, Flutter") {
      _title = "¡Título cambiado!";
    } else {
      _title = "Hola, Flutter";
    }
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Título actualizado")),
  );
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Mario Ochoa Arango - 230222016",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network('https://miro.medium.com/v2/resize:fit:1000/1*5-aoK8IBmXve5whBQM90GA.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(width: 20),
                Image.asset('assets/github.png',
                  width: 150,
                  height: 150,
                ),
              ],
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _cambiarTitulo,
              child: const Text('Cambiar Título', style: TextStyle(fontSize: 20)),
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 160,
                    color: Colors.red,
                    child: const Center(child: Text('Elemento 1', style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                  Container(
                    width: 160,
                    color: Colors.blue,
                    child: const Center(child: Text('Elemento 2', style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                  Container(
                    width: 160,
                    color: Colors.green,
                    child: const Center(child: Text('Elemento 3', style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                  Container(
                    width: 160,
                    color: Colors.orange,
                    child: const Center(child: Text('Elemento 4', style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                  Container(
                    width: 160,
                    color: Colors.purple,
                    child: const Center(child: Text('Elemento 5', style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}
