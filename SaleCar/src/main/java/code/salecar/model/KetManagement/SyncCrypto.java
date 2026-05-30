package code.salecar.model.KetManagement;

import javax.crypto.*;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.util.Base64;
import java.util.Map;
import java.util.Set;
//import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class SyncCrypto {
    String typeEn, mode, padding;
    SecretKey key;
    IvParameterSpec iv;
    // KEY
    public SecretKey genKey(String algorithm,int keySize) throws NoSuchAlgorithmException, NoSuchProviderException {
        KeyGenerator keyGenerator = KeyGenerator.getInstance(algorithm, "BC");
        keyGenerator.init(keySize);
        key = keyGenerator.generateKey();
        return key;
    }
    public SecretKey getKey() {
        return key;
    }

    public String secretKeyToString(SecretKey secretKey) {
        return Base64.getEncoder().encodeToString(secretKey.getEncoded());
    }
    public SecretKey stringToSecretKey(String encodedKey, String algorithm) {
        byte[] decodedKey = Base64.getDecoder().decode(encodedKey);
        return new SecretKeySpec(decodedKey, algorithm);
    }

    // IV
    public IvParameterSpec genIv(int ivSize) {
        iv = new IvParameterSpec(new byte[ivSize]);
        return iv;
    }
    public static byte[] base64ToIv(String base64) {
        return Base64.getDecoder().decode(base64);
    }
    public void loadKey(SecretKey key) {
        this.key = key;
    }

    // thiết lập phiên giải mã, mã hoá
    public void gen(String type, String mode, String padding) { this.typeEn = type; this.mode= mode;  this.padding = padding;}

    public String gen() {return this.typeEn + "/" +this.mode +"/"+ this.padding;}
    // --------------------- MÃ HOÁ --------------------------
    // TEXT
    public byte[] encrypt(String text) throws IllegalBlockSizeException, BadPaddingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, NoSuchProviderException {
        String gen = gen();
        Cipher cipher = Cipher.getInstance(gen, "BC");
        cipher.init(Cipher.ENCRYPT_MODE, this.key,iv);
        byte[] data = text.getBytes(StandardCharsets.UTF_8);
        return cipher.doFinal(data);
    }
    public String encyptBase64(String text) throws InvalidKeyException, IllegalBlockSizeException, BadPaddingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, NoSuchProviderException {
        return Base64.getEncoder().encodeToString(encrypt(text));
    }
    public byte[] StringToBase64(String encodedKey) throws InvalidKeyException, IllegalBlockSizeException, BadPaddingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException {
        return Base64.getDecoder().decode(encodedKey);
    }
    // FILE
    public boolean encryptFile(String src, String des) throws Exception {
        Cipher cipher = Cipher.getInstance(this.typeEn, "BC");
        cipher.init(Cipher.ENCRYPT_MODE, this.key);

        try (BufferedInputStream input = new BufferedInputStream(new FileInputStream(src));
             BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(des));
             CipherInputStream in = new CipherInputStream(input, cipher)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
        return true;
    }
    // --------------------- GIẢI MÃ --------------------------
    // TEXT
    public String descrypt(byte[] data) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException, NoSuchProviderException {
        String gen = gen();
        Cipher cipher = Cipher.getInstance(gen, "BC");
        cipher.init(Cipher.DECRYPT_MODE, this.key, iv);
        byte[] bytes = cipher.doFinal(data);
        return new String(bytes,StandardCharsets.UTF_8);
    }
    // FILE
    public boolean decryptFile(String src, String des) throws Exception {
        Cipher cipher = Cipher.getInstance(this.typeEn, "BC");
        cipher.init(Cipher.DECRYPT_MODE, this.key);

        try (BufferedInputStream input = new BufferedInputStream(new FileInputStream(src));
             BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(des));
             CipherOutputStream cipherOut = new CipherOutputStream(out, cipher)) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                cipherOut.write(buffer, 0, bytesRead);
            }
        }
        return true;
    }
    private static final Set<String> STREAM_MODES = Set.of(
            "CBC",
            "CFB", "CFB8", "CFB16", "CFB32", "CFB64", "CFB128",
            "OFB", "OFB8", "OFB16", "OFB32", "OFB64", "OFB128",
            "PCBC",
            "CTR",
            "EAX"
    );
    public int getIvSizeForMode(String algorithm, String mode)throws Exception {
        algorithm = algorithm.toUpperCase();
        mode = mode.toUpperCase();
        if (mode.equals("GCM") || mode.equals("CCM")) {
            return 12;
        }
        if (mode.equals("ECB")) {
            return 0;
        }
        if (STREAM_MODES.contains(mode)) {
            return getBlockSize(algorithm);
        }
        return getBlockSize(algorithm);
    }

    private int getBlockSize(String algorithm) throws Exception {
        Cipher cipher = Cipher.getInstance(algorithm, "BC");
        return cipher.getBlockSize();
    }
}

