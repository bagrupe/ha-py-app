import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/common/extensions/lat_lng.dart';
import 'package:app/common/extensions/text_theme.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/components/images/loading_image.dart';
import 'package:app/components/lists/empty_state.dart';
import 'package:app/components/lists/error_state.dart';
import 'package:app/graphql/__generated__/maengel.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/maengel/common/mangel.dart';
import 'package:app/routes/maengel/components/maengel_historie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'maengel_detail_content.dart';

/// Seite zur Anzeige der Detailinformationen eines Mangels.
class MaengelDetailPage extends ConsumerWidget {
  /// Erstellt eine neue Instanz der Detailseite mit der angegebenen Mangel-ID.
  const MaengelDetailPage({required this.id, super.key});

  /// Die ID des anzuzeigenden Mangels.
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.melder.maengel.title'.tr()),
        menu: false,
      ),
      body: _MaengelDetail(id: id),
    );
  }
}
