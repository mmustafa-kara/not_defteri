import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/db_helper.dart';
import '../utils/app_theme.dart';
import '../utils/date_formatter.dart';
import '../widgets/glowing_fab.dart';
import '../widgets/starfield_painter.dart';
import '../widgets/bouncing_astronaut.dart';
import 'add_edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  List<String> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    setState(() => isLoading = true);
    final cats = await DatabaseHelper.instance.getCategories();
    final allNotes = await DatabaseHelper.instance.getNotes();
    setState(() {
      categories = cats.map((c) => c.name).toList();
      notes = allNotes.where((n) => categories.contains(n.categoryName)).toList();
      isLoading = false;
    });
  }

  Future<void> _deleteCategory(String categoryName) async {
    await DatabaseHelper.instance.deleteCategory(categoryName);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$categoryName kategorisi ve notları silindi.')),
      );
    }
    refreshData();
  }

  Future<void> _deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    refreshData();
  }

  Future<void> _showAddCategoryDialog() async {
    final TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Kategori Ekle'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Kategori adı'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  await DatabaseHelper.instance.createCategory(name);
                  if (mounted) {
                    Navigator.pop(context);
                    refreshData();
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.electricBlue),
              child: const Text('Ekle', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final priorityColor = AppTheme.getPriorityColor(note.priority);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: priorityColor.withValues(alpha: 0.8), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: priorityColor.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: Colors.white.withValues(alpha: 0.05),
                child: ExpansionTile(
                  iconColor: priorityColor,
                  collapsedIconColor: Colors.white70,
                  title: Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.all(16.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.neonPurple.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.neonPurple.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            note.categoryName,
                            style: const TextStyle(color: AppTheme.neonPurple, fontSize: 12),
                          ),
                        ),
                        Text(
                          DateFormatter.format(note.createdAt),
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        note.content,
                        style: const TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          label: const Text('Sil', style: TextStyle(color: Colors.redAccent)),
                          onPressed: () => _deleteNote(note.id!),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Güncelle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.electricBlue.withValues(alpha: 0.8),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditNoteScreen(note: note),
                              ),
                            );
                            refreshData();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOT SEPETI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Yeni Kategori Ekle',
            onPressed: _showAddCategoryDialog,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.category),
            color: const Color(0xFF151515),
            onSelected: (String result) {},
            itemBuilder: (BuildContext context) {
              return categories.map((String categoryName) {
                return PopupMenuItem<String>(
                  value: categoryName,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(categoryName, style: const TextStyle(color: Colors.white)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteCategory(categoryName);
                        },
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.electricBlue))
          : Stack(
              children: [
                // Layer 1: Static Starfield
                Positioned.fill(
                  child: CustomPaint(
                    painter: StarfieldPainter(numStars: 150),
                  ),
                ),
                // Layer 2: Bouncing Astronaut (Disappears if >= 7 notes)
                if (notes.length < 7)
                  const Positioned.fill(
                    child: BouncingAstronaut(),
                  ),
                // Layer 3: Minimalist Empty State Text
                if (notes.isEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: Text(
                          'İlk notunu uzay boşluğuna bırak...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 16,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Layer 4: Notes List
                Positioned.fill(
                  child: _buildNotesList(),
                ),
              ],
            ),
      floatingActionButton: GlowingFAB(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
          refreshData();
        },
      ),
    );
  }
}
