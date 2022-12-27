import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_web_app/model/navigation_drawer_model.dart';
import 'package:flutter_web_app/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final MyDrawerController drawerController = Get.put(MyDrawerController());
  /** Function */
  var isLoading = true;
  var currentLink = 0;
  String link = 'https://google.com';
  List<NavDrawer> navDrawer = [];
  Future<List<NavDrawer>> getDrawer() async {
    try {
      isLoading = true;
      final response = await http.get(
          Uri.parse('https://webapp.openvillagesquare.com/navigation_drawer'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        navDrawer.clear();
        for (Map i in data) {
          navDrawer.add(NavDrawer.fromJson(i));
        }
        isLoading = false;
        return navDrawer;
      } else {
        return navDrawer;
      }
    } finally {
      isLoading = false;
    }
    // ignore: prefer_typing_uninitialized_variables
  }

  /** Function */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebApp'),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: link,
        javascriptMode: JavascriptMode.unrestricted,
      ),
      drawer: Drawer(
          child: Container(
        child: Obx(() => FutureBuilder(
              future: getDrawer(),
              builder: (context, snapshot) {
                if (isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          link = navDrawer[index].title.toString();
                        });
                      },
                      title: Text(
                        navDrawer[index].title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    );
                  },
                  itemCount: navDrawer.length,
                );
              },
            )),
      )),
    );
  }
}
