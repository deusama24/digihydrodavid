import 'package:flutter/material.dart';
import 'package:digihydro/index_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:math';

class signupPage extends StatefulWidget{
  @override
  signUp createState() => signUp();
}
class signUp extends State<signupPage> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController growerType = TextEditingController();
  TextEditingController userEmail= TextEditingController();
  TextEditingController userPass= TextEditingController();
  TextEditingController confirmPass= TextEditingController();

  var _selecType = "-1";
  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    userEmail.dispose();
    userPass.dispose();
    growerType.dispose();
    confirmPass.dispose();
    super.dispose();
  }
  
  bool passwordConfirmed(){
    if(userPass.text.trim() == confirmPass.text.trim()){
      return true;
    }else{
      return false;
    }
  }

  Future userSignUp() async {
  if (passwordConfirmed()) {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail.text.trim(),
        password: userPass.text.trim(),
      );
      User? user = userCredential.user;
      if (user != null) {
        await fb.ref().child('Users/${user.uid}').set({
          'firstName': firstName.text.trim(),
          'lastName': lastName.text.trim(),
          'email': userEmail.text.trim(),
          'password':userPass.text.trim(),
          'growerType': _selecType,
          'userId':user.uid,
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
  final fb = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    var rng = Random();
    var num = rng.nextInt(10000);
    //final currentUser = _auth.currentUser;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 201, 237, 220),
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        body: Form(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(50, 40, 50, 15),
                  child: Center(
                    child: Text(
                      "Create an Account",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 235, 0),
                        child: Text(
                          "First Name:",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: TextField(
                          controller: firstName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 235, 0),
                        child: Text(
                          "Last Name:",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: TextField(
                          controller: lastName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 230, 0),
                        child: Text(
                          "Grower Type:",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                          value: _selecType,
                          items: [
                            DropdownMenuItem(child: Text("-Select Grower Type-"), value: "-1",),
                            DropdownMenuItem(child: Text("Dft"), value: "Dft",),
                            DropdownMenuItem(child: Text("Nft"), value: "Nft",),
                          ],
                          onChanged:(newMethod){
                            setState(() {
                              _selecType = newMethod!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 260, 0),
                        child: Text(
                          "Email:",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: TextField(
                          controller: userEmail,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 230, 0),
                        child: Text(
                          "Password:",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: TextField(
                          controller: userPass,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 180, 0),
                        child: Text(
                          "Confirm Password:",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: TextField(
                          controller: confirmPass,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 220, 0),
                          child: ElevatedButton(
                            child: Text('Submit'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(25, 12, 25, 12),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              textStyle: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              userSignUp();
                              
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IndexScreen()));
                            },
                          )
                          /*child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(25, 12, 25, 12), //
                          textColor: Colors.white, //
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), //
                          color: Colors.redAccent, //
                          child: Text('Submit'), //
                          onPressed: (){ //
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>IndexScreen()
                            ));
                          },
                        ),*/
                          )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        // body: Center(
        //   child: RaisedButton(
        //     child: Text("Go Back"),
        //     onPressed: (){
        //       Navigator.pop(context);
        //     }
        //   ),
        // ),
        );
  }
}
