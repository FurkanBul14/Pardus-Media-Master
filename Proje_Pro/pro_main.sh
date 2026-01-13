#!/bin/bash

# ==========================================================
# PROJE ADI: PARDUS MEDIA MASTER (BUG FIX VERSION)
# AÇIKLAMA: TUI modundaki eksik kodlar tamamlandı.
#           Sepia efekti iyileştirildi.
# ==========================================================

# --- YARDIMCI FONKSİYONLAR ---
function show_error() {
    yad --error --title="Hata!" --text="$1" --width=300 --center --button="Tamam:0"
}

function show_success() {
    yad --info --title="İşlem Başarılı" --text="$1" --width=300 --center --button="Süper:0"
}

# --- GUI (GRAFİK ARAYÜZ) ---
function gui_menu() {
    while true; do
        SECIM=$(yad --list \
            --title="Pardus Media Master" \
            --text="<span font='11' foreground='blue'><b>Lütfen işlem seçiniz:</b></span>" \
            --column="ID" --column="Kategori" --column="İşlem Detayı" \
            --width=720 --height=550 \
            --center \
            --separator="|" \
            --search-column=3 \
            --button="Kapat:1" --button="Tamam:0" \
            1 "ANALİZ" "Resim Teknik Özelliklerini Göster" \
            2 "DÖNÜŞTÜRME" "Format Değiştir (Eskisini Siler)" \
            3 "DÜZENLEME" "Boyutlandırma (Resize)" \
            4 "DÜZENLEME" "Döndürme (Rotate)" \
            5 "EFEKT" "Gri Tonlama (Siyah-Beyaz)" \
            6 "EFEKT" "Negatif Film Efekti" \
            7 "EFEKT" "Sepia (Nostalji Modu)" \
            8 "YAPAY ZEKA" "OCR: Resimden Yazı Okuma (Metne Çevir)" \
            9 "SİSTEM" "Çıkış")

        if [ $? -ne 0 ]; then break; fi

        ISLEM=$(echo $SECIM | awk -F'|' '{print $1}')

        case $ISLEM in
            1)  # ANALİZ
                DOSYA=$(yad --file-selection --title="Analiz Edilecek Resmi Seç" --file-filter="Resimler | *.jpg *.png *.jpeg *.JPG *.PNG")
                if [ -n "$DOSYA" ]; then
                    identify -verbose "$DOSYA" | yad --text-info --title="Teknik Analiz Raporu" --width=800 --height=600 --center
                fi
                ;;

            2)  # FORMAT
                DOSYA=$(yad --file-selection --title="Resim Seç")
                if [ -n "$DOSYA" ]; then
                    FORMAT=$(yad --entry --title="Format" --text="Hedef format (png, jpg, pdf):" --entry-text="png")
                    if [ -n "$FORMAT" ]; then
                        AD=$(basename "$DOSYA" | cut -d. -f1)
                        KLASOR=$(dirname "$DOSYA")
                        (echo "50"; sleep 1; convert "$DOSYA" "$KLASOR/$AD.$FORMAT" && rm "$DOSYA"; echo "100") | \
                        yad --progress --title="İşleniyor" --text="Dönüştürülüyor..." --auto-close
                        show_success "İşlem Tamam:\n$KLASOR/$AD.$FORMAT"
                    fi
                fi
                ;;

            3)  # BOYUT
                DOSYA=$(yad --file-selection --title="Resim Seç")
                if [ -n "$DOSYA" ]; then
                    BOYUT=$(yad --entry --title="Boyut" --text="Yeni boyut (Örn: 50%):" --entry-text="50%")
                    if [ -n "$BOYUT" ]; then
                        AD=$(basename "$DOSYA" | cut -d. -f1)
                        KLASOR=$(dirname "$DOSYA")
                        convert "$DOSYA" -resize "$BOYUT" "$KLASOR/${AD}_yeni.jpg"
                        show_success "İşlem Tamam."
                    fi
                fi
                ;;

            4)  # DÖNDÜR
                DOSYA=$(yad --file-selection --title="Resim Seç")
                if [ -n "$DOSYA" ]; then
                    DERECE=$(yad --entry --title="Döndür" --text="Derece (90, 180):" --entry-text="90")
                    if [ -n "$DERECE" ]; then
                        AD=$(basename "$DOSYA" | cut -d. -f1)
                        KLASOR=$(dirname "$DOSYA")
                        convert "$DOSYA" -rotate "$DERECE" "$KLASOR/${AD}_donen.jpg"
                        show_success "Döndürüldü."
                    fi
                fi
                ;;
            
            5)  # SİYAH BEYAZ
                DOSYA=$(yad --file-selection --title="Resim Seç")
                if [ -n "$DOSYA" ]; then
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    convert "$DOSYA" -colorspace Gray "$KLASOR/${AD}_sb.jpg"
                    show_success "Efekt uygulandı."
                fi
                ;;

            6)  # NEGATİF
                DOSYA=$(yad --file-selection --title="Resim Seç")
                if [ -n "$DOSYA" ]; then
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    convert "$DOSYA" -negate "$KLASOR/${AD}_negatif.jpg"
                    show_success "Efekt uygulandı."
                fi
                ;;

            7)  # SEPIA (NOSTALJİ) - GÜNCELLENDİ
                DOSYA=$(yad --file-selection --title="Resim Seç")
                if [ -n "$DOSYA" ]; then
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    # Daha garantili Sepia yöntemi (-modulate)
                    convert "$DOSYA" -modulate 115,0,100 -colorize 7,21,50 "$KLASOR/${AD}_nostalji.jpg"
                    
                    if [ $? -eq 0 ]; then
                        show_success "Nostalji efekti uygulandı:\n$KLASOR/${AD}_nostalji.jpg"
                    else
                        # Eğer üstteki çalışmazsa alternatif basit yöntem
                        convert "$DOSYA" -sepia-tone 80% "$KLASOR/${AD}_nostalji.jpg" && show_success "Nostalji efekti uygulandı."
                    fi
                fi
                ;;

            8)  # YAPAY ZEKA (OCR)
                DOSYA=$(yad --file-selection --title="Yazı İçeren Resim Seç" --file-filter="Resimler | *.jpg *.png")
                if [ -n "$DOSYA" ]; then
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    
                    (echo "50"; tesseract "$DOSYA" "$KLASOR/$AD" -l tur; echo "100") | yad --progress --title="OCR" --auto-close

                    if [ -f "$KLASOR/$AD.txt" ]; then
                        yad --text-info --title="Okunan Metin" --filename="$KLASOR/$AD.txt" --width=600 --height=500 --center --editable
                    else
                        show_error "Metin okunamadı."
                    fi
                fi
                ;;

            9) exit 0 ;;
            *) ;;
        esac
    done
}

# --- TUI (TERMINAL ARAYÜZ - DÜZELTİLDİ) ---
function tui_menu() {
    while true; do
        SECIM=$(whiptail --title "Pardus PRO TUI" --menu "Seçim Yapınız:" 20 78 10 \
            "1" "Resim Analizi" \
            "2" "Format Değiştir" \
            "3" "Boyutlandır" \
            "4" "Döndür" \
            "5" "Siyah-Beyaz" \
            "6" "Negatif" \
            "7" "Sepia (Nostalji)" \
            "8" "OCR - Yazı Okuma" \
            "9" "Çıkış" 3>&1 1>&2 2>&3)

        if [ $? -ne 0 ]; then return; fi

        case $SECIM in
            1)
                DOSYA=$(whiptail --inputbox "Dosya Yolu (Örn: resim.jpg):" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$DOSYA" ]; then identify -verbose "$DOSYA" > /tmp/analiz.txt && whiptail --textbox /tmp/analiz.txt 20 78 --scrolltext; fi
                ;;
            2)
                DOSYA=$(whiptail --inputbox "Dosya Yolu:" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$DOSYA" ]; then
                    FORMAT=$(whiptail --inputbox "Yeni Format (png):" 10 60 "png" 3>&1 1>&2 2>&3)
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    convert "$DOSYA" "$KLASOR/$AD.$FORMAT" && rm "$DOSYA"
                    whiptail --msgbox "Dönüştürüldü ve eski silindi." 10 50
                fi
                ;;
            3)  # TUI BOYUTLANDIRMA (EKLENDİ)
                DOSYA=$(whiptail --inputbox "Dosya Yolu:" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$DOSYA" ]; then
                    BOYUT=$(whiptail --inputbox "Boyut (Örn: 50%):" 10 60 "50%" 3>&1 1>&2 2>&3)
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    convert "$DOSYA" -resize "$BOYUT" "${KLASOR}/${AD}_yeni.jpg"
                    whiptail --msgbox "Boyutlandırıldı!" 10 50
                fi
                ;;
            4)  # TUI DÖNDÜRME (EKLENDİ)
                DOSYA=$(whiptail --inputbox "Dosya Yolu:" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$DOSYA" ]; then
                    DERECE=$(whiptail --inputbox "Derece (90, 180):" 10 60 "90" 3>&1 1>&2 2>&3)
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    convert "$DOSYA" -rotate "$DERECE" "${KLASOR}/${AD}_donen.jpg"
                    whiptail --msgbox "Döndürüldü!" 10 50
                fi
                ;;
            5)  # TUI SİYAH BEYAZ (EKLENDİ)
                DOSYA=$(whiptail --inputbox "Dosya Yolu:" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$DOSYA" ]; then
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    convert "$DOSYA" -colorspace Gray "${KLASOR}/${AD}_sb.jpg"
                    whiptail --msgbox "Siyah-Beyaz yapıldı!" 10 50
                fi
                ;;
            6)  # TUI NEGATİF (EKLENDİ)
                DOSYA=$(whiptail --inputbox "Dosya Yolu:" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$DOSYA" ]; then
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    convert "$DOSYA" -negate "${KLASOR}/${AD}_negatif.jpg"
                    whiptail --msgbox "Negatif efekt uygulandı!" 10 50
                fi
                ;;
            7)  # TUI SEPIA (DÜZELTİLDİ)
                DOSYA=$(whiptail --inputbox "Resim Yolu:" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$DOSYA" ]; then
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    # TUI için de aynı garanti komutu kullandık
                    convert "$DOSYA" -modulate 115,0,100 -colorize 7,21,50 "${KLASOR}/${AD}_nostalji.jpg"
                    whiptail --msgbox "Nostalji efekti uygulandı!" 10 50
                fi
                ;;
            8)
                DOSYA=$(whiptail --inputbox "Resim Yolu:" 10 60 3>&1 1>&2 2>&3)
                if [ -n "$DOSYA" ]; then
                    whiptail --infobox "Okunuyor..." 10 50
                    AD=$(basename "$DOSYA" | cut -d. -f1)
                    KLASOR=$(dirname "$DOSYA")
                    tesseract "$DOSYA" "$KLASOR/$AD" -l tur
                    whiptail --textbox "$KLASOR/$AD.txt" 20 78 --scrolltext
                fi
                ;;
            9) return ;;
            *) ;;
        esac
    done
}

# --- BAŞLANGIÇ ---
MOD=$(yad --list --title="Pardus Media Master" \
    --text="Çalışma Modu:" \
    --column="Mod" --column="Açıklama" \
    --width=450 --height=200 \
    --hide-header \
    --button="Çıkış:1" --button="Başlat:0" \
    1 "Grafik Arayüz (GUI)" \
    2 "Terminal Arayüz (TUI)")

if [ $? -eq 0 ]; then
    SECIM=$(echo $MOD | awk -F'|' '{print $1}')
    if [ "$SECIM" == "1" ]; then gui_menu; else tui_menu; fi
else
    exit 0
fi
