package code.salecar.model.KeyManament;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.security.*;
import java.security.spec.X509EncodedKeySpec;

public class VerSig {
    public static void main(String[] args)  {
        try{
            FileInputStream keyfis = new FileInputStream(""); //đường dẫn
            byte[] encKey = new byte[keyfis.available()];
            keyfis.read(encKey);
            keyfis.close();

            X509EncodedKeySpec pubKeySpec = new X509EncodedKeySpec(encKey);
            KeyFactory keyFactory = KeyFactory.getInstance("DSA","SUN");
            PublicKey pubKey = keyFactory.generatePublic(pubKeySpec);

            FileInputStream sigfis = new FileInputStream("");
            byte[] sigToVerify = new byte[sigfis.available()];
            sigfis.read(sigToVerify);
            sigfis.close();

            Signature sig = Signature.getInstance("SHA1withDSA","SUN");
            sig.initVerify(pubKey);
            FileInputStream datafis = new FileInputStream(""); //Đường dẫn
            BufferedInputStream bufin = new BufferedInputStream(datafis);

            byte[] buffer = new byte[1024];
            int len;
            while((len = bufin.read(buffer)) != -1){
                sig.update(buffer,0, len);
            };
            bufin.close();

            boolean verifies = sig.verify(sigToVerify);
            System.out.println("signature verifies: " + verifies);

        } catch (Exception e) {
            System.err.println("Caught exception " + e.toString());
        }
    }}
