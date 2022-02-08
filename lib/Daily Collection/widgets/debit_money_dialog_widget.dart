import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebitMoneyDialogWidget extends StatefulWidget {
  const DebitMoneyDialogWidget({Key? key}) : super(key: key);

  @override
  _DebitMoneyDialogWidgetState createState() => _DebitMoneyDialogWidgetState();
}

class _DebitMoneyDialogWidgetState extends State<DebitMoneyDialogWidget> {
  DateTime selectedDate = DateTime.now();
  late TextEditingController amountController;
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
        String date = DateFormat('EEE, dd/MMM/y').format(selectedDate);
        dateController.text = date;
      });
    }
  }

  @override
  void initState() {
    amountController = TextEditingController();
    dateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Debit Money',
        style: TextStyle(color: Colors.blueAccent.shade400),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amountController,
            maxLength: 7,
            cursorColor: Colors.white,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Colors.blueAccent.shade700,
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                borderSide: BorderSide.none,
              ),
              hintText: 'Debit Amount',
              hintStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              counterStyle: TextStyle(
                  color: Colors.blueAccent.shade700, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
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
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(
              {'Date': dateController.text, 'Amount': amountController.text},
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text('Debit Money'),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent.shade700),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
