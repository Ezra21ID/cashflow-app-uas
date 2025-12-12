# 💰 CashFlow - Expense Tracker App

**CashFlow** adalah aplikasi manajemen keuangan pribadi berbasis mobile yang dibangun menggunakan **Flutter** dan terintegrasi dengan **Firebase Realtime Database**. Aplikasi ini dikembangkan untuk memenuhi tugas **Ujian Akhir Semester (UAS)** mata kuliah **Mobile Programming**.

Aplikasi ini memungkinkan pengguna untuk mencatat pemasukan dan pengeluaran secara *real-time*, melihat visualisasi data, serta memfilter riwayat transaksi untuk analisis keuangan yang lebih baik.

## 📱 Fitur Utama

* **User Authentication:** Login dan Sign Up aman menggunakan Email & Password (Firebase Auth).
* **Real-time Dashboard:** Sinkronisasi data otomatis antar perangkat tanpa perlu refresh manual.
* **Transaction Management:**
    * Menambah Pemasukan (Income) dan Pengeluaran (Expense).
    * Mendukung berbagai kategori (Groceries, Transportation, Salary, dll).
* **Search & Filter:** Fitur pencarian berdasarkan judul transaksi dan filter berdasarkan tipe (All/Income/Expense).
* **Data Privacy:** Isolasi data antar pengguna (User A tidak bisa melihat data User B).
* **Visual Analytics:** Grafik sederhana untuk melihat proporsi pengeluaran.

## 🛠️ Teknologi yang Digunakan

* **Frontend:** Flutter SDK (Dart)
* **Backend:** Firebase Realtime Database
* **Authentication:** Firebase Auth
* **Architecture:** Separation of Concerns (UI, Service, Model)

---

## 🚀 Cara Instalasi & Menjalankan Aplikasi

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di mesin lokal Anda.

### 1. Prasyarat (Requirements)
Pastikan komputer Anda sudah terinstal:
* **Flutter SDK** (Versi terbaru).
* **Git** (Untuk mengunduh repository).
* **Android Studio / VS Code** (Dengan ekstensi Flutter).
* **Emulator Android** atau Perangkat Fisik yang terhubung.

### 2. Clone Repository
Buka terminal atau command prompt, lalu jalankan perintah berikut untuk mengunduh kode sumber:

```bash
git clone [https://github.com/Ezra21ID/cashflow-app-uas.git](https://github.com/Ezra21ID/cashflow-app-uas.git)
cd cashflow-app-uas

## 🔗 API Endpoint & Database Structure

Aplikasi ini menggunakan **Firebase Realtime Database** sebagai *Backend-as-a-Service*. Alih-alih REST API statis, aplikasi berkomunikasi langsung dengan database melalui protokol aman (Secure WebSockets/HTTPS).

### **Base URL**
https://cashflowapp-aad0b-default-rtdb.asia-southeast1.firebasedatabase.app/

### **Endpoint Paths**

Untuk menjamin keamanan dan privasi data (Multi-tenancy), struktur endpoint dibuat hierarkis berdasarkan UID pengguna.

| Method | Endpoint Path | Deskripsi |
| :--- | :--- | :--- |
| **GET (Stream)** | `/users/{uid}/transactions` | Mengambil seluruh daftar transaksi milik user tertentu secara *real-time*. |
| **POST (Push)** | `/users/{uid}/transactions` | Menambahkan data transaksi baru ke dalam database pengguna. |

**Keterangan Parameter:**
* `{uid}` : User ID unik yang didapatkan dari sesi Login (Firebase Auth).

### **JSON Data Structure**

Setiap transaksi disimpan dalam format JSON berikut:

```json
{
  "-OE8x9s_KeyGenerated": {
    "title": "Belanja Bulanan",
    "category": "Groceries",
    "amount": 150000,
    "type": "expense",
    "date": "2025-12-12T10:00:00.000"
  }
}


