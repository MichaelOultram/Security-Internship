import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.math.BigInteger;
import java.net.Socket;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;
import javax.crypto.KeyAgreement;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.DHParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class OlivaceousClient {

	// Diffie-Hellman g and p values
	static BigInteger g = new BigInteger("129115595377796797872260754286990587373919932143310995152019820961988539107450691898237693336192317366206087177510922095217647062219921553183876476232430921888985287191036474977937325461650715797148343570627272553218190796724095304058885497484176448065844273193302032730583977829212948191249234100369155852168");
	static BigInteger p = new BigInteger("165599299559711461271372014575825561168377583182463070194199862059444967049140626852928438236366187571526887969259319366449971919367665844413099962594758448603310339244779450534926105586093307455534702963575018551055314397497631095446414992955062052587163874172731570053362641344616087601787442281135614434639");
	
	//Encoding of the RSA public and private key for the client and the servers public key
	//It would be much more secure to use a keystore to keep these keys safe
	static String serverPubKeyEncoding="30819f300d06092a864886f70d010101050003818d003081890281810081bece6fd57a1ecd71c068981ce1d6362daee9b67856ed06db50855c24969d8b2fa79de5e5cbee7f3f84f0c3c9aab95f1c524230ae08b3743860da0557847bb4e56504ea362ae1e76fbe25d8d04cece5af727a83f21478f145971092461a941c271c8172f25975aa84a9e225a614d3e2cdad0c5aa466e1f2d48d64de2934e13f0203010001";	
	static String clientPubKeyEncoding="30819f300d06092a864886f70d010101050003818d0030818902818100a4f7da937d4eb3b82b68827cbac3b14c4f0f1cbd85e357849adaaf0053737d2f161a9cea0941da0a5b4dae406767d2575846f1064429e44317c33111dafb6f1a1d8c22830a2d9cc88b55223e6f47a8ecdffd16bce4d38ff2d35fe3ab58de348c2d1e136acfdc54092c7d241f60cc1fd65a8bdcf46f2473555c346e9b25f3eea50203010001";
	static String clientPrivKeyEncoding="30820276020100300d06092a864886f70d0101010500048202603082025c02010002818100a4f7da937d4eb3b82b68827cbac3b14c4f0f1cbd85e357849adaaf0053737d2f161a9cea0941da0a5b4dae406767d2575846f1064429e44317c33111dafb6f1a1d8c22830a2d9cc88b55223e6f47a8ecdffd16bce4d38ff2d35fe3ab58de348c2d1e136acfdc54092c7d241f60cc1fd65a8bdcf46f2473555c346e9b25f3eea5020301000102818046aeabc865f842a8b670a0f8304d88b9d965f03a8413547c4c9d463e2d835e2fbe98c882be54a8c7a737316206ec4503879f5dc6018eb16ecdcfa446b23ce8ece75544ab15411589cd5fa227deadb90777c6d48abd850bf95ee07825ba99753a6530835b3083f477a4ede27579bdc92288ce84bee5836aa991679c56aa63ce01024100d6d3fcef2e29280e53518ab5c28d83f88ed8bf3bdd5a6564eca948d07990cd773700c3fa6292b6ad682a09df3d3548216d72e6f2448e15e814e54f5b56227239024100c4959cbfd2477510d6a227e0303ffb559aace8a11a0027816747ae32f3bb3e596cc09b09d8824ff13267bfa2a29c815972d987c14e988d274c1cac074c962fcd024003ce4397d52083862571b75c5af2f8d889674b93faeae40af2aa5910e066714d605b121db86b52f3257a412c844012640d3550e40fd4d88c80fa42faa23efff9024100a4827f9697266d7515e8c56dfb72cfa5a7b723460e382ad743d2dc988f1716ea46f437ca598153dd08cd81b55c57947782813ff6290bc8b42621a864c356bbd102407223567859531fdae787c7a6f9f0e0526e6bfc1022cb8abfad5dcafe3c4c148edeb621c9f9081e9ad35a574cdbcd9fa76f842055c403fe898b7cc89a82de8b81";
	static Cipher decAESsessionCipher;
	static Cipher encAESsessionCipher;
	
	static int portNo = 11330;
	static String IPaddy = "127.0.0.1";
	//static String IPaddy = "192.168.56.101";

	public static void main(String[] args) throws Exception {

//		if (args.length!=3) {
//			System.out.println("Usage: java Protocol1Client <IP address> <port number>");
//			System.exit(0);
//		}
//		
//		IPaddy = args[1];
//		portNo = Integer.parseInt(args[2]);
		
		System.out.println("Running protocol with "+IPaddy+" on port "+portNo);
		
		// Initiate the RSA cipher objects.
		byte[] serverPubRSAKeyVerifyBytes = hexStringToByteArray(serverPubKeyEncoding);
		byte[] clientPrivRSAKeySignBytes = hexStringToByteArray(clientPrivKeyEncoding);
		KeyFactory kf = KeyFactory.getInstance("RSA");
		PrivateKey clientPrivRSAKeySign = kf.generatePrivate(new PKCS8EncodedKeySpec(clientPrivRSAKeySignBytes));
		PublicKey serverPubRSAKeyVerify = kf.generatePublic(new X509EncodedKeySpec(serverPubRSAKeyVerifyBytes));
		
		Signature sigObject = Signature.getInstance("SHA256withRSA");
		sigObject.initSign(clientPrivRSAKeySign);
		Signature verifyObject = Signature.getInstance("SHA256withRSA");
		verifyObject.initVerify(serverPubRSAKeyVerify);
			
		// Open the connection to the server
		Socket connection = new Socket(IPaddy,portNo);
		DataOutputStream outStream = new DataOutputStream(connection.getOutputStream());
		DataInputStream inStream = new DataInputStream(connection.getInputStream());
		
		System.out.println("Connected");
		
		// Set up the Diffie Hellman values
		DHParameterSpec dhSpec = new DHParameterSpec(p,g);
		KeyPairGenerator diffieHellmanGen = KeyPairGenerator.getInstance("DiffieHellman");
		diffieHellmanGen.initialize(dhSpec);
		KeyPair clientPair = diffieHellmanGen.generateKeyPair();
		PrivateKey x = clientPair.getPrivate();
		PublicKey gToTheX = clientPair.getPublic();
		
		//Protocol message 1: C -> S: g^x
		//
		//byte[] bytes = hexStringToByteArray(hexKey);
		outStream.writeInt(gToTheX.getEncoded().length);
		outStream.write(gToTheX.getEncoded());
		//System.out.println("g^x len: "+gToTheX.getEncoded().length);
		//System.out.println("g^x cert: "+byteArrayToHexString(gToTheX.getEncoded()));

		//Protocol message 2: S -> C: g^y
		int publicKeyLen = inStream.readInt();
		System.out.println("g^y len: "+publicKeyLen);
		byte[] message2 = new byte[publicKeyLen];
		inStream.read(message2);
		
		//Make the Diffie Hellman key session key
		KeyFactory keyfactoryDH = KeyFactory.getInstance("DH");
		X509EncodedKeySpec x509Spec = new X509EncodedKeySpec(message2);
		PublicKey gToTheY = keyfactoryDH.generatePublic(x509Spec);
		System.out.println("g^y cert: "+byteArrayToHexString(gToTheY.getEncoded()));
		calculateSessionKey(x,gToTheY);
		
		System.out.println("Diffie Hellman key set up");
		
		//Protocol message 3: C -> S: Sign_C{g^y}
		System.out.println("sign");
		sigObject.update(message2);
		byte[] sign = sigObject.sign();
		System.out.println(sign.length);
		System.out.println("Sign: "+byteArrayToHexString(sign));
		
		outStream.write(sign);
		
		//Protocol message 4: S -> C:  Sign_S{g^x}, {sec}_{g^{xy}}
		byte[] message4 = new byte[192];
		inStream.read(message4);
		byte[] serverSign = new byte[128];
		byte[] encSec = new byte[64];
		System.arraycopy(message4, 0, serverSign, 0, 128);
		System.arraycopy(message4, 128, encSec, 0, 64);
		
		//Verify the Server sign.
		verifyObject.update(gToTheX.getEncoded());
		if (verifyObject.verify(serverSign)) {
			System.out.println("Server authenticated");
			//Decrypt the secret
			//byte[] secret = decAESsessionCipher.doFinal(encSec);
			//System.out.println(new String(secret));	
		} else {
			System.out.println("Server authentication failed");
		}
		
	}
	
	// This method sets decAESsessioncipher & encAESsessioncipher 
	private static void calculateSessionKey(PrivateKey y, PublicKey gToTheX)  {
		try {
			// Find g^xy
			KeyAgreement serverKeyAgree = KeyAgreement.getInstance("DiffieHellman");
			serverKeyAgree.init(y);
			serverKeyAgree.doPhase(gToTheX, true);
			byte[] secretDH = serverKeyAgree.generateSecret();
			//if (debug) System.out.println("g^xy: "+byteArrayToHexString(secretDH));
			//Use first 16 bytes of g^xy to make an AES key
			byte[] aesSecret = new byte[16];
			System.arraycopy(secretDH,0,aesSecret,0,16);
			Key aesSessionKey = new SecretKeySpec(aesSecret, "AES");
			System.out.println("Session key: "+byteArrayToHexString(aesSessionKey.getEncoded()));
			// Set up Cipher Objects
			decAESsessionCipher = Cipher.getInstance("AES");
			decAESsessionCipher.init(Cipher.DECRYPT_MODE, aesSessionKey);
			encAESsessionCipher = Cipher.getInstance("AES");
			encAESsessionCipher.init(Cipher.ENCRYPT_MODE, aesSessionKey);
		} catch (NoSuchAlgorithmException e ) {
			System.out.println(e);
		} catch (InvalidKeyException e) {
			System.out.println(e);
		} catch (NoSuchPaddingException e) {
			e.printStackTrace();
		}
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
	
	
}
