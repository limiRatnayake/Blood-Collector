class InsightsModel {
  final String details;
  final String color;
  final int value;

  InsightsModel({
    this.details,
    this.color,
    this.value,
  });

  InsightsModel.fromMap(Map snapshot)
      : details = snapshot['details'] ?? null,
        color = snapshot['color'] ?? null,
        value = snapshot['value'] ?? null;

  toJson() {
    return {
      "details": details,
      "color": color,
      "value": value,
    };
  }
}
