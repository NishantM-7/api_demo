import 'dart:convert';

import 'package:api_demo/demo_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'API DEMO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _responseData;
  bool isLoading = false;

  Future<void> getData() async {
    print('In INITSTATE');
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get(Uri.parse('https://api.adviceslip.com/advice'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        _responseData = data;
        isLoading = false;
      });
    } else {
      var data = {'advice': 'No Gyan Found!!'};
      setState(() {
        _responseData = data;
        isLoading = false;
      });
    }
  }

  Future<void> getLovePercentage() async {
    const String baseUrl =
        "https://love-calculator.p.rapidapi.com/getPercentage";
    // Sign up to rapid api wwebsite and it will generate you personal api key.

    const String apiKey = "PUT_YOUR_API_KEY_HERE";

    final Map<String, String> queryParameters = {
      "sname": "Riya",
      "fname": "Soumya",
    };
    setState(() {
      isLoading = true;
    });
    final Uri uri =
        Uri.parse(baseUrl).replace(queryParameters: queryParameters);

//can also be written as  https://love-calculator.p.rapidapi.com/getPercentage?sname=Alice&fname=John   directly instead of using Uri.parse().replace

    print('API call');
    final http.Response response = await http.get(
      uri,
      headers: {
        "X-RapidAPI-Key": apiKey,
        "X-RapidAPI-Host": "love-calculator.p.rapidapi.com",
      },
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      setState(() {
        _responseData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(5),
            child: Card(
              color: Colors.amber[50],
              elevation: 5,
              child: Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(_responseData == null
                        ? 'Click If you are not Gay'
                        : '${_responseData['percentage']}%'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: getLovePercentage,
              child: const Text('Naya Gyan Dijiye')),
          ElevatedButton(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DemoPage();
                  })),
              child: const Text('Demo Page')),
        ],
      )),
    );
  }
}
