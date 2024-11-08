# Pasar Barang Pilihan Mobile

## Tugas 8

1. **Apa kegunaan `const` di Flutter? Jelaskan apa keuntungan ketika menggunakan `const` pada kode Flutter. Kapan sebaiknya kita menggunakan `const`, dan kapan sebaiknya tidak digunakan?**

   `const` digunakan untuk mendefinisikan nilai atau objek yang konstan pada waktu kompilasi, sehingga data tersebut tidak akan berubah selama aplikasi berjalan. Keuntungan dari penggunaan `const` adalah peningkatan performa aplikasi, karena objek `const` hanya dibuat sekali di memori, dan Flutter bisa menghindari pembuatan ulang objek tersebut.

   Penggunaan `const` pada kode:
   ```dart
   const Text(
     'Pasar Barang Pilihan',
     style: TextStyle(
       fontSize: 24,
       fontWeight: FontWeight.bold,
       color: Colors.white,
     ),
   );
   ```
   
   `const` digunakan jika data atau objek bersifat statis dan tidak akan berubah saat runtime, seperti teks tetap atau nilai konstan. Jangan menggunakan `const` jika data bergantung pada input pengguna atau berubah selama aplikasi berjalan.

2. **Jelaskan dan bandingkan penggunaan `Column` dan `Row` pada Flutter. Berikan contoh implementasi dari masing-masing layout widget ini!**

   `Column` digunakan untuk menyusun widget secara vertikal, sedangkan `Row` untuk menyusun secara horizontal. Keduanya memiliki properti seperti `mainAxisAlignment` dan `crossAxisAlignment` yang membantu dalam mengatur posisi dan jarak antara widget anak di dalamnya.

   Penggunaan `Column` dalam kode:
   ```dart
   ...
   child: Column(
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
   ...
   ```

   Penggunaan `Row`:
   ```dart
   ...
   Row(
     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
     children: [
       Icon(Icons.home_outlined),
       Icon(Icons.add_shopping_cart),
       Icon(Icons.logout),
     ],
   ),
   ...
   ```

3. **Sebutkan apa saja elemen input yang kamu gunakan pada halaman form yang kamu buat pada tugas kali ini. Apakah terdapat elemen input Flutter lain yang tidak kamu gunakan pada tugas ini? Jelaskan!**

   Elemen input yang digunakan pada halaman form adalah `TextFormField` untuk memasukkan nama produk, deskripsi, dan harga. Pada Flutter, tersedia elemen input lain seperti `Checkbox`, `Radio`, `Switch`, `Slider`, dan `DropdownButton` yang tidak digunakan pada tugas ini. Elemen-elemen tersebut akan cocok digunakan pada input pilihan 2 opsi, pilihan dari beberapa opsi, atau input rentang nilai.

   Penggunaan `TextFormField` pada kode:
   ```dart
   ...
   Padding(
     padding: const EdgeInsets.all(8.0),
     child: TextFormField(
       decoration: InputDecoration(
   ...
   ```

4. **Bagaimana cara kamu mengatur tema (theme) dalam aplikasi Flutter agar aplikasi yang dibuat konsisten? Apakah kamu mengimplementasikan tema pada aplikasi yang kamu buat?**

   Tema diatur menggunakan `ThemeData` pada `MaterialApp`, yang membantu menjaga konsistensi warna, font, dan gaya di seluruh aplikasi.

   Implementasi tema pada kode:
   ```dart
   ...
   theme: ThemeData(
     colorScheme: ColorScheme.fromSwatch(
       primarySwatch: Colors.blue,
     ).copyWith(
       secondary: Colors.lightBlueAccent,
     ),
     useMaterial3: true,
   ),
   ...
   ```

   Pada aplikasi yang saya buat, tema telah diterapkan untuk menjaga konsistensi visual di seluruh tampilan.

5. **Bagaimana cara kamu menangani navigasi dalam aplikasi dengan banyak halaman pada Flutter?**

   Navigasi dilakukan menggunakan widget `Navigator` dan metode `push`, `pop`, dan `pushReplacement()`. `LeftDrawer` berfungsi untuk navigasi aplikasi.

   Navigasi pada kode:
   ```dart
   ...
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => ProductEntryFormPage()),
   );
   ...
   ```
   ```dart
   ...
   onPressed: () {
    Navigator.pop(context);
   },
   ...
   ```
   ```dart
   ...
   Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => MyHomePage(),
    ),
   );
   ...
   ```


### Referensi
- [Dokumentasi Flutter](https://flutter.dev/docs)
- [09 - Layouts and Forms](https://scele.cs.ui.ac.id/pluginfile.php/240691/mod_resource/content/2/09%20-%20Layouts%20and%20Forms.pdf)