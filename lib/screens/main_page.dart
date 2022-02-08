import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropDownText;

  get onSelectionChanged => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 4,
        toolbarHeight: 100,
        title: Row(
          children: [
            Text(
              'Diary',
              style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
            ),
            const Text(
              'Book',
              style: TextStyle(fontSize: 39, color: Colors.green),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  items: const ['Latest', 'Earliest']
                      .map((item) => DropdownMenuItem(
                            child: Text(
                              item,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            value: item,
                          ))
                      .toList(),
                  hint: _dropDownText == null
                      ? const Text('Select')
                      : Text(_dropDownText!),
                  onChanged: (value) {
                    setState(() {
                      _dropDownText = value.toString();
                    });
                  },
                ),
              ),
              //TODO: create profile
              Container(
                child: Row(
                  children: [
                    Column(
                      children: const [
                        Expanded(
                          child: InkWell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://picsum.photos/200/300'),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'James',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.logout_outlined,
                          size: 19,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
              )
            ],
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        right: BorderSide(width: 0.4, color: Colors.blueGrey))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SfDateRangePicker(
                        onSelectionChanged: (dateRangePickerSelection) {
                          print(dateRangePickerSelection.value.toString());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Card(
                          elevation: 4,
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.greenAccent,
                            ),
                            label: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Write New',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      child: Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (ctx, i) {
                                    return SizedBox(
                                      width:
                                          MediaQuery.of(ctx).size.width * 0.4,
                                      child: Card(
                                        elevation: 4,
                                        child: ListTile(
                                          title: Text('Hello'),
                                        ),
                                      ),
                                    );
                                  }))
                        ],
                      ),
                    )),
                  ],
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
