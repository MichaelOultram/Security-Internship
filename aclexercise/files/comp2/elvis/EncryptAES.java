// A simple program to do AES in Java
// For the Intro. Comp. Sec. module, UoB 2014.

import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.Provider;
import java.security.Security;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.spec.SecretKeySpec;
import java.io.FileOutputStream;
import java.util.Arrays;

public class EncryptAES {

    static String hexKey="c12d13ca13551bf3a87664015763fcee";
    public static void main(String[] args) {


	String plainText = args[0];

	try {
	    //Initiate the cipher and key objects for encryption
	    Key aesKey = new SecretKeySpec(hexStringToByteArray(hexKey), "AES");
	    Cipher encAEScipher = Cipher.getInstance("AES");
	    encAEScipher.init(Cipher.ENCRYPT_MODE, aesKey);


	    // Encrypt the plain text
	    byte[] cipherText = encAEScipher.doFinal(plainText.getBytes());

	    // Write cipherText to file
	    FileOutputStream outToFile = new FileOutputStream("javaCipherText");
	    outToFile.write(cipherText);
	    outToFile.close();

	} catch (Exception e){
	    System.out.println("Doh "+e);
	}
    }


    private static String byteArrayToHexString(byte[] data) {
	StringBuffer buf = new StringBuffer();
	for (int i = 0; i < data.length; i++) {
	    int halfbyte = (data[i] >>> 4) & 0x0F;
	    int two_halfs = 0;
	    do {
		if ((0 <= halfbyte) && (halfbyte <= 9))
		    buf.append((char) ('0' + halfbyte));
		else
		    buf.append((char) ('a' + (halfbyte - 10)));
		halfbyte = data[i] & 0x0F;
	    } while(two_halfs++ < 1);
	}
	return buf.toString();
    }


    private static byte[] hexStringToByteArray(String s) {
	int len = s.length();
	byte[] data = new byte[len / 2];
	for (int i = 0; i < len; i += 2) {
	    data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
				  + Character.digit(s.charAt(i+1), 16));
	}
	return data;
    }
}
