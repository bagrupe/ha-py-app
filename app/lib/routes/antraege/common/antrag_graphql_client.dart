import 'package:graphql/client.dart';

/// Extended timeout for Antrag submission requests that may include large uploads.
const antragRequestTimeout = Duration(seconds: 60);

GraphQLClient withAntragRequestTimeout(GraphQLClient client) =>
    client.copyWith(queryRequestTimeout: antragRequestTimeout);
