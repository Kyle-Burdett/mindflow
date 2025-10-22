import 'package:get_it/get_it.dart';
// Note: Adjusted path assuming user_view_model.dart is in the view-models folder
import '../view-models/user_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register the UserViewModel as a Lazy Singleton
  if (!locator.isRegistered<UserViewModel>()) {
    locator.registerLazySingleton<UserViewModel>(() => UserViewModel());
  }
}
