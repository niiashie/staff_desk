import 'package:leave_desk/services/app_service.dart';
import 'package:leave_desk/services/image_compression_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerSingleton<DialogService>(DialogService());
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<AppService>(AppService());
  locator.registerSingleton<ImageCompressionService>(ImageCompressionService());
  // locator.registerSingleton<PrintService>(PrintService());
}
