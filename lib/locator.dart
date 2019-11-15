
import 'package:poloTournamnets/providers/data_service.dart';
import 'package:get_it/get_it.dart';
// import 'package:poloTournamnets/providers/player_provider.dart';
// import 'package:poloTournamnets/providers/tournament_provider.dart';


GetIt locator = GetIt();

void setupLocator() {

  locator.registerLazySingleton(() => DataService());
}