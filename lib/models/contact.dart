class Contact {
  static const tblContact = 'contacts';
  static const colID = 'id';
  static const colName = 'name';
  static const colMobile = 'mobile';

  Contact({int? id, String? name, String? mobile});

  late int id;
  late String name;
  late String mobile;

  Contact.fromMap(Map<String, dynamic> map){
    id = map[colID];
    name = map[colName];
    mobile = map[colMobile];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{colName: name, colMobile: mobile};
    if (id != null){
      map[colID] = id;
    }
    return map;
  }

}