class MediaHideModel{
  late String mediaPath;
  late String mediaName;
  late String mediaThumbnail;

  MediaHideModel(this.mediaPath, this.mediaName, {this.mediaThumbnail = ""});

  MediaHideModel.fromJson(Map json){
    mediaPath = json["mediaPath"];
    mediaName = json["mediaName"];
    mediaThumbnail = json["mediaThumbnail"]??"";
  }

  toJson(){
    return {
      "mediaPath": mediaPath,
      "mediaName": mediaName,
      "mediaThumbnail": mediaThumbnail,
    };
  }
}