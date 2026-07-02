import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/db_helper.dart';
import '../utils/app_theme.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  
  String? _selectedCategory;
  String? _selectedPriority;

  List<String> _categories = [];
  final List<String> _priorities = ['Acil', 'Önemli', 'Normal', 'Az Önemli'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedPriority = widget.note?.priority ?? _priorities.first;
    
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await DatabaseHelper.instance.getCategories();
    setState(() {
      _categories = cats.map((c) => c.name).toList();
      if (_categories.isNotEmpty) {
        if (widget.note != null && _categories.contains(widget.note!.categoryName)) {
          _selectedCategory = widget.note!.categoryName;
        } else {
          _selectedCategory = _categories.first;
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        categoryName: _selectedCategory!,
        priority: _selectedPriority!,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
      );

      if (widget.note == null) {
        await DatabaseHelper.instance.createNote(note);
      } else {
        await DatabaseHelper.instance.updateNote(note);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppTheme.electricBlue),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppTheme.neonPurple, width: 1.5),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppTheme.electricBlue, width: 2.5),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 2.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Yeni Not' : 'Notu Güncelle'),
      ),
      body: _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: _buildInputDecoration('Kategori'),
                      dropdownColor: const Color(0xFF151515),
                      items: _categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedCategory = val);
                      },
                      validator: (val) => val == null ? 'Kategori seçmelisiniz' : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: _buildInputDecoration('Başlık'),
                      validator: (val) => val == null || val.isEmpty ? 'Başlık boş olamaz' : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white70),
                      decoration: _buildInputDecoration('İçerik'),
                      validator: (val) => val == null || val.isEmpty ? 'İçerik boş olamaz' : null,
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: _buildInputDecoration('Öncelik Durumu'),
                      dropdownColor: const Color(0xFF151515),
                      items: _priorities.map((priority) {
                        return DropdownMenuItem(
                          value: priority, 
                          child: Text(
                            priority, 
                            style: TextStyle(color: AppTheme.getPriorityColor(priority)),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedPriority = val);
                      },
                    ),
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.neonPurple,
                            side: const BorderSide(color: AppTheme.neonPurple),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: const Text('Vazgeç', style: TextStyle(fontSize: 16)),
                        ),
                        ElevatedButton(
                          onPressed: _saveNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.electricBlue,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shadowColor: AppTheme.electricBlue,
                            elevation: 10,
                          ),
                          child: const Text('Kaydet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
