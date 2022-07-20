import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/model/data_model.dart';
import 'package:flutter_application_2/provider/auth_prover.dart';
import 'package:flutter_application_2/provider/data_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<DataProvider>(context, listen: false);
    _provider.getData(null);
    return Scaffold(
      floatingActionButton: Material(
          color: Colors.blue,
          child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Provider.of<DataProvider>(context, listen: false).data.clear();
                Provider.of<AuthProvider>(context, listen: false).logout();
              })),
      appBar: AppBar(title: Text("Todo App"), actions: [
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/add');
            },
            child: Icon(Icons.add)),
        SizedBox(
          width: 5,
        )
      ]),
      body: Consumer<DataProvider>(
        builder: (context, provider, _) => ListView(
            children: provider.data
                .map<Widget>((param) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/edit",
                            arguments: {"id": param.id});
                      },
                      child: Dismissible(
                          key: Key(param.id),
                          confirmDismiss: (_) {
                            return _provider
                                .deleteData(param.id)
                                .then((value) => true);
                          },
                          child: ListTile(
                              leading: CircleAvatar(
                                  child: Text((provider.data.indexOf(param) + 1)
                                      .toString())),
                              title: Text(param.name),
                              subtitle: Text(param.description),
                              trailing: Text(DateFormat('yyyy-MM-dd')
                                  .format(param.updatedAt)
                                  .toString()))),
                    ))
                .toList()),
      ),
    );
  }
}
