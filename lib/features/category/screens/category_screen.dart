import 'package:flutter/material.dart';
import 'package:mobile/features/category/model/category_model.dart';
import 'package:mobile/features/category/services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _categoryService = CategoryService();
  final TextEditingController _controller = TextEditingController();
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    _categories = await _categoryService.fetchCategories();
    setState(() => _isLoading = false);
  }

  Future<void> _addCategory() async {
    if (_controller.text.isEmpty) return;
    await _categoryService.addCategory(_controller.text);
    _controller.clear();
    await _loadCategories();
  }

  Future<void> _deleteCategory(int id) async {
    await _categoryService.deleteCategory(id);
    await _loadCategories();
  }

  Future<void> _showUpdateDialog(Category category) async {
    final TextEditingController _editController = TextEditingController(
      text: category.name,
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Kategori Güncelle"),
            content: TextField(controller: _editController),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _categoryService.updateCategory(
                    category.id,
                    _editController.text,
                  );
                  await _loadCategories();
                },
                child: const Text("Güncelle"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategoriler")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: "Kategori adı",
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addCategory,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (_, index) {
                        final category = _categories[index];
                        return ListTile(
                          title: Text(category.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showUpdateDialog(category),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteCategory(category.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
