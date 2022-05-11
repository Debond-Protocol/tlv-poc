from brownie import network, accounts, config, EncDecTLV


def deploy_enc_dec_tlv():
    account = get_account()

    enc_dec_tlv = EncDecTLV.deploy({"from": account})
    stored_value = enc_dec_tlv.addInfo(
        1,  # Data in Hex
        "0203425443"  # BTC
        + "03140102030405060708091011121314151617181920"  # Token Address
        + "040101"  # Interest Type
        + "2104627C022D"  # Maturity Date
        + "220800000000627C022D"  # Liquidity
        + "41140102030405060708091011121314151617181920"  # Bidder Address
        + "4204627C022D"  # End Time
        + "4304000003E8",  # Final Price
        {"from": account},
    )

    stored_value = enc_dec_tlv.getTokenAddress(1, {"from": account})
    print(len(stored_value))
    print(stored_value)

    stored_value = enc_dec_tlv.getTokenSymbol(1, {"from": account})
    print(len(stored_value))
    print(stored_value)

    stored_value = enc_dec_tlv.getInterestType(1, {"from": account})
    print(stored_value)

    stored_value = enc_dec_tlv.getMaturityDate(1, {"from": account})
    print(stored_value)

    stored_value = enc_dec_tlv.getLiquidity(1, {"from": account})
    print(stored_value)

    stored_value = enc_dec_tlv.getBidderAddress(1, {"from": account})
    print(len(stored_value))
    print(stored_value)

    stored_value = enc_dec_tlv.getEndTime(1, {"from": account})
    print(stored_value)

    stored_value = enc_dec_tlv.getFinalPrice(1, {"from": account})
    print(stored_value)

    stored_value = enc_dec_tlv.setBidderAddress(
        1, "0x1112030405060708091011121314151617181920", {"from": account}
    )
    print(stored_value)

    stored_value = enc_dec_tlv.getBidderAddress(1, {"from": account})
    print(len(stored_value))
    print(stored_value)

    stored_value = enc_dec_tlv.setEndTime(1, {"from": account})
    print(stored_value)

    stored_value = enc_dec_tlv.getEndTime(1, {"from": account})
    print(stored_value)

    stored_value = enc_dec_tlv.setFinalPrice(1, 1500, {"from": account})
    print(stored_value)

    stored_value = enc_dec_tlv.getFinalPrice(1, {"from": account})
    print(stored_value)


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def main():
    deploy_enc_dec_tlv()
