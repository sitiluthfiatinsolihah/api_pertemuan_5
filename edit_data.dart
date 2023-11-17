import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pertemuan_5/main.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  final List list;
  final int index;

  Edit({Key? key, required this.list, required this.index}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late TextEditingController name;
  late TextEditingController address;
  late TextEditingController salary;
  final home = MyApp();

  Future<void> editData() async {
    if (name.text.isNotEmpty &&
        address.text.isNotEmpty &&
        salary.text.isNotEmpty) {
      var url = Uri.parse(
          'http://192.168.0.102/api_pertemuan_5/update.php'); // Update API Calling
      final response = await http.post(url, body: {
        'id': widget.list[widget.index]['id'],
        'name': name.text,
        'address': address.text,
        'salary': salary.text,
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil diperbarui'),
          ),
        );

        const MyApp().refreshData();

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => MyApp(),
        ));
      } else {
        // Jika terjadi kesalahan dalam permintaan API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat mengedit data'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap isi kedua bidang input'),
        ),
      );
    }
  }

  @override
  void initState() {
    name = TextEditingController(text: widget.list[widget.index]['name']);
    address = TextEditingController(text: widget.list[widget.index]['address']);
    salary = TextEditingController(text: widget.list[widget.index]['salary']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Data ${widget.list[widget.index]['name']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: name,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Title',
                hintText: 'Enter Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              maxLines: 5,
              controller: address,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Content',
                hintText: 'Enter Content',
                prefixIcon: Icon(Icons.text_snippet_outlined),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: salary,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Salary',
                hintText: 'Enter Salary',
                prefixIcon: Icon(Icons.money),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: MaterialButton(
              child: Text(
                "Edit Data",
                style: TextStyle(
                    // color: Colors.white,
                    ),
              ),
              color: Colors.green,
              onPressed: () {
                editData();
              },
              height: 45,
            ),
          )
        ],
      ),
    );
  }
}
