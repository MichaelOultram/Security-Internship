
// ICS 2015 Protocol Exercise 3 Part 1 Server,
//
// Implements the server side of:
//
// C -> S: {SessionKey}_Kcs,
// S -> C: N_S, {N_S}_Kcs, {Sec}_{SessionKey}

import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.security.Key;
import java.security.SecureRandom;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

public class Protocol3 implements Runnable {

	static int portNo = 11337;
	static String hexKey = "hex_key";
	static Cipher decAEScipher;
	static Cipher encAEScipher;

	public static void main(String[] args) throws Exception {
		new Protocol3().run();
	}

	private static class ProtocolInstance implements Runnable {
		Socket myConnection;

		public ProtocolInstance(Socket myConnection) {
			this.myConnection = myConnection;
		}

		public void run() {
			OutputStream outStream;
			InputStream inStream;
			try {
				outStream = myConnection.getOutputStream();
				inStream = myConnection.getInputStream();

				//
				// Message1: C -> S: {SessionKey}_Kcs
				//
				byte[] message1 = new byte[32];
				inStream.read(message1);
				byte[] sessionKey = decAEScipher.doFinal(message1);
				Key aesKey = new SecretKeySpec(sessionKey, "AES");
				System.out.print("KEY: ");
				System.out.println(byteArrayToHexString(sessionKey));
				Cipher encAESsessionCipher = Cipher.getInstance("AES");
				encAESsessionCipher.init(Cipher.ENCRYPT_MODE, aesKey);

				//
				// Message2: S-> C: N_S, {N_S}_Kcs, {Sec}_{SessionKey}
				//
				SecureRandom gen = new SecureRandom();
				byte[] nonce = new byte[16];
				gen.nextBytes(nonce);
				byte[] message2 = new byte[112];
				System.arraycopy(nonce, 0, message2, 0, 16);
				System.arraycopy(encAEScipher.doFinal(nonce), 0, message2, 16, 32);
				byte[] secret = ("Well Done. Submit this value: " + secretValue()).getBytes();
				System.arraycopy(encAESsessionCipher.doFinal(secret), 0, message2, 48, 64);
				outStream.write(message2);
				outStream.flush();
				myConnection.close();
			} catch (Exception e) {
				System.out.println("Exception  " + e);
				return;
			}
		}
	}

	private static String secretValue() {
		return "token";
	}

	private static byte[] hexStringToByteArray(String s) {
		int len = s.length();
		byte[] data = new byte[len / 2];
		for (int i = 0; i < len; i += 2) {
			data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1), 16));
		}
		return data;
	}

	private static String byteArrayToHexString(byte[] data) {
		StringBuffer buf = new StringBuffer();
		for (int i = 0; i < data.length; i++) {
			int halfbyte = (data[i] >>> 4) & 0x0F;
			int two_halfs = 0;
			do {
				if ((0 <= halfbyte) && (halfbyte <= 9)) buf.append((char) ('0' + halfbyte));
				else buf.append((char) ('a' + (halfbyte - 10)));
				halfbyte = data[i] & 0x0F;
			} while (two_halfs++ < 1);
		}
		return buf.toString();
	}

	@Override
	public void run() {
		try {
			// Initiate the AES cipher objects for the long term key.
			Key aesKey = new SecretKeySpec(hexStringToByteArray(hexKey), "AES");
			decAEScipher = Cipher.getInstance("AES");
			decAEScipher.init(Cipher.DECRYPT_MODE, aesKey);
			encAEScipher = Cipher.getInstance("AES");
			encAEScipher.init(Cipher.ENCRYPT_MODE, aesKey);

			// Listen for connections for the client
			ServerSocket listening = new ServerSocket(portNo);
			while (true) {
				// For each connection spin off a new protocol instance.
				Socket connection = listening.accept();
				Thread instance = new Thread(new ProtocolInstance(connection));
				instance.start();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
