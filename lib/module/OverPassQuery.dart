import 'package:mapmosphere/module/SetElementModule.dart';

class OverPassQuery {
  String output;
  int timeOut;
  late List<SetElement> elements;

  OverPassQuery({
    required this.output,
    required this.timeOut,
    required this.elements,
  });

  Map<String, String> toMap() {
    String elementsString = '';

    for (SetElement element in elements) {
      elementsString += '$element;';
    }

    String data = '[out:$output][timeout:$timeOut];($elementsString);out;';

    return <String, String>{'data': data};
  }
}
