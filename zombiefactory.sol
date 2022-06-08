//SPDX-License-Identifier: Unlicensed
//pragma solidity >=0.5.0 <0.6.0;
pragma solidity ^0.8.14;


contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    //public массив с зомби
    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) private {
        
        //для старых версий компилятора  >=0.5.0 <0.6.0
        //uint id = zombies.push(Zombie(_name, _dna)) - 1;
        
        //для новой версии компилятора, начиная с ^0.8.14  
        zombies.push(Zombie(_name, _dna));
        uint id = zombies.length - 1;
        
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);

    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
       
        //abi.encodePacked(_str) - преобразует строку в тип bytes
        //keccak256 - превращает bytes в рандомное 256-битное шестнадцатеричное число
        uint rand  = uint(keccak256(abi.encodePacked(_str)));
       
        //Остаток от деления по модулю. Делим на 10^16. Почлучаем число 16 знаков
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
       
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);

    }

}