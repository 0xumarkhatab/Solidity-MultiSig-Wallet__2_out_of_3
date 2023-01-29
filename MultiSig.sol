pragma solidity ^0.8.0;

contract MultiSig {
    struct Transaction {
        address[] potentialSigners;
        address[] signers;
    }

    mapping(bytes32 => Transaction) public transactions;

    function proposeTransaction(bytes32 txHash, address[] memory potentialSigners) public {
        require(potentialSigners.length == 3, "Three potential signers are required");
        transactions[txHash] = Transaction(potentialSigners, new address[](0));
    }

    function confirmTransaction(bytes32 txHash) public {
        require(msg.sender in transactions[txHash].potentialSigners, "Sender is not a potential signer for this transaction");
        require(!(msg.sender in transactions[txHash].signers), "Sender has already signed this transaction");
        transactions[txHash].signers.push(msg.sender);
        if (transactions[txHash].signers.length >= 2) {
            executeTransaction(txHash);
        }
    }

    function executeTransaction(bytes32 txHash) internal {
        // Perform the actual execution of the transaction here
        require(transactions[txHash].signers.length >= 2, "Two or more signers are required to execute the transaction");
        //Delete the transaction after execution
        delete transactions[txHash];
    }
}
