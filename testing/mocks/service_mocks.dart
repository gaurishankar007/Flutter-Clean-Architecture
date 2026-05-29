import 'package:clean_architecture/core/services/encryption_service.dart';
import 'package:clean_architecture/core/services/package_info_service.dart';
import 'package:mocktail/mocktail.dart';

class MockPackageInfoService extends Mock implements PackageInfoService {}

class MockEncryptionService extends Mock implements EncryptionService {}
