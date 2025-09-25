import '../entities/signature_url.dart';

abstract class SignatureRepo {
  Future<List<SignatureUrl>> getSignatures(String signId);
}
