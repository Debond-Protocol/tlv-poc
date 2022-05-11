# tlv-poc
```
Tag Length Value PoC Implementation and Testing 

[Tag: Tag is a 1 Byte value which defines the type of Value in the standard Tag Length Value Encoding.]

[Since the Tag is a 1 byte long value, there are 2^8 = 256 possible values (from 0 to 255).]

Here are the possible values of the tag.

Tag (Hex)	Field			Data Type		Description
0		Ignore Tag 		NA			Ignore the L bytes value
—--------------------------------------------------<< CLASS >>—--------------------------------------------------
1		Class Id		Number, 2 bytes	        Class Id of the bond
2		Token Symbol	        String, 3-5 bytes	Symbol of the underlying asset
3		Token Address	        Hex, 20 bytes		Address of the token
4		Interest Type		0 = float, 1 = fixed	Interest type for the bond
|
|
—--------------------------------------------------<< NONCE >>—--------------------------------------------------
21		Maturity Date		Unix time, 4 bytes	Maturity date of the bond
22		Liquidity		Number, 8 bytes	        Liquidity at the time of bond issue
 |
 |
—-------------------------------------------------<< AUCTION >>—-------------------------------------------------
41		Final Bidder		Hex, 20 bytes		Address of the Final Bidder
42		End Time		Unix TIme, 4 bytes	End Time of the Auction
43		Final Price		Number, 4 Bytes	        Closing Price of the Auction
 |
 |
—-----------------------------------------------<<SYSTEM>>------------------------------------------------------
F0		Nested Tag		NA			Generic Nested Tag Structure
F1		Nested Class Tag	NA			Class Nested Tag Structure
F2		Nested Nonce Tag	NA			Nonce Nested Tag
F3		Nested Auction Tag	NA	
```

