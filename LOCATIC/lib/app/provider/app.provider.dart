import 'package:locatic/core/notifier/authentication.notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders{
  List<SingleChildWidget> providers = [

    ChangeNotifierProvider(create: (_) => AuthenticationNotifier())
  ];
}