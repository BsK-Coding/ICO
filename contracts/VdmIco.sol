/* Utilisation des Contrats ERC20 d'Openzeppelin pour la création du Token "VDM" */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Import de fonctions liées au type d'adresse
 */
import "@openzeppelin/contracts/utils/Address.sol";
/**
 * @dev Import de la gestion des membres owners (Liste d'adresses) pour le Smart Contract.
 */
// import "./access/Whitelist.sol";
import "./VieDeMerde.sol";
/**
 * @dev Import de fonction opérateurs d'Openzepellin.
 */
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
/**
 * @dev Import de l'Interface IERC20 d'Openzepellin.
 */
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
/**
 * @dev Import de la gestion des membres owners (Liste d'adresses) pour le Smart Contract.
 */
import "./access/Whitelist.sol";

/**
 * @dev Import du contrat TokenTimelock d'Openzepellin.
 */
import "@openzeppelin/contracts/token/ERC20/utils/TokenTimelock.sol";

// /**
//  * @dev Import de la gestion de calcule pour le Smart Contract.
//  */
// import "./utils/math/Calc.sol";

/**
 * @title Smart Contrat de nos Token VDM Commercial.
 * @dev Création de nos Ico "VDM".
 * @notice VdmIco - Déclaration du contrat et du token VdmIco.
 *  Whitelist   =>  Comportera la gestion d'un groupe de membres owner pour le contrat.
 *                  La gestions des Membres se fera sur la base du Smart contrat Ownable d'Openzepellin.
 */
// abstract contract VdmIco is VieDeMerde, Whitelist, Calculator {
abstract contract VdmIco is VieDeMerde, Whitelist {
    using Address for address payable;
    using SafeMath for uint256;
    // using Calc for int256;

    /**
     * @dev Utilisation des informations de notre Token VieDeMerde généré en ERC20 "VieDeMerde.sol"
     */
    VieDeMerde public token;

    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _depositTime;
    mapping(address => mapping(address => uint256)) private _allowances;
    address private _addressIco = address(this);
    address payable private _beneficiary;
    uint256 private _totalSupply;
    uint256 private _prix;
    uint256 private immutable _releaseTime = 1209600; // 1 209 600 secondes correspondent à 2 semaines
    uint8 private _decimals;

    /**
     * @dev Renseignement des valeurs {prix}, {beneficiary_} et {_addressIco} de notre VdmIco
     *  Prix de 1 unitée de token exprimé en wei.
     */
    constructor(
        uint256 prix,
        address payable beneficiary_,
        address addressIco_
    ) {
        _prix = prix;
        _beneficiary = beneficiary_;
        _addressIco = addressIco_;
        token = VieDeMerde(_addressIco);
    }

    /**
     * @dev Fonction permettant de recevoir des ETHs
     */
    receive() external payable {
        buy(msg.value / _prix);
    }

    /* CODE DE TEST */
    // /**
    //  * @dev the time when the tokens are released.
    //  */
    // function releaseToken() public virtual {
    //     return release();
    // }

    // /**
    //  * @dev Throws if called by any account other than the owner.
    //  */
    // modifier onlyOwner() override {
    //     require(isMember(), "Ownable: caller is not the owner");
    //     _;
    // }

    /**
     * @notice
     *  Prérequis:
     *  - L'acheteur doit avoir suffisamment d'ETH pour la transaction
     *  - Le prix des Tokens acheter ne doit pas dépasser le montant du solde de l'acheteur
     * @dev Fonction permettant l'achat de token
     * @param   "nbToken" nombre de Token à acheter
     */
    function buy(uint256 nbTokens) public payable returns (bool) {
        require(block.timestamp < _releaseTime, "VdmIco: Temps de vente des Token VdmIco terminer");
        require(msg.value >= 0, "VdmIco: Le prix n'est pas de 0 ether");
        require(nbTokens * _prix <= msg.value, "VdmIco: Ether insuffisant pour l'achat");
        require(msg.value == 0.000000001 ether, "VdmIco: Doit envoyer 0.000000001 ether pour l'achat d'un Token");
        uint256 _prixReel = nbTokens * _prix;
        uint256 _restant = msg.value - _prixReel;
        token.transferFrom(_beneficiary, msg.sender, nbTokens);
        _beneficiary.transfer(_prixReel);
        if (_restant > 0) {
            _beneficiary.transfer(_restant);
        }
        return true;
    }

    /**
     * @dev Aperçu de {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Aperçu de {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev Aperçu des droits Owner {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev Aperçu de {IERC20-transfer}.
     *
     * Prérequis:
     *
     * - `recipient` ne peut pas être l'adresse zéro.
     * - Le demandeur doit avoir un solde d'au moins égal à 'amount'.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev Aperçu de {IERC20-approve}.
     *
     * Prérequis:
     *
     * - `spender` ne peut pas être l'adresse zéro.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev Aperçu de {IERC20-transferFrom}.
     *
     * Émet un événement {Approval} indiquant la mise à jour des droits.
     *
     * Prérequis:
     *
     * - `sender` et `recipient` ne peuvent pas être l'adresse zéro.
     * - `sender` doit avoir un solde au moins égal à montant `amount`.
     * - Le demandeur doit avoir les droits pour ``sender`` et des jetons au moins égal à
     * montant `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        require(sender != address(0), "VdmIco: transfer from the zero address");
        require(recipient != address(0), "VdmIco: transfer from the zero address");
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, "VdmIco: transfer amount exceeds allowance")
        );
        return true;
    }

    /**
     * @dev Augmente atomiquement les droits accordée aux dépenser `spender`par les demandeurs.
     *
     * Il s'agit d'une alternative pour {approve} qui peut être utilisée comme mesure pour réduire les
     * problèmes décrits dans {IERC20-approve}.
     *
     *
     * Émet un évènement {Approval} indiquant la mise à jour des droits.
     *
     * Prérequis:
     *
     * - dépenser `spender` ne peut pas être l'adresse zéro.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Diminue atomiquement les droits accordée à `spender`par les demandeurs.
     *
     * Il s'agit d'une alternative pour {approve} qui peut être utilisée comme mesure pour réduire les
     * problèmes décrits dans {IERC20-approve}.
     *
     * Émet un évènement {Approval} indiquant la mise à jour des droits.
     *
     * Prérequis:
     *
     * - `spender` ne peut pas être l'adresse zéro.
     * - `spender` doit avoir les droits pour des demandes au moins égal à
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(subtractedValue, "VdmIco: decreased allowance below zero")
        );
        return true;
    }

    /**
     * @dev Déplace le tokens montant `amount` de `sender` à `recipient`.
     *
     * Cette fonction interne est équivalente à {transfert} et peut être utilisée pour
     * mettre en œuvre des frais de jetons automatiques, des mécanismes de réduction, etc.
     *
     * Émet un évènement {Transfer}.
     *
     * Prérequis:
     *
     * - `sender` ne peut pas être l'adresse zéro.
     * - `recipient` ne peut pas être l'adresse zéro.
     * - `sender` doit avoir un solde au moins égal à montant `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        require(sender != address(0), "VdmIco: transfer from the zero address");
        require(recipient != address(0), "VdmIco: transfer to the zero address");
        _beforeTokenTransfer(sender, recipient, amount);
        _balances[sender] = _balances[sender].sub(amount, "VdmIco: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Créer un montant `amount` de Token et les attribue à `account`, en augmentant l'offre total.
     *
     * Émet un évènement {Transfer} avec `from` mis à l'adresse zéro.
     *
     * Prérequis:
     *
     * - `to` ne peut pas être l'adresse zéro.
     */
    function _mint(address account, uint256 amount) internal virtual override {
        require(account != address(0), "VdmIco: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Détruit un montant `amount` de token de `account`, réduisant l'offre totale.
     *
     * Émet un évènement {Transfer} avec `to` mis à l'adresse zéro.
     *
     * Prérequis:
     *
     * - `account` ne peut pas être l'adresse zéro.
     * - `account` doit avoir au moins un montant `amount` de token.
     */
    function _burn(address account, uint256 amount) internal virtual override {
        require(account != address(0), "VdmIco: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "VdmIco: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * Cette fonction interne équivaut à «approuver» et peut être utilisée pour
     * par exemple. définir des allocations automatiques pour certains sous-systèmes, etc.
     *
     * Emits an {Approval} event.
     *
     * Prérequis:
     *
     * - `owner` ne peut pas être l'adresse zéro.
     * - `spender` ne paut pas être l'adresse zéro.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual override {
        require(owner != address(0), "VdmIco: approve from the zero address");
        require(spender != address(0), "VdmIco: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: Sa fonction ne doit être appelée que depuis le constructeur.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook qui est appelé avant tout transfert de jetons. Ceci comprend
     * le monnayage et le brûlage de jetons.
     *
     * Appels de conditions:
     *
     * - lorsque `from` et `to` sont tous deux différents de zéro, montant `amount` des tokens ``from``
     * sera transféré à `to`.
     * - lorsque `from` est égal à zéro, des jetons montant `amount` seront émis pour `to`.
     * - lorsque `to` vaut zéro, le montant `amount` des jetons ``from`` sera brûlé.
     * - `from` et `to` ne sont jamais nuls.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {}
}
