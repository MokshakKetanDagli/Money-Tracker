import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceivedPaymentsScreen extends StatefulWidget {
  const ReceivedPaymentsScreen({Key? key}) : super(key: key);

  @override
  State<ReceivedPaymentsScreen> createState() => _ReceivedPaymentsScreenState();
}

class _ReceivedPaymentsScreenState extends State<ReceivedPaymentsScreen> {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('New_Daily_Collection_350');
  DateTime selectedDate = DateTime.now();
  late TextEditingController dateController;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String date = DateFormat('y M').format(selectedDate);
        dateController.text = date;
      });
    }
  }

  @override
  void initState() {
    dateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        centerTitle: true,
        title: const Text('Daily Collection'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dateController.text.isEmpty
                  ? Text(
                      'Received Payments',
                      style: TextStyle(
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  : const SizedBox(),
              dateController.text.isEmpty
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.blueAccent.shade700,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Select Date',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                onTap: () => _selectDate(context),
                controller: dateController,
              ),
              Expanded(
                  child: FutureBuilder<QuerySnapshot>(
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
                    List<String> receivedUsersList = [];
                    for (var doc in snapshot.data!.docs) {
                      for (var entry in doc.get('Account Transactions')) {
                        DateFormat format = DateFormat('EEE, dd/MMM/y');
                        var formattedDate = format.parse(entry['Date'] as String);
                        if (dateController.text.isNotEmpty) {
                          DateFormat newformat = DateFormat('y M');
                          var newformattedDate = newformat.parse(dateController.text);
                          if (formattedDate.year == newformattedDate.year &&
                              formattedDate.month == newformattedDate.month) {
                            receivedUsersList.add(doc.get('Username'));
                          } else {
                            continue;
                          }
                        }
                      }
                    }
                    if (dateController.text.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Please select a month and year.',
                              style: TextStyle(
                                color: Colors.blueAccent.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else if (dateController.text.isNotEmpty && receivedUsersList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'No payments received for the selected month and year.',
                              style: TextStyle(
                                color: Colors.blueAccent.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: receivedUsersList.toSet().length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListTile(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                tileColor: Colors.blueAccent.shade700,
                                leading: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                title: Text(
                                  receivedUsersList.toSet().toList()[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
