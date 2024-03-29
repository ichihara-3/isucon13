package main

var tagMap = map[int64]string{
	1:   "ライブ配信",
	2:   "ゲーム実況",
	3:   "生放送",
	4:   "アドバイス",
	5:   "初心者歓迎",
	6:   "プロゲーマー",
	7:   "新作ゲーム",
	8:   "レトロゲーム",
	9:   "RPG",
	10:  "FPS",
	11:  "アクションゲーム",
	12:  "対戦ゲーム",
	13:  "マルチプレイ",
	14:  "シングルプレイ",
	15:  "ゲーム解説",
	16:  "ホラーゲーム",
	17:  "イベント生放送",
	18:  "新情報発表",
	19:  "Q&Aセッション",
	20:  "チャット交流",
	21:  "視聴者参加",
	22:  "音楽ライブ",
	23:  "カバーソング",
	24:  "オリジナル楽曲",
	25:  "アコースティック",
	26:  "歌配信",
	27:  "楽器演奏",
	28:  "ギター",
	29:  "ピアノ",
	30:  "バンドセッション",
	31:  "DJセット",
	32:  "トーク配信",
	33:  "朝活",
	34:  "夜ふかし",
	35:  "日常話",
	36:  "趣味の話",
	37:  "語学学習",
	38:  "お料理配信",
	39:  "手料理",
	40:  "レシピ紹介",
	41:  "アート配信",
	42:  "絵描き",
	43:  "DIY",
	44:  "手芸",
	45:  "アニメトーク",
	46:  "映画レビュー",
	47:  "読書感想",
	48:  "ファッション",
	49:  "メイク",
	50:  "ビューティー",
	51:  "健康",
	52:  "ワークアウト",
	53:  "ヨガ",
	54:  "ダンス",
	55:  "旅行記",
	56:  "アウトドア",
	57:  "キャンプ",
	58:  "ペットと一緒",
	59:  "猫",
	60:  "犬",
	61:  "釣り",
	62:  "ガーデニング",
	63:  "テクノロジー",
	64:  "ガジェット紹介",
	65:  "プログラミング",
	66:  "DIY電子工作",
	67:  "ニュース解説",
	68:  "歴史",
	69:  "文化",
	70:  "社会問題",
	71:  "心理学",
	72:  "宇宙",
	73:  "科学",
	74:  "マジック",
	75:  "コメディ",
	76:  "スポーツ",
	77:  "サッカー",
	78:  "野球",
	79:  "バスケットボール",
	80:  "ライフハック",
	81:  "教育",
	82:  "子育て",
	83:  "ビジネス",
	84:  "起業",
	85:  "投資",
	86:  "仮想通貨",
	87:  "株式投資",
	88:  "不動産",
	89:  "キャリア",
	90:  "スピリチュアル",
	91:  "占い",
	92:  "手相",
	93:  "オカルト",
	94:  "UFO",
	95:  "都市伝説",
	96:  "コンサート",
	97:  "ファンミーティング",
	98:  "コラボ配信",
	99:  "記念配信",
	100: "生誕祭",
	101: "周年記念",
	102: "サプライズ",
	103: "椅子",
}

var tagIds = map[string]int64{
	"ライブ配信":     1,
	"ゲーム実況":     2,
	"生放送":       3,
	"アドバイス":     4,
	"初心者歓迎":     5,
	"プロゲーマー":    6,
	"新作ゲーム":     7,
	"レトロゲーム":    8,
	"RPG":       9,
	"FPS":       10,
	"アクションゲーム":  11,
	"対戦ゲーム":     12,
	"マルチプレイ":    13,
	"シングルプレイ":   14,
	"ゲーム解説":     15,
	"ホラーゲーム":    16,
	"イベント生放送":   17,
	"新情報発表":     18,
	"Q&Aセッション":  19,
	"チャット交流":    20,
	"視聴者参加":     21,
	"音楽ライブ":     22,
	"カバーソング":    23,
	"オリジナル楽曲":   24,
	"アコースティック":  25,
	"歌配信":       26,
	"楽器演奏":      27,
	"ギター":       28,
	"ピアノ":       29,
	"バンドセッション":  30,
	"DJセット":     31,
	"トーク配信":     32,
	"朝活":        33,
	"夜ふかし":      34,
	"日常話":       35,
	"趣味の話":      36,
	"語学学習":      37,
	"お料理配信":     38,
	"手料理":       39,
	"レシピ紹介":     40,
	"アート配信":     41,
	"絵描き":       42,
	"DIY":       43,
	"手芸":        44,
	"アニメトーク":    45,
	"映画レビュー":    46,
	"読書感想":      47,
	"ファッション":    48,
	"メイク":       49,
	"ビューティー":    50,
	"健康":        51,
	"ワークアウト":    52,
	"ヨガ":        53,
	"ダンス":       54,
	"旅行記":       55,
	"アウトドア":     56,
	"キャンプ":      57,
	"ペットと一緒":    58,
	"猫":         59,
	"犬":         60,
	"釣り":        61,
	"ガーデニング":    62,
	"テクノロジー":    63,
	"ガジェット紹介":   64,
	"プログラミング":   65,
	"DIY電子工作":   66,
	"ニュース解説":    67,
	"歴史":        68,
	"文化":        69,
	"社会問題":      70,
	"心理学":       71,
	"宇宙":        72,
	"科学":        73,
	"マジック":      74,
	"コメディ":      75,
	"スポーツ":      76,
	"サッカー":      77,
	"野球":        78,
	"バスケットボール":  79,
	"ライフハック":    80,
	"教育":        81,
	"子育て":       82,
	"ビジネス":      83,
	"起業":        84,
	"投資":        85,
	"仮想通貨":      86,
	"株式投資":      87,
	"不動産":       88,
	"キャリア":      89,
	"スピリチュアル":   90,
	"占い":        91,
	"手相":        92,
	"オカルト":      93,
	"UFO":       94,
	"都市伝説":      95,
	"コンサート":     96,
	"ファンミーティング": 97,
	"コラボ配信":     98,
	"記念配信":      99,
	"生誕祭":       100,
	"周年記念":      101,
	"サプライズ":     102,
	"椅子":        103,
}
