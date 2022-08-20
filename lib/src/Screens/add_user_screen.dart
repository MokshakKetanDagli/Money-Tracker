import 'package:daily_collection/src/widgets/custom_elevated_button.dart';
import 'package:daily_collection/src/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController amountController;
  late CollectionReference collectionReference;

  @override
  void initState() {
    usernameController = TextEditingController();
    phoneController = TextEditingController();
    amountController = TextEditingController();
    collectionReference = FirebaseFirestore.instance.collection('New_Daily_Collection_350');
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        centerTitle: true,
        title: const Text('Add User'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: usernameController,
              hintText: 'Username',
              textInputType: TextInputType.name,
              maxLength: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: phoneController,
              hintText: 'Phone Number',
              textInputType: TextInputType.phone,
              maxLength: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: amountController,
              hintText: 'Inital Amount',
              textInputType: TextInputType.number,
              maxLength: 7,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevatedButton(
              voidCallback: () {
                if (usernameController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Please enter a valid username.',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.blueAccent.shade700,
                    ),
                  );
                } else if (phoneController.text == '' || phoneController.text.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Please enter a valid phone number.',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.blueAccent.shade700,
                    ),
                  );
                } else if (amountController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Please enter a valid inital balance amount.',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.blueAccent.shade700,
                    ),
                  );
                } else {
                  FocusScope.of(context).unfocus();
                  collectionReference
                      .doc(usernameController.text.toString())
                      .set({
                        'Username': usernameController.text.toString(),
                        'Phone Number': phoneController.text,
                        'Closing Balance': int.parse(amountController.text),
                        'Account Transactions': [],
                      })
                      .whenComplete(
                        () => {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blueAccent.shade700,
                              content: const Text(
                                'User Added',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Navigator.pop(context),
                        },
                      )
                      .catchError(
                        // ignore: invalid_return_type_for_catch_error
                        (error) => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Error Occured.\nTry Again!',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                }
              },
              buttonName: 'Add User',
            )
          ],
        ),
      ),
    );
  }
}
