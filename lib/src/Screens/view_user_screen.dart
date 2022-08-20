import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

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
                                      ElevatedButton(
                                        onPressed: () {
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
                                        child: const Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                          child: Text('Yes'),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                              Colors.blueAccent.shade700),
                                          shape: MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                          child: Text('No'),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                              Colors.blueAccent.shade700),
                                          shape: MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                          ),
                                        ),
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
          },
        ));
  }
}
