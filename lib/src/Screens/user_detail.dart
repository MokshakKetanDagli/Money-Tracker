import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';

import '../widgets/credit_money_dialog_widget.dart';
import '../widgets/debit_money_dialog_widget.dart';
import 'view_user_screen.dart';

class UserDetail extends StatelessWidget {
  final String userName;

  const UserDetail({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    CollectionReference users = FirebaseFirestore.instance.collection('New_Daily_Collection_350');
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('$userName\'s Account'.toUpperCase()),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetail(
                  userName: userName,
                ),
              ),
            ),
            icon: const Icon(
              Icons.refresh,
              size: 24,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(userName).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text("Document does not exist"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
            var accountTransactions =
                List<Map<String, dynamic>>.from(snapshot.data!.get('Account Transactions'));
            return Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (dialogContext) => const CreditMoneyDialogWidget(),
                              ).then(
                                (value) {
                                  if (value == null) {
                                    return ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Transaction Failed\nTry Again',
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor: Colors.blueAccent.shade700,
                                      ),
                                    );
                                  } else if (value['Date'] == '') {
                                    return ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Please select a date',
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor: Colors.blueAccent.shade700,
                                      ),
                                    );
                                  } else if (value['Amount'] == '') {
                                    return ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Please enter the amount',
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor: Colors.blueAccent.shade700,
                                      ),
                                    );
                                  } else {
                                    final int accountBalance =
                                        (userData['Closing Balance'] + int.parse(value['Amount']));
                                    final accountTransactions = List<Map<String, dynamic>>.from(
                                        userData['Account Transactions']);
                                    accountTransactions.insert(0, {
                                      'Date': value['Date'],
                                      'Amount': value['Amount'],
                                      'Type': 'Credit',
                                    });
                                    users.doc(userName).update({
                                      'Username': userData['Username'],
                                      'Phone Number': userData['Phone Number'],
                                      'Closing Balance': accountBalance,
                                      'Account Transactions': accountTransactions,
                                    }).whenComplete(
                                      () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Transaction Saved',
                                              style: TextStyle(
                                                  color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                            backgroundColor: Colors.blueAccent.shade700,
                                          ),
                                        );
                                        // await sendSMS(
                                        //   message:
                                        //       '(${accountTransactions.where((element) => element["Type"] == "Credit").length}) : Payment Received for ${DateFormat.yMMM().format(DateFormat("EEE, dd/MMM/y").parse(value['Date'])).toString()} Rs ${value['Amount']}',
                                        //   recipients: [userData['Phone Number']],
                                        //   sendDirect: true,
                                        // );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserDetail(
                                              userName: userName,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              );
                            },
                            child: Chip(
                              backgroundColor: Colors.blueAccent.shade700,
                              label: const Text(
                                'CREDIT MONEY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (dialogContext) => const DebitMoneyDialogWidget(),
                            ).then(
                              (value) {
                                if (value == null) {
                                  return ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Transaction Failed\nTry Again Later',
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.blueAccent.shade700,
                                    ),
                                  );
                                } else if (value['Date'] == '') {
                                  return ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Please select a date',
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.blueAccent.shade700,
                                    ),
                                  );
                                } else if (value['Amount'] == '') {
                                  return ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Please enter the amount',
                                        style: TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.blueAccent.shade700,
                                    ),
                                  );
                                } else {
                                  final int accountBalance =
                                      (userData['Closing Balance'] - int.parse(value['Amount']));
                                  final accountTransactions = List<Map<String, dynamic>>.from(
                                      userData['Account Transactions']);
                                  accountTransactions.insert(0, {
                                    'Date': value['Date'],
                                    'Amount': value['Amount'],
                                    'Type': 'Debit',
                                  });
                                  users.doc(userName).update({
                                    'Username': userData['Username'],
                                    'Phone Number': userData['Phone Number'],
                                    'Closing Balance': accountBalance,
                                    'Account Transactions': accountTransactions,
                                  }).whenComplete(
                                    () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Transaction Saved',
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.blueAccent.shade700,
                                        ),
                                      );
                                      // await sendSMS(
                                      //   message:
                                      //       '(${accountTransactions.where((element) => element["Type"] == "Debit").length}) : Paid on ${DateFormat.yMEd().format(DateFormat("EEE, dd/MMM/y").parse(value['Date'])).toString()} Rs ${value['Amount']}',
                                      //   recipients: [userData['Phone Number']],
                                      //   sendDirect: true,
                                      // );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserDetail(
                                            userName: userName,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            child: Chip(
                              backgroundColor: Colors.blueAccent.shade700,
                              label: const Text(
                                'DEBIT MONEY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Chip(
                            backgroundColor: Colors.blueAccent.shade700,
                            label: Text(
                              'BAL ₹ ${userData['Closing Balance']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: accountTransactions.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: accountTransactions[index]['Type'] == 'Credit'
                              ? GestureDetector(
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    tileColor: Colors.greenAccent.shade400,
                                    title: Text(
                                      'Day ${accountTransactions.length - index}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    subtitle: Text(
                                      '${accountTransactions[index]['Date']}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${accountTransactions[index]['Amount']}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25)),
                                                title: Text(
                                                  'Delete Transaction',
                                                  style: TextStyle(
                                                    color: Colors.blueAccent.shade400,
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      final accountTransactions =
                                                          List<Map<String, dynamic>>.from(
                                                              userData['Account Transactions']);
                                                      final int accountBalance =
                                                          (userData['Closing Balance'] -
                                                              int.parse(accountTransactions[index]
                                                                  ['Amount']));
                                                      accountTransactions.removeWhere((element) {
                                                        return element.containsKey('Type') &&
                                                            element.containsValue('Credit') &&
                                                            element.containsKey('Date') &&
                                                            element.containsValue(
                                                                accountTransactions[index]
                                                                    ['Date']) &&
                                                            element.containsKey('Amount') &&
                                                            element.containsValue(
                                                                accountTransactions[index]
                                                                    ['Amount']);
                                                      });
                                                      users.doc(userName).update({
                                                        'Username': userData['Username'],
                                                        'Phone Number': userData['Phone Number'],
                                                        'Closing Balance': accountBalance,
                                                        'Account Transactions': accountTransactions,
                                                      }).whenComplete(
                                                        () => {
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: const Text(
                                                                'Transaction Deleted',
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.blueAccent.shade700,
                                                            ),
                                                          ),
                                                          Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => UserDetail(
                                                                userName: userName,
                                                              ),
                                                            ),
                                                          )
                                                        },
                                                      );
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 15, vertical: 15),
                                                      child: Text('Yes'),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              Colors.blueAccent.shade700),
                                                      shape:
                                                          MaterialStateProperty.all<OutlinedBorder>(
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
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 15, vertical: 15),
                                                      child: Text('No'),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              Colors.blueAccent.shade700),
                                                      shape:
                                                          MaterialStateProperty.all<OutlinedBorder>(
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
                                )
                              : ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: Colors.redAccent.shade400,
                                  title: Text(
                                    'Day ${accountTransactions.length - index}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  subtitle: Text(
                                    '${accountTransactions[index]['Date']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${accountTransactions[index]['Amount']}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25)),
                                              title: Text(
                                                'Delete Transaction',
                                                style: TextStyle(
                                                  color: Colors.blueAccent.shade400,
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    final accountTransactions =
                                                        List<Map<String, dynamic>>.from(
                                                            userData['Account Transactions']);
                                                    final int accountBalance =
                                                        (userData['Closing Balance'] +
                                                            int.parse(accountTransactions[index]
                                                                ['Amount']));
                                                    accountTransactions.removeWhere((element) {
                                                      return element.containsKey('Type') &&
                                                          element.containsValue('Debit') &&
                                                          element.containsKey('Date') &&
                                                          element.containsValue(
                                                              accountTransactions[index]['Date']) &&
                                                          element.containsKey('Amount') &&
                                                          element.containsValue(
                                                              accountTransactions[index]['Amount']);
                                                    });
                                                    users.doc(userName).update({
                                                      'Username': userData['Username'],
                                                      'Phone Number': userData['Phone Number'],
                                                      'Closing Balance': accountBalance,
                                                      'Account Transactions': accountTransactions,
                                                    }).whenComplete(
                                                      () => {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                              'Transaction Deleted',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.blueAccent.shade700,
                                                          ),
                                                        ),
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const ViewUserScreen(),
                                                          ),
                                                        ),
                                                      },
                                                    );
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15, vertical: 15),
                                                    child: Text('Yes'),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            Colors.blueAccent.shade700),
                                                    shape:
                                                        MaterialStateProperty.all<OutlinedBorder>(
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
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15, vertical: 15),
                                                    child: Text('No'),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            Colors.blueAccent.shade700),
                                                    shape:
                                                        MaterialStateProperty.all<OutlinedBorder>(
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
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent.shade700,
            ),
          );
        },
      ),
    );
  }
}
