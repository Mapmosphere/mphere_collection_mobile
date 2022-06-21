class SearchType {
  late String singular;
  late String plural;
  late Map<String, String> tags;

  SearchType(this.singular, this.plural, this.tags);

  SearchType.fromJson(Map<dynamic, dynamic> json) {
    singular = json['name']['singular'];
    plural = json['name']['plural'];

    Map<String, String> tags = Map();

    json['tags'].forEach((key, value) {
      tags[key] = value;
    });

    this.tags = tags;
  }
}
