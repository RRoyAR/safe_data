class EncryptionData
{
	String displayName;
	String cipherText;
	String initializationVector;

	EncryptionData(this.cipherText, this.initializationVector, this.displayName);

	EncryptionData.fromJson(Map<String, dynamic> json):
		displayName = json["displayName"],
		cipherText = json["cipherText"],
		initializationVector = json["initializeVector"];

	Map<String, dynamic> toJson() =>
	{
		"displayName": displayName,
		"cipherText": cipherText,
		"initializeVector": initializationVector
	};
}
