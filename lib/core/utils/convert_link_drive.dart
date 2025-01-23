String clearUrlImageDriveGoogle(String? googleDriveUrl) {
  if (googleDriveUrl == null || googleDriveUrl.isEmpty) {
    return ''; // Return empty string if the input is null or empty
  }

  final uri = Uri.parse(googleDriveUrl);

  // Periksa apakah URL berasal dari Google Drive
  if (uri.host.contains('drive.google.com')) {
    // Jika URL sudah menggunakan format `uc?export=view`, kembalikan langsung
    if (uri.path.contains('/uc')) {
      return googleDriveUrl;
    }

    // Jika URL berbagi dengan format `file/d/{id}/view`, konversi ke tautan langsung
    if (uri.pathSegments.contains('file')) {
      final idIndex = uri.pathSegments.indexOf('d');
      if (idIndex != -1 && idIndex + 1 < uri.pathSegments.length) {
        final fileId = uri.pathSegments[idIndex + 1];
        return 'https://drive.google.com/uc?export=view&id=$fileId';
      }
    }
  }

  // Kembalikan URL asli jika tidak sesuai kriteria
  return googleDriveUrl;
}
