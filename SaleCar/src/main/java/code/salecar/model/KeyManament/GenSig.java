package code.salecar.model.KeyManament;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.security.*;

public class GenSig {
    public static void main(String[] args) {
        try{
            KeyPairGenerator keyGen = KeyPairGenerator.getInstance("DSA","SUN"); //key DSA
            SecureRandom random = SecureRandom.getInstance("SHA1PRNG","SUN");
            keyGen.initialize(1024,random);
            KeyPair pair = keyGen.generateKeyPair();
            PrivateKey priv = pair.getPrivate();
            PublicKey pub = pair.getPublic();

            Signature dsa = Signature.getInstance("SHA1withDSA","SUN");
            dsa.initSign(priv);
            FileInputStream fis = new FileInputStream("F:"); // đường dẫn
            BufferedInputStream bufin = new BufferedInputStream(fis);
            byte[] bufer = new byte[1024];
            int len;
            while ((len = bufin.read(bufer)) != -1){
                dsa.update(bufer, 0, len);
            };
            bufin.close();
            byte[] realSig = dsa.sign();
            //save signature
            FileOutputStream sigfos = new FileOutputStream(""); // đường dẫn
            sigfos.write(realSig);
            sigfos.close();
            //save public key
            byte[] key = pub.getEncoded();
            FileOutputStream keyfos = new FileOutputStream(""); // đường dẫn
            keyfos.write(key);
            keyfos.close();
        } catch(Exception e){
            System.err.println("Caught exception " + e.toString());
        }
    }
}

