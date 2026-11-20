// ignore_for_file: strict_raw_type, inference_failure_on_function_invocation

import 'package:app/common/extensions/lat_lng.dart';
import 'package:app/common/geofencing/hameln_pyrmont_boundary_provider.dart';
import 'package:app/common/location_service.dart';
import 'package:app/common/mapbox_reverse_geocoding/mapbox_reverse_geocoding.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/formular_field_style.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/selection_map.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/uebersicht_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

typedef LocationPositionSelector =
    Future<LatLng?> Function(BuildContext context, LatLng? center);
typedef LocationAddressResolver = Future<String?> Function(LatLng position);

/// Ein Formularfeld zur Auswahl und Anzeige eines Standorts mit Adresse.
/// Nutzt eine Karte zur Auswahl und zeigt die Adresse als Textfeld an.
class FormularLocationField extends ConsumerStatefulWidget {
  /// Erstellt ein Formularfeld für die Standortauswahl.
  /// [feld] enthält die Metadaten des Formularfelds.
  const FormularLocationField({
    required this.feld,
    super.key,
    this.optional = false,
    this.positionSelector,
    this.addressResolver,
  });
  final FormularFeldData feld;

  /// Gibt an, ob das Feld optional ist.
  final bool optional;
  final LocationPositionSelector? positionSelector;
  final LocationAddressResolver? addressResolver;

  @override
  ConsumerState<FormularLocationField> createState() =>
      _FormularLocationFieldState();
}

class _FormularLocationFieldState extends ConsumerState<FormularLocationField> {
  LatLng? _addressResolutionPosition;

  /// Öffnet eine modale Karte zur Auswahl eines Standorts.
  /// [context] ist der BuildContext, [center] der initiale Kartenmittelpunkt.
  /// Gibt die ausgewählte Position als [LatLng] zurück oder null, wenn abgebrochen.
  Future<LatLng?> _showSelectionMap(
    BuildContext context,
    LatLng? center,
  ) async {
    final positionSelector = widget.positionSelector;
    if (positionSelector != null) return positionSelector(context, center);
    return showModalBottomSheet<LatLng>(
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      context: context,
      builder: (c) => SelectionMap(
        center: center,
        onSelect: Navigator.of(context).pop,
        onCancel: Navigator.of(context).pop,
      ),
    );
  }

  /// Ermittelt die Adresse zu einer gegebenen Position über den Mapbox-Dienst.
  /// [ref] ist der WidgetRef für Providerzugriff, [position] die Koordinate.
  /// Gibt die formatierte Adresse als String zurück oder null, falls nicht verfügbar.
  Future<String?> _setAddress(LatLng position) async {
    final addressResolver = widget.addressResolver;
    if (addressResolver != null) return addressResolver(position);
    final mapboxLatLngToAddressProvider = ref.read(mapboxLatLngToAddress);

    final results = await mapboxLatLngToAddressProvider.getAddressString(
      position,
    );

    final feature = results.features.firstOrNull;

    final formattedAddress = feature?.placeNameDe?.split(', ');
    formattedAddress?.removeLast();

    return formattedAddress?.join(', ');
  }

  bool get _isResolvingAddress => _addressResolutionPosition != null;

  Future<void> _applyPosition(
    FormFieldState<FormLocation> field,
    LatLng position,
  ) async {
    _addressResolutionPosition = position;
    field
      ..didChange(FormLocation(position: position))
      ..validate();
    if (mounted) setState(() {});

    String? address;
    try {
      address = await _setAddress(position).timeout(const Duration(seconds: 3));
    } catch (_) {
      address = null;
    }

    if (!mounted || _addressResolutionPosition != position) return;
    final currentField = FormBuilder.of(context)?.fields[widget.feld.slotName];
    setState(() => _addressResolutionPosition = null);
    currentField
      ?..didChange(FormLocation(addressString: address, position: position))
      ..validate();
  }

  @override
  Widget build(BuildContext context) {
    final boundaryState = ref.watch(hamelnPyrmontBoundaryProvider);
    final boundary = switch (boundaryState) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final isBoundaryLoading = boundaryState is AsyncLoading;
    final hasBoundaryError = boundaryState is AsyncError;
    return FormBuilderField<FormLocation>(
      name: widget.feld.slotName,
      validator: (value) {
        if (value == null) {
          return widget.optional
              ? null
              : 'application.antraege.location.required'.tr();
        }
        if (boundary == null) {
          return 'application.antraege.location.boundary_unavailable'.tr();
        }
        if (!boundary.contains(value.position)) {
          return 'application.antraege.location.outside_district'.tr();
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return TextField(
          readOnly: true,
          enabled: boundary != null,
          onTap: () async {
            final position = await _showSelectionMap(
              context,
              field.value?.position,
            );
            if (position == null) return;
            await _applyPosition(field, position);
          },
          controller: TextEditingController()
            ..text = _isResolvingAddress
                ? 'application.antraege.location.resolving_address'.tr()
                : field.value?.addressString ??
                      field.value?.position.formatted ??
                      '',
          decoration: InputDecoration(
            labelText: widget.feld.angezeigterName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: widget.feld.anweisung,
            errorText: field.errorText,
            errorMaxLines: 5,
            suffixIcon: isBoundaryLoading || _isResolvingAddress
                ? Semantics(
                    label: isBoundaryLoading
                        ? 'application.antraege.location.loading_boundary'.tr()
                        : 'application.antraege.location.resolving_address'
                              .tr(),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : hasBoundaryError
                ? Tooltip(
                    message:
                        'application.antraege.location.boundary_unavailable'
                            .tr(),
                    child: const Icon(Icons.error_outline),
                  )
                : IconButton(
                    tooltip: 'application.antraege.location.use_current'.tr(),
                    onPressed: () async {
                      final currentPosition =
                          await LocationService.getCurrentPosition(
                            context: context,
                          );
                      final position = LatLng(
                        currentPosition.latitude,
                        currentPosition.longitude,
                      );
                      await _applyPosition(field, position);
                    },
                    icon: const Icon(Icons.place_outlined),
                  ),
            isDense: true,
            border: const OutlineInputBorder(
              borderRadius: formularFieldBorderRadius,
            ),
          ),
        );
      },
    );
  }
}

/// Repräsentiert einen Standort mit Adresse und Koordinate.
class FormLocation {
  /// Erstellt eine Instanz mit optionaler Adresse und verpflichtender Position.
  const FormLocation({required this.position, this.addressString});
  final String? addressString;
  final LatLng position;

  /// Wandelt die Instanz in ein JSON-kompatibles Map um.
  Map toJson() => {'addressString': addressString, ...position.toJson()};
}
