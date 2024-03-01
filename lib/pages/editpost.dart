import 'package:flutter/material.dart';
import 'package:typicodenetworking/models/post.dart';
import 'package:typicodenetworking/services/apiservice.dart';
import 'package:typicodenetworking/widgets/showmessage_widget.dart';

class EditPostPage extends StatefulWidget {
  Post post;
  EditPostPage(this.post, {super.key});
  @override
  State<EditPostPage> createState() => _EditPostState();
}

class _EditPostState extends State<EditPostPage> {
  var formKey = GlobalKey<FormState>(); //**** */
  ApiService _apiService = ApiService();
  var title = "";
  var body = "";

  //flags
  bool get isSavingOk => title.isNotEmpty && body.isNotEmpty;
  bool isPostEdit = false;
  Post? _post;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.post.title ?? ""; //retrieve data from old post
    body = widget.post.body ?? "";
  }

  savePost() {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save(); //all are set,inplace
      _apiService.editPost(widget.post.id!, title, body).then((result) {
        if (result.status) {
          _post = result.value as Post; //edited post is carried
          showMessage(context, "Success", result.message, callBack: () {
            Navigator.pop(context, _post);
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _post);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Editing Post"),
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
                  initialValue: title,
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
                    initialValue: body,
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
