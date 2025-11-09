class ReportModel{
  late String reportId;
  late String reportType;
  late String complainantId;
  late String accusedId;
  late String reportNote;
  late String complainingId;

  ReportModel(this.reportId, this.reportType, this.complainantId, this.accusedId, this.reportNote, this.complainingId);

  ReportModel.fromJson(Map json){
    reportId = json["reportId"];
    reportType = json["reportType"];
    complainantId = json["complainantId"];
    accusedId = json["accusedId"];
    reportNote = json["reportNote"];
    complainingId = json["complainingId"];
  }

  toJson(){
    return {
      "reportId": reportId,
      "reportType": reportType,
      "complainantId": complainantId,
      "accusedId": accusedId,
      "reportNote": reportNote,
      "complainingId": complainingId,
    };
  }
}
