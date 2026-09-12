import 'package:clean_architecture/core/clients/local/local_storage_client.dart';
import 'package:clean_architecture/core/clients/remote/connectivity_client.dart';
import 'package:clean_architecture/core/clients/remote/http/http_client.dart';
import 'package:clean_architecture/routing/navigation_client.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockAuthInterceptor extends Mock implements HttpAuthInterceptor {}

class MockInternetClient extends Mock implements ConnectivityClient {}

class MockLocalStorageClient extends Mock implements LocalStorageClient {}

class MockNavigationClient extends Mock implements NavigationClient {}
