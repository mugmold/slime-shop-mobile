### Repo: https://github.com/mugmold/slime-shop-mobile

---

# Tugas 7

---

## "Jelaskan apa itu widget tree pada Flutter dan bagaimana hubungan parent-child (induk-anak) bekerja antar widget."

Widget tree merupakan struktur penting dari semua widget yang menyusun tampilan aplikasi, dimulai dari satu widget root. Hubungan parent-child (induk-anak) adalah inti dari struktur ini, di mana widget parent "mengandung" satu atau lebih widget child. Parent bertanggung jawab untuk mengontrol layout (seperti ukuran dan posisi) serta dapat meneruskan data dan tema ke child-child di bawahnya. Misalnya, di proyek, `Scaffold` adalah parent yang mengatur `AppBar` dan `MenuButtons` sebagai child-nya.

---

## "Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya."

Dalam proyek ini, kita menggunakan `MaterialApp` sebagai widget root yang menyediakan tema dan navigasi. `Scaffold` berfungsi sebagai kerangka halaman yang memiliki `AppBar` untuk judul dan `body`. Di dalam `body`, kita menggunakan `MenuButtons`, sebuah widget custom yang berisi `Center` untuk memposisikan `Column` di tengah. `Column` sendiri menyusun tiga `ElevatedButton.icon` secara vertikal, di mana setiap tombol menggunakan `Icon` dan `Text` untuk menampilkan konten. kita juga memakai `SizedBox` untuk memberi jarak antar tombol dan memanggil `SnackBar` melalui `ScaffoldMessenger` untuk menampilkan pesan saat tombol ditekan.

---

## "Apa fungsi dari widget `MaterialApp`? Jelaskan mengapa widget ini sering digunakan sebagai widget root."

Fungsi utama `MaterialApp` adalah untuk membungkus seluruh aplikasi dan menyediakan fungsionalitas inti yang dibutuhkan oleh standar Material Design. Ini termasuk mengatur tema global (warna, font), mengelola tumpukan navigasi (perpindahan halaman), dan menyediakan konteks untuk widget Material lainnya. Ia digunakan sebagai widget root karena widget-widget seperti `Scaffold`, `AppBar`, dan `ElevatedButton` perlu "menemukan" `MaterialApp` di atas mereka dalam widget tree untuk dapat berfungsi dengan benar dan mengambil data tema serta navigasi.

---

## "Jelaskan perbedaan antara `StatelessWidget` dan `StatefulWidget`. Kapan kamu memilih salah satunya?"

Perbedaan utamanya terletak pada "state" atau data internal. `StatelessWidget` adalah widget yang propertinya tidak dapat berubah setelah dibuat (immutable); ia hanya digambar berdasarkan konfigurasi awal dan data dari parent-nya. Kita biasanya menggunakan ini untuk tampilan statis seperti ikon atau label. Sebaliknya, `StatefulWidget` dapat melacak data internal yang bisa berubah selama runtime. Ia memiliki objek State terpisah dan fungsi `setState()`untuk memberi tahu Flutter agar me-render ulang dirinya sendiri saat data tersebut berubah. Kita memilih ini untuk UI interaktif seperti checkbox, formulir, atau counter.

---

## "Apa itu `BuildContext` dan mengapa penting di Flutter? Bagaimana penggunaannya di metode `build`?"

`BuildContext` adalah sebuah objek yang merepresentasikan lokasi atau "alamat" sebuah widget di dalam widget tree. Ini sangat penting karena menjadi jembatan bagi widget untuk berinteraksi dengan widget lain di pohon, terutama para leluhurnya (ancestors). Dalam metode `build`, `context` diterima sebagai parameter yang memberi tahu widget di mana ia harus "ditempatkan". Penggunaan paling umum adalah untuk mencari layanan yang disediakan oleh leluhur, seperti `Theme.of(context)` untuk mengambil data tema, atau `ScaffoldMessenger.of(context)` untuk menemukan Scaffold terdekat dan menampilkan SnackBar.

---

## "Jelaskan konsep `hot reload` di Flutter dan bagaimana bedanya dengan `hot restart`."

`Hot reload` adalah fitur yang menyuntikkan file kode yang baru diubah ke dalam Dart Virtual Machine (VM) yang sedang berjalan, lalu hanya membangun ulang widget tree, sehingga perubahan UI terlihat instan tanpa kehilangan state aplikasi (tetap di halaman yang sama, data formulir tidak hilang). Sedangkan `hot restart` mematikan Dart VM yang sedang berjalan dan memulai yang baru, yang berarti seluruh state aplikasi akan hilang (reset) dan aplikasi akan dimulai ulang dari awal (halaman `home`).

---

# Tugas 8

---

## "Jelaskan perbedaan antara Navigator.push() dan Navigator.pushReplacement() pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Slime Shop kamu?"

Perbedaan utamanya terletak pada cara mereka mengelola "tumpukan" halaman navigasi. `Navigator.push()` **menambahkan** halaman baru di atas halaman saat ini, sehingga pengguna bisa kembali ke halaman sebelumnya (biasanya memunculkan tombol "kembali" di `AppBar`). Sebaliknya, `Navigator.pushReplacement()` **mengganti** halaman saat ini dengan halaman baru, halaman lama dihapus dari tumpukan, sehingga pengguna tidak bisa kembali ke halaman tersebut. Dalam aplikasi Slime Shop, kita menggunakan `Navigator.push()` (melalui `pushNamed`) saat menekan tombol "Create Product" atau menu "Tambah Produk" di `Drawer`, agar pengguna bisa kembali ke halaman utama. Kita menggunakan `Navigator.pushReplacement()` (melalui `pushReplacementNamed`) saat memilih "Halaman Utama" dari `Drawer`, untuk memastikan halaman utama menggantikan halaman apa pun yang sedang aktif (seperti halaman form) tanpa menumpuknya.

---

## "Bagaimana kamu memanfaatkan hierarchy widget seperti Scaffold, AppBar, dan Drawer untuk membangun struktur halaman yang konsisten di seluruh aplikasi?"

Hierarki ini dimanfaatkan untuk menciptakan tata letak visual yang standar dan konsisten. `Scaffold` bertindak sebagai kerangka dasar untuk setiap halaman, menyediakan properti standar seperti `appBar` dan `drawer`. Dengan menempatkan `AppBar` di dalam `Scaffold`, kita memastikan *bar* judul selalu berada di bagian atas halaman. Demikian pula, dengan menyediakan widget `LeftDrawer` ke properti `drawer` pada `Scaffold` di beberapa halaman (seperti di `HomePage` dan `ShopFormPage`), kita membuat menu navigasi samping yang konsisten dapat diakses dari mana saja. Penggunaan hierarki ini menghemat kode dan membiasakan pengguna dengan struktur aplikasi kita, di mana pun mereka berada.

---

## "Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti Padding, SingleChildScrollView, dan ListView saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu."

Kelebihan utamanya adalah untuk mengelola ruang dan *scrolling* agar formulir tetap fungsional di berbagai ukuran layar. Di aplikasi kita, `ShopFormPage` menggunakan `SingleChildScrollView` untuk membungkus `Form` yang berisi banyak `TextFormField`. Ini sangat penting karena ketika *keyboard* virtual muncul dan ruang layar berkurang, pengguna tetap dapat *scroll* ke bawah untuk mengakses *field* di bagian bawah atau tombol "Save". Kita juga menggunakan `Padding` di sekeliling `SingleChildScrollView` untuk memberi "napas" visual, sehingga elemen formulir tidak menempel di tepi layar. `ListView` juga bisa digunakan untuk fungsi *scrolling*, dan sangat efisien jika elemen formulir kita sangat banyak atau dinamis, karena ia me-*render* elemen hanya saat akan tampil di layar.

---

## "Bagaimana kamu menyesuaikan warna tema agar aplikasi Slime Shop memiliki identitas visual yang konsisten dengan brand toko?"

Untuk menyesuaikan warna tema, kita memodifikasi properti `theme` pada widget `MaterialApp` di file `main.dart`. Properti ini menerima sebuah `ThemeData` di mana kita dapat mengatur `primarySwatch` (seperti `Colors.blue` yang kita gunakan) atau `colorScheme` yang lebih modern untuk kontrol yang lebih detail. Setelah diatur di sana, semua widget Material Design di dalam aplikasi, seperti `AppBar`, `ElevatedButton`, dan `DrawerHeader`, secara otomatis akan mengadopsi skema warna ini. Ini memastikan identitas visual *brand* "Slime Shop" (misalnya warna biru) diterapkan secara konsisten di seluruh aplikasi tanpa harus mengatur warna pada setiap widget satu per satu.

---

# Tugas 9

---

## "Jelaskan mengapa kita perlu membuat model Dart saat mengambil/mengirim data JSON? Apa konsekuensinya jika langsung memetakan Map<String, dynamic> tanpa model (terkait validasi tipe, null-safety, maintainability)?"

Kita perlu membuat model Dart karena Dart adalah bahasa yang *strongly-typed*, sehingga pendefinisian struktur data yang jelas sangat krusial untuk menjaga kestabilan aplikasi kita. Dengan membuat model seperti `Product`, kita dapat memastikan bahwa setiap data yang masuk dari JSON memiliki tipe data yang sesuai, misalnya `price` pasti berupa `int` dan `name` pasti berupa `String`. Konsekuensinya jika kita hanya mengandalkan `Map<String, dynamic>` secara langsung adalah hilangnya fitur keamanan tipe (*type safety*) dan *null-safety*. Kesalahan penulisan nama *key* (misalnya mengetik `'prce'` bukannya `'price'`) tidak akan terdeteksi oleh *compiler* dan baru akan menyebabkan *crash* saat aplikasi dijalankan (*runtime error*). Selain itu, dari sisi *maintainability*, kode kita akan menjadi sulit dibaca dan dikelola karena kita harus selalu mengingat struktur JSON mentah di setiap bagian kode yang menggunakannya, berbeda dengan model yang mendefinisikan struktur tersebut di satu tempat saja.

---

## "Apa fungsi package http dan CookieRequest dalam tugas ini? Jelaskan perbedaan peran http vs CookieRequest."

Dalam tugas ini, package `http` menyediakan fungsi dasar bagi kita untuk melakukan pertukaran data melalui protokol HTTP, seperti method `GET` dan `POST`. Namun, kita secara spesifik menggunakan `CookieRequest` dari package `pbp_django_auth` karena aplikasi kita membutuhkan manajemen sesi yang persisten. Perbedaan utamanya terletak pada pengelolaan *state* autentikasi. Package `http` standar bersifat *stateless*, artinya ia tidak menyimpan informasi apa pun antar *request*, sehingga kita harus mengurus *header* dan *cookie* secara manual setiap kali melakukan pemanggilan API. Sebaliknya, `CookieRequest` berperan sebagai *wrapper* yang secara otomatis menyimpan dan menyertakan *cookies* (seperti `sessionid` dan `csrftoken`) yang diterima dari Django setelah kita login. Hal ini memungkinkan aplikasi Flutter kita dianggap sebagai pengguna yang sudah terautentikasi oleh server Django pada *request-request* selanjutnya tanpa perlu konfigurasi manual yang rumit.

---

## "Jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter."

Instance `CookieRequest` perlu kita bagikan ke seluruh komponen karena objek ini menyimpan "identitas" sesi pengguna saat ini berupa *cookies* yang didapat saat login. Jika kita membuat *instance* `CookieRequest` baru di setiap halaman atau widget, maka *instance* baru tersebut akan kosong dan tidak memiliki *cookie* sesi yang valid, sehingga server Django akan menganggap kita belum login (anonymous user). Dengan membagikan satu *instance* yang sama menggunakan `Provider` di root aplikasi (`main.dart`), kita memastikan konsistensi *state* autentikasi di seluruh aplikasi. Baik saat kita berada di `LoginPage`, `HomePage`, maupun `ShopFormPage`, semua widget tersebut mengakses objek sesi yang sama, memungkinkan kita untuk tetap terautentikasi selama navigasi antar halaman berlangsung.

---

## "Jelaskan konfigurasi konektivitas yang diperlukan agar Flutter dapat berkomunikasi dengan Django. Mengapa kita perlu menambahkan 10.0.2.2 pada ALLOWED_HOSTS, mengaktifkan CORS dan pengaturan SameSite/cookie, dan menambahkan izin akses internet di Android? Apa yang akan terjadi jika konfigurasi tersebut tidak dilakukan dengan benar?"

Agar Flutter di emulator Android dapat berkomunikasi dengan Django di *local machine*, kita memerlukan beberapa konfigurasi spesifik. Kita perlu menambahkan `10.0.2.2` pada `ALLOWED_HOSTS` karena emulator Android menggunakan alamat IP spesial ini untuk merujuk ke *localhost* komputer tempat server Django berjalan, bukan `127.0.0.1` yang merujuk ke emulator itu sendiri. Kita mengaktifkan `CORS` (Cross-Origin Resource Sharing) dan mengatur `corsheaders` karena secara *default* browser atau webview akan memblokir permintaan sumber daya dari domain atau *port* yang berbeda demi keamanan. Pengaturan `SameSite` dan *cookie* juga perlu kita sesuaikan agar sesi dapat disimpan meskipun melalui koneksi HTTP lokal. Terakhir, izin akses internet di `AndroidManifest.xml` mutlak diperlukan agar aplikasi Android kita memiliki wewenang untuk menggunakan jaringan. Jika konfigurasi ini tidak benar, aplikasi kita akan mengalami kegagalan koneksi, seperti error `Connection Refused`, blokir oleh kebijakan CORS, atau kegagalan login karena *cookie* sesi tidak berhasil disimpan atau ditolak oleh server.

---

## "Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter."

Mekanisme ini dimulai ketika kita memasukkan data pada form di Flutter, misalnya di `ShopFormPage`. Saat tombol simpan ditekan, data tersebut dikonversi menjadi format JSON (biasanya menggunakan `jsonEncode`) agar dapat dibaca oleh server. Flutter kemudian mengirimkan data JSON ini melalui *request* HTTP `POST` menggunakan `CookieRequest` ke *endpoint* Django yang sesuai. Di sisi server, Django menerima *request*, mem-parsing data JSON tersebut, memvalidasinya, dan menyimpannya ke dalam database PostgreSQL. Untuk menampilkan data kembali ke Flutter, aplikasi kita mengirimkan *request* HTTP `GET` ke *endpoint* JSON Django. Server akan mengambil data dari database, menserialisasikannya menjadi format JSON, dan mengirimkannya sebagai respons. Aplikasi Flutter kita menerima JSON ini, lalu mengubahnya kembali menjadi objek Dart menggunakan model (misalnya `Product.fromJson`) dan akhirnya menampilkannya ke layar menggunakan widget seperti `ListView` atau `GridView`.

---

## "Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter."

Proses autentikasi dimulai saat kita memasukkan *username* dan *password* di halaman login atau register Flutter. Data ini dikirim via HTTP `POST` ke *endpoint* autentikasi Django yang telah kita buat (misalnya `/auth/login/`). Di sisi Django, fungsi `authenticate()` akan memverifikasi kredensial tersebut dengan data di database. Jika valid, fungsi `login()` akan membuat sesi baru dan server mengirimkan respons sukses beserta *cookie* `sessionid`. Di Flutter, `CookieRequest` menangkap dan menyimpan *cookie* ini. Setelah login berhasil, status `loggedIn` pada `CookieRequest` berubah menjadi `true`, dan aplikasi menavigasi kita ke halaman utama (`HomePage`) serta menampilkan menu-menu yang tadinya tersembunyi atau dilindungi. Untuk *logout*, Flutter mengirimkan pesan ke *endpoint* logout Django, yang kemudian menghapus sesi di server. Secara lokal, `CookieRequest` akan menghapus *cookie* yang tersimpan, dan aplikasi mengembalikan kita ke halaman login.

---

## "Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial)."

Awalnya kita menyiapkan backend Django agar kompatibel dengan Flutter. Kita membuat view baru di `views.py` yang menggunakan dekorator `@csrf_exempt` dan mengembalikan `JsonResponse` untuk keperluan login, register, dan logout, serta memastikan server menangani data input berupa JSON, bukan form-data biasa. Kita juga mengonfigurasi `corsheaders` di `settings.py` untuk mengizinkan akses lintas origin. Selanjutnya di sisi Flutter, kita menginstal dependensi `provider` dan `pbp_django_auth`. Kita membuat model `Product` di folder `models` untuk memetakan struktur JSON dari server ke objek Dart. Di `main.dart`, kita membungkus root widget dengan `Provider` yang menyediakan satu *instance* `CookieRequest` untuk seluruh aplikasi. Kemudian, kita membuat halaman `LoginPage` dan `RegisterPage` yang menggunakan `request.login` dan `request.postJson` untuk berkomunikasi dengan backend. Terakhir, kita menghubungkan halaman-halaman tersebut dengan sistem navigasi *named routes* dan mengimplementasikan logika `logout` pada `LeftDrawer`, serta memastikan setiap *request* yang mengubah data (seperti tambah produk) menggunakan format JSON yang valid menggunakan `jsonEncode` agar tidak terjadi konflik format data.

---