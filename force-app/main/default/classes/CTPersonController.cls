public with sharing class CTPersonController {
    
    public static String getToken(String mobile){

        //Creating token
        Blob target = Blob.valueOf(mobile);
        Blob hash   = Crypto.generateDigest('MD5', target);

        return EncodingUtil.base64Encode(hash);
    }
}
