/// Resolution and quality limits applied when re-encoding selected images.
enum ImageCompressionProfile {
  dokument(maxEdge: 2480, quality: 85),

  passfoto(maxEdge: 1600, quality: 85),

  foto(maxEdge: 1600, quality: 80),

  unterschrift(maxEdge: 1000, quality: 85);

  const ImageCompressionProfile({required this.maxEdge, required this.quality});

  /// Maximum length of the output image's longest edge.
  final int maxEdge;

  /// JPEG quality used by the native encoder.
  final int quality;

  /// Maximum source file size accepted before native decoding.
  static const maxInputBytes = 100 * 1024 * 1024;

  /// Maximum source pixel count accepted before native decoding.
  static const maxInputPixels = 100 * 1000 * 1000;

  /// Resolution limit passed to the platform image picker.
  double get pickerMaxEdge => maxEdge.toDouble();

  /// Computes the short edge without upscaling small source images.

  int targetSide({required int width, required int height}) {
    final longEdge = width > height ? width : height;
    final shortEdge = width > height ? height : width;
    if (longEdge <= maxEdge) return shortEdge;
    return (maxEdge * shortEdge / longEdge).floor().clamp(1, maxEdge);
  }

  /// Computes a power-of-two sampling factor for native image decoding.
  int sampleSize({required int width, required int height}) {
    final longEdge = width > height ? width : height;
    var sample = 1;
    while (longEdge / (sample * 2) >= maxEdge) {
      sample *= 2;
    }
    return sample;
  }
}
