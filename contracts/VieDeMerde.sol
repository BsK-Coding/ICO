/* Utilisation de contrat ERC20 d'Openzeppelin pour la création du Token "VDM" */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Création du Token VDM
 * @notice Ce Smart Contrat créer uniquement un Token VDM en ERC20
 * @dev L'utilisation du token ERC20 d'Openzeppelin permettra une modularité du contrat
 */
contract VieDeMerde is ERC20 {
    /**
     * @dev Constructeur du contrat.
     * @param owner_ sera "le propriétaire du Smart Contrat"
     * @param initialSupply sera le "nombre de token créé"
     */
    constructor(address owner_, uint256 initialSupply) ERC20("VieDeMerde", "VDM") {
        _mint(owner_, initialSupply);
    }
}
