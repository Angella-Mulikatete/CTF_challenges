// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "../src/Challenge2.sol";

contract ChallengeTwoTest is Test{
    ChallengeTwo chal2;

    address owner = makeAddr("owner");
    address userAddress = makeAddr("user");
    string public rpcUrl;
    
  // Storage slot calculations for private mappings
    // bytes32 constant HASSOLVED1_POSITION = keccak256("hasSolved1");
    // bytes32 constant HASSOLVED2_POSITION = keccak256("hasSolved2");
    // bytes32 constant HASCOMPLETED_POSITION = keccak256("hasCompleted");

    bytes32 constant HASSOLVED1_POSITION = 0;
    bytes32 constant HASSOLVED2_POSITION = bytes32(uint256(1));
    bytes32 constant HASCOMPLETED_POSITION = keccak256("hasCompleted");

    function setUp() public {
        rpcUrl = vm.envString("MAINNET_RPC_URL");
        vm.createSelectFork(rpcUrl);
        vm.startPrank(owner);
        chal2 = new ChallengeTwo();
        vm.stopPrank();
    }

    function getStorageBoolean(bytes32 position, address user) internal view returns (bool) {
        bytes32 slot = keccak256(abi.encode(user, position));
        uint256 value;
        assembly {
            value := sload(slot)
        }
        return value == 1;
    }

    function setHasSolved1(address user, bool value) internal {
        bytes32 slot = keccak256(abi.encode(user, HASSOLVED1_POSITION));
        vm.store(address(chal2), slot, bytes32(uint256(value ? 1 : 0)));
    }


    // Helper functions to check private mapping values
    function getHasSolved1(address user) public view returns (bool) {
        return getStorageBoolean(HASSOLVED1_POSITION, user);
    }

    function getHasSolved2(address user) public view returns (bool) {
        return getStorageBoolean(HASSOLVED2_POSITION, user);
    }

    function getHasCompleted(address user) public view returns (bool) {
        return getStorageBoolean(HASCOMPLETED_POSITION, user);
    }


    function passkey(address c) public {
        for (uint16 i = 0; i <= type(uint16).max; ++i) {
            if (
                keccak256(abi.encode(i)) ==
                0xd8a1c3b3a94284f14146eb77d9b0decfe294c3ba72a437151caae86c3c8b2070
            ) {
                ChallengeTwo(c).passKey(i);
                console2.log("key found", i);
                break;
            }
        }
    }

    function test_passKey_success() public {
        vm.prank(userAddress);
        passkey(address(chal2));
        assertTrue(getHasSolved1(userAddress));
        vm.stopPrank();
    }

    function testFail_passKey_wrongKey() public {
        uint16 wrongKey = 12345;
        vm.prank(userAddress);
        chal2.passKey(wrongKey);
    }

    function testFail_getEnoughPoint_withoutLevel1() public {
        vm.prank(userAddress);
        chal2.getENoughPoint("TestUser");
    }


}

// https://eth-mainnet.g.alchemy.com/v2/QVY2UstBJhd7ELG4N6yM2GNbve_RT-0Y
     // Test passKey function
    // function test_passKey() public {
    //     uint16 key = 31337; 
    //     vm.startPrank(userAddress);
    //     chal2.passKey(key);
    //     assertTrue(getHasSolved1(userAddress));
    //     vm.stopPrank();
    // }

    // function testFail_passKey_wrongKey() public {
    //     uint16 wrongKey = 12345;
    //     vm.prank(userAddress);
    //     chal2.passKey(wrongKey);
    // }