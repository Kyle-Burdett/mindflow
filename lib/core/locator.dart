import 'package:get_it/get_it.dart';
import 'package:mindflow/view-models/check_in_view_model.dart';
import 'package:mindflow/view-models/track_view_model.dart';
import 'package:mindflow/view-models/user_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserViewModel());
  locator.registerLazySingleton(() => TrackViewModel());
  locator.registerLazySingleton(() => CheckInViewModel());
}