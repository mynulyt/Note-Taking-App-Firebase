

class NoteModel{
  String id;
  String? title;
  String? text;

  NoteModel({required this.id, this.title, this.text});
  
  NoteModel.fromJson(Map<String, dynamic>Json, this.id){
    title = Json["title"];
    text = Json["text"];
  }

Map<String, dynamic>toJson(){
  return {
    "id": id,
    "title":title,
    "text": text,
  };

}
}