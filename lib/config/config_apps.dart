class ConfigApps {
  static String url = 'http://localhost:8000';

  //Login Backend
  static String login = '/api/auth/login';
  static String logout = '/api/auth/logout';
  static String check = '/api/auth/checkstatus';

  //data buku
  static String listbuku = '/api/buku';
  static String detilbuku = '/api/buku/detil/';
  static String caribuku = '/api/buku/cari';
  static String tambahbuku = '/api/buku/tambah/';
  static String hapusbuku = '/api/buku/hapus/';
  static String editbuku = '/api/buku/edit';
} 