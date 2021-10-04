/* import 'package:encrypt/encrypt.dart';
import 'package:meta/meta.dart';

final mSALT = 'D:pLC&g&Uz\$azD=~\$jCG:U#h<wSrfHTB';

final iv = IV.fromLength(16);
final key = Key.fromUtf8(mSALT);
final encrypter = Encrypter(AES(key));

Encrypted encrypt({
  @required String data,
}) {
  final encrypted = encrypter.encrypt(data, iv: iv);
  //print('Base64: ' + encrypted.base64);
  //print('Base16: ' + encrypted.base16);
  return encrypted;
}

String decrypt16({@required String encrypted}) {
  final decrypted = encrypter.decrypt16(encrypted, iv: iv);
 // print('hash: ' + encrypted);
  return decrypted;
}
 */