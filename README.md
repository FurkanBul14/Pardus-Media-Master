#  Resim Dizayn Aracı (GUI & TUI)

##  Proje Hakkında

Bu proje, **Kabuk Programlama (Shell Scripting)** dersi kapsamında geliştirilmiştir. Temel amacı, Linux terminalinde güçlü ancak kullanımı karmaşık olan `ImageMagick` ve `Tesseract` gibi araçları, son kullanıcı için basit ve anlaşılır bir arayüze kavuşturmaktır.

Proje geliştirme süreci tamamen **Sanal Makine (Virtual Machine)** üzerine kurulan yerli işletim sistemimiz **Pardus** üzerinde gerçekleştirilmiştir. Pardus'un kararlı yapısı üzerinde test edilen uygulama, hem görsel (GUI) hem de metin tabanlı (TUI) arayüz seçenekleri sunarak her seviyeden kullanıcıya hitap etmektedir.

## 🛠️ Kullanılan Teknolojiler ve Araçlar

Bu projenin arkasında yatan güç, aşağıdaki açık kaynak teknolojilerin birleşiminden gelmektedir:

* **Bash Scripting:** Projenin ana omurgası, modüler fonksiyon yapısı.
* **Pardus Linux:** Geliştirme ve test ortamı.
* **YAD (Yet Another Dialog):** Modern ve kullanıcı dostu Grafik Arayüz (GUI) tasarımı için.
* **Whiptail:** Terminal tabanlı menüler (TUI) için.
* **ImageMagick (Convert/Identify):** Resim işleme, boyutlandırma, döndürme ve efekt işlemleri için.
* **Tesseract OCR:** Resim üzerindeki metinleri okuyup dijital yazıya çeviren Yapay Zeka motoru.

---

##  Arayüzler ve Özellikler

Proje açılışta kullanıcıya iki farklı çalışma modu sunar:

![Başlangıç Mod Seçimi](resimler/baslangic_secimi.png)

### 1. Grafiksel Kullanıcı Arayüzü (GUI)
Fare ve pencere odaklı, modern bir deneyim sunar. YAD kütüphanesi ile tasarlanmıştır.

**Öne Çıkan Özellikler:**
* **Akıllı Format Dönüştürme:** JPG, PNG, PDF arası dönüşüm (Dönüşüm sonrası eski dosyayı otomatik temizleme).
* **Yapay Zeka Destekli OCR:** Kitap sayfası veya belge fotoğraflarındaki yazıları %99 doğrulukla metne (.txt) çevirir.
* **Gelişmiş Efektler:** Siyah-Beyaz, Negatif ve **Sepia (Nostalji)** efektleri.
* **Teknik Analiz:** Resimlerin EXIF ve boyut bilgilerini raporlar.

*(Aşağıdaki görselde GUI Ana Menüsü, Analiz ve OCR işlem sonuçları görülmektedir)*

![GUI Ana Menü](resimler/gui_ana_menu.png)
![Analiz Raporu](resimler/gui_analiz_raporu.png)
![OCR Sonucu](resimler/gui_ocr_sonuc.png)
![Sepia Sonucu](resimler/gui_sepia_sonuc.png)

### 2. Terminal Tabanlı Arayüz (TUI)
Düşük sistem kaynağı tüketen, klavye ile yönetilen hızlı arayüz. Whiptail kütüphanesi ile tasarlanmıştır.

**Öne Çıkan Özellikler:**
* GUI sürümündeki tüm temel fonksiyonları (Format, Boyutlandırma, Döndürme) destekler.
* Sistem yöneticileri ve terminal severler için optimize edilmiştir.
* Hızlı ve pratiktir.

*(Aşağıdaki görselde Terminal Arayüzü menü yapısı ve işlem adımları görülmektedir)*

![TUI Ana Menü](resimler/tui_ana_menu.png)
![Dosya Girişi](resimler/tui_dosya_girisi.png)
![Döndürme Girişi](resimler/tui_döndürme_girisi.png)

**İşlem Öncesi ve Sonrası Kanıtı (Boyut Küçültme & Efekt):**
![Boyut Kanıtı](resimler/tui_buyut_kanit.png)
![Siyah Beyaz Sonuç](resimler/tui_sb_sonuc.png)

---

##  İşlemleri Yapınca Klasörün Son Hali
![Klasör Son Hali](resimler/klasor_son_hali.png)

---

##  İndirme ve Çalıştırma Rehberi

Projeyi bilgisayarınıza indirip hemen test etmek için aşağıdaki adımları sırasıyla uygulayın.

### 1. İndirme ve Hazırlık
Bu sayfanın sağ üst köşesindeki yeşil **"Code"** butonuna tıklayıp **"Download ZIP"** seçeneği ile dosyayı indirin.
* İnen ZIP dosyasını **Masaüstüne** çıkartın.
* Klasörün adı `Pardus-Media-Master` veya `Pardus-Media-Master-main` olabilir, sorun değil.

** Hazır Test Materyalleri:**
Klasörün içinde programı hemen denemeniz için örnek dosyalar bulunmaktadır:
* **`ss1.jpg`**: **Yapay Zeka (OCR)** özelliğini bu resimle test edebilirsiniz.
* **`galatasaray.png`**: **Format Dönüştürme** ve **Efektleri** bu resimle deneyebilirsiniz.

### 2. Kurulum (Gerekli Paketlerin Yüklenmesi)
Programın hatasız çalışması için terminali açın ve şu komutu yapıştırarak gerekli kütüphaneleri yükleyin:
```
sudo apt update
sudo apt install yad whiptail imagemagick graphicsmagick-imagemagick-compat tesseract-ocr tesseract-ocr-tur -y
```
kütüphanleri indirdikten sonra aşağıdaki kodlarlara giriş ekranını ulaşabilirsiniz:
```
cd ~/Masaüstü/Pardus-Media-Master*

cd proje_pro

chmod +x pro_main.sh

./pro_main.sh
```
