# Tutorial Game Development 2025/2026 Genap
Nama  : Rizqya Az Zahra Putri  
NPM   : 2306244936

## Tutorial 3
Untuk bagian latihan mandiri, saya menambahkan beberapa mekanika pergerakan pada karakter permainan:
- Triple Jump
- Crouching
- Slide

Bonus polishing:
- Animasi karakter berganti secara otomatis mengikuti kondisi karakter saat ini:  _idle_, _walk_, _jump_, _fall_, _duck_, _slide_, dan _win_. Polishing ini saya lakukan dengan menggunakan node bertipe `AnimationPlayer` untuk animasi karakternya.
- Sprite karakter membalik arah (flip horizontal) sesuai arah gerak karakter (menggunakan `flip_h`). 

### 1. Triple Jump
Karakter pemain dapat melompat hingga 3 kali secara berturut-turut dengan menekan tombol `↑` sebanyak 3 kali, termasuk saat berada di udara. 

Fitur ini saya implementasikan menggunakan variabel `jump_counts` yang menghitung berapa kali pemain sudah melompat dan `max_jumps` yang menjadi batas maksimum lompatan.

### 2. Crouching (Jongkok)
Karakter dapat jongkok dengan menekan tombol `↓` saat berada di lantai. Saat jongkok, kecepatan geraknya berkurang dan animasi berubah ke state _Duck_.

Diimplementasikan dengan state boolean `is_crouching`. `is_crouching` bernilai true jika tombol `ui_down` ditekan, karakter di lantai, dan tidak sedang sliding. Lalu, kecepatan yang digunakan berganti dari `walk_speed` menjadi `crouch_speed`.

### 3. Slide
Karakter dapat melakukan gerakan slide dengan menekan tombol `↓` + `←` atau `↓` + `→` secara bersamaan saat berada di lantai. Saat slide, karakter bergerak lebih cepat dari kecepatan berjalan normal dan hitbox-nya mengecil.

Slide diaktifkan ketika `ui_down` ditekan bersamaan dengan `ui_left` atau `ui_right`. Selain itu, saya menggunakan variabel `slide_timer` untuk menghitung durasi slide, di mana setelah habis, slide otomatis berhenti.

### Tambahan
Saya menambahkan platform baru untuk memastikan setiap fitur pergerakan yang diimplementasikan dapat digunakan. Pemain harus menjelajahi seluruh tingkatan platform untuk bisa mencapai finish line (bendera).

**Referensi**
- Godot CharacterBody2D: https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
- Godot Sprite2D: https://docs.godotengine.org/en/stable/classes/class_sprite2d.html
- Godot AnimationPlayer: https://youtu.be/ATfE4k6EP9U?si=WhLYhUW-D3n4NPsE
- How To Double Jump: https://www.youtube.com/watch?v=DW4CQoYddXQ



## Tutorial 5 - Menambahkan Enemy dan Audio
Pada tutorial ini ditambahkan objek enemy baru berupa zombie yang bergerak secara otomatis, dapat berinteraksi dengan player, serta sistem audio berupa _sound effects_ dan _background music_.

### 1. Implementasi Objek Enemy
Objek enemy yang ditambahkan adalah karakter zombie yang diambil dari website [Game Art 2D](https://www.gameart2d.com/the-zombies-free-sprites.html). Enemy dirancang untuk bergerak secara otomatis tanpa kendali pemain dan mampu berinteraksi langsung dengan player ketika bersentuhan.
Node yang digunakan untuk enemy adalah `CharacterBody2D`, dipilih karena mendukung interaksi fisika seperti deteksi lantai secara bawaan. Lalu, untuk mendeteksi kedatangan player, dipasang node `Area2D` sebagai child dari enemy.

Setiap kondisi enemy direpresentasikan dengan animasi tersendiri menggunakan node `AnimatedSprite2D`. Seluruh animasi didefinisikan di dalam SpriteFrames dengan rincian sebagai berikut:

Nama Animasi | Keterangan
---|---
idle | Enemy berdiri diam di awal game
walk | Enemy berjalan saat melakukan patroli
attack | Enemy menampilkan gerakan serang
dead | Enemy roboh ketika dikalahkan player

Untuk memastikan enemy menghadap ke arah yang benar saat bergerak, properti `flip_h` pada `AnimatedSprite2D` diubah secara dinamis berdasarkan nilai variabel `direction`.

#### Interaksi Player dengan Enemy
- Player mengenai Enemy -> Level restart

Ketika player memasuki area Area2D milik enemy, signal `body_entered` terpanggil dan diteruskan ke fungsi `_on_body_entered`. Fungsi ini memverifikasi apakah body yang masuk terdaftar dalam group "player", lalu memanggil `get_tree().reload_current_scene()` untuk mengulang level dari awal.

- Player menyerang Enemy -> Enemy mati

Player dapat mengalahkan enemy dengan menekan tombol Space. Saat tombol ditekan, fungsi `_attack()` dipanggil dan mengambil daftar semua body yang sedang berada di dalam AttackArea (node Area2D yang dipasang di depan player) menggunakan `get_overlapping_bodies()`. Setiap body yang memiliki method `die()` akan langsung dipanggil.

### 2. Implementasi Audio
#### Sound Effects
Ketiga SFX ditempatkan sebagai child node `AudioStreamPlayer` di dalam scene player:
Node | Trigger
---|---
SFXWin | Player berhasil mencapai finish flag
SFXLose | Player bersentuhan dengan enemy
SFXPunch | Player menekan Space untuk menyerang
Masing-masing SFX diputar dengan memanggil `.play()` pada momen yang sesuai.

#### Background Music
BGM ditempatkan sebagai node `AudioStreamPlayer` di scene level utama. dengan properti Autoplay diaktifkan supaya musik langsung diputar begitu level dimuat. BGM dihentikan secara manual ketika player menang atau kalah melalui fungsi `stop_bgm()` yang menemukan node BGM menggunakan `find_child()` dan memanggil `.stop()` padanya.


Assets yang digunakan:
- Animasi enemy: https://www.gameart2d.com/the-zombies-free-sprites.html
- SFX & BGM: https://freesound.org/