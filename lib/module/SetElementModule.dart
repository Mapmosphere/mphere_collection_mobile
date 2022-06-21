import 'package:mapmosphere/module/LocationArea.dart';

class SetElement {
  Map<String, String> tags;
  final LocationArea area;

  SetElement({required this.tags, required this.area});

  @override
  String toString() {
    String tagString = '';

    tags.forEach((key, value) {
      tagString += '["$key"="$value"]';
    });

    String areaString =
        '(around:${area.radius},${area.latitude},${area.longitude})';

    return 'node$tagString$areaString';
  }
}
