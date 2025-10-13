import 'package:get_it/get_it.dart';
import 'package:mindflow/view-models/track_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => TrackViewModel());
}