import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/provider/data_provider.dart';
import 'package:provider/provider.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late DataProvider _provider;
  bool _changed = false;
  bool _changed2 = false;
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  Map<String, String> _arguments = {};
  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (_changed) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 4) {
        return 'Too short';
      }
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorText2 {
    // at any time, we can get the text from _controller.value.text
    final text = _controller2.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (_changed2) {
      if (text.isEmpty) {
        return 'Can\'t be empty';
      }
      if (text.length < 4) {
        return 'Too short';
      }
    }
    // return null if the text is valid
    return null;
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<DataProvider>(context, listen: false);
    _arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    _provider.getData(_arguments["id"]).then((value) {
      if (value != null) {
        _controller.text = value["name"] as String;
        _controller2.text = value["description"] as String;
      }
    });

    super.didChangeDependencies();
  }

  // dispose it when the widget is unmounted
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data"),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(5, 30, 5, 10),
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            TextField(
              controller: _controller,
              onTap: () {
                setState(() {
                  _changed2 = true;
                });
              },
              onChanged: (param) => setState(() {}),
              decoration: InputDecoration(
                  label: Text('Title'),
                  errorText: _errorText2,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.difference_outlined)),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _controller2,
              onTap: () {
                setState(() {
                  _changed = true;
                });
              },
              onChanged: (param) => setState(() {}),
              decoration: InputDecoration(
                  errorText: _errorText,
                  label: Text('Description'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.difference)),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  if (_errorText == null && _errorText2 == null) {
                    _provider
                        .editData(_arguments["id"] as String,
                            _controller.value.text, _controller2.value.text)
                        .then((value) => Navigator.pop(context));
                  }
                },
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                child: Text('Edit Data'))
          ])),
    );
  }
}
