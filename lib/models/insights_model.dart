// class InsightsModel {
//   final String taskDetails;
//   final String colorVal;
//   final int taskVal;

//   InsightsModel({
//     this.taskDetails,
//     this.colorVal,
//     this.taskVal,
//   });

//   InsightsModel.fromMap(Map snapshot)
//       : taskDetails = snapshot['taskDetails'] ?? null,
//         colorVal = snapshot['colorVal'] ?? null,
//         taskVal = snapshot['taskVal'] ?? null;

//   toJson() {
//     return {
//       "taskDetails": taskDetails,
//       "colorVal": colorVal,
//       "taskVal": taskVal,
//     };
//   }
// }
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
