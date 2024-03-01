import 'package:flutter/material.dart';
import 'package:typicodenetworking/models/post.dart';
import 'package:typicodenetworking/services/apiservice.dart';
import 'package:typicodenetworking/widgets/showmessage_widget.dart';

class CreatePostPage extends StatefulWidget {
  CreatePostPage({super.key});
  @override
  State<CreatePostPage> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePostPage> {
  var formKey = GlobalKey<FormState>(); //**** */
  ApiService _apiService = ApiService();
  var title = "";
  var body = "";

  //flags
  bool get isSavingOk => title.isNotEmpty && body.isNotEmpty;
  bool isPostCreated = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  savePost() {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save(); //all are set,in place
      _apiService.createPost(title, body).then((result) {
        if (result.status) {
          showMessage(context, "Success", result.message, callBack: () {
            //Navigator.pop(context, true);
            isPostCreated = true;
            clearAllText();
          });
        } else {
          showMessage(context, "Error", result.message);
        }
      });
    }
  }

  clearAllText() {
    formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creating Post"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: isSavingOk
                ? () {
                    savePost();
                  }
                : null,
            icon: Icon(
              Icons.save,
              color: isSavingOk ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
      body: Form(
        /** */
        key: formKey, //** */
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title"),
              TextFormField(
                //** */
                onChanged: (value) {
                  title = value;
                  setState(() {});
                },
                onSaved: (value) {
                  title = value!;
                },
                /** */
                validator: titleValidator, /** */
              ),
              const Text("Body"),
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  onChanged: (value) {
                    body = value;
                    setState(() {});
                  },
                  onSaved: (value) {
                    body = value!;
                  },
                  validator: bodyValidator,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? titleValidator(String? value) {
    if (value!.isEmpty) return "Enter post title";
    if (value!.length < 5)
      return "Post title must be greater than 5 characters";
    return null;
  }

  String? bodyValidator(String? value) {
    if (value!.isEmpty) return "Enter post body";
    if (value!.length < 5)
      return "Post body must be greater than 10 characters";
    return null;
  }
}
