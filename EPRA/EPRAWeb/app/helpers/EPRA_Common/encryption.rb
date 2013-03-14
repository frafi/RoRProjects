module EPRA_Common
	class Encryption
		def initialize()
			@_salt = "5@qt_qweu3_rd1@bc"
			@_password = "ur5asdfw0rd15_asicva22##"
		end

		def Encryption.Encrypt(data)
			saltBytes = UTF8Encoding.UTF8.GetBytes(@_salt)
			# Our symmetric encryption algorithm
			aes = AesManaged.new()
			# We're using the PBKDF2 standard for password-based key generation
			rfc = Rfc2898DeriveBytes.new(@_password, saltBytes)
			# Setting our parameters
			aes.BlockSize = aes.LegalBlockSizes[0].MaxSize
			aes.KeySize = aes.LegalKeySizes[0].MaxSize
			aes.Key = rfc.GetBytes(aes.KeySize / 8)
			aes.IV = rfc.GetBytes(aes.BlockSize / 8)
			# Encryption
			encryptTransf = aes.CreateEncryptor()
			# Output stream, can be also a FileStream
			encryptedStream = MemoryStream.new()
			encryptor = CryptoStream.new(encryptedStream, encryptTransf, CryptoStreamMode.Write)
			encryptor.Write(data, 0, data.Length)
			encryptor.Flush()
			encryptor.Close()
			# Showing our encrypted content
			encryptedBytes = encryptedStream.ToArray()
			return encryptedBytes
		end

		def Encryption.Decrypt(encryptedBytes)
			saltBytes = Encoding.UTF8.GetBytes(@_salt)
			# Our symmetric encryption algorithm
			aes = AesManaged.new()
			# We're using the PBKDF2 standard for password-based key generation
			rfc = Rfc2898DeriveBytes.new(@_password, saltBytes)
			# Setting our parameters
			aes.BlockSize = aes.LegalBlockSizes[0].MaxSize
			aes.KeySize = aes.LegalKeySizes[0].MaxSize
			aes.Key = rfc.GetBytes(aes.KeySize / 8)
			aes.IV = rfc.GetBytes(aes.BlockSize / 8)
			# Now, decryption
			decryptTrans = aes.CreateDecryptor()
			# Output stream, can be also a FileStream
			decryptedStream = MemoryStream.new()
			decryptor = CryptoStream.new(decryptedStream, decryptTrans, CryptoStreamMode.Write)
			decryptor.Write(encryptedBytes, 0, encryptedBytes.Length)
			decryptor.Flush()
			decryptor.Close()
			# Showing our decrypted content
			decryptedBytes = decryptedStream.ToArray()
			return decryptedBytes
		end

		def Encryption.Encrypt(input)
			# Test data
			data = input
			utfdata = UTF8Encoding.UTF8.GetBytes(data)
			saltBytes = UTF8Encoding.UTF8.GetBytes(@_salt)
			# Our symmetric encryption algorithm
			aes = AesManaged.new()
			# We're using the PBKDF2 standard for password-based key generation
			rfc = Rfc2898DeriveBytes.new(@_password, saltBytes)
			# Setting our parameters
			aes.BlockSize = aes.LegalBlockSizes[0].MaxSize
			aes.KeySize = aes.LegalKeySizes[0].MaxSize
			aes.Key = rfc.GetBytes(aes.KeySize / 8)
			aes.IV = rfc.GetBytes(aes.BlockSize / 8)
			# Encryption
			encryptTransf = aes.CreateEncryptor()
			# Output stream, can be also a FileStream
			encryptStream = MemoryStream.new()
			encryptor = CryptoStream.new(encryptStream, encryptTransf, CryptoStreamMode.Write)
			encryptor.Write(utfdata, 0, utfdata.Length)
			encryptor.Flush()
			encryptor.Close()
			# Showing our encrypted content
			encryptBytes = encryptStream.ToArray()
			#string encryptedString = UTF8Encoding.UTF8.GetString(encryptBytes, 0, encryptBytes.Length);
			encryptedString = Convert.ToBase64String(encryptBytes)
			#System.Diagnostics.Debug.WriteLine(encryptedString);
			return encryptedString
		end

		def Encryption.Decrypt(base64Input)
			#byte[] encryptBytes = UTF8Encoding.UTF8.GetBytes(input);
			encryptBytes = Convert.FromBase64String(base64Input)
			saltBytes = Encoding.UTF8.GetBytes(@_salt)
			# Our symmetric encryption algorithm
			aes = AesManaged.new()
			# We're using the PBKDF2 standard for password-based key generation
			rfc = Rfc2898DeriveBytes.new(@_password, saltBytes)
			# Setting our parameters
			aes.BlockSize = aes.LegalBlockSizes[0].MaxSize
			aes.KeySize = aes.LegalKeySizes[0].MaxSize
			aes.Key = rfc.GetBytes(aes.KeySize / 8)
			aes.IV = rfc.GetBytes(aes.BlockSize / 8)
			# Now, decryption
			decryptTrans = aes.CreateDecryptor()
			# Output stream, can be also a FileStream
			decryptStream = MemoryStream.new()
			decryptor = CryptoStream.new(decryptStream, decryptTrans, CryptoStreamMode.Write)
			decryptor.Write(encryptBytes, 0, encryptBytes.Length)
			decryptor.Flush()
			decryptor.Close()
			# Showing our decrypted content
			decryptBytes = decryptStream.ToArray()
			decryptedString = UTF8Encoding.UTF8.GetString(decryptBytes, 0, decryptBytes.Length)
			#System.Diagnostics.Debug.WriteLine(decryptedString);
			return decryptedString
		end
	end
end