import 'package:flutter/material.dart';
import 'package:pallinet/components/loading.dart';
import 'package:pallinet/firestore/firestore.dart';
import 'package:pallinet/models/physician_model.dart';
import 'package:pallinet/models/session_manager.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  State<ProfileContent> createState() => ProfileContentState();
}

class ProfileContentState extends State<ProfileContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final SessionManager _prefs;

  @override
  void initState() {
    _prefs = SessionManager();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  String? desc;
  String? name;
  String? email;
  String? phoneNumber;
  String? location;

  bool _edit = false; // false means cannot edit, true means can edit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popAndPushNamed(context, "/physician/home");
            },
          ),
          title: const Text('Profile'),
          centerTitle: true,
          actions: <Widget>[
            TextButton.icon(
              label: _edit ? const Text("Save") : const Text("Edit"),
              icon: _edit ? const Icon(Icons.save) : const Icon(Icons.edit),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.only(right: 20)),
              onPressed: () {
                if (_edit == true) {
                  _formKey.currentState?.save();
                  {
                    Map<String, dynamic> payload = {
                      "description": desc,
                      "name": name,
                      "email": email,
                      "phone": phoneNumber
                    };
                    _prefs
                        .getUid()
                        .then((uid) => {updatePhysicianProfile(uid!, payload)});
                  }
                }
                setState(() {
                  _edit = !_edit;
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<Physician>(
            future:
                _prefs.getUid().then((uid) => retrievePhysicianProfile(uid)),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                Physician? physData = snapshot.data;
                desc = physData!.description;
                name = physData.name;
                email = physData.email;
                phoneNumber = physData.phoneNumber;
                return SingleChildScrollView(
                    child: Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        gap(),
                        gap(),
                        const Text(
                          'Name',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        gap(),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 1,
                          initialValue: name,
                          enabled: _edit,
                          onSaved: (value) => {name = value},
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            prefixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.all(16.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                        gap(),
                        const Text(
                          'Phone Number',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        gap(),
                        TextFormField(
                          maxLines: null,
                          minLines: 1,
                          initialValue: phoneNumber,
                          enabled: _edit,
                          keyboardType: TextInputType.number,
                          onSaved: (value) => {phoneNumber = value},
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.all(16.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                        gap(),
                        const Text(
                          'Email',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        gap(),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 1,
                          initialValue: email,
                          enabled: _edit,
                          onSaved: (value) => {email = value},
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            contentPadding: EdgeInsets.all(16.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                        gap(),
                        const Text(
                          'Description',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        gap(),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 3,
                          initialValue: desc,
                          enabled: _edit,
                          onSaved: (value) => {desc = value},
                          decoration: const InputDecoration(
                            hintText: 'Profile Description',
                            prefixIcon: Icon(Icons.description),
                            contentPadding: EdgeInsets.all(16.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                        gap(),
                      ],
                    ),
                  ),
                ));
              } else {
                return const LoadingScreen("Loading Profile");
              }
            })));
  }

  Widget gap() => const SizedBox(height: 16);
}
