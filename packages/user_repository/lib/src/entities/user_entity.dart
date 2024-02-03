import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userID;
  final String email;
  final String name;

  const MyUserEntity({
    required this.userID,
    required this.email
    ,required this.name,
  });
  Map<String,Object?> toDocument(){
    return {
    'userId' :userID,
    'email' :email,
    'name' :name,
    };
  }

  static MyUserEntity fromDocument(Map<String,dynamic> doc){
    return MyUserEntity(userID: doc['userId'], email: doc['email'], name: doc['name']);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [userID,email,name];
}