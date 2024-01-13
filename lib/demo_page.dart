import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  var _responseData = {};
  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get(Uri.parse('https://api.adviceslip.com/advice'));
    setState(() {
      _responseData = jsonDecode(response.body) as Map<String, dynamic>;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Demo Screen'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(5),
            child: Card(
              child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : _responseData.isEmpty
                          ? const Text('Click if you are not gay!!')
                          : Text('${_responseData['slip']['advice']}')),
            ),
          ),
          ElevatedButton(
              onPressed: getData, child: const Text('Naya Gyan Dijiye'))
        ],
      )),
    );
  }
}
