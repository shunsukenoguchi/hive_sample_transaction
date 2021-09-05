import 'package:flutter/material.dart';
import 'package:hive_sample_transaction/boxes.dart';

import '../model/transaction.dart';

class Register extends StatefulWidget {
  final Transaction? transaction;
  final Function(String name, int age) onClickedDone;

  Register({
    Key? key,
    this.transaction,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction!;

      nameController.text = transaction.name;
      ageController.text = transaction.age.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Expense Tracker'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildAge(),
              SizedBox(height: 8),
              buildAddButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildAge() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Amount',
        ),
        keyboardType: TextInputType.number,
        validator: (age) => age != null && double.tryParse(age) == null
            ? 'Enter a valid number'
            : null,
        controller: ageController,
      );
  Widget buildAddButton(BuildContext context) {
    return TextButton(
      child: Text('add'),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final age = int.tryParse(ageController.text) ?? 0;

          widget.onClickedDone(name, age);

          Navigator.of(context).pop();
        }
      },
    );
  }
}

Future addTransaction(String name, int age) async {
  final transaction = Transaction()
    ..name = name
    ..age = age;

  final box = Boxes.getTransactions();
  box.add(transaction);
  //box.put('mykey', transaction);

  // final mybox = Boxes.getTransactions();
  // final myTransaction = mybox.get('key');
  // mybox.values;
  // mybox.keys;
}

void editTransaction(
  Transaction transaction,
  String name,
  int age,
) {
  transaction.name = name;
  transaction.age = age;

  // final box = Boxes.getTransactions();
  // box.put(transaction.key, transaction);

  transaction.save();
}

void deleteTransaction(Transaction transaction) {
  // final box = Boxes.getTransactions();
  // box.delete(transaction.key);

  transaction.delete();
  //setState(() => transactions.remove(transaction));
}
