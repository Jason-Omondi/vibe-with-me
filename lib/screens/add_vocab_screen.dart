import 'package:flutter/material.dart';

class AddVocabScreen extends StatelessWidget {
  const AddVocabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey();
    TextEditingController _wordController = TextEditingController();
    TextEditingController _definitionController = TextEditingController();
    TextEditingController _exampleController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vocabulary'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Word'),
              controller: _wordController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Definition'),
              controller: _definitionController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Example Sentence'),
              controller: _exampleController,
            ),
          ],
        ),
      ),
    );
  }
}
