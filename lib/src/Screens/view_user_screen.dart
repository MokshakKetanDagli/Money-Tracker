import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_collection/src/widgets/custom_dailog_button.dart';
import 'package:daily_collection/src/widgets/custom_elevated_button.dart';

import 'package:flutter/material.dart';

import 'add_user_screen.dart';
import 'user_detail.dart';

class ViewUserScreen extends StatelessWidget {
  const ViewUserScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('New_Daily_Collection_350');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        centerTitle: true,
        title: const Text('View Users'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewUserScreen(),
              ),
            ),
            icon: const Icon(
              Icons.refresh,
              size: 24,
            ),
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: collectionReference.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Container(
                color: Colors.blueAccent.shade700,
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Error Occured.\nRetry Again!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent.shade700,
              ),
            );
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'NO USERS CREATED',
                      style: TextStyle(
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomElevatedButton(
                      voidCallback: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddUserScreen(),
                        ),
                      ),
                      buttonName: 'Add User',
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetail(
                              userName: snapshot.data!.docs[index].get('Username'),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        tileColor: Colors.blueAccent.shade700,
                        leading: Text(
                          '${index + 1}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        title: Text(
                          '${snapshot.data!.docs[index].get('Username')}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹ ${snapshot.data!.docs[index].get('Closing Balance')}',
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)),
                                    title: Text(
                                      'Delete User',
                                      style: TextStyle(
                                        color: Colors.blueAccent.shade400,
                                      ),
                                    ),
                                    actions: [
                                      CustomDailogButton(
                                        buttonName: 'Yes',
                                        voidCallback: () {
                                          collectionReference
                                              .doc(snapshot.data!.docs[index].get('Username'))
                                              .delete()
                                              .whenComplete(
                                                () => {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                        'User Deleted',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      backgroundColor: Colors.blueAccent.shade700,
                                                    ),
                                                  ),
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const ViewUserScreen(),
                                                    ),
                                                  )
                                                },
                                              )
                                              .catchError(
                                                (error) =>
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                      'Try Again',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.blueAccent.shade700,
                                                  ),
                                                ),
                                              );
                                        },
                                      ),
                                      CustomDailogButton(
                                        buttonName: 'No',
                                        voidCallback: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
