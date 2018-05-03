package spider

// 基础包
import (
	"github.com/henrylee2cn/pholcus/app/downloader/request" //必需
	. "github.com/henrylee2cn/pholcus/app/spider"           //必需
	// . "github.com/henrylee2cn/pholcus/app/spider/common"    //选用
	"github.com/henrylee2cn/pholcus/common/goquery" //DOM解析
	// "github.com/henrylee2cn/pholcus/logs"       //信息输出

	// net包
	// "net/http" //设置http.Header
	// "net/url"

	// 编码包
	// "encoding/xml"
	// "encoding/json"

	// 字符串处理包
	// "regexp"
	// "strconv"
	// 其他包
	"fmt"
	// "math"
	// "time"
)

func init() {
	Jinsecaijing.Register()
}

var Jinsecaijing = &Spider{
	Name:        "金色财经",
	Description: "金色财经新闻 [https://www.jinse.com/xinwen]",
	// Pausetime: 300,
	// Keyin:     KEYIN,
	// Limit:     LIMIT,
	EnableCookie: false,
	RuleTree: &RuleTree{
		Root: func(ctx *Context) {
			ctx.AddQueue(&request.Request{Url: "https://www.jinse.com/xinwen", Rule: "获取新闻URL"})
		},

		Trunk: map[string]*Rule{

			"获取新闻URL": {
				ParseFunc: func(ctx *Context) {
					query := ctx.GetDom()
					lis := query.Find(".article-main div ol a")
					lis.Each(func(i int, s *goquery.Selection) {
						if i == 0 {
							return
						}

						if url, ok := s.Attr("href"); ok {
							fmt.Print("url is: ", url, "\n")
							ctx.AddQueue(&request.Request{Url: url, Rule: "新闻详情", Temp: map[string]interface{}{"goodsType": s.Text()}})
						}
					})
				},
			},

			"新闻详情": {
				ParseFunc: func(ctx *Context) {
					query := ctx.GetDom()

					title := query.Find("h2").Text()
					// info := query.Find(".article-info").Text()
					content := query.Find("p").Text()


					fmt.Print("title: ", title, "\n")
					fmt.Print(" -------------------- ")
					fmt.Print("content: ", content, "\n")

					ctx.Output(map[int]interface{}{
						0: title,
						1: content,
						2: ctx.GetTemp("goodsType", ""),
					})

				},
			},
		},
	},
}
