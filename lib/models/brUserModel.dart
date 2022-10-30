

class BrUser {

  String? id;
  String? email;
  String? name ;
  String? pwd;
  String? joinDate;
  String? currency;
  bool? hasStores;
  bool isAdmin;
  bool verified;
  List? stores;




  BrUser({
    this.id = 'no-id',
    this.email = 'no-email',
    this.name = 'no-name',
    this.joinDate = 'no-join',
    this.currency = 'no-curr',
    this.hasStores = false,
    this.isAdmin = false,
    this.verified = false,
    this.pwd  = 'no-pwd',
    this.stores = const [],
  });
}


BrUser BrUserFromMap(userDoc){

  BrUser user =BrUser();

  user.id = userDoc.get('id');
  user.email = userDoc.get('email');
  user.pwd = userDoc.get('pwd');
  user.name = userDoc.get('name');
  user.verified = userDoc.get('verified');
  user.isAdmin = userDoc.get('isAdmin');
  user.joinDate = userDoc.get('joinDate');
  user.currency = userDoc.get('currency');
  user.stores = userDoc.get('stores');
  user.hasStores = user.stores!.isNotEmpty;


  print('## User_Props_loaded');


  return user;
}

printUser(BrUser user){
  print(
      '#### USER ####'
          '--id: ${user.id} \n'
          '--email: ${user.email} \n'
          '--pwd: ${user.pwd} \n'
          '--name: ${user.name} \n'
          '--verified: ${user.verified} \n'
          '--isAdmin: ${user.isAdmin} \n'
          '--currency: ${user.currency} \n'
          '--joinDate: ${user.joinDate} \n'
          '--stores: ${user.stores} \n'
          '--hasStores: ${user.hasStores} \n'

  );
}