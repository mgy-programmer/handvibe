class ReportModel{
  late String reportId;
  late String reportType;
  late String complainantId; //Şikayet Eden Kişi
  late String accusedId; //Şikayet Edilen Kişi (Sanık)
  late String reportNote;
  late String complainingId; //Şikayet Edilen içeriğin idsi

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