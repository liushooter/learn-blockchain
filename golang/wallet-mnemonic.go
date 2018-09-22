package main

import (
	"fmt"

	"github.com/tyler-smith/go-bip32"
	"github.com/tyler-smith/go-bip39"
)

func main() {
	entropy, _ := bip39.NewEntropy(128) // 必须128位才能生成12个单词长度的助记词
	mnemonic, _ := bip39.NewMnemonic(entropy)
	seed := bip39.NewSeed(mnemonic, "Passphrase")

	masterKey, _ := bip32.NewMasterKey(seed)
	publicKey := masterKey.PublicKey()

	// Display mnemonic and keys
	fmt.Println("Mnemonic: ", mnemonic)
	fmt.Println("Master private key: ", masterKey)
	fmt.Println("Master public key: ", publicKey)

	departmentKeys := map[string]*bip32.Key{}
	departmentKeys["Sales"], _ = masterKey.NewChildKey(0)
	departmentKeys["Marketing"], _ = masterKey.NewChildKey(1)
	departmentKeys["Engineering"], _ = masterKey.NewChildKey(2)
	departmentKeys["Customer Support"], _ = masterKey.NewChildKey(3)

	// Create public keys for record keeping, auditors, payroll, etc
	departmentAuditKeys := map[string]*bip32.Key{}
	departmentAuditKeys["Sales"] = departmentKeys["Sales"].PublicKey()
	departmentAuditKeys["Marketing"] = departmentKeys["Marketing"].PublicKey()
	departmentAuditKeys["Engineering"] = departmentKeys["Engineering"].PublicKey()
	departmentAuditKeys["Customer Support"] = departmentKeys["Customer Support"].PublicKey()

	for department, pubKey := range departmentAuditKeys {
		fmt.Println(department, ":", pubKey)
	}
}

// https://github.com/tyler-smith/go-bip39
// https://github.com/tyler-smith/go-bip32
