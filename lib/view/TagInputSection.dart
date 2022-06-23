import 'package:flutter/material.dart';
import 'package:mapmosphere/controller/mycustomeController/updatePinDataController.dart';

import '../module/MyCostumeModule/pointDataModel.dart';

class UserInputTagData extends StatefulWidget {
  List<PointDataModel> featuresTypes;
  double pinLat;
  double pinLong;
  UserInputTagData(this.featuresTypes, this.pinLat, this.pinLong, {Key? key})
      : super(key: key);

  @override
  State<UserInputTagData> createState() =>
      _UserInputTagDataState(featuresTypes, pinLat, pinLong);
}

class _UserInputTagDataState extends State<UserInputTagData> {
  List<PointDataModel> featuresTypes;
  double pinLat;
  double pinLong;
  _UserInputTagDataState(
    this.featuresTypes,
    this.pinLat,
    this.pinLong,
  );
  TextEditingController pinPointName = TextEditingController();
  TextEditingController pinPointDescription = TextEditingController();
  // this is the dynamic text fields
  List<TextEditingController> tagController = [];
  List<TextField> tagFields = [];
  List<TextEditingController> nameController = [];
  List<TextField> nameFields = [];
  // this is the array string
  var concatenate = StringBuffer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(pinLat);
    print(pinLong);
    tagController = [];
    tagFields = [];
    nameController = [];
    nameFields = [];
  }

  @override
  void dispose() {
    for (final controller in tagController) {
      controller.dispose();
    }
    for (final controller in nameController) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Input data"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ExpansionTile(
                      initiallyExpanded: true,
                      backgroundColor: Colors.white,
                      title: const Text(
                        "Features Types",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.red,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 20,
                                    color: Colors.white,
                                    child: Center(
                                      child: Icon(featuresTypes.first.iconData),
                                    ),
                                  ),
                                ),
                                // this is the name of the features types
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: 20,
                                    color: Colors.white54,
                                    child: Center(
                                      child: Text(
                                        featuresTypes.first.pointName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                ),
              ),
              // this is the another expansion tile
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: const Text(
                        "Fields",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.red)),
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: "Name",
                              ),
                              controller: pinPointName,
                            ),
                          ),
                        ),
                        // this is the description of the pinPoint
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.red)),
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: "Description",
                              ),
                              controller: pinPointDescription,
                            ),
                          ),
                        )
                      ]),
                ),
              ),
              // this is the expansion fields to add the tags
              ExpansionTile(
                title: Text("Tags"),
                children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: nameController.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 2, child: tagFields[index]),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            flex: 3, child: nameFields[index]),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft, child: _addTile()),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.done,
            size: 30,
          ),
          onPressed: () {
            var object = [];
            for (int i = 0; i < nameController.length; i++) {
              object.add({
                tagController[i].text: nameController[i].text,
              });
            }
            object.forEach((item) {
              concatenate.write(item);
            });
            UpdatePinDataController().updatePinData(
              pinLat,
              pinLong,
              featuresTypes.first.pointName,
              pinPointName.text,
              pinPointDescription.text,
              concatenate.toString(),
            );
            setState(() {
              for (int i = 0; i < nameController.length; i++) {
                nameController[i].text = "";
                tagController[i].text = "";
                pinPointName.text = "";
                pinPointDescription.text = "";
              }
            });
          }),
    );
  }

  Widget _addTile() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.black, // Background color
      ),
      child: const Text("Add Fields"),
      onPressed: () {
        final name = TextEditingController();
        final tag = TextEditingController();

        final nameField = _generateTextField(name, "name");
        final telField = _generateTextField(tag, "Tag");

        setState(() {
          nameController.add(name);
          tagController.add(tag);

          nameFields.add(nameField);
          tagFields.add(telField);
        });
      },
    );
  }

  TextField _generateTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }
  // update api
}
