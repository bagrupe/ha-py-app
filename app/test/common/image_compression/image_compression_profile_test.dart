import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImageCompressionProfile', () {
    test('profiles match the specified values', () {
      expect(ImageCompressionProfile.dokument.maxEdge, 2480);
      expect(ImageCompressionProfile.dokument.quality, 85);
      expect(ImageCompressionProfile.passfoto.maxEdge, 1600);
      expect(ImageCompressionProfile.passfoto.quality, 85);
      expect(ImageCompressionProfile.foto.maxEdge, 1600);
      expect(ImageCompressionProfile.foto.quality, 80);
      expect(ImageCompressionProfile.unterschrift.maxEdge, 1000);
      expect(ImageCompressionProfile.unterschrift.quality, 85);
    });

    group('targetSide', () {
      const profile = ImageCompressionProfile.foto;

      test('scales the short edge so the long edge becomes 1600', () {
        final side = profile.targetSide(width: 4032, height: 3024);
        expect(side, 1200);
        expect(4032 * side / 3024, closeTo(1600, 1));
      });

      test('behaves identically for portrait images', () {
        expect(profile.targetSide(width: 3024, height: 4032), 1200);
      });

      test('small images keep their existing short edge', () {
        expect(profile.targetSide(width: 200, height: 100), 100);
      });

      test('square image gets the full edge', () {
        expect(profile.targetSide(width: 3000, height: 3000), 1600);
      });
    });

    group('sampleSize', () {
      const profile = ImageCompressionProfile.foto;

      test('image within the edge limit is not subsampled', () {
        expect(profile.sampleSize(width: 1600, height: 1200), 1);
        expect(profile.sampleSize(width: 2399, height: 1800), 1);
      });

      test('stops at the largest power of two that keeps the target edge', () {
        expect(profile.sampleSize(width: 4000, height: 3000), 2);
        expect(profile.sampleSize(width: 3200, height: 2400), 2);
        expect(profile.sampleSize(width: 6400, height: 4800), 4);
        expect(profile.sampleSize(width: 30000, height: 18840), 16);
      });

      test('uses the long edge for portrait images', () {
        expect(profile.sampleSize(width: 3000, height: 4000), 2);
      });
    });
  });
}
