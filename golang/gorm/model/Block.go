package model

import (
	"time"
	// "github.com/jinzhu/gorm"
)

type dbBlock struct {
	// gorm.Model

	ID         int       `json:"id"`
	Height     int       `json:"height"`
	Timestamp  int       `json:"timestamp"`
	TxsNum     int       `json:"txs_num"`
	Hash       string    `json:"hash"`
	ParentHash string    `json:"parent_hash"`
	UncleHash  string    `json:"uncle_hash"`
	Coinbase   string    `json:"coinbase"`
	Difficulty int       `json:"difficulty"`
	Size       int       `json:"size"`
	GasUsed    int       `json:"gas_used"`
	GasLimit   int       `json:"gas_limit"`
	Nonce      int       `json:"nonce"`
	Reward     int       `json:"reward"`
	ExtraData  string    `json:"extra_data"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}

func (dbBlock) TableName() string {
	return "blocks" // 数据库名
}
