// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract demo{
   uint[3] public array = [10,20,30];
   
   funciton returnarr() public view returns(uint[3] memory){
      return array;

}

}