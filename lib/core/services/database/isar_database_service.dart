// import 'package:injectable/injectable.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';

// import '../../../features/auth/data/isar_collections/user_collection.dart';

// abstract interface class IsarDatabaseService {
//   Future<void> put<T>(T collection);
//   Future<void> putAll<T>(List<T> collection);
//   Future<List<T>> getAll<T>();
//   Future<T?> get<T>(int id);
//   Future<void> clearAll();
// }

// @module
// abstract class IsarDatabaseModule {
//   @preResolve
//   Future<Isar> provideIsar() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return await Isar.open(
//       [UserCollectionSchema],
//       directory: directory.path,
//       inspector: true,
//     );
//   }
// }

// @LazySingleton(as: IsarDatabaseService)
// final class IsarDatabaseServiceImpl implements IsarDatabaseService {
//   final Isar _isar;

//   const IsarDatabaseServiceImpl({required Isar isar}) : _isar = isar;

//   @override
//   Future<void> put<T>(T collection) async => await _isar.writeTxn(
//     () async => await _isar.collection<T>().put(collection),
//   );

//   @override
//   Future<void> putAll<T>(List<T> collection) async => await _isar.writeTxn(
//     () async => await _isar.collection<T>().putAll(collection),
//   );

//   @override
//   Future<List<T>> getAll<T>() async =>
//       await _isar.collection<T>().where().findAll();

//   @override
//   Future<T?> get<T>(int id) async => await _isar.collection<T>().get(id);

//   @override
//   Future<void> clearAll() async =>
//       await _isar.writeTxn(() async => await _isar.clear());
// }
