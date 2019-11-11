
import 'package:poloTournamnets/business/api_firebase.dart';
import 'package:get_it/get_it.dart';
import 'package:poloTournamnets/models/providers/tournament_provider.dart';


GetIt locator = GetIt();

void setupLocator() {

  locator.registerLazySingleton(() => ApiFirebase('tournaments'));
  locator.registerLazySingleton(() => TorunamentProvider()) ;
}