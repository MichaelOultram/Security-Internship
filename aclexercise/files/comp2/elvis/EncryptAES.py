# A simple program to do AES in Python
# For the Intro. Comp. Sec. module, UoB 2014.

from Crypto import Random
from Crypto.Cipher import AES
import sys
import getpass
import pwd
import os

def pad(s):
    x = AES.block_size - len(s) % AES.block_size
    return s + (chr(x) * x)

def encrypt(message, key):
    padded_message = pad(message)
    cipher = AES.new(key, AES.MODE_ECB)
    return cipher.encrypt(padded_message)

def decrypt(ciphertext, key):
    unpad = lambda s: s[:-ord(s[-1])]
    cipher = AES.new(key, AES.MODE_ECB)
    plaintext = unpad(cipher.decrypt(ciphertext))[AES.block_size:]
    return plaintext

if __name__ == '__main__':

    message = sys.argv[1]

    # python for: c12d13ca13551bf3a87664015763fcee
    key='\xc1\x2d\x13\xca\x13\x55\x1b\xf3\xa8\x76\x64\x01\x57\x63\xfc\xee'

    cipherText = encrypt(message,key)

    f = open('pythonCiptherText', 'w')
    f.write(cipherText)
    f.close
