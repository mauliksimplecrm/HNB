//
//  EncDec.swift
//  HNB
//
//  Created by Maulik Vora on 27/11/23.
//

import Foundation

class encDecription{
    /*
    func encryptAES(plain_text: String, cipherMode: String, passphrase: String) {
        var sugar_config = ""
        let passphrase = strtolower(empty($passphrase) ? $sugar_config['API_TRANSIT_AES_ENCRYPTION_KEY'] : $passphrase);
        $cipherMode = strtolower(empty($cipherMode) ? $sugar_config['API_TRANSIT_AES_ENCRYPTION_CIPHER_MODE'] : $cipherMode);

        // Generate random salt and IV
        if ($cipherMode == 'aes-256-gcm' || $cipherMode == 'aes-128-gcm') {
            $iv = random_bytes(12); // Corresponds to 96 bits
            $keySize = ($cipherMode === 'aes-256-gcm') ? 32 : 16;

            // Derive key using PBKDF2
            $key = hash_pbkdf2("sha512", $passphrase, 16, 999, $keySize, true); // 32 bytes key

            // Encrypt using AES
            $encrypted = openssl_encrypt($plain_text, $cipherMode, $key, OPENSSL_RAW_DATA, $iv, $tag);
            $slam_ol = $tag;
        } else {
            $slam_ol = random_bytes(256); // Corresponds to 256 bits
            $iv = random_bytes(16); // Corresponds to 128 bits

            // Derive key using PBKDF2
            $key = hash_pbkdf2("sha512", $passphrase, $slam_ol, 999, 64, true);

            // Encrypt using AES
            $encrypted = openssl_encrypt($plain_text, $cipherMode, $key, OPENSSL_RAW_DATA, $iv);
        }


        // Prepare the data array
        $data = array(
            'amtext' => base64_encode($encrypted),
            'slam_ltol' => bin2hex($slam_ol),
            'iavmol' => bin2hex($iv)
        );

        // Return the base64-encoded JSON string
        return base64_encode(json_encode($data));
    }

    /**
     * Decrypts AES-encrypted data with support for various modes.
     *
     * @param string $encryptedData The encrypted data in base64-encoded JSON format.
     * @param string $cipherMode The AES cipher mode used for encryption. (e.g., 'aes-256-cbc', 'aes-128-gcm', etc.).
     * @param string $passphrase Cipher Secret Key.
     *
     * @return string|bool The decrypted plaintext or false on failure.
     *
     * @author Bhushan
     */
    function decryptAES($encryptedData, $cipherMode = '', $passphrase = '') {
        try {
            global $sugar_config;
            $passphrase = strtolower(empty($passphrase) ? $sugar_config['API_TRANSIT_AES_ENCRYPTION_KEY'] : $passphrase);
            $cipherMode = strtolower(empty($cipherMode) ? $sugar_config['API_TRANSIT_AES_ENCRYPTION_CIPHER_MODE'] : $cipherMode);

            // Decode the base64-encoded and JSON data
            $enc_text = json_decode(base64_decode($encryptedData), true);

            // Extract necessary components
            $slam_ol = hex2bin($enc_text["slam_ltol"]);
            $iavmol = hex2bin($enc_text["iavmol"]);
            $ciphertext = base64_decode($enc_text["amtext"]);

            if ($cipherMode == 'aes-256-gcm' || $cipherMode == 'aes-128-gcm') {
                // Determine the key size based on the cipher mode (32 bytes for AES-256-GCM, 16 bytes for AES-128-GCM).
                $keySize = ($cipherMode === 'aes-256-gcm') ? 32 : 16;

                // Generate the encryption key
                $key = hash_pbkdf2("sha512", $passphrase, 16, 999, $keySize, true);

                // Decrypt using AES-GCM
                $decrypted = openssl_decrypt($ciphertext, $cipherMode, $key, OPENSSL_RAW_DATA, $iavmol, $slam_ol);
            } else {
                // For non-GCM modes (e.g., AES-CBC), derive the key using PBKDF2 with a fixed 64 bytes key.
                // Generate the encryption key
                $key = hash_pbkdf2("sha512", $passphrase, $slam_ol, 999, 64);

                // Decrypt the data
                $decrypted = openssl_decrypt($ciphertext, $cipherMode, hex2bin($key), OPENSSL_RAW_DATA, $iavmol);
            }

            return $decrypted;
        } catch (Exception $e) {
            return null;
        }
    }
*/
}
