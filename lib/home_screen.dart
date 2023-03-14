
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_curd_app/boxes/boxes.dart';
import 'package:hive_curd_app/models/note_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive db"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _){

          var data = box.values.toList().cast<NotesModel>();

          return Padding(

            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: box.length,
              itemBuilder: (context,  index){
                return Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString()),
                            Spacer(),
                            InkWell(
                              onTap: (){
                                _addEditDialog(data[index], data[index].title, data[index].description);
                              },
                                child: Icon(Icons.edit)),
                            SizedBox(width: 15,),
                            InkWell(
                              onTap: (){
                                delete(data[index]);
                              },
                                child: Icon(Icons.delete))
                          ],
                        ),

                        Text(data[index].description.toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          _showMyDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog()async{
    return showDialog(
        context: context,
        builder: (context){
      return AlertDialog(
        title: Text("Add Notes"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter your Title",
                  border: OutlineInputBorder()
                ) ,
              ),

              SizedBox(height: 20,),

              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: "Enter your description",
                    border: OutlineInputBorder()
                ) ,

              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),

          TextButton(onPressed: (){
            final data = NotesModel(
                title: titleController.text,
                description: descriptionController.text);

            final box = Boxes.getData();
            box.add(data);

            //data.save();

            print(box);

            titleController.clear();
            descriptionController.clear();

            Navigator.pop(context);
          }, child: Text("Add")),
        ],
      );
        });

  }
  
  void delete(NotesModel notesModel)async{
    await notesModel.delete();
    
  }

  Future<void> _addEditDialog(NotesModel notesModel, String title, String description)async{
    
    titleController.text = title;
    descriptionController.text = description;
    
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Update Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: "Enter your Title",
                        border: OutlineInputBorder()
                    ) ,
                  ),

                  SizedBox(height: 20,),

                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: "Enter your description",
                        border: OutlineInputBorder()
                    ) ,

                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),

              TextButton(onPressed: ()async{

                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();
                await notesModel.save();
                descriptionController.clear();
                titleController.clear();

                Navigator.pop(context);
              }, child: Text("Edit")),
            ],
          );
        });

  }

}
