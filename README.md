# Pasar Barang Pilihan Mobile

## Tugas 9

1. **Jelaskan mengapa kita perlu membuat model untuk melakukan pengambilan ataupun pengiriman data JSON? Apakah akan terjadi error jika kita tidak membuat model terlebih dahulu?**

   Membuat model dalam aplikasi Flutter sangat penting untuk beberapa alasan:

   - **Type Safety:** Dengan model, kita dapat memastikan bahwa data yang diterima atau dikirim memiliki tipe yang sesuai. Ini membantu mencegah error runtime yang disebabkan oleh tipe data yang tidak sesuai.
   
   - **Kemudahan Akses Data:** Model memudahkan akses dan manipulasi data. Alih-alih bekerja dengan `Map<String, dynamic>`, kita dapat mengakses properti langsung melalui objek model.
   
   - **Maintainability:** Model membuat kode lebih terstruktur dan mudah dipelihara. Jika struktur data JSON berubah, kita hanya perlu memperbarui model yang relevan.
   
   - **Autocomplete dan Refactoring:** IDE seperti VSCode atau Android Studio menyediakan fitur autocomplete dan refactoring yang lebih baik ketika menggunakan model, meningkatkan produktivitas pengembang.

   Jika kita tidak membuat model dan langsung bekerja dengan `Map<String, dynamic>`, beberapa masalah yang mungkin terjadi meliputi:

   - **Kesalahan Tipe Data:** Tanpa model, kesalahan tipe data tidak akan terdeteksi hingga runtime, yang dapat menyebabkan aplikasi crash.
   
   - **Kode yang Tidak Terstruktur:** Menggunakan map secara langsung membuat kode menjadi kurang terstruktur dan sulit dibaca.
   
   - **Kurangnya Dukungan IDE:** Kesalahan ketik atau perubahan struktur data tidak akan ditangkap oleh IDE, meningkatkan kemungkinan bug.

   **Contoh Model dalam `product_entry.dart`:**
   ```dart
   import 'dart:convert';
   
   class ProductEntry {
       String model;
       String pk;
       Fields fields;
   
       ProductEntry({
           required this.model,
           required this.pk,
           required this.fields,
       });
   
       factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
           model: json["model"],
           pk: json["pk"],
           fields: Fields.fromJson(json["fields"]),
       );
   
       Map<String, dynamic> toJson() => {
           "model": model,
           "pk": pk,
           "fields": fields.toJson(),
       };
   }
   
   class Fields {
       int user;
       String name;
       DateTime time;
       int price;
       String description;
   
       Fields({
           required this.user,
           required this.name,
           required this.time,
           required this.price,
           required this.description,
       });
   
       factory Fields.fromJson(Map<String, dynamic> json) => Fields(
           user: json["user"],
           name: json["name"],
           time: DateTime.parse(json["time"]),
           price: json["price"],
           description: json["description"],
       );
   
       Map<String, dynamic> toJson() => {
           "user": user,
           "name": name,
           "time": "${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}",
           "price": price,
           "description": description,
       };
   }
   ```

2. **Jelaskan fungsi dari library http yang sudah kamu implementasikan pada tugas ini**

   Library `http` digunakan untuk melakukan komunikasi antara aplikasi Flutter dengan backend Django melalui HTTP requests. Fungsi utamanya meliputi:

   - **Pengambilan Data (GET):** Mengambil data dari server, seperti daftar produk yang tersedia.
   
   - **Pengiriman Data (POST):** Mengirim data ke server, seperti saat menambahkan produk baru atau melakukan autentikasi pengguna.
   
   - **Handling Response:** Mengelola respons yang diterima dari server, baik itu data yang diminta atau status sukses/gagal dari operasi yang dilakukan.

   **Implementasi dalam `list_productentry.dart`:**
   ```dart
   Future<List<ProductEntry>> fetchProduct(CookieRequest request) async {
     // Mengirim GET request ke endpoint JSON
     final response = await request.get('http://10.0.2.2:8000/json/');
     
     // Mengonversi response menjadi objek JSON
     var data = jsonDecode(utf8.decode(response.bodyBytes));
     
     // Mengonversi JSON ke dalam list model ProductEntry
     List<ProductEntry> listProduct = [];
     for (var d in data) {
       if (d != null) {
         listProduct.add(ProductEntry.fromJson(d));
       }
     }
     return listProduct;
   }
   ```

   **Implementasi dalam `login.dart`:**
   ```dart
   ElevatedButton(
     onPressed: () async {
       String username = _usernameController.text;
       String password = _passwordController.text;
       
       // Mengirim POST request untuk login
       final response = await request.login(
         "http://10.0.2.2:8000/auth/login/", {
           'username': username,
           'password': password,
         });
       
       if (request.loggedIn) {
         // Menangani response sukses
       } else {
         // Menangani response gagal
       }
     },
     child: const Text('Login'),
   ),
   ```

3. **Jelaskan fungsi dari CookieRequest dan jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.**

   `CookieRequest` adalah sebuah kelas yang digunakan untuk mengelola autentikasi dan session cookies dalam aplikasi Flutter. Dengan menggunakan `CookieRequest`, kita dapat mengirim HTTP requests yang menyertakan cookies yang diperlukan untuk menjaga sesi autentikasi pengguna.

   **Fungsi `CookieRequest`:**
   
   - **Manajemen Autentikasi:** Menyimpan informasi autentikasi pengguna, seperti token atau session cookies.
   - **Pengiriman Requests Berkelanjutan:** Memastikan bahwa setiap HTTP request yang dikirim ke server menyertakan cookies yang diperlukan untuk autentikasi.
   - **Penanganan Cookies Secara Otomatis:** Otomatis menyimpan dan mengirim kembali cookies yang diterima dari server tanpa perlu penanganan manual.

   **Mengapa Instance `CookieRequest` Perlu Dibagikan ke Semua Komponen:**
   
   - **Konsistensi Sesi:** Dengan membagikan satu instance `CookieRequest` ke seluruh komponen, memastikan bahwa semua permintaan HTTP menggunakan session yang sama, menjaga konsistensi sesi pengguna di seluruh aplikasi.
   - **Efisiensi:** Menghindari duplikasi cookies dan mengoptimalkan pengelolaan autentikasi dengan satu sumber pengelolaan.
   - **Pengelolaan State yang Mudah:** Memudahkan pengaturan state autentikasi, karena semua bagian aplikasi mengakses state melalui instance `CookieRequest` yang sama.

   **Contoh Implementasi dalam `main.dart`:**
   ```dart
   import 'package:pbp_django_auth/pbp_django_auth.dart';
   import 'package:provider/provider.dart';
   
   void main() {
     runApp(
       Provider(
         create: (_) => CookieRequest(),
         child: const MyApp(),
       ),
     );
   }
   ```

4. **Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.**

   Mekanisme pengiriman data dalam aplikasi Flutter melibatkan beberapa langkah mulai dari input data oleh pengguna hingga data tersebut ditampilkan di antarmuka. Berikut adalah langkah-langkahnya:

   1. **Input Data oleh Pengguna:**
      Pengguna memasukkan data melalui widget input seperti `TextFormField` pada halaman form.
      ```dart
      TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(labelText: 'Username'),
        // ...
      ),
      TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
      ),
      ```
   
   2. **Validasi Data:**
      Data yang dimasukkan divalidasi untuk memastikan bahwa input memenuhi kriteria tertentu, seperti tidak kosong atau format yang benar.
      ```dart
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong!';
        }
        return null;
      },
      ```
   
   3. **Mengirim Data ke Backend:**
      Setelah validasi berhasil, data dikirim ke backend (Django) menggunakan HTTP POST request dengan bantuan `CookieRequest`.
      ```dart
      final response = await request.postJson(
          "http://10.0.2.2:8000/auth/register/",
          jsonEncode({
            "username": username,
            "password1": password1,
            "password2": password2,
          }));
      ```
   
   4. **Processing di Backend Django:**
      Django menerima data, memprosesnya (misalnya, menyimpan ke database), dan mengirimkan respons yang sesuai kembali ke aplikasi Flutter.
   
   5. **Handling Respons di Flutter:**
      Aplikasi Flutter menerima respons dari Django. Jika sukses, data dapat ditampilkan atau navigasi ke halaman lain; jika gagal, menampilkan pesan error kepada pengguna.
      ```dart
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully registered!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register!')),
        );
      }
      ```
   
   6. **Menampilkan Data dalam UI:**
      Data yang berhasil dikirim dan diproses dapat ditampilkan menggunakan widget seperti `FutureBuilder` dan `ListView.builder`.
      ```dart
      FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Text('Belum ada data produk.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => ListTile(
                title: Text(snapshot.data![index].fields.name),
                subtitle: Text(snapshot.data![index].fields.description),
              ),
            );
          }
        },
      )
      ```

5. **Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.**

   Mekanisme autentikasi dalam aplikasi ini meliputi tiga tahap utama: registrasi, login, dan logout. Berikut adalah penjelasan lengkapnya:

   **a. Registrasi Akun:**
   
   1. **Input Data oleh Pengguna:**
      Pengguna mengisi form registrasi dengan username, password, dan konfirmasi password melalui widget `TextFormField`.
      ```dart
      TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(labelText: 'Username'),
      ),
      TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
      ),
      TextFormField(
        controller: _confirmPasswordController,
        decoration: InputDecoration(labelText: 'Confirm Password'),
        obscureText: true,
      ),
      ```
   
   2. **Validasi Data:**
      Memastikan bahwa password dan konfirmasi password cocok dan memenuhi kriteria keamanan.
      ```dart
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }
      ```
   
   3. **Mengirim Data ke Django:**
      Data dikirim ke endpoint registrasi Django menggunakan HTTP POST request.
      ```dart
      final response = await request.postJson(
          "http://10.0.2.2:8000/auth/register/",
          jsonEncode({
            "username": username,
            "password1": password1,
            "password2": password2,
          }));
      ```
   
   4. **Processing di Backend Django:**
      Django menerima data, melakukan validasi dan penyimpanan ke database, kemudian mengirimkan respons.
   
   5. **Handling Respons di Flutter:**
      Jika registrasi berhasil, pengguna diarahkan ke halaman login; jika gagal, menampilkan pesan error.
      ```dart
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully registered!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register!')),
        );
      }
      ```

   **b. Login Akun:**
   
   1. **Input Data oleh Pengguna:**
      Pengguna mengisi form login dengan username dan password.
      ```dart
      TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(labelText: 'Username'),
      ),
      TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
      ),
      ```
   
   2. **Mengirim Data ke Django:**
      Data dikirim ke endpoint login Django menggunakan metode `login` dari `CookieRequest`.
      ```dart
      final response = await request.login(
          "http://10.0.2.2:8000/auth/login/", {
            'username': username,
            'password': password,
          });
      ```
   
   3. **Processing di Backend Django:**
      Django memverifikasi kredensial dan mengirimkan respons autentikasi.
   
   4. **Handling Respons di Flutter:**
      Jika autentikasi berhasil, aplikasi akan mengarahkan pengguna ke halaman utama dan menampilkan pesan selamat datang; jika gagal, menampilkan pesan error.
      ```dart
      if (request.loggedIn) {
        String message = response['message'];
        String uname = response['username'];
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("$message Selamat datang, $uname.")),
            );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Gagal'),
            content: Text(response['message']),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
      ```

   **c. Logout Akun:**
   
   1. **Pengguna Menekan Tombol Logout:**
      Pengguna mengakses opsi logout melalui `LeftDrawer` atau widget lain.
      ```dart
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          // Implementasi logout
        },
      ),
      ```
   
   2. **Mengirim Permintaan Logout ke Django:**
      Data autentikasi dibersihkan dan session dihapus.
      ```dart
      final response = await request.logout("http://10.0.2.2:8000/auth/logout/");
      ```
   
   3. **Processing di Backend Django:**
      Django menghapus session atau token autentikasi dan mengirimkan respons logout.
   
   4. **Handling Respons di Flutter:**
      Setelah logout berhasil, aplikasi akan mengarahkan pengguna kembali ke halaman login dan membersihkan state autentikasi.
      ```dart
      if (response['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully logged out!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to logout!')),
        );
      }
      ```

6. **Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).**

   Implementasi checklist dilakukan dengan langkah-langkah berikut:

   1. **Integrasi Autentikasi Django-Flutter:**
      - **Provider Setup:** Menggunakan `Provider` untuk menyediakan instance `CookieRequest` ke seluruh widget dalam aplikasi Flutter.
        ```dart
        // main.dart
        Provider(
          create: (_) => CookieRequest(),
          child: MaterialApp(
            // ...
          ),
        );
        ```
      - **Halaman Login:** Membuat halaman login dengan `TextFormField` untuk input username dan password, serta `ElevatedButton` untuk aksi login.
      - **Koneksi ke Django:** Menghubungkan form login dengan endpoint Django menggunakan metode `login` dari `CookieRequest`.

   2. **Pembuatan Model Custom:**
      - **Generate Model:** Mengenerate kelas model dari respons JSON menggunakan tool seperti `quicktype.io`.
      - **Implementasi `fromJson` dan `toJson`:** Menambahkan metode `fromJson` dan `toJson` dalam kelas model untuk mempermudah konversi data.
        ```dart
        // product_entry.dart
        class ProductEntry {
          String model;
          String pk;
          Fields fields;

          ProductEntry({required this.model, required this.pk, required this.fields});

          factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
                model: json["model"],
                pk: json["pk"],
                fields: Fields.fromJson(json["fields"]),
              );

          Map<String, dynamic> toJson() => {
                "model": model,
                "pk": pk,
                "fields": fields.toJson(),
              };
        }
        ```

   3. **Integrasi Form Flutter-Django:**
      - **Form Input Produk:** Membuat form input produk dengan widget `TextFormField` untuk nama, deskripsi, dan harga di `productentry_form.dart`.
      - **Pengiriman Data:** Mengirim data produk ke Django melalui HTTP POST request menggunakan `request.postJson`.
        ```dart
        final response = await request.postJson(
            "http://10.0.2.2:8000/create-flutter/",
            jsonEncode({
              'product': _product,
              'price': _price,
              'description': _description,
            }));
        ```
      - **Handling Respons:** Menangani respons dari server untuk memastikan data berhasil disimpan atau menampilkan pesan error.
   
   4. **Implementasi Fitur Logout:**
      - **Endpoint Logout di Django:** Menambahkan endpoint logout di backend Django yang menghapus session atau token autentikasi.
      - **Fungsi Logout di Flutter:** Membuat fungsi logout di Flutter yang memanggil endpoint logout dan membersihkan state autentikasi.
      - **Navigasi setelah Logout:** Mengarahkan pengguna kembali ke halaman login setelah logout berhasil.
   
   5. **Membuat Halaman Daftar Produk:**
      - **`list_productentry.dart`:** Membuat halaman yang menampilkan daftar semua item dari endpoint JSON.
      - **Penggunaan `FutureBuilder` dan `ListView.builder`:** Menggunakan `FutureBuilder` untuk menunggu data dan `ListView.builder` untuk menampilkan list produk secara dinamis.
      - **Navigasi ke Halaman Detail:** Menambahkan fitur navigasi ke halaman detail produk ketika pengguna menekan salah satu item.
        ```dart
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                product: snapshot.data![index],
              ),
            ),
          );
        },
        ```
   
   6. **Membuat Halaman Detail Produk:**
      - **`product.dart`:** Membuat halaman detail yang menampilkan seluruh atribut dari produk yang dipilih.
      - **Tombol Kembali:** Menambahkan tombol untuk kembali ke halaman daftar produk.
        ```dart
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Kembali'),
        ),
        ```
   
   7. **Memfilter Item Berdasarkan Pengguna yang Login:**
      - **Query Berdasarkan User:** Memodifikasi fungsi fetch data untuk mengambil hanya produk yang terkait dengan pengguna yang sedang login.
        ```dart
        Future<List<ProductEntry>> fetchProduct(CookieRequest request) async {
          final response = await request.get('http://10.0.2.2:8000/json/?user=${request.username}');
          // ...
        }
        ```
   
   8. **Menyesuaikan UI dengan Widget dan Tema:**
      - **Pengaturan Tema:** Mengatur tema aplikasi menggunakan `ThemeData` dalam `main.dart` untuk konsistensi desain.
        ```dart
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: Colors.lightBlueAccent,
          ),
        ),
        ```
      - **Penggunaan Widget Bawaan:** Menggunakan widget seperti `InfoCard`, `AlertDialog`, dan `Scaffold` untuk membangun antarmuka yang intuitif.
   
   9. **Mengecek dan Memastikan Deployment Proyek:**
      - **Testing:** Melakukan testing untuk setiap fitur autentikasi dan CRUD data produk untuk memastikan semuanya berjalan dengan baik.
      - **Localhost Integration:** Menggunakan URL `http://10.0.2.2:8000/` untuk menghubungkan Flutter dengan backend Django pada emulator Android.

   Dengan mengikuti langkah-langkah tersebut, proyek aplikasi Flutter terintegrasi dengan backend Django dengan fitur autentikasi yang berfungsi penuh dan antarmuka pengguna yang responsif serta intuitif.

### Referensi
- [10 - Navigation, Networking, and Integration](https://scele.cs.ui.ac.id/pluginfile.php/241452/mod_resource/content/1/10%20-%20Navigation%2C%20Networking%2C%20and%20Integration.pdf)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Django REST framework](https://www.django-rest-framework.org/)