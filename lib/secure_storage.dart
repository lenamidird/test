
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{




  // Create storage
  final storage = new FlutterSecureStorage();


  Future stockToken(String Key)async{

    var tokenStocked= await storage.write(key: 'jwt', value: Key);

    print('Key');
    print(Key);
    await storage.deleteAll();
    print('remove storage');
    Map<String, String> allValues = await storage.readAll();
    print(allValues);

    return tokenStocked;



  }

}



