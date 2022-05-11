//SPDX-License-Identifier: Apache 2.0

pragma solidity ^0.8.0;

contract EncDecTLV {
    //Database
    mapping(uint16 => bytes) public classes;
    address public admin;

    constructor() public {
        admin = msg.sender;
    }

    //Add Data to Database
    function addInfo(uint16 _classId, bytes memory _info) public {
        require(msg.sender == admin, "Not Authorized");
        classes[_classId] = _info;
    }

    //Get Bytes
    function getBytes(
        bytes memory _infoBytes,
        bytes1 _tag,
        uint8 _expLen
    ) private pure returns (bytes memory) {
        uint256 _pointer = 0;
        uint8 _len = 0;

        while (_pointer < _infoBytes.length - 1) {
            _len = uint8(_infoBytes[_pointer + 1]);

            if (_infoBytes[_pointer] != _tag) {
                _pointer += uint256(_len) + 2;
            } else {
                require(_len <= _expLen, "Invalid Encoding");
                uint256 _startIndex = _pointer + 2;
                uint256 _endIndex = _startIndex + uint256(_len) - 1;

                bytes memory _result = new bytes(_len);
                //start filling from right
                for (uint256 i = _endIndex; i >= _startIndex; i--) {
                    _result[--_len] = _infoBytes[i];
                }
                return _result;
            }
        }
    }

    //Class Info Getters
    function getTokenAddress(uint16 _classId) public view returns (address) {
        bytes memory _info = classes[_classId];
        //Tag = 0x03, Size = 20
        return address(uint160(bytes20(getBytes(_info, 0x03, 20))));
    }

    function getTokenSymbol(uint16 _classId)
        public
        view
        returns (string memory)
    {
        bytes memory _info = classes[_classId];
        //Tag = 0x02, Size = 5
        return string(getBytes(_info, 0x02, 5));
    }

    function getInterestType(uint16 _classId) public view returns (uint8) {
        bytes memory _info = classes[_classId];
        //Tag = 0x04, Size = 1
        return uint8(bytes1(getBytes(_info, 0x04, 1)));
    }

    //Nonce Info Getters
    function getMaturityDate(uint16 _classId) public view returns (uint32) {
        bytes memory _info = classes[_classId];
        //Tag = 0x21, Size = 4
        return uint32(bytes4(getBytes(_info, 0x21, 4)));
    }

    function getLiquidity(uint16 _classId) public view returns (uint256) {
        bytes memory _info = classes[_classId];
        //Tag = 0x22, Size = 8
        return uint256(uint64(bytes8(getBytes(_info, 0x22, 8)))) * 10**18;
    }

    //Auction Info Getters
    function getBidderAddress(uint16 _classId) public view returns (address) {
        bytes memory _info = classes[_classId];
        //Tag = 0x41, Size = 20
        return address(uint160(bytes20(getBytes(_info, 0x41, 20))));
    }

    function getEndTime(uint16 _classId) public view returns (uint32) {
        bytes memory _info = classes[_classId];
        //Tag = 0x42, Size = 4
        return uint32(bytes4(getBytes(_info, 0x42, 4)));
    }

    function getFinalPrice(uint16 _classId) public view returns (uint32) {
        bytes memory _info = classes[_classId];
        //Tag = 0x43, Size = 4
        return uint32(bytes4(getBytes(_info, 0x43, 4)));
    }

    function setBytes(
        uint16 _classId,
        bytes memory _dataBytes,
        bytes1 _tag,
        uint8 _expLen
    ) private {
        uint256 _pointer = 0;
        uint8 _len;

        bytes memory test = classes[_classId];

        while (_pointer < test.length - 1) {
            _len = uint8(test[_pointer + 1]);

            if (test[_pointer] != _tag) {
                _pointer += uint256(_len) + 2;
            } else {
                require(_len == _expLen, "Invalid Length");
                uint256 _startIndex = _pointer + 2;
                uint256 _endIndex = _startIndex + uint256(_len) - 1;

                for (uint256 i = _endIndex; i >= _startIndex; i--) {
                    test[i] = _dataBytes[--_len];
                }
                classes[_classId] = test;
                return;
            }
        }
    }

    function setBidderAddress(uint16 _classId, address _bidderAddress) public {
        bytes memory _dataBytes = abi.encodePacked(_bidderAddress);
        setBytes(_classId, _dataBytes, 0x41, 20);
    }

    function setEndTime(uint16 _classId) public {
        bytes memory _dataBytes = abi.encodePacked(uint32(block.timestamp));
        setBytes(_classId, _dataBytes, 0x42, 4);
    }

    function setFinalPrice(uint16 _classId, uint32 _finalPrice) public {
        bytes memory _dataBytes = abi.encodePacked(_finalPrice);
        setBytes(_classId, _dataBytes, 0x43, 4);
    }
}
