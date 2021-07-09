import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List userData;
  bool isLoading = true;
  final String url = 'https://randomuser.me/api/?results=50';

  Future getData() async {
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    List data = jsonDecode(response.body)['results'];
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Radom Users'),
        ),
        body: Container(
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: userData == null ? 0 : userData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(20.0),
                              child: Image(
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    userData[index]["picture"]["thumbnail"]),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      userData[index]["name"]["title"] +
                                          " " +
                                          userData[index]["name"]["first"] +
                                          " " +
                                          userData[index]["name"]["last"],
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.phone),
                                    title: Text(userData[index]["phone"]),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(userData[index]["gender"]),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.calendar_view_day),
                                    title: Text(userData[index]["dob"]["date"]),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(
                                        userData[index]["login"]["username"]),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ));
  }
}
