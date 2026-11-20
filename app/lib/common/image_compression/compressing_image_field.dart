import 'package:app/common/image_compression/image_compression.dart';
import 'package:app/common/image_compression/image_compression_profile.dart';
import 'package:app/common/image_compression/image_too_large_exception.dart';
import 'package:cross_file/cross_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

part 'compression_busy_overlay.dart';

class CompressingImageField extends StatefulWidget {
  const CompressingImageField({
    required this.name,
    required this.profile,
    required this.builder,
    super.key,
  });

  final String name;

  final ImageCompressionProfile profile;

  final Widget Function(
    BuildContext context,
    ValueChanged<List<dynamic>?> onChanged,
  )
  builder;

  @override
  State<CompressingImageField> createState() => _CompressingImageFieldState();
}

class _CompressingImageFieldState extends State<CompressingImageField> {
  bool _busy = false;
  bool _applyingOwnChange = false;

  /// Revalidates temporary files after returning from the background.
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: () => FormBuilder.of(context)?.fields[widget.name]?.validate(),
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  Future<void> _onChanged(List<dynamic>? value) async {
    if (_applyingOwnChange) return;
    if (value == null) return;

    final pending = value.whereType<XFile>().any((f) => !isProcessed(f));
    if (!pending) return;

    final field = FormBuilder.of(context)?.fields[widget.name];
    if (field == null) return;

    setState(() => _busy = true);
    try {
      final compressed = await trackImageCompression(_compressAll(value));
      if (!mounted) return;
      _applyingOwnChange = true;
      try {
        field.didChange(compressed);
      } finally {
        _applyingOwnChange = false;
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Processes each attachment independently and reports rejected files.
  Future<List<dynamic>> _compressAll(List<dynamic> value) async {
    final compressed = <dynamic>[];
    var rejected = false;

    /// Whether any attachment failed for a reason other than its size.
    var processingFailed = false;
    for (final item in value) {
      if (item is! XFile) {
        compressed.add(item);
        continue;
      }
      try {
        compressed.add(await compressImage(item, widget.profile));
      } on ImageTooLargeException {
        rejected = true;
      } catch (_) {
        processingFailed = true;
      }
    }
    if (rejected && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('application.image_picker.too_large'.tr())),
      );
    }
    if (processingFailed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('application.attachments.processing_error'.tr()),
        ),
      );
    }
    return compressed;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(context, _onChanged),
        if (_busy) const _CompressionBusyOverlay(),
      ],
    );
  }
}
