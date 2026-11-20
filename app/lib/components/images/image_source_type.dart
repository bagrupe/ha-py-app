/// The source of the image, used for fallback logic.
enum ImageSourceType {
  /// The primary URL.
  primary,

  /// A network fallback URL from CMS.
  fallbackNetwork,

  /// A local asset fallback.
  fallbackAsset,
}
