package main

import (
	"flag"
	"log"
	"time"

	"github.com/nsqio/go-nsq"
)

func main() {
	go startConsumer()
	startProducer()
}

var url string

func init() {
	//具体ip,端口根据实际情况传入或者修改默认配置
	flag.StringVar(&url, "url", "127.0.0.1:4150", "nsqd")
	flag.Parse()
}

// 生产者
func startProducer() {
	cfg := nsq.NewConfig()
	producer, err := nsq.NewProducer(url, cfg)
	if err != nil {
		log.Fatal(err)
	}
	// 发布消息
	for {
		if err := producer.Publish("test", []byte("test message")); err != nil {
			log.Fatal("publish error: " + err.Error())
		}
		time.Sleep(1 * time.Second)
	}
}

// 消费者
func startConsumer() {
	cfg := nsq.NewConfig()
	consumer, err := nsq.NewConsumer("test", "sensor01", cfg)
	if err != nil {
		log.Fatal(err)
	}
	// 设置消息处理函数
	consumer.AddHandler(nsq.HandlerFunc(func(message *nsq.Message) error {
		log.Println(string(message.Body))
		return nil
	}))
	// 连接到单例nsqd
	if err := consumer.ConnectToNSQD(url); err != nil {
		log.Fatal(err)
	}
	<-consumer.StopChan
}
