package code.salecar.model.KetManagement;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigInteger;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Hash {
    public String checkSum(String input,String algorithm) {
        try {
            MessageDigest md = MessageDigest.getInstance(algorithm);
            byte[] massageDigest = md.digest(input.getBytes());
            BigInteger number = new BigInteger(1,massageDigest); // binary
            return number.toString(16);
        }catch(NoSuchAlgorithmException e) {
            throw new RuntimeException();
        }
    }
    public String hash(String file,String algorithm)throws Exception{
        MessageDigest digest = MessageDigest.getInstance(algorithm);
        InputStream is = new BufferedInputStream(new FileInputStream(file));
        DigestInputStream dis = new DigestInputStream(is, digest);

        byte[] buffer = new byte[1624];
        int read;
        do {
            read = dis.read(buffer);
        }while (read != -1);
        BigInteger number = new BigInteger(1,dis.getMessageDigest().digest());
        dis.close();
        return number.toString();
    }
}

