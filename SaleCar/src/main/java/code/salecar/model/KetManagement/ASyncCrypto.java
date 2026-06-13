package code.salecar.model.KetManagement;
import javax.crypto.*;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;


/*
         trang quản lý khoá
            panel 1
         - chọn thuật toán, chọn độ dài khoá
         - chức năng tạo cặp khoá gửi lên servlet bằng ajax sau hiển thị text 2 khoá
         - chức năng lưu private, public key về máy
         - chức năng lưu khoá public lên CSDL ( tạo 1 table là keyPublic )
         - nút reset phiên tạo khoá
            panel 2
         - hiển thị key text, ngày tạo, trạng thái, thuật toán
         - chức năng báo mất khoá hiển thị hộp xác nhận và thay đổi trạng thái đã thu hồi
         - chức năng xem chi tiết khoá
            panel 3
         - hiển thị tất cả khoá đã tạo ( ngày tạo, ngày báo mất khoá)

Chi tiết trang
         -Hiển thị trang thái chìa khoá
          + nếu có kiểm tra trạng thái:
            . ACTIVE hiển thị tên thuật toán, ngày tạo
            . REVOKE hiển thị thông báo đã thu hồi
          + nếu không có, hiển thị thông báo chưa có, câ tạo mới
         -Chức năng tạo khoá
          + đầu vào độ dài khoá, thuật toán
          + hiển thị thanh tiến trình ( trong lúc tạo khoá )
          + hiển thị các khoá đã tạo:
            . chức năng copy text khoá public, private
            . chức năng download khoá về máy
            . chức năng gửi public Key lên server ( kích hoạt khoá ) == > reset lại trang
            . chức năng kiểm tra khoá đã được đưa lên máy chủ chưa để nhắc nhở người dùng
            . chức năng tạo khoá ( nhận đầu vào, hiển thị thanh tiến trình ==> trức tiếp trên frontend
            gen khoá phải trên servlet
            . chức năng huỷ khoá ( trước tải lên server, sau khi tải thì không kích hoạt được )
         -Hiển thị khoá hiện tại ( nếu có , chỉ 1 khoá đang kích hoạt ):
          + hiển thị ( tên thuât toán, fingerfrint ? , mã khoá tóm tắt rút gọn
          + chức năng gửi email
          + chức năng xem chi tiết khoá
          + chức năng báo mất khoá ( có thẻ reset lại trang,
          đầu vào có lý do mất khoá , ghi chú tính huống, mã xác nhận )
         - lịch sử quản lý khoá
          + hiện thị ngày tạo, ngày thu hồi, thuật toán, độ dài ,mã khoá của từng khóa


          ==> servlet Hiển thị trang ( trang thái khoá , khoá hiện tại, lịch sử khoá )
          ==> servlet tạo khoá ( gửi lên thuật toán, kích thước khoá , gen key , sau render lại trên jsp)
          ==> servlet chức năng gửi khoá public lên server kích hoạt khoá = reset trang
          ( có thể kiểm tra người dùng đã tải khoá private chưa sau đó kích hoạt thông báo yêu cầu tải private key)
          ==> servlet chức năng báo mất khoá ( gửi yêu cầu , sau đó reset lại trang )
 */
/*
    Trang ký giấy điện tử
    panel 1
        - uploads private key : xử lý trực tiếp tại frontend không gửi lên server và mà pin chứng thư số
        - tiến hành ký ( cần tìm hiểu kỹ ) gửi lên servlet
        (gôm thông tin đơn hàng cần băm và khoá ) đồng thời hiển thị thanh tiến trình

        - lưu database, tạo đơn hàng



 */

public class ASyncCrypto {
    KeyPair keypair;
    PrivateKey privateKey;
    PublicKey publicKey;
    String typeEn, mode, padding;
    SyncCrypto syncCrypto;

    public ASyncCrypto(){
        syncCrypto = new SyncCrypto();
    }

    public String gen() {return this.typeEn + "/" +this.mode +"/"+ this.padding;}
    public void gen(String type, String mode, String padding) { this.typeEn = type; this.mode= mode;  this.padding = padding;}

    public void genKey() throws Exception{
        KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
        generator.initialize(2048);
        keypair = generator.generateKeyPair();
        publicKey = keypair.getPublic();
        privateKey = keypair.getPrivate();
    }

    public PrivateKey getPrivateKey() {
        return privateKey;
    }

    public PublicKey getPublicKey() {
        return publicKey;
    }

    public String publicKeyToString(PublicKey publicKey) {
        return Base64.getEncoder().encodeToString(publicKey.getEncoded());
    }
    public String privateLeyToString(PrivateKey privateKey) {
        return Base64.getEncoder().encodeToString(privateKey.getEncoded());
    }
    public PublicKey stringToPublicKey(String publicKeyString) throws Exception {
        publicKeyString = publicKeyString.replace("-----BEGIN PUBLIC KEY-----", "").replace("-----END PUBLIC KEY-----", "").replaceAll("\\s", "");
        byte[] keyBytes = Base64.getDecoder().decode(publicKeyString);
        X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PublicKey publicKey1 = keyFactory.generatePublic(spec);
        this.publicKey = publicKey1;
        return publicKey1;
    }
    public PrivateKey stringToPrivateKey(String privateKeyString) throws Exception {
        privateKeyString = privateKeyString.replace("-----BEGIN PRIVATE KEY-----", "").replace("-----END PRIVATE KEY-----", "").replaceAll("\\s", "");
        byte[] keyBytes = Base64.getDecoder().decode(privateKeyString);
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey1 = keyFactory.generatePrivate(spec);
        this.privateKey = privateKey1;
        return privateKey1;
    }
    // -------------------- MÃ HOÁ -----------------------
    // TEXT
    public String encryptBase64(String data)throws Exception{
        return Base64.getEncoder().encodeToString(encrypt(data));
    }
    public byte[] encrypt(String data)throws Exception{
        Cipher cipher = Cipher.getInstance(gen());
        byte[] in = data.getBytes(StandardCharsets.UTF_8);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] out = cipher.doFinal(in);
        return out;
    }

    // FILE
    public void encryptFile(String inputFile, String outputFile, PublicKey publicKey, String type, String mode, String padding, int keySize) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance(type);
        keyGen.init(keySize);
        SecretKey key = keyGen.generateKey();
        int ivSize = getIvSizeForMode(type, mode);
        byte[] ivBytes = new byte[ivSize];
        SecureRandom ran = new SecureRandom();
        ran.nextBytes(ivBytes);
        IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);

        String rsa = gen();
        Cipher rsaCipher = Cipher.getInstance(rsa);
        rsaCipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encryptKey = rsaCipher.doFinal(key.getEncoded());

        String session = type + "/" + mode + "/" + padding;
        Cipher cipher = Cipher.getInstance(session);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        try (FileInputStream fis = new FileInputStream(inputFile);
             FileOutputStream fos = new FileOutputStream(outputFile)) {
            writeConfig(fos, type, mode, padding, keySize);
            fos.write((encryptKey.length >> 8) & 0xFF);
            fos.write(encryptKey.length & 0xFF);
            fos.write(encryptKey);
            fos.write(ivBytes);
            try (CipherOutputStream cos = new CipherOutputStream(fos, cipher)) {
                byte[] read = new byte[8192];
                int i;
                while ((i = fis.read(read)) != -1) {
                    cos.write(read, 0, i);
                }
            }
        }
    }
    // -------------------- GIẢI MÃ -----------------------
    // TEXT
    public String decrypt(String base64)throws Exception{
        Cipher cipher = Cipher.getInstance(gen());
        byte[] in = Base64.getDecoder().decode(base64);
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] out = cipher.doFinal(in);
        return new String(out, StandardCharsets.UTF_8);
    }
    // FILE
    public void decryptFile(String inputFile, String outputFile, PrivateKey privateKey) throws Exception {
        try (FileInputStream fis = new FileInputStream(inputFile); FileOutputStream fos = new FileOutputStream(outputFile)) {
            Config config = readConfig(fis);
            int keyLen = ((fis.read() & 0xFF) << 8) | (fis.read() & 0xFF);
            byte[] encryptKey = new byte[keyLen];
            if (fis.read(encryptKey) != keyLen)
                throw new IOException("Không đọc đủ khóa RSA đã mã hóa");
            int ivSize = getIvSizeForMode(config.type, config.mode);
            byte[] ivBytes = new byte[ivSize];
            if (fis.read(ivBytes) != ivSize)
                throw new IOException("Không đọc đủ IV");
            IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);
            String rsa= gen();
            Cipher rsaCipher = Cipher.getInstance(rsa);
            rsaCipher.init(Cipher.DECRYPT_MODE, privateKey);
            byte[] aesKeyBytes = rsaCipher.doFinal(encryptKey);
            SecretKey aesKey = new SecretKeySpec(aesKeyBytes, config.type);

            String session = config.type + "/" + config.mode + "/" + config.padding;
            Cipher aesCipher = Cipher.getInstance(session);
            aesCipher.init(Cipher.DECRYPT_MODE, aesKey, ivSpec);

            try (CipherInputStream cis = new CipherInputStream(fis, aesCipher)) {
                byte[] read = new byte[8192];
                int i;
                while ((i = cis.read(read)) != -1) {
                    fos.write(read, 0, i);
                }
            }
        }
    }
    private void writeConfig(OutputStream os, String type, String mode, String padding, int keySize) throws IOException {
        byte[] typeBytes = type.getBytes(StandardCharsets.UTF_8);
        os.write(typeBytes.length);
        os.write(typeBytes);
        byte[] modeBytes = mode.getBytes(StandardCharsets.UTF_8);
        os.write(modeBytes.length);
        os.write(modeBytes);
        byte[] paddingBytes = padding.getBytes(StandardCharsets.UTF_8);
        os.write(paddingBytes.length);
        os.write(paddingBytes);

        os.write((keySize >> 24) & 0xFF);
        os.write((keySize >> 16) & 0xFF);
        os.write((keySize >> 8) & 0xFF);
        os.write(keySize & 0xFF);
    }

    private Config readConfig(InputStream is) throws IOException {
        int typeLen = is.read();
        byte[] typeBytes = new byte[typeLen];
        if (is.read(typeBytes) != typeLen) throw new IOException("Lỗi type");
        String type = new String(typeBytes, StandardCharsets.UTF_8);
        int modeLen = is.read();
        byte[] modeBytes = new byte[modeLen];
        if (is.read(modeBytes) != modeLen) throw new IOException("Lỗi mode");
        String mode = new String(modeBytes, StandardCharsets.UTF_8);
        int padLen = is.read();
        byte[] padBytes = new byte[padLen];
        if (is.read(padBytes) != padLen) throw new IOException("Lỗi padding");
        String padding = new String(padBytes, StandardCharsets.UTF_8);
        int keySize = ((is.read() & 0xFF) << 24) | ((is.read() & 0xFF) << 16) | ((is.read() & 0xFF) << 8) | (is.read() & 0xFF);
        return new Config(type, mode, padding, keySize);
    }

    private int getIvSizeForMode(String algorithm, String mode) {
        int blockSize = getBlockSize(algorithm);
        switch (mode.toUpperCase()) {
            case "CBC":
            case "CFB":
            case "OFB":
            case "PCBC":
            case "CTR":
                return blockSize;
            case "GCM": case "CCM":
                return 12;
            default:
                return blockSize;
        }
    }

    private int getBlockSize(String algorithm) {
        switch (algorithm.toUpperCase()) {
            case "AES":
                return 16;
            case "DES":
            case "DESEDE":
            case "BLOWFISH":
                return 8;
            default:
                return 16;
        }
    }
    private static class Config {
        String type, mode, padding;
        int keySize;
        Config(String type, String mode, String padding, int keySize) {
            this.type = type;
            this.mode = mode;
            this.padding = padding;
            this.keySize = keySize;
        }
    }
}

