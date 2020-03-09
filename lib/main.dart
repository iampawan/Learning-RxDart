import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'demo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RX Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  BehaviorSubject<List<String>> streamController =
      BehaviorSubject<List<String>>();

  StreamTransformer<List<String>, List<String>> get streamTransformer =>
      StreamTransformer<List<String>, List<String>>.fromHandlers(
        handleData: (data, sink) {
          if (_textController.text.length > 0) {
            sink.add(
                data.where((e) => e.contains(_textController.text)).toList());
          } else {
            sink.add(data);
          }
        },
        handleError: (error, stackTrace, sink) {},
      );

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Rx Demo"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _learnStream();
          },
          child: Icon(Icons.refresh),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter something"),
                ),
                Container(
                  height: 400,
                  child: StreamBuilder(
                    stream: streamController.transform(streamTransformer),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> data = snapshot.data ?? "";
                        return ListView(
                          children: data
                              .map((s) => ListTile(
                                    title: Text(s),
                                  ))
                              .toList(),
                        );
                      }
                      return Text(snapshot.error.toString());
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  fetchData() async {
    final stopwatch = Stopwatch()..start();
    Rx.combineLatest2(fetchHelloString().asStream(),
        fetchWelcomeString().asStream(), (a, b) => a + b).listen((event) {
      streamController.sink.add(event);
    });

    print('executed in ${stopwatch.elapsedMilliseconds}');
    stopwatch.stop();
  }

  _learnStream() async {
    // var subject = StreamController.broadcast();
    // var subject = PublishSubject<String>();
    var subject = BehaviorSubject<String>();
    // var subject = ReplaySubject<String>();

    // subject
    //     .map((event) => event.toUpperCase())
    //     .map((event) => event.substring(event.length - 1))
    //     // .map<Person>((event) => Person("PK $event"))
    //     .map((event) => num.tryParse(event))
    //     // .where((event) => event % 2 == 0)
    //     // .scan((a, b, index) => a + b, 1)
    //     // .asyncMap((event) async => await fetchWelcomeString())
    //     // .debounceTime(Duration(milliseconds: 100))
    //     // .bufferTime(Duration(seconds: 1))
    //     // .defaultIfEmpty(100)
    //     // .distinctUnique()
    //     // .pairwise()

    //     .listen((value) {
    //   print("Added $value to 1st Sub");
    // });
    // RangeStream(1, 5)
    //     .switchMap((value) => TimerStream(value, Duration(seconds: value)))
    //     .listen((value) {
    //   print("Added $value to 1st Sub");
    // });

    // fetchHelloString()
    //     .asStream()
    //     .zipWith(fetchWelcomeString().asStream(), (a, b) => a + b)
    //     .listen((value) {
    //   print("Added $value to 1st Sub");
    // });

    // fetchHelloString()
    //     .asStream()
    //     .concatWith([fetchWelcomeString().asStream()]).listen((value) {
    //   print("Added $value to 1st Sub");
    // });

    // subject.add("Item 1");

    // subject.add("Item 2");
    // // subject.add("Item 2");

    // // subject.listen((value) {
    // //   print("Added $value to 2nd Sub");
    // // });
    // // await fetchSomething();

    // subject.add("Item 3");

    // subject.add("Item 4");
    // subject.add("Item 5");

    subject.close();
  }
}

fetchSomething() async {
  await Future.delayed(Duration(seconds: 2));
}

class Person {
  final String name;
  Person(this.name);

  @override
  String toString() {
    return name.toString();
  }
}

// Stream<List<String>> res1 = fetchHelloString();
// Stream<List<String>> res2 = fetchWelcomeString();
// res1.mergeWith([res2]).listen((item) {
//   print("Added $item to 1st stream");
// });
