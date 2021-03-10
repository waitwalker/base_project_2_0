import 'package:base_project_2_0/generated/i18n.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //runApp前调用，初始化绑定，手势、渲染、服务等
  WidgetsFlutterBinding.ensureInitialized();
  int v = SpUtil.getInt("cache_count", defValue: 20);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var va = sharedPreferences.getInt("cache_count") ?? 30;

  runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (context) {
      /// 初始化model
      return Counter(va);
  },),
  );
}

class Counter with ChangeNotifier {
  /// 变量
  int value = 0;

  Counter(this.value);

  void increment() {
    value += 1;
    notifyListeners();
  }

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int currentValue = 0;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("cache_count", currentValue);
    Provider.of<Counter>(context, listen: false).increment();
    print("currentValue:$currentValue");
    // SpUtil.putInt("cache_count", currentValue);
  }

  @override
  void initState() {
    super.initState();
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
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),

            Consumer<Counter>(builder: (context, counter, child){
              currentValue = counter.value;
              return Text("${counter.value}");
            }),

            InkWell(
              child: Text("获取值"),
              onTap: () async {
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                var va = sharedPreferences.getInt("cache_count");
                print("$va");
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
