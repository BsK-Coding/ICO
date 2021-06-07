// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// event Add(address indexed account, int256 nb1, int256 nb2, int256 res);
// event Sub(address indexed account, int256 nb1, int256 nb2, int256 res);
// event Mul(address indexed account, int256 nb1, int256 nb2, int256 res);
// event Div(address indexed account, int256 nb1, int256 nb2, int256 res);
// event Mod(address indexed account, int256 nb1, int256 nb2, int256 res);

/**
 * @dev Solidity's arithmetic operations.
 */
library Calc {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(int256 nb1, int256 nb2) public pure returns (int256) {
        // emit Add(msg.sender, nb1, nb2, nb1 + nb2);
        return nb1 + nb2;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(int256 nb1, int256 nb2) public pure returns (int256) {
        // emit Sub(msg.sender, nb1, nb2, nb1 - nb2);
        return nb1 - nb2;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(int256 nb1, int256 nb2) public pure returns (int256) {
        // emit Mul(msg.sender, nb1, nb2, nb1 * nb2);
        return nb1 * nb2;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(int256 nb1, int256 nb2) public pure returns (int256) {
        require(nb2 > 0, "Calc: cannot divide by zero");
        // emit Div(msg.sender, nb1, nb2, nb1 / nb2);
        return nb1 / nb2;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(int256 nb1, int256 nb2) public pure returns (int256) {
        // emit Mod(msg.sender, nb1, nb2, nb1 % nb2);
        return nb1 % nb2;
    }
}

/* Brouillon Partie de code pour les dépenses en GAS */
/*
    function GasCost(string memory name, function() internal returns (string memory) fun)
        internal
        returns (string memory)
    {
        uint256 u0 = gasleft();
        string memory sm = fun();
        uint256 u1 = gasleft();
        uint256 diff = u0 - u1;
        return concat(name, " GasCost: ", stringOfUint(diff), " returns(", sm, ")");
    }
*/
