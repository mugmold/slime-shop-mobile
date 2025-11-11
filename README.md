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