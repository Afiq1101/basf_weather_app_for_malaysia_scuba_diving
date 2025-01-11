
class ScubaSpotModel {

  String id; // id for the scuba spot
  String scubaSpotLabel; // name of scuba spot
  double lat; //latitude of scuba spot
  double long; // longitude of scuba spot
  int priorityIndex; //sort by index, higher the number the higher the priority
  String regionLabel; // the name of the state "Sabah"
  String countryLabel; // name of country  "Malaysia"
  String saveType;  // was is it hard coded or from json

  ScubaSpotModel({
    required this.id,
    required this.scubaSpotLabel,
    required this.lat,
    required this.long,
    required this.priorityIndex,
    required this.regionLabel,
    required this.countryLabel,
    required this.saveType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scubaSpotLabel': scubaSpotLabel,
      'lat': lat,
      'long': long,
      'priorityIndex': priorityIndex,
      'regionLabel': regionLabel,
      'countryLabel': countryLabel,
      'saveType': saveType
    };
  }

  factory ScubaSpotModel.fromJson(Map<String, dynamic> json) {
    return ScubaSpotModel(
      id: json['id'],
      scubaSpotLabel: json['scubaSpotLabel'],
      lat: json['lat'],
      long: json['long'],
      priorityIndex: json['priorityIndex'],
      regionLabel: json['regionLabel'],
      countryLabel: json['countryLabel'],
      saveType: json['saveType'],
    );
  }
}