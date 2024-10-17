class PDFDocument {
  final String titleName;
  final String fileName;
  final String url;

  PDFDocument({required this.titleName, required this.fileName, required this.url});

  Map<String, dynamic> toMap() {
    return {
      'titleName': titleName,
      'fileName': fileName,
      'url': url,
    };
  }

  factory PDFDocument.fromMap(Map<String, dynamic> map) {
    return PDFDocument(
      titleName: map['titleName'],
      fileName: map['fileName'],
      url: map['url'],
    );
  }
}
