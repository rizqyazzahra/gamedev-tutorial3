# Tutorial 3 Game Development 2025/2026 Genap
Nama  : Rizqya Az Zahra Putri  
NPM   : 2306244936

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