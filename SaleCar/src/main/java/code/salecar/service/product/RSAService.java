package code.salecar.service.product;

import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;


public class RSAService {

    private static final String ALGORITHM = "RSA";
    private static final String SIGNATURE_ALGORITHM = "SHA256withRSA";
    private static final int KEY_SIZE = 2048;

    public static KeyPair generateKeyPair() throws NoSuchAlgorithmException {
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance(ALGORITHM);
        keyGen.initialize(KEY_SIZE, new SecureRandom());
        return keyGen.generateKeyPair();
    }


    public static String publicKeyToBase64(PublicKey publicKey) {
        String encoded = Base64.getEncoder().encodeToString(publicKey.getEncoded());
        return "<<BeginPublicKey>>\n" + encoded + "\n<<EndPublicKey>>";
    }

    public static String privateKeyToBase64(PrivateKey privateKey) {
        String encoded = Base64.getEncoder().encodeToString(privateKey.getEncoded());
        return "<<BeginPrivateKey>>\n" + encoded + "\n<<EndPrivateKey>>";
    }

    public static PublicKey parsePublicKey(String base64Key) throws Exception {
        String cleaned = base64Key
                .replace("<<BeginPublicKey>>", "")
                .replace("<<EndPublicKey>>", "")
                .replace("<<BeginPrivateKey>>", "")
                .replace("<<EndPrivateKey>>", "")
                .replaceAll("\\s", "");
        byte[] keyBytes = Base64.getDecoder().decode(cleaned);
        X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(ALGORITHM);
        return keyFactory.generatePublic(spec);
    }


    public static PrivateKey parsePrivateKey(String base64Key) throws Exception {
        String cleaned = base64Key
                .replace("<<BeginPublicKey>>", "")
                .replace("<<EndPublicKey>>", "")
                .replace("<<BeginPrivateKey>>", "")
                .replace("<<EndPrivateKey>>", "")
                .replaceAll("\\s", "");
        byte[] keyBytes = Base64.getDecoder().decode(cleaned);
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(ALGORITHM);
        return keyFactory.generatePrivate(spec);
    }


    public static String sign(String data, PrivateKey privateKey) throws Exception {
        Signature signature = Signature.getInstance(SIGNATURE_ALGORITHM);
        signature.initSign(privateKey);
        signature.update(data.getBytes("UTF-8"));
        byte[] signatureBytes = signature.sign();
        return Base64.getEncoder().encodeToString(signatureBytes);
    }


    public static boolean verify(String data, String base64Signature, PublicKey publicKey) {
        try {
            Signature signature = Signature.getInstance(SIGNATURE_ALGORITHM);
            signature.initVerify(publicKey);
            signature.update(data.getBytes("UTF-8"));
            byte[] signatureBytes = Base64.getDecoder().decode(base64Signature);
            return signature.verify(signatureBytes);
        } catch (Exception e) {
            return false;
        }
    }

    public static String stripKeyBoundaries(String keyString) {
        return keyString
                .replace("<<BeginPublicKey>>", "")
                .replace("<<EndPublicKey>>", "")
                .replace("<<BeginPrivateKey>>", "")
                .replace("<<EndPrivateKey>>", "")
                .trim();
    }
}
