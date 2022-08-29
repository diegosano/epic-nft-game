// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract EpicGame is ERC721 {
    struct Character {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    Character[] defaultCharacters;

    mapping(uint256 => Character) public holderCharacter;
    mapping(address => uint256) public holders;

    struct Boss {
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    Boss public boss;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        uint256 bossHp,
        uint256 bossAttackDamage
    ) ERC721("Heroes", "HERO") {
        boss = Boss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });

        for (uint256 i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(
                Character({
                    characterIndex: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    hp: characterHp[i],
                    maxHp: characterHp[i],
                    attackDamage: characterAttackDmg[i]
                })
            );

            Character memory c = defaultCharacters[i];

            console.log(
                "Personagem inicializado: %s com %s de HP, img %s",
                c.name,
                c.hp,
                c.imageURI
            );

            _tokenIds.increment();
        }
    }

    function mintCharacter(uint256 _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        holderCharacter[newItemId] = Character({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log(
            "Minted NFT with token ID %s e characterIndex %s",
            newItemId,
            _characterIndex
        );

        holders[msg.sender] = newItemId;

        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        Character memory character = holderCharacter[_tokenId];

        string memory strHp = Strings.toString(character.hp);
        string memory strMaxHp = Strings.toString(character.maxHp);
        string memory strAttackDamage = Strings.toString(
            character.attackDamage
        );

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                character.name,
                " -- NFT #: ",
                Strings.toString(_tokenId),
                '", "description": "This NFT gives access to my game!", "image": "',
                character.imageURI,
                '", "attributes": [ { "trait_type": "Health Points", "value": ',
                strHp,
                ', "max_value":',
                strMaxHp,
                '}, { "trait_type": "Attack Damage", "value": ',
                strAttackDamage,
                "} ]}"
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    function attackBoss() public {
        uint256 characterId = holders[msg.sender];
        Character storage character = holderCharacter[characterId];

        console.log(
            "\nCharacter %s \nHP: %s \nAP:%s",
            character.name,
            character.hp,
            character.attackDamage
        );
        console.log(
            "\nBoss %s \nHP: %s \n:AP %s",
            boss.name,
            boss.hp,
            boss.attackDamage
        );

        require(
            character.hp > 0,
            "Error: character need positive HP to attack the boss!"
        );

        require(
            boss.hp > 0,
            "Error: boss need positive HP to be attacked by the character!"
        );

        if (boss.hp < character.attackDamage) {
            boss.hp = 0;
        } else {
            boss.hp = boss.hp - character.attackDamage;
        }

        console.log("Character attacks. Boss HP: %s", boss.hp);

        if (character.hp < boss.attackDamage) {
            character.hp = 0;
        } else {
            character.hp = character.hp - boss.attackDamage;
        }

        console.log("Boss attacks. Character HP: %s", character.hp);
    }
}
