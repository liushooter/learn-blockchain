package main

import (
	"fmt"

	"github.com/upyun/go-sdk/upyun"
)

func main() {

	up := upyun.NewUpYun(&upyun.UpYunConfig{
		Bucket:   "img",
		Operator: "upyun",
		Password: "upyun",
	})

	notifyUrl := ""
	localPath := "./lenna.jpg"
	saveKey := localPath

	resp, err := up.FormUpload(&upyun.FormUploadConfig{
		LocalPath:      localPath,
		SaveKey:        saveKey,
		NotifyUrl:      notifyUrl,
		ExpireAfterSec: 60,
		Options:        nil, //map[string]interface{}{"x-gmkerl-thumb": "/format/png"},
	})

	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(resp.Code, resp.Msg, resp.Taskids)
	}

}
