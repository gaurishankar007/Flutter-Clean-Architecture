import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract interface class PackageInfoService {
  Future<PackageInfo> getPackageInformation();
}

@LazySingleton(as: PackageInfoService)
final class PackageInfoServiceImpl implements PackageInfoService {
  @override
  Future<PackageInfo> getPackageInformation() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
