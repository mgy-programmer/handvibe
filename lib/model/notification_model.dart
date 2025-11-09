class NotificationModel{
  late String notificationId;
  late String userId;
  late String myId;
  late String typeOfNotification;
  late String contentId;
  late DateTime dateTime;
  late bool isSeen;

  NotificationModel(this.notificationId, this.userId, this.myId, this.isSeen, this.typeOfNotification, this.contentId, this.dateTime);

  NotificationModel.fromJson(Map json){
    notificationId = json["notificationId"];
    userId = json["userId"];
    myId = json["myId"];
    isSeen = json["isSeen"];
    typeOfNotification = json["typeOfNotification"];
    contentId = json["contentId"]??"";
    dateTime = json["dateTime"].toDate();
  }

  toJson(){
    return {
      "notificationId": notificationId,
      "userId": userId,
      "myId": myId,
      "isSeen": isSeen,
      "typeOfNotification": typeOfNotification,
      "contentId": contentId,
      "dateTime": dateTime,
    };
  }
}

