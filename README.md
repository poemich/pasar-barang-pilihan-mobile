# Pasar Barang Pilihan Mobile

## Tugas 7

1. **Jelaskan apa yang dimaksud dengan stateless widget dan stateful widget, dan jelaskan perbedaan dari keduanya.**  
   - **Stateless Widget**: merupakan widget yang tidak memiliki state dan tidak berubah selama aplikasi berjalan. Widget ini menerima input dari widget induk dan tidak memiliki variabel yang bisa berubah seiring waktu. Contohnya adalah widget `Text` atau `Icon`.
   - **Stateful Widget**: widget yang memiliki state dan bisa berubah-ubah saat aplikasi berjalan. Stateful widget bergantung pada class State untuk menangani perubahan yang terjadi. Contoh umum adalah widget `TextField` atau `Checkbox`, yang dapat berubah sesuai input pengguna.

   **Perbedaan utama** antara keduanya adalah pada kemampuan untuk mempertahankan state. Stateless widget bersifat statis, sedangkan stateful widget dapat beradaptasi dan berubah berdasarkan interaksi pengguna.

2. **Sebutkan widget apa saja yang kamu gunakan pada proyek ini dan jelaskan fungsinya.**
   - **Scaffold**: Menyediakan struktur dasar halaman dengan AppBar dan body.
   - **AppBar**: Bagian atas halaman yang menampilkan judul aplikasi.
   - **Column**: Untuk menyusun widget secara vertikal, seperti teks dan grid item.
   - **Row**: Untuk menampilkan beberapa `InfoCard` secara horizontal.
   - **GridView**: Menampilkan daftar widget `ItemCard` dalam bentuk grid dengan beberapa kolom.
   - **Card**: Menyediakan tampilan seperti kartu dengan bayangan untuk informasi `NPM`, `Name`, dan `Class`.
   - **Icon dan Text**: Menampilkan ikon dan teks pada kartu.
   - **InkWell**: Menangani interaksi tap pada item, seperti menampilkan `SnackBar` ketika tombol ditekan.

3. **Apa fungsi dari setState()? Jelaskan variabel apa saja yang dapat terdampak dengan fungsi tersebut.**  
   `setState()` digunakan pada stateful widget untuk memberitahu Flutter bahwa ada perubahan pada state yang memerlukan update UI. Fungsi ini akan menjalankan ulang `build()` sehingga UI bisa diperbarui. Variabel-variabel yang terdampak adalah variabel yang mendefinisikan tampilan di dalam widget, contohnya variabel yang memuat informasi produk atau status login.

4. **Jelaskan perbedaan antara const dengan final.**  
   - **const**: Digunakan untuk nilai yang bersifat konstan secara waktu kompilasi (compile-time constant), artinya nilai tersebut harus sudah diketahui saat kompilasi.
   - **final**: Digunakan untuk variabel yang hanya dapat diinisialisasi sekali dan bersifat immutable, tetapi nilainya bisa ditentukan saat runtime.

5. **Jelaskan bagaimana cara kamu mengimplementasikan checklist-checklist di atas.**

   Berikut langkah-langkah implementasi aplikasi ini:

   - **Membuat Proyek Flutter Baru**
     1. Pertama, buat proyek Flutter dengan menjalankan perintah berikut:
        ```bash
        flutter create pasar_barang_pilihan
        cd pasar_barang_pilihan
        ```
     2. Atur struktur proyek dengan membuat dua file, yaitu `main.dart` dan `menu.dart` untuk memisahkan UI utama dan tampilan menu.

   - **Membangun Struktur Scaffold pada main.dart**
     ```dart
     import 'package:flutter/material.dart';
     import 'package:pasar_barang_pilihan/menu.dart';

     void main() {
       runApp(const MyApp());
     }

     class MyApp extends StatelessWidget {
       const MyApp({Key? key}) : super(key: key);

       @override
       Widget build(BuildContext context) {
         return MaterialApp(
           title: 'Pasar Barang Pilihan',
           theme: ThemeData(primarySwatch: Colors.blue),
           home: MyHomePage(),
         );
       }
     }
     ```

   - **Membangun Tampilan Utama di menu.dart**
     ```dart
     class MyHomePage extends StatelessWidget {
       final List<ItemHomepage> items = [
         ItemHomepage("Lihat Product", Icons.add_shopping_cart),
         ItemHomepage("Tambah Product", Icons.add),
         ItemHomepage("Logout", Icons.logout),
       ];

       @override
       Widget build(BuildContext context) {
         return Scaffold(
           appBar: AppBar(
             title: const Text('Pasar Barang Pilihan'),
           ),
           body: Padding(
             padding: const EdgeInsets.all(16.0),
             child: Column(
               children: [
                 Row(
                   children: [
                     InfoCard(title: 'NPM', content: '2306245011'),
                     InfoCard(title: 'Name', content: 'Muhammad Fadhlan Karimuddin'),
                     InfoCard(title: 'Class', content: 'PBP F'),
                   ],
                 ),
                 Expanded(
                   child: GridView.count(
                     crossAxisCount: 3,
                     children: items.map((item) => ItemCard(item)).toList(),
                   ),
                 ),
               ],
             ),
           ),
         );
       }
     }
     ```

   - **Menambahkan Interaksi pada Item Card**
     Setiap kartu memiliki `InkWell` untuk mendeteksi klik dan menampilkan `SnackBar`:
     ```dart
     class ItemCard extends StatelessWidget {
       final ItemHomepage item;

       const ItemCard(this.item, {Key? key}) : super(key: key);

       @override
       Widget build(BuildContext context) {
         return Material(
           color: Theme.of(context).colorScheme.secondary,
           borderRadius: BorderRadius.circular(12),
           child: InkWell(
             onTap: () {
               ScaffoldMessenger.of(context)
                 ..hideCurrentSnackBar()
                 ..showSnackBar(
                   SnackBar(content: Text("Kamu telah menekan tombol ${item.name}"))
                 );
             },
             child: Column(
               children: [
                 Icon(item.icon, color: Colors.white, size: 30),
                 Text(item.name, style: const TextStyle(color: Colors.white)),
               ],
             ),
           ),
         );
       }
     }
     ```

### **Referensi**

- **Layouts and Forms**:

  - https://scele.cs.ui.ac.id/pluginfile.php/240691/mod_resource/content/2/09%20-%20Layouts%20and%20Forms.pdf

- **Flutter Documentation**:

  - https://docs.flutter.dev/