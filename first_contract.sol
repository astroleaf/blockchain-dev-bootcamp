// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

//this is needed to be written in the start of all the programs

contract jump{
    
    uint public  max_height = 30;
    uint public  max_achievable_height = 15;
    uint public  x = 20;
    int8 public  c = 123;

    //this is the function for the function for using the pure function
    function setter(uint enter_height) public pure{
        uint alpha;
        alpha = enter_height;

        if (alpha<15) {
            alpha = alpha-1;
            
        }
    }

    function setterllocal(uint num) public pure{
        uint a;
        a = num;
    }

    function setterstate(uint num) public{
        x = num;
    }

    function getterstate() public view returns(uint){
        return x;
    }


}