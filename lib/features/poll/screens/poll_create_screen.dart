// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mobile/features/poll/models/poll_create_dto.dart';
// import 'package:mobile/features/poll/models/question_create_dto.dart';
// import 'package:mobile/features/poll/models/option_create_dto.dart';
// import 'package:mobile/features/poll/providers/poll_provider.dart';
// import 'package:mobile/features/poll/models/question_detail_dto.dart';

// class CreatePollScreen extends StatefulWidget {
//   const CreatePollScreen({Key? key}) : super(key: key);

//   @override
//   _CreatePollScreenState createState() => _CreatePollScreenState();
// }

// class _CreatePollScreenState extends State<CreatePollScreen> {
//   final _formKey = GlobalKey<FormState>();
  
//   // Form değerleri
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   DateTime? _expiryDate;
//   bool _isActive = true;
//   int? _selectedCategoryId;
  
//   // Kategori listesi (API'den çekilmeli)
//   final List<DropdownMenuItem<int>> _categoryItems = [
//     const DropdownMenuItem(value: 1, child: Text('Genel')),
//     const DropdownMenuItem(value: 2, child: Text('İş')),
//     const DropdownMenuItem(value: 3, child: Text('Eğitim')),
//     // Diğer kategoriler...
//   ];
  
//   // Sorular listesi
//   List<QuestionItem> _questions = [];

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pollProvider = Provider.of<PollProvider>(context);
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Yeni Anket Oluştur'),
//       ),
//       body: pollProvider.isLoading 
//         ? const Center(child: CircularProgressIndicator())
//         : SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Hata mesajı gösterimi
//                   if (pollProvider.errorMessage != null)
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       color: Colors.red.shade100,
//                       child: Text(
//                         pollProvider.errorMessage!,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     ),
                  
//                   // Anket başlığı
//                   TextFormField(
//                     controller: _titleController,
//                     decoration: const InputDecoration(
//                       labelText: 'Anket Başlığı *',
//                       hintText: 'Anket başlığını girin',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Lütfen anket başlığı girin';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
                  
//                   // Anket açıklaması
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Anket Açıklaması',
//                       hintText: 'Anket açıklamasını girin (opsiyonel)',
//                     ),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 16),
                  
//                   // Kategori seçimi
//                   DropdownButtonFormField<int>(
//                     decoration: const InputDecoration(
//                       labelText: 'Kategori *',
//                       hintText: 'Bir kategori seçin',
//                     ),
//                     value: _selectedCategoryId,
//                     items: _categoryItems,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedCategoryId = value;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Lütfen bir kategori seçin';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
                  
//                   // Bitiş tarihi seçimi
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           _expiryDate == null
//                               ? 'Bitiş Tarihi Seçilmedi'
//                               : 'Bitiş Tarihi: ${_formatDate(_expiryDate!)}',
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () => _selectExpiryDate(context),
//                         child: const Text('Tarih Seç'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
                  
//                   // Aktif/Pasif seçimi
//                   CheckboxListTile(
//                     title: const Text('Anket Aktif'),
//                     value: _isActive,
//                     onChanged: (value) {
//                       setState(() {
//                         _isActive = value ?? true;
//                       });
//                     },
//                     contentPadding: EdgeInsets.zero,
//                   ),
                  
//                   const Divider(height: 32),
                  
//                   // Sorular başlığı
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Sorular',
//                         style: TextStyle(
//                           fontSize: 18, 
//                           fontWeight: FontWeight.bold
//                         ),
//                       ),
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.add),
//                         label: const Text('Soru Ekle'),
//                         onPressed: _addNewQuestion,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
                  
//                   // Soru listesi
//                   ..._buildQuestionsList(),
                  
//                   const SizedBox(height: 32),
                  
//                   // Kaydet butonu
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _questions.isEmpty ? null : () => _submitForm(context),
//                       child: const Text('Anketi Kaydet'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//     );
//   }

//   // Soru