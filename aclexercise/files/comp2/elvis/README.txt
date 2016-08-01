This directory contains a Java program that will encrypt the text given to it on the command line (EncryptAES.java & EncryptAES.class). Type:

java EncryptAES <plainText>

to encrypt <plainText> with the key inside the java file with AES. The cipherText is then written to the file: javaCipherText.

The program "EncryptAES.py" is the equivalent program in Python and uses the same key. You can run this program by typing:

python EncryptAES.py <plainText>

 As you can see, the Python program is quite a bit shorter and easier to understand, however in Python you need to define the padding yourself. The Python ciphertext is written the to the file: pythonCipherText. You can use the xxd command to examine the two cipher text files and see they are exactly the same.

The C programs encTimeTestJava and encTimeTestPython will load a file and pass it to the encryption programs on the command line (you can run these by, for instance, typing "./encTimeTestJava testFile.txt").

These C programs will also time how long it takes for the encryption programs to run in microseconds. As you can see Python is also faster than Java. Maybe next year I'll use Python for this module.  
