import 'package:flutter/material.dart';
import 'package:notes/helper/database_helper.dart';

import '../model/note_model.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notesList = [];
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    List<Note> notes = await _databaseHelper.getAllNotes();
    setState(() {
      _notesList = notes;
    });
  }

  void _saveNote(Note note) async {
    await _databaseHelper.insert(note);
    _loadNotes();
  }

  void _updateNote(Note note) async {
    await _databaseHelper.update(note);
    _loadNotes();
  }

  void _deleteNote(int id) async {
    await _databaseHelper.delete(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notesList.length,
        itemBuilder: (context, index) {
          Note note = _notesList[index];
          return InkWell(
            onTap: () {
              _editNote(note);
            },
            child: ListTile(
              title: Text(note.title.toString()),
              subtitle: Text(note.content.toString()),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteNote(note.id!);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNoteDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showNoteDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String content = contentController.text;
                if (title.isNotEmpty && content.isNotEmpty) {
                  Note note = Note(title: title, content: content);
                  _saveNote(note);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editNote(Note note) {
    TextEditingController titleController =
        TextEditingController(text: note.title);
    TextEditingController contentController =
        TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String content = contentController.text;
                if (title.isNotEmpty && content.isNotEmpty) {
                  note.title = title;
                  note.content = content;
                  _updateNote(note);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
