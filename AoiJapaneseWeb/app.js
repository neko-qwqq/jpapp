const storageKey = "aoi-japanese-self-study-v2";

function buildLevel(key, label, title, goal, grammarRows, vocab, kanji) {
  return {
    key,
    label,
    title,
    goal,
    grammar: grammarRows.map((row) => ({
      id: `${key}-${row[0]}`,
      title: row[1],
      zh: row[2],
      pattern: row[3],
      example: row[4],
      exampleZh: row[5],
      tags: row[6]
    })),
    vocab,
    kanji
  };
}

const kanaSections = [
  {
    title: "清音",
    rows: [
      [
        { h: "あ", k: "ア", r: "a" },
        { h: "い", k: "イ", r: "i" },
        { h: "う", k: "ウ", r: "u" },
        { h: "え", k: "エ", r: "e" },
        { h: "お", k: "オ", r: "o" }
      ],
      [
        { h: "か", k: "カ", r: "ka" },
        { h: "き", k: "キ", r: "ki" },
        { h: "く", k: "ク", r: "ku" },
        { h: "け", k: "ケ", r: "ke" },
        { h: "こ", k: "コ", r: "ko" }
      ],
      [
        { h: "さ", k: "サ", r: "sa" },
        { h: "し", k: "シ", r: "shi" },
        { h: "す", k: "ス", r: "su" },
        { h: "せ", k: "セ", r: "se" },
        { h: "そ", k: "ソ", r: "so" }
      ],
      [
        { h: "た", k: "タ", r: "ta" },
        { h: "ち", k: "チ", r: "chi" },
        { h: "つ", k: "ツ", r: "tsu" },
        { h: "て", k: "テ", r: "te" },
        { h: "と", k: "ト", r: "to" }
      ],
      [
        { h: "な", k: "ナ", r: "na" },
        { h: "に", k: "ニ", r: "ni" },
        { h: "ぬ", k: "ヌ", r: "nu" },
        { h: "ね", k: "ネ", r: "ne" },
        { h: "の", k: "ノ", r: "no" }
      ],
      [
        { h: "は", k: "ハ", r: "ha" },
        { h: "ひ", k: "ヒ", r: "hi" },
        { h: "ふ", k: "フ", r: "fu" },
        { h: "へ", k: "ヘ", r: "he" },
        { h: "ほ", k: "ホ", r: "ho" }
      ],
      [
        { h: "ま", k: "マ", r: "ma" },
        { h: "み", k: "ミ", r: "mi" },
        { h: "む", k: "ム", r: "mu" },
        { h: "め", k: "メ", r: "me" },
        { h: "も", k: "モ", r: "mo" }
      ],
      [
        { h: "や", k: "ヤ", r: "ya" },
        null,
        { h: "ゆ", k: "ユ", r: "yu" },
        null,
        { h: "よ", k: "ヨ", r: "yo" }
      ],
      [
        { h: "ら", k: "ラ", r: "ra" },
        { h: "り", k: "リ", r: "ri" },
        { h: "る", k: "ル", r: "ru" },
        { h: "れ", k: "レ", r: "re" },
        { h: "ろ", k: "ロ", r: "ro" }
      ],
      [
        { h: "わ", k: "ワ", r: "wa" },
        null,
        null,
        null,
        { h: "を", k: "ヲ", r: "wo" }
      ],
      [
        { h: "ん", k: "ン", r: "n" },
        null,
        null,
        null,
        null
      ]
    ]
  },
  {
    title: "浊音和半浊音",
    rows: [
      [
        { h: "が", k: "ガ", r: "ga" },
        { h: "ぎ", k: "ギ", r: "gi" },
        { h: "ぐ", k: "グ", r: "gu" },
        { h: "げ", k: "ゲ", r: "ge" },
        { h: "ご", k: "ゴ", r: "go" }
      ],
      [
        { h: "ざ", k: "ザ", r: "za" },
        { h: "じ", k: "ジ", r: "ji" },
        { h: "ず", k: "ズ", r: "zu" },
        { h: "ぜ", k: "ゼ", r: "ze" },
        { h: "ぞ", k: "ゾ", r: "zo" }
      ],
      [
        { h: "だ", k: "ダ", r: "da" },
        { h: "ぢ", k: "ヂ", r: "ji" },
        { h: "づ", k: "ヅ", r: "zu" },
        { h: "で", k: "デ", r: "de" },
        { h: "ど", k: "ド", r: "do" }
      ],
      [
        { h: "ば", k: "バ", r: "ba" },
        { h: "び", k: "ビ", r: "bi" },
        { h: "ぶ", k: "ブ", r: "bu" },
        { h: "べ", k: "ベ", r: "be" },
        { h: "ぼ", k: "ボ", r: "bo" }
      ],
      [
        { h: "ぱ", k: "パ", r: "pa" },
        { h: "ぴ", k: "ピ", r: "pi" },
        { h: "ぷ", k: "プ", r: "pu" },
        { h: "ぺ", k: "ペ", r: "pe" },
        { h: "ぽ", k: "ポ", r: "po" }
      ]
    ]
  },
  {
    title: "拗音",
    rows: [
      [
        { h: "きゃ", k: "キャ", r: "kya" },
        { h: "きゅ", k: "キュ", r: "kyu" },
        { h: "きょ", k: "キョ", r: "kyo" },
        null,
        null
      ],
      [
        { h: "しゃ", k: "シャ", r: "sha" },
        { h: "しゅ", k: "シュ", r: "shu" },
        { h: "しょ", k: "ショ", r: "sho" },
        null,
        null
      ],
      [
        { h: "ちゃ", k: "チャ", r: "cha" },
        { h: "ちゅ", k: "チュ", r: "chu" },
        { h: "ちょ", k: "チョ", r: "cho" },
        null,
        null
      ],
      [
        { h: "にゃ", k: "ニャ", r: "nya" },
        { h: "にゅ", k: "ニュ", r: "nyu" },
        { h: "にょ", k: "ニョ", r: "nyo" },
        null,
        null
      ],
      [
        { h: "ひゃ", k: "ヒャ", r: "hya" },
        { h: "ひゅ", k: "ヒュ", r: "hyu" },
        { h: "ひょ", k: "ヒョ", r: "hyo" },
        null,
        null
      ],
      [
        { h: "みゃ", k: "ミャ", r: "mya" },
        { h: "みゅ", k: "ミュ", r: "myu" },
        { h: "みょ", k: "ミョ", r: "myo" },
        null,
        null
      ],
      [
        { h: "りゃ", k: "リャ", r: "rya" },
        { h: "りゅ", k: "リュ", r: "ryu" },
        { h: "りょ", k: "リョ", r: "ryo" },
        null,
        null
      ],
      [
        { h: "ぎゃ", k: "ギャ", r: "gya" },
        { h: "ぎゅ", k: "ギュ", r: "gyu" },
        { h: "ぎょ", k: "ギョ", r: "gyo" },
        null,
        null
      ],
      [
        { h: "じゃ", k: "ジャ", r: "ja" },
        { h: "じゅ", k: "ジュ", r: "ju" },
        { h: "じょ", k: "ジョ", r: "jo" },
        null,
        null
      ],
      [
        { h: "びゃ", k: "ビャ", r: "bya" },
        { h: "びゅ", k: "ビュ", r: "byu" },
        { h: "びょ", k: "ビョ", r: "byo" },
        null,
        null
      ],
      [
        { h: "ぴゃ", k: "ピャ", r: "pya" },
        { h: "ぴゅ", k: "ピュ", r: "pyu" },
        { h: "ぴょ", k: "ピョ", r: "pyo" },
        null,
        null
      ]
    ]
  }
];

const levels = {
  n5: buildLevel(
    "n5",
    "N5",
    "N5 基础句型",
    "目标：能读懂基础句子，能完成自我介绍、购物、问路和每日生活表达。",
    [
      ["desu", "です", "判断句：是、为", "Nです", "私は学生です。", "我是学生。", ["判断"]],
      ["dewa-arimasen", "ではありません / じゃありません", "判断句否定：不是", "Nではありません", "これは私の本ではありません。", "这不是我的书。", ["判断", "否定"]],
      ["deshita", "でした", "判断句过去：曾经是", "Nでした", "昨日は休みでした。", "昨天是休息日。", ["过去"]],
      ["dewa-arimasen-deshita", "ではありませんでした", "判断句过去否定", "Nではありませんでした", "先週は暇ではありませんでした。", "上周不空。", ["过去", "否定"]],
      ["kore-sore-are", "これ / それ / あれ", "这个、那个、远处那个", "これ・それ・あれ", "これは辞書です。", "这是词典。", ["指示"]],
      ["kono-sono-ano", "この / その / あの", "这个的、那个的、远处那个的", "このN", "この時計は高いです。", "这块表很贵。", ["指示"]],
      ["koko-soko-asoko", "ここ / そこ / あそこ", "这里、那里、远处那里", "ここ・そこ・あそこ", "トイレはそこです。", "洗手间在那里。", ["地点"]],
      ["no-possessive", "NのN", "所属、说明、修饰", "N1のN2", "日本語の本を読みます。", "读日语书。", ["助词"]],
      ["wa", "は", "提示主题", "Nは", "私は中国人です。", "我是中国人。", ["助词"]],
      ["ga", "が", "提示主语、存在对象、能力对象", "Nが", "猫がいます。", "有猫。", ["助词"]],
      ["mo", "も", "也", "Nも", "私も行きます。", "我也去。", ["助词"]],
      ["wo", "を", "动作对象", "NをVます", "水を飲みます。", "喝水。", ["助词"]],
      ["ni-time", "に", "时间点、目的地、存在位置", "時間に / 場所に", "七時に起きます。", "七点起床。", ["助词"]],
      ["de-place", "で", "动作发生地点、方法工具", "場所で / 道具で", "駅で友達に会います。", "在车站见朋友。", ["助词"]],
      ["e", "へ", "方向", "場所へ行きます", "京都へ行きます。", "去京都。", ["助词"]],
      ["to", "と", "和、共同对象", "Nと", "友達と映画を見ます。", "和朋友看电影。", ["助词"]],
      ["kara-made", "から / まで", "从、到", "NからNまで", "九時から五時まで働きます。", "从九点工作到五点。", ["范围"]],
      ["ya", "や", "列举部分项目", "NやN", "パンや果物を買いました。", "买了面包、水果等。", ["列举"]],
      ["ne-yo", "ね / よ", "确认、提醒、强调", "文ね / 文よ", "今日は寒いですね。", "今天真冷呢。", ["语气"]],
      ["masu", "ます形", "礼貌现在肯定", "Vます", "毎日勉強します。", "每天学习。", ["动词"]],
      ["masen", "ません", "礼貌现在否定", "Vません", "今日は行きません。", "今天不去。", ["动词", "否定"]],
      ["mashita", "ました", "礼貌过去肯定", "Vました", "昨日ラーメンを食べました。", "昨天吃了拉面。", ["过去"]],
      ["masen-deshita", "ませんでした", "礼貌过去否定", "Vませんでした", "先週は勉強しませんでした。", "上周没有学习。", ["过去", "否定"]],
      ["masenka", "ませんか", "邀请", "Vませんか", "一緒に帰りませんか。", "要不要一起回去？", ["邀请"]],
      ["mashou", "ましょう", "提议一起做", "Vましょう", "少し休みましょう。", "休息一下吧。", ["提议"]],
      ["tai", "たい", "想做某事", "Vます去ます + たい", "日本へ行きたいです。", "想去日本。", ["愿望"]],
      ["te-kudasai", "てください", "请求对方做", "Vてください", "もう一度言ってください。", "请再说一遍。", ["请求"]],
      ["temo-ii", "てもいいです", "可以做", "Vてもいいです", "写真を撮ってもいいですか。", "可以拍照吗？", ["许可"]],
      ["tewa-ikenai", "てはいけません", "不可以做", "Vてはいけません", "ここでタバコを吸ってはいけません。", "这里不能抽烟。", ["禁止"]],
      ["te-iru", "ています", "正在做、持续状态", "Vています", "今、日本語を勉強しています。", "现在正在学日语。", ["状态"]],
      ["ni-iku", "に行く", "去做某事", "Vます去ます + に行く", "図書館へ勉強しに行きます。", "去图书馆学习。", ["目的"]],
      ["nai", "ない形", "普通否定", "Vない", "肉を食べないです。", "不吃肉。", ["否定"]],
      ["naide-kudasai", "ないでください", "请不要做", "Vないでください", "ここに入らないでください。", "请不要进入这里。", ["请求"]],
      ["nakereba", "なければなりません", "必须做", "Vない去ない + なければなりません", "宿題をしなければなりません。", "必须做作业。", ["义务"]],
      ["nakutemo", "なくてもいいです", "不做也可以", "Vない去ない + なくてもいいです", "明日は来なくてもいいです。", "明天不来也可以。", ["许可"]],
      ["i-adj", "い形容词", "い形容词现在、否定、过去", "高い / 高くない / 高かった", "この店は安くないです。", "这家店不便宜。", ["形容词"]],
      ["na-adj", "な形容词", "な形容词修饰名词", "静かなN", "静かな部屋が好きです。", "喜欢安静的房间。", ["形容词"]],
      ["aru-iru", "あります / います", "无生命、有生命存在", "Nがあります / Nがいます", "机の上に本があります。", "桌上有书。", ["存在"]],
      ["houga-ii", "ほうがいいです", "建议最好做", "Vた / Vない + ほうがいい", "早く寝たほうがいいです。", "最好早点睡。", ["建议"]],
      ["yori", "より", "比较：比", "AはBより", "日本語は英語より難しいです。", "日语比英语难。", ["比较"]],
      ["ichiban", "一番", "最高级", "Nの中で一番", "季節の中で春が一番好きです。", "四季中最喜欢春天。", ["比较"]],
      ["mou-mada", "もう / まだ", "已经、还没有", "もうVました / まだVていません", "もう昼ご飯を食べました。", "已经吃午饭了。", ["时间"]],
      ["kara-reason", "から", "原因、理由", "文から", "暑いですから、窓を開けます。", "因为热，所以开窗。", ["原因"]],
      ["mae-ni", "前に", "在某事之前", "V辞書形 / Nの + 前に", "寝る前に本を読みます。", "睡前读书。", ["时间"]],
      ["ato-de", "後で", "之后", "Vた / Nの + 後で", "ご飯を食べた後で散歩します。", "吃完饭后散步。", ["时间"]],
      ["toki", "時", "某个时候", "V普通形 / Nの + 時", "暇な時、音楽を聞きます。", "有空时听音乐。", ["时间"]],
      ["counter", "数量词", "数量表达", "数量 + 助数詞", "りんごを三つ買いました。", "买了三个苹果。", ["数量"]]
    ],
    [
      { title: "自我介绍", words: ["私：我", "名前：名字", "学生：学生", "会社員：上班族", "中国人：中国人", "趣味：兴趣"] },
      { title: "时间日期", words: ["今日：今天", "明日：明天", "昨日：昨天", "朝：早上", "昼：中午", "夜：晚上", "毎日：每天"] },
      { title: "生活动作", words: ["起きる：起床", "寝る：睡觉", "食べる：吃", "飲む：喝", "行く：去", "帰る：回", "見る：看"] },
      { title: "购物点餐", words: ["水：水", "お茶：茶", "パン：面包", "店：店", "いくら：多少钱", "ください：请给我"] },
      { title: "基础形容词", words: ["高い：贵/高", "安い：便宜", "大きい：大", "小さい：小", "新しい：新", "古い：旧"] }
    ],
    "日一国人年大十二本中長出三時行見月後前生五間上東四今金九入学高円子外八六下来気小七山話女北午百書先名川千水半男西電校語土木聞食車何南万毎白天母火右読友左休父雨"
  ),
  n4: buildLevel(
    "n4",
    "N4",
    "N4 生活表达",
    "目标：能说明经历、计划、理由、条件和请求，能把短句连成自然段落。",
    [
      ["plain-form", "普通形", "把礼貌句改成普通句", "V普通形 / い形 / な形だ / Nだ", "明日は雨だと思います。", "我觉得明天会下雨。", ["基础"]],
      ["to-omou", "と思います", "表达想法、判断", "普通形 + と思います", "この映画は面白いと思います。", "我觉得这部电影有趣。", ["判断"]],
      ["to-iu", "と言います", "引用别人说的话", "普通形 + と言います", "先生は試験があると言いました。", "老师说有考试。", ["引用"]],
      ["koto-ga-dekiru", "ことができます", "能够做某事", "V辞書形 + ことができます", "私は少し日本語を話すことができます。", "我能说一点日语。", ["能力"]],
      ["ta-koto-ga-aru", "たことがあります", "有过某经历", "Vた + ことがあります", "日本へ行ったことがあります。", "去过日本。", ["经历"]],
      ["tari-tari", "たり〜たりします", "列举动作", "VたりVたりします", "週末は掃除したり買い物したりします。", "周末打扫、购物等。", ["列举"]],
      ["tsumori", "つもりです", "打算", "V辞書形 / Vない + つもり", "来年日本へ留学するつもりです。", "打算明年去日本留学。", ["计划"]],
      ["yotei", "予定です", "预定、计划", "V辞書形 / Nの + 予定", "午後会議の予定です。", "下午预定开会。", ["计划"]],
      ["you-ni-naru", "ようになる", "变得能够、习惯", "V辞書形 / Vない + ようになる", "早く起きられるようになりました。", "变得能早起了。", ["变化"]],
      ["you-ni-suru", "ようにする", "努力做到", "V辞書形 / Vない + ようにする", "毎日復習するようにしています。", "我尽量每天复习。", ["习惯"]],
      ["naide", "ないで", "不做某事而做另一事", "Vないで", "朝ご飯を食べないで学校へ行きました。", "没吃早饭就去了学校。", ["连接"]],
      ["nakereba-naranai", "なければならない", "必须", "Vない去ない + なければならない", "薬を飲まなければなりません。", "必须吃药。", ["义务"]],
      ["nakutemo-ii", "なくてもいい", "不做也行", "Vない去ない + なくてもいい", "全部覚えなくてもいいです。", "不用全部记住也可以。", ["许可"]],
      ["te-mo", "ても", "即使、就算", "Vても / い形くても", "雨が降っても行きます。", "即使下雨也去。", ["让步"]],
      ["te-ageru", "てあげる", "为别人做", "Vてあげる", "友達に宿題を教えてあげました。", "教朋友做作业。", ["授受"]],
      ["te-kureru", "てくれる", "别人为我方做", "Vてくれる", "母が弁当を作ってくれました。", "妈妈给我做了便当。", ["授受"]],
      ["te-morau", "てもらう", "请别人为我做", "Vてもらう", "先生に作文を直してもらいました。", "请老师改了作文。", ["授受"]],
      ["te-oku", "ておく", "提前准备、保持", "Vておく", "旅行の前にホテルを予約しておきます。", "旅行前先订好酒店。", ["准备"]],
      ["te-shimau", "てしまう", "完成、遗憾", "Vてしまう", "財布を忘れてしまいました。", "把钱包忘了。", ["完成", "遗憾"]],
      ["te-miru", "てみる", "试着做", "Vてみる", "この言葉を使ってみます。", "试着用这个词。", ["尝试"]],
      ["te-aru", "てある", "人为结果状态", "V他動詞てある", "窓が開けてあります。", "窗户被打开着。", ["状态"]],
      ["sou-appearance", "そうです", "看起来像", "Vます去ます / い形去い / な形 + そう", "このケーキはおいしそうです。", "这个蛋糕看起来好吃。", ["样态"]],
      ["sou-hearsay", "そうです（传闻）", "听说", "普通形 + そうです", "明日は寒いそうです。", "听说明天冷。", ["传闻"]],
      ["you-desu", "ようです", "好像、类似", "普通形 + ようです", "外は雨のようです。", "外面好像在下雨。", ["推量"]],
      ["mitai", "みたいです", "像、好像", "普通形 + みたいです", "この町は京都みたいです。", "这个城市像京都。", ["比喻"]],
      ["tame-ni", "ために", "为了", "V辞書形 / Nの + ために", "試験のために勉強します。", "为了考试学习。", ["目的"]],
      ["node", "ので", "因为，较客观", "普通形 + ので", "電車が遅れたので、遅刻しました。", "因为电车晚点，所以迟到了。", ["原因"]],
      ["noni", "のに", "明明、可是", "普通形 + のに", "勉強したのに、試験は難しかったです。", "明明学习了，考试还是很难。", ["转折"]],
      ["shi", "し", "列举理由", "普通形 + し", "安いし、おいしいし、この店が好きです。", "又便宜又好吃，所以喜欢这家店。", ["原因"]],
      ["ba", "ば", "条件", "Vば / い形ければ", "時間があれば、映画を見ます。", "有时间的话看电影。", ["条件"]],
      ["tara", "たら", "如果、做完后", "Vたら", "家に帰ったら、電話します。", "回到家后打电话。", ["条件"]],
      ["nara", "なら", "如果是、承接话题", "Nなら / 普通形なら", "日本語なら、少し分かります。", "日语的话，我懂一点。", ["条件"]],
      ["to-condition", "と", "恒常条件、必然结果", "V辞書形 + と", "このボタンを押すと、ドアが開きます。", "按这个按钮门就会开。", ["条件"]],
      ["potential", "可能形", "能够做", "V可能形", "漢字が読めます。", "能读汉字。", ["能力"]],
      ["passive", "受身形", "被动", "V受身形", "先生に褒められました。", "被老师表扬了。", ["被动"]],
      ["causative", "使役形", "让、使", "V使役形", "子どもに野菜を食べさせます。", "让孩子吃蔬菜。", ["使役"]],
      ["imperative", "命令形 / 禁止形", "命令、禁止", "V命令形 / V辞書形な", "ここで走るな。", "不要在这里跑。", ["命令"]],
      ["tokoro", "ところです", "正要、正在、刚刚", "V辞書形 / Vている / Vた + ところ", "今、出かけるところです。", "现在正要出门。", ["时间"]],
      ["bakari", "ばかり", "刚刚、全是", "Vたばかり / Nばかり", "さっき起きたばかりです。", "刚刚起床。", ["时间"]],
      ["hazu", "はずです", "按理应该", "普通形 + はずです", "田中さんはもう着いたはずです。", "田中应该已经到了。", ["推量"]],
      ["kamoshirenai", "かもしれない", "也许、可能", "普通形 + かもしれない", "明日は雨かもしれません。", "明天可能下雨。", ["推量"]],
      ["deshou", "でしょう", "推测、确认", "普通形 + でしょう", "週末は忙しいでしょう。", "周末大概会忙吧。", ["推量"]],
      ["sugiru", "すぎる", "过度", "Vます去ます / い形去い + すぎる", "食べすぎました。", "吃太多了。", ["程度"]],
      ["yasui-nikui", "やすい / にくい", "容易做、难做", "Vます去ます + やすい / にくい", "この説明は分かりやすいです。", "这个说明容易懂。", ["性质"]],
      ["kata", "方", "做法", "Vます去ます + 方", "漢字の読み方を教えてください。", "请教我汉字的读法。", ["方法"]],
      ["te-itadakemasenka", "ていただけませんか", "礼貌请求", "Vていただけませんか", "写真を撮っていただけませんか。", "能请您帮我拍照吗？", ["敬语"]],
      ["honorific", "お / ご + になる", "尊敬语基本形", "おVます去ますになります", "先生はもうお帰りになりました。", "老师已经回去了。", ["敬语"]],
      ["humble", "お / ご + する", "自谦语基本形", "おVます去ますします", "荷物をお持ちします。", "我来帮您拿行李。", ["敬语"]]
    ],
    [
      { title: "学校工作", words: ["授業：课", "宿題：作业", "試験：考试", "会議：会议", "資料：资料", "残業：加班"] },
      { title: "出行交通", words: ["電車：电车", "地下鉄：地铁", "駅：车站", "切符：票", "遅れる：迟到/晚点", "乗り換える：换乘"] },
      { title: "情绪评价", words: ["安心：安心", "心配：担心", "便利：方便", "不便：不方便", "簡単：简单", "複雑：复杂"] },
      { title: "请求说明", words: ["説明：说明", "予約：预约", "確認：确认", "連絡：联系", "相談：商量", "手伝う：帮忙"] },
      { title: "生活事件", words: ["引っ越し：搬家", "旅行：旅行", "病気：生病", "用事：事情", "約束：約定", "準備：准备"] }
    ],
    "不世主乗事京仕代以会住体作使借元兄公写冬切別力勉動医去口古台同味品員問図地堂場声売夏夕夜太好妹姉始字室家寒少屋工市帰広度建弟弱強待心思急悪意所持教文料方旅族早明映春昼暑暗曜有服朝村林森業楽歌止正歩死民池注洗海漢牛物特犬理産用田町画界病発県真着知研私秋究答紙終習考者肉自色花英茶薬親言計試説貸質赤走起転軽近送通週進運遠都重野銀門開院集青音頭題顔風飯飲館駅験魚鳥黒"
  ),
  n3: buildLevel(
    "n3",
    "N3",
    "N3 表达升级",
    "目标：能表达原因、立场、推测、让步、变化和抽象关系，写出口语感自然的长句。",
    [
      ["aida", "間 / 間に", "在某段时间内、期间发生", "Vている / Nの + 間に", "留学している間に、友達が増えました。", "留学期间朋友变多了。", ["时间"]],
      ["uchi-ni", "うちに", "趁着、在变化前", "普通形 + うちに", "忘れないうちにメモします。", "趁没忘先记下来。", ["时间"]],
      ["saichuu", "最中に", "正在做某事的时候", "Nの / Vている + 最中に", "会議の最中に電話が鳴りました。", "开会时电话响了。", ["时间"]],
      ["tabi-ni", "たびに", "每当", "V辞書形 / Nの + たびに", "この曲を聞くたびに、故郷を思い出します。", "每次听这首歌都会想起故乡。", ["频率"]],
      ["tsuide-ni", "ついでに", "顺便", "V辞書形 / Vた / Nの + ついでに", "買い物のついでに、本屋へ行きました。", "购物时顺便去了书店。", ["顺便"]],
      ["tate", "たて", "刚刚完成", "Vます去ます + たて", "焼きたてのパンはおいしいです。", "刚烤好的面包很好吃。", ["时间"]],
      ["mama", "まま", "保持原样", "Vた / Nの + まま", "電気をつけたまま寝てしまいました。", "灯开着就睡着了。", ["状态"]],
      ["ppanashi", "っぱなし", "一直放任某状态", "Vます去ます + っぱなし", "水を出しっぱなしにしないでください。", "请不要一直开着水。", ["状态"]],
      ["kiri", "きり", "之后再也没有、仅仅", "Vた + きり", "彼とは去年会ったきりです。", "和他去年见过后就没再见。", ["状态"]],
      ["okage-de", "おかげで", "多亏", "普通形 + おかげで", "先生のおかげで合格できました。", "多亏老师，我及格了。", ["原因"]],
      ["sei-de", "せいで", "都怪、由于负面原因", "普通形 + せいで", "寝不足のせいで集中できません。", "因为睡眠不足无法集中。", ["原因"]],
      ["mono-dakara", "ものだから", "因为，带解释语气", "普通形 + ものだから", "急いでいたものだから、忘れてしまいました。", "因为当时很急，就忘了。", ["原因"]],
      ["bakari-ni", "ばかりに", "正因为某原因导致坏结果", "普通形 + ばかりに", "本当のことを言ったばかりに、怒られました。", "就因为说了真话，被骂了。", ["原因"]],
      ["kara-niwa", "からには", "既然", "普通形 + からには", "始めたからには、最後までやります。", "既然开始了，就做到最后。", ["立场"]],
      ["ijou-wa", "以上は", "既然到了这个程度", "普通形 + 以上は", "約束した以上は、守るべきです。", "既然约定了，就应该遵守。", ["立场"]],
      ["ue-wa", "上は", "既然", "V辞書形 / Vた + 上は", "参加する上は、準備が必要です。", "既然参加，就需要准备。", ["立场"]],
      ["noni", "のに", "明明却", "普通形 + のに", "練習したのに、うまく話せませんでした。", "明明练习了，却没能说好。", ["转折"]],
      ["mono-no", "ものの", "虽然但是", "普通形 + ものの", "説明を読んだものの、使い方が分かりません。", "虽然读了说明，还是不懂用法。", ["转折"]],
      ["kuseni", "くせに", "明明却，责备语气", "普通形 + くせに", "知っているくせに、教えてくれません。", "明明知道却不告诉我。", ["转折"]],
      ["warini", "わりに", "与预想相比", "普通形 + わりに", "値段のわりに、品質がいいです。", "相对价格来说，质量不错。", ["评价"]],
      ["ni-shitewa", "にしては", "以某标准来看", "N / 普通形 + にしては", "初めてにしては上手です。", "以第一次来说很不错。", ["评价"]],
      ["hantai-men", "反面", "另一方面", "普通形 + 反面", "便利な反面、費用が高いです。", "方便，但另一方面费用高。", ["对比"]],
      ["ippou-de", "一方で", "另一方面、同时", "普通形 + 一方で", "都会は便利な一方で、生活費が高いです。", "城市方便，同时生活费高。", ["对比"]],
      ["kawari-ni", "かわりに", "代替、作为交换", "Nの / V普通形 + かわりに", "手伝うかわりに、昼ご飯をおごってください。", "我帮你，作为交换请我吃午饭。", ["交换"]],
      ["dake-de-naku", "だけでなく", "不但", "Nだけでなく", "文法だけでなく、発音も練習します。", "不只练语法，也练发音。", ["并列"]],
      ["bakari-de-naku", "ばかりでなく", "不仅", "Nばかりでなく", "日本語ばかりでなく、文化も学びたいです。", "不仅想学日语，也想学文化。", ["并列"]],
      ["shika-nai", "しかない", "只能、只好", "V辞書形 + しかない", "電車がないので、歩くしかありません。", "没有电车，只能走路。", ["限制"]],
      ["wake-da", "わけだ", "怪不得、自然是", "普通形 + わけだ", "毎日練習しているんですね。上手なわけです。", "你每天练啊，怪不得很厉害。", ["解释"]],
      ["wake-dewa-nai", "わけではない", "并不是", "普通形 + わけではない", "嫌いなわけではありません。", "并不是讨厌。", ["否定"]],
      ["wake-ga-nai", "わけがない", "不可能", "普通形 + わけがない", "一日で全部覚えられるわけがありません。", "不可能一天全记住。", ["否定"]],
      ["hazu-ga-nai", "はずがない", "按理不可能", "普通形 + はずがない", "彼が約束を忘れるはずがありません。", "他不可能忘记约定。", ["推量"]],
      ["ni-chigai-nai", "に違いない", "一定是", "普通形 + に違いない", "この答えは正しいに違いありません。", "这个答案一定是对的。", ["推量"]],
      ["ni-kimatteiru", "に決まっている", "肯定是，语气强", "普通形 + に決まっている", "そんな話は嘘に決まっています。", "那种话肯定是假的。", ["推量"]],
      ["hazu-da", "はずだ", "应该、按理", "普通形 + はずだ", "荷物は今日届くはずです。", "包裹应该今天到。", ["推量"]],
      ["beki", "べきだ", "应该", "V辞書形 + べきだ", "間違えたら謝るべきです。", "做错了就应该道歉。", ["建议"]],
      ["beki-dewa-nai", "べきではない", "不应该", "V辞書形 + べきではない", "人の秘密を話すべきではありません。", "不应该说别人的秘密。", ["建议"]],
      ["koto-ni-suru", "ことにする", "自己决定", "V辞書形 / Vない + ことにする", "毎朝日本語を読むことにしました。", "我决定每天早上读日语。", ["决定"]],
      ["koto-ni-naru", "ことになる", "客观决定", "V辞書形 / Vない + ことになる", "来月大阪へ出張することになりました。", "决定下个月去大阪出差。", ["决定"]],
      ["koto-ni-natteiru", "ことになっている", "规定、安排", "V辞書形 / Vない + ことになっている", "この部屋では飲食しないことになっています。", "规定这个房间不能饮食。", ["规定"]],
      ["koto-wa-nai", "ことはない", "没必要", "V辞書形 + ことはない", "そんなに心配することはありません。", "没必要那么担心。", ["建议"]],
      ["to-wa-kagiranai", "とは限らない", "不一定", "普通形 + とは限らない", "高いものがいいとは限りません。", "贵的不一定好。", ["判断"]],
      ["wake-niwa-ikanai", "わけにはいかない", "不能那样做", "V辞書形 + わけにはいかない", "仕事があるので、休むわけにはいきません。", "有工作，不能休息。", ["限制"]],
      ["nai-wakeniwa-ikanai", "ないわけにはいかない", "不能不做", "Vない + わけにはいかない", "招待されたので、行かないわけにはいきません。", "被邀请了，不能不去。", ["限制"]],
      ["zu-niwa-irarenai", "ずにはいられない", "忍不住", "Vない去ない + ずにはいられない", "面白くて笑わずにはいられません。", "太有趣了，忍不住笑。", ["情绪"]],
      ["te-naranai", "てならない", "非常、无法抑制", "Vて / い形くて + ならない", "将来が心配でなりません。", "非常担心未来。", ["情绪"]],
      ["te-tamaranai", "てたまらない", "非常强烈", "Vて / い形くて + たまらない", "眠くてたまりません。", "困得不得了。", ["情绪"]],
      ["te-shouganai", "てしょうがない", "非常、没办法", "Vて / い形くて + しょうがない", "結果が気になってしょうがないです。", "非常在意结果。", ["情绪"]],
      ["ppoi", "っぽい", "像、容易", "N / Vます去ます + っぽい", "この服は安っぽく見えます。", "这件衣服看起来廉价。", ["性质"]],
      ["gachi", "がち", "容易、常常负面", "Vます去ます / N + がち", "忙しいと食事を忘れがちです。", "忙的时候容易忘记吃饭。", ["倾向"]],
      ["gimi", "気味", "有点倾向", "Vます去ます / N + 気味", "最近、疲れ気味です。", "最近有点累。", ["倾向"]],
      ["darake", "だらけ", "满是，负面多", "N + だらけ", "間違いだらけの作文を直しました。", "修改了满是错误的作文。", ["状态"]],
      ["darou", "だろう", "推测", "普通形 + だろう", "明日は晴れるだろう。", "明天大概会晴。", ["推量"]],
      ["you-to-suru", "ようとする", "正要、试图", "V意向形 + とする", "電車に乗ろうとした時、ドアが閉まりました。", "正要上电车时门关了。", ["动作"]],
      ["you-ni", "ように", "为了达到某状态", "V辞書形 / Vない + ように", "聞こえるように大きな声で話します。", "为了听得见，大声说。", ["目的"]],
      ["you-na", "ような / ように", "像那样", "Nのような / Vように", "先生のように自然に話したいです。", "想像老师那样自然地说。", ["比喻"]],
      ["to-shite", "として", "作为", "Nとして", "留学生として日本へ行きました。", "作为留学生去了日本。", ["身份"]],
      ["ni-tsuite", "について", "关于", "Nについて", "日本の文化について調べています。", "正在调查日本文化。", ["话题"]],
      ["ni-kanshite", "に関して", "关于，较正式", "Nに関して", "試験に関して質問があります。", "关于考试有问题。", ["话题"]],
      ["ni-taishite", "に対して", "对于、对比", "Nに対して", "お客様に対して丁寧に話します。", "对客人礼貌说话。", ["对象"]],
      ["ni-yotte", "によって", "根据、由于、被", "Nによって", "国によって習慣が違います。", "习惯因国家而异。", ["关系"]],
      ["ni-yoru-to", "によると / によれば", "据说根据", "Nによると", "ニュースによると、明日は雨です。", "据新闻说明天下雨。", ["信息"]],
      ["ni-kurabete", "に比べて", "与...相比", "Nに比べて", "去年に比べて、話せるようになりました。", "和去年相比，变得能说了。", ["比较"]],
      ["ni-tomonatte", "に伴って", "伴随", "N / V辞書形 + に伴って", "人口が増えるに伴って、問題も増えます。", "随着人口增加，问题也增加。", ["变化"]],
      ["ni-shitagatte", "に従って", "随着、按照", "V辞書形 / N + に従って", "練習するに従って、発音がよくなります。", "随着练习，发音会变好。", ["变化"]],
      ["ni-tsurete", "につれて", "随着", "V辞書形 / N + につれて", "日本語に慣れるにつれて、自信が出ました。", "随着习惯日语，有了自信。", ["变化"]],
      ["ni-oujite", "に応じて", "根据情况", "Nに応じて", "レベルに応じて教材を選びます。", "根据等级选择教材。", ["对应"]],
      ["wo-chuushin-ni", "を中心に", "以...为中心", "Nを中心に", "文法を中心に復習します。", "以语法为中心复习。", ["范围"]],
      ["wo-tooshite", "を通して / を通じて", "通过、贯穿", "Nを通して", "会話を通して日本語を学びます。", "通过会话学习日语。", ["方法"]],
      ["wo-hajime", "をはじめ", "以...为首", "Nをはじめ", "東京をはじめ、多くの町でイベントがあります。", "以东京为首，许多城市有活动。", ["列举"]],
      ["wo-komete", "をこめて", "带着情感", "Nをこめて", "感謝をこめて手紙を書きました。", "怀着感谢写了信。", ["情感"]],
      ["ue-de", "上で", "在...之后、在...方面", "Vた / Nの + 上で", "内容を確認した上で、返事します。", "确认内容之后回复。", ["顺序"]],
      ["ue-ni", "上に", "不但而且", "普通形 + 上に", "この店は安い上に、おいしいです。", "这家店不但便宜，而且好吃。", ["并列"]],
      ["toshitemo", "としても", "即使如此", "普通形 + としても", "失敗したとしても、いい経験になります。", "即使失败，也会成为好经验。", ["让步"]],
      ["nishitemo", "にしても", "即使、无论", "普通形 + にしても", "忙しいにしても、連絡は必要です。", "即使忙，也需要联系。", ["让步"]],
      ["temo-kamawanai", "てもかまわない", "即使也没关系", "Vても + かまわない", "少し遅れてもかまいません。", "稍微迟到也没关系。", ["许可"]],
      ["tokoro-datta", "ところだった", "差点就", "V辞書形 + ところだった", "もう少しで忘れるところでした。", "差点就忘了。", ["险些"]],
      ["dokoroka", "どころか", "岂止，反而", "普通形 + どころか", "休むどころか、残業しました。", "别说休息了，反而加班了。", ["强调"]],
      ["dokoro-dewa-nai", "どころではない", "不是做某事的时候", "V辞書形 / N + どころではない", "忙しくて旅行どころではありません。", "忙得不是旅行的时候。", ["限制"]],
      ["to-iu-yori", "というより", "与其说不如说", "普通形 + というより", "これは趣味というより、習慣です。", "这与其说是兴趣，不如说是习惯。", ["说明"]],
      ["to-ieba", "といえば", "说到", "Nといえば", "日本の春といえば、桜です。", "说到日本春天，就是樱花。", ["话题"]],
      ["to-ittemo", "といっても", "虽说如此", "普通形 + といっても", "料理ができるといっても、簡単なものだけです。", "虽说会做饭，也只是简单的。", ["说明"]],
      ["mono-da", "ものだ", "本来就是、感叹回忆", "普通形 + ものだ", "子どもはよく泣くものです。", "孩子本来就常哭。", ["常识"]],
      ["mono-nara", "ものなら", "如果能的话", "V可能形 + ものなら", "できるものなら、もう一度やり直したいです。", "如果能做到，想再来一次。", ["假设"]]
    ],
    [
      { title: "抽象表达", words: ["理由：理由", "結果：结果", "影響：影响", "変化：变化", "習慣：习惯", "経験：经验", "意見：意见"] },
      { title: "论述连接", words: ["一方：另一方面", "反面：反面", "つまり：也就是说", "例えば：例如", "ただし：但是", "その結果：结果"] },
      { title: "情绪状态", words: ["不安：不安", "自信：自信", "後悔：后悔", "緊張：紧张", "感謝：感谢", "満足：满意"] },
      { title: "社会生活", words: ["職場：职场", "上司：上司", "同僚：同事", "取引先：客户", "締め切り：截止日期", "責任：责任"] },
      { title: "学习输出", words: ["復習：复习", "暗記：背诵", "発音：发音", "添削：批改", "例文：例句", "表現：表达"] }
    ],
    "丁両丸予争交他付令仲伝位低例便係信倉候借値停健側働億兆児共兵具典冷初判別利刷副功加努労勇包卒協単博印参反取受史号司各向君告周命和唱商喜器囲固園在坂均型堂報塩士変夫央失好委季孫守完官定実客室害家容宿寂寄富寒察寺封専将尊導小居届展属山岩岸島州巣差巻市希席帯帳平幸幹幼広庁床庫庭式役律後従得忘忙念怒怖性恋息悲想愛感成戦戸才打投折抜抱押招指捕捨授採探接提揮支改放政故救敗教散敬数整敵料断新方旅旗昔星昨昭昼晴暗曲更最望期未末札机材束条松板果枝枯枚染柱査栄根案桜梅械棒森植業楽様横橋機欠次欲歯歴残段殺毒比毛民求決治法泣波泳洗活流浅浴済混清減温港湖湯満演点然焼照熱燃父片版牛牧物状独率玉王現球産由申男町留番疑病痛発登白的皆皮皿直相省看県真眠石破確示礼社祝神票祭禁福私秋科秒移程税種積空窓章童競竹笑筆等算管箱節米粉糸約紅純級細組経結給統絵絶続緑練署美羽翌老考者耳職肉育胃背能腕腰腹舞船良芸苦草荷落葉著蒸虫血街衣表要親覚観角解言計記訪訳試詩話誌認誤説調談論識警議負財貧責貨販貯費資賛赤走起路身車軽輪農辺返追退送逃途通速造連週進遊運過道達違遠適選都配酒重野量鉄録門閉開間関阪降限院除険陽階際雑難雨雪雲静非面革音順願類飛飯養館駅骨高髪鬥魚鳥鳴麦黄黒"
  )
};

const screenTitles = {
  home: "练习",
  kana: "五十音",
  n5: "N5",
  n4: "N4",
  n3: "N3"
};

const defaultState = {
  activeScreen: "home",
  kanaMode: "hiragana",
  selectedKana: "あ",
  levelSection: { n5: "grammar", n4: "grammar", n3: "grammar" },
  queries: { n5: "", n4: "", n3: "" },
  expandedId: "",
  mastered: {},
  quiz: null,
  installHintSeen: false
};

let state = loadState();
let deferredInstallPrompt = null;
let toastTimer = null;
let speechRecognition = null;

document.addEventListener("DOMContentLoaded", () => {
  bindEvents();
  registerServiceWorker();
  renderAll();
});

function bindEvents() {
  document.body.addEventListener("click", handleClick);
  document.body.addEventListener("input", handleInput);
  window.addEventListener("beforeinstallprompt", (event) => {
    event.preventDefault();
    deferredInstallPrompt = event;
  });
}

function handleClick(event) {
  const tab = event.target.closest(".tab-item");
  if (tab) {
    setScreen(tab.dataset.target);
    return;
  }

  const actionElement = event.target.closest("[data-action]");
  if (!actionElement) return;

  const action = actionElement.dataset.action;
  const { screen, level, id, value, text } = actionElement.dataset;

  if (action === "install") installApp();
  if (action === "go-screen") setScreen(screen);
  if (action === "set-kana-mode") setKanaMode(value);
  if (action === "select-kana") selectKana(id);
  if (action === "toggle-kana-mastered") toggleMastered(`kana:${id}`, "五十音");
  if (action === "speak") speakText(text);
  if (action === "start-mixed-quiz") startMixedQuiz();
  if (action === "start-voice-quiz") startVoiceQuiz();
  if (action === "start-kana-quiz") startKanaQuiz();
  if (action === "set-level-section") setLevelSection(level, value);
  if (action === "expand-knowledge") toggleExpanded(id);
  if (action === "toggle-mastered") toggleMastered(id, levels[level]?.label || "知识点");
  if (action === "start-level-quiz") startLevelQuiz(level);
  if (action === "answer-quiz") answerQuiz(id);
  if (action === "submit-written-quiz") submitWrittenQuiz();
  if (action === "start-speech-answer") startSpeechAnswer();
  if (action === "submit-speech-quiz") submitSpeechQuiz();
  if (action === "next-quiz") nextQuiz();
  if (action === "clear-quiz") clearQuiz();
  if (action === "reset-progress") resetProgress();
}

function handleInput(event) {
  const quizInput = event.target.closest("[data-quiz-answer]");
  if (quizInput && state.quiz && !state.quiz.answered) {
    state.quiz.answerValue = quizInput.value;
    saveState();
    return;
  }

  const input = event.target.closest("[data-search-level]");
  if (!input) return;
  state.queries[input.dataset.searchLevel] = input.value;
  saveState();
  renderLevelContentOnly(input.dataset.searchLevel);
}

function loadState() {
  try {
    const raw = localStorage.getItem(storageKey);
    if (!raw) return cloneDefaultState();
    return mergeState(defaultState, JSON.parse(raw));
  } catch {
    return cloneDefaultState();
  }
}

function mergeState(base, saved) {
  return {
    ...cloneDefaultState(),
    ...saved,
    levelSection: { ...base.levelSection, ...(saved.levelSection || {}) },
    queries: { ...base.queries, ...(saved.queries || {}) },
    mastered: { ...(saved.mastered || {}) }
  };
}

function cloneDefaultState() {
  return JSON.parse(JSON.stringify(defaultState));
}

function saveState() {
  localStorage.setItem(storageKey, JSON.stringify(state));
}

function renderAll() {
  renderScreenState();
  renderHome();
  renderKana();
  renderLevel("n5");
  renderLevel("n4");
  renderLevel("n3");
}

function setScreen(screen) {
  state.activeScreen = screen;
  state.quiz = null;
  saveState();
  renderAll();
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function renderScreenState() {
  document.querySelectorAll(".screen").forEach((screen) => {
    screen.classList.toggle("is-active", screen.dataset.screen === state.activeScreen);
  });

  document.querySelectorAll(".tab-item").forEach((button) => {
    button.classList.toggle("is-active", button.dataset.target === state.activeScreen);
  });

  const title = document.getElementById("screen-title");
  title.textContent = screenTitles[state.activeScreen] || "练习";
}

function renderHome() {
  const kanaProgress = getKanaProgress();
  const n5Progress = getLevelProgress("n5");
  const n4Progress = getLevelProgress("n4");
  const n3Progress = getLevelProgress("n3");
  const total = getTotalProgress();
  const tasks = buildTodayTasks();
  const root = document.getElementById("screen-home");

  root.innerHTML = `
    <section class="hero">
      <div class="hero-top">
        <div>
          <p class="eyebrow">Practice First</p>
          <h2>先做题，再回去补知识点。</h2>
          <p>随机练习会混合五十音、N5、N4、N3、词汇、汉字、听力和口述。用错题把记忆压实。</p>
        </div>
        <div class="progress-orb" style="--angle:${total.percent * 3.6}deg">
          <strong>${total.percent}%</strong>
          <span>总进度</span>
        </div>
      </div>
      <div class="stats-grid">
        ${renderStat("五十音", `${kanaProgress.done}/${kanaProgress.total}`)}
        ${renderStat("语法", `${total.grammarDone}/${total.grammarTotal}`)}
        ${renderStat("题库", `${getPracticePoolSize()} 题源`)}
      </div>
    </section>

    ${state.quiz ? renderQuiz() : ""}

    <section class="panel">
      <div class="section-title">
        <h3>随机练习</h3>
        <button class="text-button" data-action="reset-progress" type="button">重置进度</button>
      </div>
      <div class="practice-mode-grid">
        <button class="practice-mode-card main" data-action="start-mixed-quiz" type="button">
          <span>综合随机</span>
          <strong>30 题</strong>
          <p>五十音 + N5/N4/N3 + 词汇 + 汉字 + 听力 + 输入。</p>
        </button>
        <button class="practice-mode-card" data-action="start-voice-quiz" type="button">
          <span>语音专项</span>
          <strong>20 题</strong>
          <p>听音选择、听句选义、播放后跟读，能用语音识别时自动评分。</p>
        </button>
        <button class="practice-mode-card" data-action="start-kana-quiz" type="button">
          <span>五十音</span>
          <strong>20 题</strong>
          <p>读、拼、写、听混合。</p>
        </button>
      </div>
    </section>

    <section class="panel">
      <div class="section-title">
        <h3>分级练习</h3>
      </div>
      <div class="quick-grid">
        ${renderPracticeQuick("N5", "20 题", "n5")}
        ${renderPracticeQuick("N4", "20 题", "n4")}
        ${renderPracticeQuick("N3", "20 题", "n3")}
      </div>
    </section>

    <section class="panel">
      <div class="section-title">
        <h3>知识点入口</h3>
      </div>
      <div class="quick-grid">
        ${renderQuick("五十音", `${kanaProgress.percent}%`, "kana")}
        ${renderQuick("N5", `${n5Progress.percent}%`, "n5")}
        ${renderQuick("N4", `${n4Progress.percent}%`, "n4")}
        ${renderQuick("N3", `${n3Progress.percent}%`, "n3")}
      </div>
    </section>

    <section class="panel">
      <div class="section-title">
        <h3>今日补漏</h3>
      </div>
      <div class="task-list">
        ${tasks.map((task, index) => renderTask(task, index)).join("")}
      </div>
    </section>
  `;
}

function renderKana() {
  const selected = getKanaById(state.selectedKana) || getFlatKana()[0];
  const progress = getKanaProgress();
  const currentChar = getKanaChar(selected);
  const root = document.getElementById("screen-kana");

  root.innerHTML = `
    <section class="hero">
      <div class="hero-top">
        <div>
          <p class="eyebrow">Kana</p>
          <h2>五十音、浊音、拗音一次放在这里。</h2>
          <p>点任意音节可听发音；综合测验包含读音、拼读、书写和听音，不再把答案直接写在选项里。</p>
        </div>
        <div class="progress-orb" style="--angle:${progress.percent * 3.6}deg">
          <strong>${progress.percent}%</strong>
          <span>假名</span>
        </div>
      </div>
    </section>

    <div class="toolbar">
      <div class="segmented">
        ${renderChip("平假名", "set-kana-mode", "hiragana", state.kanaMode === "hiragana")}
        ${renderChip("片假名", "set-kana-mode", "katakana", state.kanaMode === "katakana")}
        <button class="chip" data-action="start-kana-quiz" type="button">综合测 20 题</button>
      </div>
    </div>

    ${state.quiz?.type === "kana" ? renderQuiz() : ""}

    <section class="panel">
      <div class="section-title">
        <h3>当前音</h3>
      </div>
      <article class="detail-card">
        <div>
          <div class="jp-large">${escapeHtml(currentChar)}</div>
          <p>${escapeHtml(selected.r)}，${escapeHtml(selected.h)} / ${escapeHtml(selected.k)}</p>
        </div>
        <div class="detail-actions">
          <button class="secondary-button" data-action="speak" data-text="${escapeAttr(currentChar)}" type="button">播放</button>
          <button class="secondary-button" data-action="toggle-kana-mastered" data-id="${escapeAttr(selected.h)}" type="button">
            ${isMastered(`kana:${selected.h}`) ? "取消掌握" : "标记掌握"}
          </button>
        </div>
      </article>
    </section>

    ${kanaSections.map((section) => renderKanaSection(section)).join("")}
  `;
}

function renderLevel(levelKey) {
  const level = levels[levelKey];
  const root = document.getElementById(`screen-${levelKey}`);
  const section = state.levelSection[levelKey] || "grammar";
  const progress = getLevelProgress(levelKey);
  const query = state.queries[levelKey] || "";
  const content = renderLevelContent(levelKey, section, query);

  root.innerHTML = `
    <section class="hero">
      <div class="hero-top">
        <div>
          <p class="eyebrow">${level.label}</p>
          <h2>${escapeHtml(level.title)}</h2>
          <p>${escapeHtml(level.goal)}</p>
        </div>
        <div class="progress-orb" style="--angle:${progress.percent * 3.6}deg">
          <strong>${progress.percent}%</strong>
          <span>语法</span>
        </div>
      </div>
      <div class="stats-grid">
        ${renderStat("语法", `${progress.done}/${progress.total}`)}
        ${renderStat("词汇组", `${level.vocab.length}`)}
        ${renderStat("汉字", `${level.kanji.length}`)}
      </div>
    </section>

    <div class="toolbar">
      <div class="segmented">
        ${renderLevelChip(levelKey, "grammar", "语法")}
        ${renderLevelChip(levelKey, "vocab", "词汇")}
        ${renderLevelChip(levelKey, "kanji", "汉字")}
        <button class="chip" data-action="start-level-quiz" data-level="${levelKey}" type="button">练 20 题</button>
      </div>
      <input class="search-box" data-search-level="${levelKey}" type="search" value="${escapeAttr(query)}" placeholder="搜索：助词、原因、ています..." />
    </div>

    ${state.quiz?.type === "level" && state.quiz.level === levelKey ? renderQuiz() : ""}
    <div id="${levelKey}-content">${content}</div>
  `;
}

function renderLevelContentOnly(levelKey) {
  const container = document.getElementById(`${levelKey}-content`);
  if (!container) return;
  const section = state.levelSection[levelKey] || "grammar";
  const query = state.queries[levelKey] || "";
  container.innerHTML = renderLevelContent(levelKey, section, query);
}

function renderLevelContent(levelKey, section, query) {
  const level = levels[levelKey];
  const normalizedQuery = normalize(query);

  if (section === "grammar") {
    const items = level.grammar.filter((item) => matchGrammar(item, normalizedQuery));
    if (!items.length) return renderEmpty("没有匹配的语法点", "换一个关键词，比如「原因」「可能」「て」。");
    return `<div class="knowledge-list">${items.map((item) => renderKnowledgeCard(levelKey, item)).join("")}</div>`;
  }

  if (section === "vocab") {
    const groups = level.vocab.filter((group) => normalize(`${group.title} ${group.words.join(" ")}`).includes(normalizedQuery));
    if (!groups.length) return renderEmpty("没有匹配的词汇组", "可以搜「交通」「情绪」「学习」这类主题。");
    return `<div class="vocab-list">${groups.map(renderVocabCard).join("")}</div>`;
  }

  const kanji = [...level.kanji].filter((char) => !normalizedQuery || normalize(char).includes(normalizedQuery));
  if (!kanji.length) return renderEmpty("没有匹配的汉字", "汉字区目前按等级集中背，不做复杂拆解。");
  return `<div class="kanji-grid">${kanji.map((char) => `<button class="kanji-card" data-action="speak" data-text="${escapeAttr(char)}" type="button">${escapeHtml(char)}</button>`).join("")}</div>`;
}

function renderKnowledgeCard(levelKey, item) {
  const mastered = isMastered(item.id);
  const expanded = state.expandedId === item.id;
  return `
    <article class="knowledge-card ${mastered ? "is-mastered" : ""} ${expanded ? "is-expanded" : ""}">
      <div class="knowledge-head">
        <div>
          <strong>${escapeHtml(item.title)}</strong>
          <p>${escapeHtml(item.zh)}</p>
          <div class="knowledge-meta">
            <span class="tag">${escapeHtml(item.pattern)}</span>
            ${(item.tags || []).map((tag) => `<span class="tag green">${escapeHtml(tag)}</span>`).join("")}
          </div>
        </div>
        <button class="small-button" data-action="expand-knowledge" data-id="${escapeAttr(item.id)}" type="button">${expanded ? "收起" : "展开"}</button>
      </div>
      <div class="knowledge-body">
        <div class="example">
          <b>${escapeHtml(item.example)}</b>
          <span>${escapeHtml(item.exampleZh)}</span>
        </div>
        <div class="card-actions">
          <button class="secondary-button" data-action="speak" data-text="${escapeAttr(item.example)}" type="button">播放例句</button>
          <button class="secondary-button" data-action="toggle-mastered" data-level="${levelKey}" data-id="${escapeAttr(item.id)}" type="button">
            ${mastered ? "取消掌握" : "标记掌握"}
          </button>
        </div>
      </div>
    </article>
  `;
}

function renderVocabCard(group) {
  return `
    <article class="vocab-card">
      <strong>${escapeHtml(group.title)}</strong>
      <div class="word-cloud">
        ${group.words.map((word) => `<span class="word-pill">${escapeHtml(word)}</span>`).join("")}
      </div>
    </article>
  `;
}

function renderKanaSection(section) {
  return `
    <section class="panel">
      <div class="section-title">
        <h3>${escapeHtml(section.title)}</h3>
      </div>
      <div class="kana-board">
        ${section.rows.map((row) => `<div class="kana-row">${row.map(renderKanaCell).join("")}</div>`).join("")}
      </div>
    </section>
  `;
}

function renderKanaCell(item) {
  if (!item) return `<span class="kana-cell is-empty"></span>`;
  const char = getKanaChar(item);
  const selected = state.selectedKana === item.h;
  const mastered = isMastered(`kana:${item.h}`);
  return `
    <button class="kana-cell ${mastered ? "is-mastered" : ""} ${selected ? "is-selected" : ""}" data-action="select-kana" data-id="${escapeAttr(item.h)}" type="button">
      <strong>${escapeHtml(char)}</strong>
      <span>${escapeHtml(item.r)}</span>
    </button>
  `;
}

function renderQuiz() {
  const quiz = state.quiz;
  const question = quiz.questions[quiz.index];
  if (!question) {
    return `
      <article class="quiz-card">
        <h3>练习完成</h3>
        <p>正确 ${quiz.score} / ${quiz.questions.length}。错题不用急，回到卡片里标记和复习就行。</p>
        <button class="primary-button" data-action="clear-quiz" type="button">结束练习</button>
      </article>
    `;
  }

  const answered = Boolean(quiz.answered);
  return `
    <article class="quiz-card">
      <h3>${escapeHtml(quiz.title)} ${quiz.index + 1} / ${quiz.questions.length}</h3>
      <div class="quiz-prompt-line">
        <span class="quiz-type">${escapeHtml(question.typeLabel || "练习")}</span>
        <p>${escapeHtml(question.prompt)}</p>
      </div>
      ${question.speakText ? `
        <button class="secondary-button quiz-audio" data-action="speak" data-text="${escapeAttr(question.speakText)}" type="button">
          播放题目
        </button>
      ` : ""}
      ${renderQuizBody(question, answered)}
      ${answered ? `
        <div class="example">
          <b>${escapeHtml(question.feedbackTitle)}</b>
          ${question.kind === "input" || question.kind === "speech" ? `<span>你的答案：${escapeHtml(quiz.answerValue || "空")}</span>` : ""}
          <span>${escapeHtml(question.feedback)}</span>
        </div>
        <button class="primary-button" data-action="next-quiz" type="button">${quiz.index + 1 >= quiz.questions.length ? "完成" : "下一题"}</button>
      ` : ""}
    </article>
  `;
}

function renderQuizBody(question, answered) {
  if (question.kind === "input") return renderWrittenQuiz(question, answered);
  if (question.kind === "speech") return renderSpeechQuiz(question, answered);
  return renderChoiceQuiz(question, answered);
}

function renderChoiceQuiz(question, answered) {
  return `
    <div class="quiz-options">
      ${question.options.map((option) => renderQuizOption(question, option, answered)).join("")}
    </div>
  `;
}

function renderSpeechQuiz(question, answered) {
  return `
    <div class="speech-card">
      ${question.visibleText ? `<p class="speech-target">${escapeHtml(question.visibleText)}</p>` : ""}
      <div class="speech-actions">
        <button class="secondary-button" data-action="start-speech-answer" type="button" ${answered || state.quiz.listening ? "disabled" : ""}>
          ${state.quiz.listening ? "正在听..." : "开始录音"}
        </button>
        <button class="primary-button" data-action="submit-speech-quiz" type="button" ${answered ? "disabled" : ""}>提交口述</button>
      </div>
      <input
        class="quiz-input"
        data-quiz-answer="true"
        type="text"
        value="${escapeAttr(state.quiz.answerValue || "")}"
        placeholder="识别结果会出现在这里；不支持语音识别时可手动输入"
        autocapitalize="none"
        autocomplete="off"
        autocorrect="off"
        ${answered ? "disabled" : ""}
      />
    </div>
  `;
}

function renderWrittenQuiz(question, answered) {
  return `
    <div class="quiz-input-row">
      <input
        class="quiz-input"
        data-quiz-answer="true"
        type="text"
        value="${escapeAttr(state.quiz.answerValue || "")}"
        placeholder="${escapeAttr(question.placeholder || "输入答案")}"
        autocapitalize="none"
        autocomplete="off"
        autocorrect="off"
        ${answered ? "disabled" : ""}
      />
      <button class="primary-button" data-action="submit-written-quiz" type="button" ${answered ? "disabled" : ""}>提交</button>
    </div>
  `;
}

function renderQuizOption(question, option, answered) {
  let className = "";
  if (answered && option.id === question.correctId) className = "is-correct";
  if (answered && option.id === state.quiz.selectedId && option.id !== question.correctId) className = "is-wrong";
  return `
    <button class="option-button ${className}" data-action="answer-quiz" data-id="${escapeAttr(option.id)}" type="button" ${answered ? "disabled" : ""}>
      ${escapeHtml(option.label)}
    </button>
  `;
}

function renderTask(task, index) {
  return `
    <article class="task-item">
      <span class="task-number">${index + 1}</span>
      <div>
        <strong>${escapeHtml(task.title)}</strong>
        <p>${escapeHtml(task.detail)}</p>
        <button class="small-button" data-action="go-screen" data-screen="${task.screen}" type="button">进入</button>
      </div>
    </article>
  `;
}

function renderQuick(title, value, screen) {
  return `
    <button class="quick-card" data-action="go-screen" data-screen="${screen}" type="button">
      <span>${escapeHtml(title)}</span>
      <strong>${escapeHtml(value)}</strong>
    </button>
  `;
}

function renderPracticeQuick(title, value, level) {
  return `
    <button class="quick-card" data-action="start-level-quiz" data-level="${level}" type="button">
      <span>${escapeHtml(title)}</span>
      <strong>${escapeHtml(value)}</strong>
    </button>
  `;
}

function renderStat(title, value) {
  return `<article class="stat-card"><span>${escapeHtml(title)}</span><strong>${escapeHtml(value)}</strong></article>`;
}

function renderChip(label, action, value, active) {
  return `<button class="chip ${active ? "is-active" : ""}" data-action="${action}" data-value="${escapeAttr(value)}" type="button">${escapeHtml(label)}</button>`;
}

function renderLevelChip(level, value, label) {
  const active = (state.levelSection[level] || "grammar") === value;
  return `<button class="chip ${active ? "is-active" : ""}" data-action="set-level-section" data-level="${level}" data-value="${value}" type="button">${escapeHtml(label)}</button>`;
}

function renderEmpty(title, detail) {
  return `<article class="empty-card"><strong>${escapeHtml(title)}</strong><p>${escapeHtml(detail)}</p></article>`;
}

function buildTodayTasks() {
  const tasks = [];
  const firstKana = getFlatKana().find((item) => !isMastered(`kana:${item.h}`));
  if (firstKana) {
    tasks.push({
      title: `五十音：先记 ${firstKana.h} / ${firstKana.k}`,
      detail: `读音是 ${firstKana.r}。点进去听一遍，再手动标记掌握。`,
      screen: "kana"
    });
  }

  ["n5", "n4", "n3"].forEach((levelKey) => {
    const item = levels[levelKey].grammar.find((grammar) => !isMastered(grammar.id));
    if (item) {
      tasks.push({
        title: `${levels[levelKey].label}：${item.title}`,
        detail: `${item.zh}。先看例句，再做 20 题综合练习。`,
        screen: levelKey
      });
    }
  });

  return tasks.slice(0, 4);
}

function setKanaMode(mode) {
  state.kanaMode = mode;
  saveState();
  renderKana();
}

function selectKana(id) {
  state.selectedKana = id;
  saveState();
  renderKana();
  const item = getKanaById(id);
  if (item) speakText(getKanaChar(item));
}

function setLevelSection(level, section) {
  state.levelSection[level] = section;
  state.quiz = null;
  saveState();
  renderLevel(level);
}

function toggleExpanded(id) {
  state.expandedId = state.expandedId === id ? "" : id;
  saveState();
  renderAll();
}

function toggleMastered(id, label) {
  state.mastered[id] = !state.mastered[id];
  if (!state.mastered[id]) delete state.mastered[id];
  saveState();
  showToast(state.mastered[id] ? `${label}已标记掌握` : "已取消掌握");
  renderAll();
}

function startMixedQuiz() {
  state.quiz = createQuiz("mixed", "综合随机练习", buildMixedQuizQuestions(30));
  saveState();
  renderHome();
}

function startVoiceQuiz() {
  state.quiz = createQuiz("voice", "语音专项练习", buildVoiceQuizQuestions(20));
  saveState();
  renderHome();
}

function startKanaQuiz() {
  const questionCount = 20;
  state.quiz = createQuiz("kana", "五十音综合测", buildKanaQuizQuestions(questionCount));
  saveState();
  if (state.activeScreen === "home") renderHome();
  else renderKana();
}

function createQuiz(type, title, questions, extra = {}) {
  return {
    type,
    title,
    index: 0,
    score: 0,
    answered: false,
    selectedId: "",
    answerValue: "",
    listening: false,
    questions,
    ...extra
  };
}

function buildKanaQuizQuestions(count) {
  const items = shuffle(getFlatKana());
  const types = ["romaji-to-kana", "kana-to-romaji", "write-hiragana", "write-katakana", "write-romaji", "listen-kana"];
  return Array.from({ length: count }, (_, index) => {
    const item = items[index % items.length];
    return createKanaQuestion(item, types[index % types.length]);
  });
}

function createKanaQuestion(item, type) {
  const kanaLabel = getKanaChar(item);
  const feedbackTitle = `${item.h} / ${item.k} / ${item.r}`;
  const feedback = `平假名：${item.h}。片假名：${item.k}。罗马音：${item.r}。`;

  if (type === "romaji-to-kana") {
    const options = buildKanaOptions(item);
    return {
      kind: "choice",
      typeLabel: "读",
      masteryId: item.h,
      masteryKey: `kana:${item.h}`,
      correctId: `kana:${item.h}`,
      prompt: `读音「${item.r}」对应哪个${state.kanaMode === "katakana" ? "片假名" : "平假名"}？`,
      feedbackTitle,
      feedback,
      options
    };
  }

  if (type === "kana-to-romaji") {
    const options = buildRomajiOptions(item);
    return {
      kind: "choice",
      typeLabel: "拼",
      masteryId: item.h,
      masteryKey: `kana:${item.h}`,
      correctId: `romaji:${item.r}`,
      prompt: `假名「${kanaLabel}」应该怎么读？`,
      feedbackTitle,
      feedback,
      options
    };
  }

  if (type === "write-hiragana") {
    return {
      kind: "input",
      typeLabel: "写",
      masteryId: item.h,
      masteryKey: `kana:${item.h}`,
      prompt: `把读音「${item.r}」写成平假名。`,
      placeholder: "例如：あ",
      acceptedAnswers: [item.h],
      feedbackTitle,
      feedback
    };
  }

  if (type === "write-katakana") {
    return {
      kind: "input",
      typeLabel: "写",
      masteryId: item.h,
      masteryKey: `kana:${item.h}`,
      prompt: `把读音「${item.r}」写成片假名。`,
      placeholder: "例如：ア",
      acceptedAnswers: [item.k],
      feedbackTitle,
      feedback
    };
  }

  if (type === "write-romaji") {
    return {
      kind: "input",
      typeLabel: "拼",
      masteryId: item.h,
      masteryKey: `kana:${item.h}`,
      prompt: `写出假名「${kanaLabel}」的罗马音。`,
      placeholder: "例如：shi",
      acceptedAnswers: getRomajiAnswers(item.r),
      feedbackTitle,
      feedback
    };
  }

  return {
    kind: "choice",
    typeLabel: "听",
    masteryId: item.h,
    masteryKey: `kana:${item.h}`,
    correctId: `kana:${item.h}`,
    prompt: `先点播放，选择你听到的${state.kanaMode === "katakana" ? "片假名" : "平假名"}。`,
    speakText: item.h,
    feedbackTitle,
    feedback,
    options: buildKanaOptions(item)
  };
}

function buildKanaOptions(item) {
  const wrong = sample(getFlatKana().filter((candidate) => candidate.h !== item.h && candidate.r !== item.r), 3);
  return shuffle([
    { id: `kana:${item.h}`, label: getKanaChar(item) },
    ...wrong.map((candidate) => ({ id: `kana:${candidate.h}`, label: getKanaChar(candidate) }))
  ]);
}

function buildRomajiOptions(item) {
  const wrongItems = [];
  const used = new Set([item.r]);
  for (const candidate of shuffle(getFlatKana())) {
    if (used.has(candidate.r)) continue;
    used.add(candidate.r);
    wrongItems.push(candidate);
    if (wrongItems.length >= 3) break;
  }
  return shuffle([
    { id: `romaji:${item.r}`, label: item.r },
    ...wrongItems.map((candidate) => ({ id: `romaji:${candidate.r}`, label: candidate.r }))
  ]);
}

function getRomajiAnswers(romaji) {
  const aliases = {
    shi: ["shi", "si"],
    chi: ["chi", "ti"],
    tsu: ["tsu", "tu"],
    fu: ["fu", "hu"],
    ji: ["ji", "zi"],
    sha: ["sha", "sya"],
    shu: ["shu", "syu"],
    sho: ["sho", "syo"],
    cha: ["cha", "cya", "tya"],
    chu: ["chu", "cyu", "tyu"],
    cho: ["cho", "cyo", "tyo"],
    ja: ["ja", "jya", "zya"],
    ju: ["ju", "jyu", "zyu"],
    jo: ["jo", "jyo", "zyo"]
  };
  return aliases[romaji] || [romaji];
}

function buildMixedQuizQuestions(count) {
  const guaranteed = [
    ...buildKanaQuizQuestions(6),
    ...buildBalancedLevelQuizQuestions("n5", 8),
    ...buildBalancedLevelQuizQuestions("n4", 8),
    ...buildBalancedLevelQuizQuestions("n3", 8)
  ];
  const bank = [
    ...guaranteed,
    ...buildKanaQuizQuestions(24),
    ...buildLevelPracticeBank("n5"),
    ...buildLevelPracticeBank("n4"),
    ...buildLevelPracticeBank("n3")
  ];
  return takeUniqueQuestions(guaranteed, bank, count);
}

function buildVoiceQuizQuestions(count) {
  const bank = [
    ...buildKanaQuizQuestions(18).filter((question) => question.typeLabel === "听"),
    ...buildLevelPracticeBank("n5").filter(isVoiceQuestion),
    ...buildLevelPracticeBank("n4").filter(isVoiceQuestion),
    ...buildLevelPracticeBank("n3").filter(isVoiceQuestion)
  ];
  return sample(bank, Math.min(count, bank.length));
}

function isVoiceQuestion(question) {
  return question.typeLabel === "听力" || question.typeLabel === "跟读" || question.typeLabel === "听";
}

function startLevelQuiz(levelKey) {
  const level = levels[levelKey];
  state.quiz = createQuiz("level", `${level.label} 综合练习`, buildBalancedLevelQuizQuestions(levelKey, 20, state.queries[levelKey]), { level: levelKey });
  saveState();
  if (state.activeScreen === "home") renderHome();
  else renderLevel(levelKey);
}

function buildBalancedLevelQuizQuestions(levelKey, count, query = "") {
  const bank = buildLevelPracticeBank(levelKey, query);
  const grammar = bank.filter((question) => isGrammarPractice(question, levelKey) && !isVoiceQuestion(question));
  const vocab = bank.filter((question) => isVocabPractice(question, levelKey) && !isVoiceQuestion(question));
  const kanji = bank.filter((question) => question.typeLabel === "汉字");
  const voice = bank.filter(isVoiceQuestion);

  const guaranteed = [
    ...sample(grammar, Math.min(8, grammar.length)),
    ...sample(vocab, Math.min(5, vocab.length)),
    ...sample(kanji, Math.min(3, kanji.length)),
    ...sample(voice, Math.min(4, voice.length))
  ];

  return takeUniqueQuestions(guaranteed, bank, count);
}

function isGrammarPractice(question, levelKey) {
  return Boolean(question.masteryKey && question.masteryKey.startsWith(`${levelKey}-`));
}

function isVocabPractice(question, levelKey) {
  return Boolean(question.masteryKey && question.masteryKey.startsWith(`${levelKey}:`));
}

function takeUniqueQuestions(guaranteed, bank, count) {
  const seen = new Set();
  const selected = [];
  const add = (question) => {
    const key = `${question.kind}:${question.typeLabel}:${question.prompt}:${question.correctId || question.acceptedAnswers?.join("|") || ""}`;
    if (seen.has(key)) return;
    seen.add(key);
    selected.push(question);
  };

  guaranteed.forEach(add);
  shuffle(bank).forEach((question) => {
    if (selected.length < count) add(question);
  });
  return shuffle(selected).slice(0, count);
}

function buildLevelPracticeBank(levelKey, query = "") {
  const level = levels[levelKey];
  const normalizedQuery = normalize(query);
  const grammarSource = normalizedQuery
    ? level.grammar.filter((item) => matchGrammar(item, normalizedQuery))
    : level.grammar;
  const grammarItems = grammarSource.length ? grammarSource : level.grammar;
  const vocabItems = getLevelWords(levelKey);
  const kanjiItems = [...level.kanji].map((char) => ({ char, levelKey }));

  return [
    ...grammarItems.flatMap((item) => buildGrammarQuestions(levelKey, item)),
    ...vocabItems.flatMap((item) => buildVocabQuestions(levelKey, item)),
    ...sample(kanjiItems, Math.min(80, kanjiItems.length)).map((item) => buildKanjiQuestion(item))
  ];
}

function buildGrammarQuestions(levelKey, item) {
  const level = levels[levelKey];
  const wrongGrammar = level.grammar.filter((candidate) => candidate.id !== item.id);
  return [
    {
      kind: "choice",
      typeLabel: "语法",
      masteryKey: item.id,
      correctId: `grammar:${item.id}:pattern`,
      prompt: `「${item.zh}」常用哪个句型？`,
      feedbackTitle: `${item.title}：${item.pattern}`,
      feedback: `${item.example}（${item.exampleZh}）`,
      options: shuffle([
        { id: `grammar:${item.id}:pattern`, label: `${item.title}  ${item.pattern}` },
        ...sample(wrongGrammar, 3).map((candidate) => ({
          id: `grammar:${candidate.id}:pattern`,
          label: `${candidate.title}  ${candidate.pattern}`
        }))
      ])
    },
    {
      kind: "choice",
      typeLabel: "理解",
      masteryKey: item.id,
      correctId: `grammar:${item.id}:meaning`,
      prompt: `句型「${item.title}」主要是什么意思？`,
      feedbackTitle: `${item.title}：${item.zh}`,
      feedback: `${item.example}（${item.exampleZh}）`,
      options: shuffle([
        { id: `grammar:${item.id}:meaning`, label: item.zh },
        ...sample(wrongGrammar, 3).map((candidate) => ({
          id: `grammar:${candidate.id}:meaning`,
          label: candidate.zh
        }))
      ])
    },
    {
      kind: "input",
      typeLabel: "输入",
      masteryKey: item.id,
      prompt: `输入这个意思对应的句型：${item.zh}`,
      placeholder: item.title,
      acceptedAnswers: getGrammarAnswers(item),
      feedbackTitle: `${item.title}：${item.pattern}`,
      feedback: `${item.example}（${item.exampleZh}）`
    },
    {
      kind: "choice",
      typeLabel: "听力",
      masteryKey: item.id,
      correctId: `grammar:${item.id}:listen`,
      prompt: "播放日语例句，选择它的中文意思。",
      speakText: item.example,
      feedbackTitle: item.example,
      feedback: item.exampleZh,
      options: shuffle([
        { id: `grammar:${item.id}:listen`, label: item.exampleZh },
        ...sample(wrongGrammar, 3).map((candidate) => ({
          id: `grammar:${candidate.id}:listen`,
          label: candidate.exampleZh
        }))
      ])
    },
    {
      kind: "speech",
      typeLabel: "跟读",
      masteryKey: item.id,
      prompt: "播放后跟读这句日语。",
      speakText: item.example,
      visibleText: item.example,
      acceptedAnswers: [item.example],
      feedbackTitle: item.example,
      feedback: `目标意思：${item.exampleZh}`
    }
  ];
}

function buildVocabQuestions(levelKey, item) {
  const words = getLevelWords(levelKey).filter((word) => word.ja !== item.ja);
  return [
    {
      kind: "choice",
      typeLabel: "词汇",
      masteryKey: item.id,
      correctId: `vocab:${item.id}:zh`,
      prompt: `「${item.ja}」是什么意思？`,
      feedbackTitle: `${item.ja}：${item.zh}`,
      feedback: `词汇主题：${item.groupTitle}`,
      options: shuffle([
        { id: `vocab:${item.id}:zh`, label: item.zh },
        ...sample(words, 3).map((word) => ({ id: `vocab:${word.id}:zh`, label: word.zh }))
      ])
    },
    {
      kind: "choice",
      typeLabel: "词汇",
      masteryKey: item.id,
      correctId: `vocab:${item.id}:ja`,
      prompt: `中文「${item.zh}」对应哪个日语词？`,
      feedbackTitle: `${item.ja}：${item.zh}`,
      feedback: `词汇主题：${item.groupTitle}`,
      options: shuffle([
        { id: `vocab:${item.id}:ja`, label: item.ja },
        ...sample(words, 3).map((word) => ({ id: `vocab:${word.id}:ja`, label: word.ja }))
      ])
    },
    {
      kind: "input",
      typeLabel: "输入",
      masteryKey: item.id,
      prompt: `把「${item.zh}」写成日语。`,
      placeholder: item.ja,
      acceptedAnswers: [item.ja],
      feedbackTitle: `${item.ja}：${item.zh}`,
      feedback: `词汇主题：${item.groupTitle}`
    },
    {
      kind: "choice",
      typeLabel: "听力",
      masteryKey: item.id,
      correctId: `vocab:${item.id}:listen`,
      prompt: "播放日语词，选择中文意思。",
      speakText: item.ja,
      feedbackTitle: `${item.ja}：${item.zh}`,
      feedback: `词汇主题：${item.groupTitle}`,
      options: shuffle([
        { id: `vocab:${item.id}:listen`, label: item.zh },
        ...sample(words, 3).map((word) => ({ id: `vocab:${word.id}:listen`, label: word.zh }))
      ])
    },
    {
      kind: "speech",
      typeLabel: "跟读",
      masteryKey: item.id,
      prompt: "播放后跟读这个词。",
      speakText: item.ja,
      visibleText: item.ja,
      acceptedAnswers: [item.ja],
      feedbackTitle: `${item.ja}：${item.zh}`,
      feedback: `词汇主题：${item.groupTitle}`
    }
  ];
}

function buildKanjiQuestion(item) {
  const level = levels[item.levelKey];
  return {
    kind: "choice",
    typeLabel: "汉字",
    masteryKey: `kanji:${item.levelKey}:${item.char}`,
    correctId: `kanji:${item.levelKey}`,
    prompt: `汉字「${item.char}」在这个 App 里归到哪个等级？`,
    feedbackTitle: `${item.char}：${level.label}`,
    feedback: "先用等级范围做快速识别；后续可以继续补读音和释义表。",
    options: shuffle(Object.values(levels).map((candidate) => ({
      id: `kanji:${candidate.key}`,
      label: candidate.label
    })))
  };
}

function getGrammarAnswers(item) {
  const raw = `${item.title} / ${item.pattern}`;
  return raw
    .split("/")
    .map((part) => part.trim())
    .filter(Boolean);
}

function getLevelWords(levelKey) {
  return levels[levelKey].vocab.flatMap((group) =>
    group.words.map((word) => {
      const [ja, zh = ""] = word.split("：");
      return {
        id: `${levelKey}:${ja}`,
        levelKey,
        groupTitle: group.title,
        ja,
        zh
      };
    })
  );
}

function answerQuiz(id) {
  if (!state.quiz || state.quiz.answered) return;
  const question = state.quiz.questions[state.quiz.index];
  state.quiz.selectedId = id;
  state.quiz.answered = true;
  if (id === question.correctId) {
    state.quiz.score += 1;
    markQuestionMastered(question);
  }
  saveState();
  renderAll();
}

function submitWrittenQuiz() {
  if (!state.quiz || state.quiz.answered) return;
  const question = state.quiz.questions[state.quiz.index];
  if (!question || question.kind !== "input") return;

  const answer = state.quiz.answerValue || "";
  if (!normalizeAnswer(answer)) {
    showToast("先输入答案再提交");
    return;
  }

  const correct = (question.acceptedAnswers || []).some((accepted) => normalizeAnswer(answer) === normalizeAnswer(accepted));
  state.quiz.selectedId = normalizeAnswer(answer);
  state.quiz.answered = true;
  if (correct) {
    state.quiz.score += 1;
    markQuestionMastered(question);
  }
  saveState();
  renderAll();
}

function startSpeechAnswer() {
  if (!state.quiz || state.quiz.answered) return;
  const question = state.quiz.questions[state.quiz.index];
  if (!question || question.kind !== "speech") return;

  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SpeechRecognition) {
    showToast("这个浏览器不支持语音识别，可以先手动输入识别结果");
    return;
  }

  if (speechRecognition) {
    speechRecognition.stop();
    speechRecognition = null;
  }

  state.quiz.answerValue = "";
  state.quiz.listening = true;
  saveState();
  renderAll();

  speechRecognition = new SpeechRecognition();
  speechRecognition.lang = "ja-JP";
  speechRecognition.interimResults = false;
  speechRecognition.maxAlternatives = 1;
  speechRecognition.onresult = (event) => {
    const transcript = event.results[0][0].transcript;
    state.quiz.answerValue = transcript;
    state.quiz.listening = false;
    saveState();
    renderAll();
  };
  speechRecognition.onerror = () => {
    state.quiz.listening = false;
    saveState();
    showToast("没有识别到声音，可以再试一次或手动输入");
    renderAll();
  };
  speechRecognition.onend = () => {
    if (state.quiz?.listening) {
      state.quiz.listening = false;
      saveState();
      renderAll();
    }
    speechRecognition = null;
  };
  speechRecognition.start();
}

function submitSpeechQuiz() {
  if (!state.quiz || state.quiz.answered) return;
  const question = state.quiz.questions[state.quiz.index];
  if (!question || question.kind !== "speech") return;

  const answer = state.quiz.answerValue || "";
  if (!normalizeAnswer(answer)) {
    showToast("先录音或手动输入再提交");
    return;
  }

  const score = scoreSpeechAnswer(answer, question.acceptedAnswers || []);
  state.quiz.selectedId = normalizeSpeech(answer);
  state.quiz.answered = true;
  if (score >= 0.58) {
    state.quiz.score += 1;
    markQuestionMastered(question);
  }
  question.feedback = `${question.feedback}。相似度：${Math.round(score * 100)}%。`;
  saveState();
  renderAll();
}

function markQuestionMastered(question) {
  if (!question.masteryKey) return;
  state.mastered[question.masteryKey] = true;
}

function nextQuiz() {
  if (!state.quiz) return;
  state.quiz.index += 1;
  state.quiz.answered = false;
  state.quiz.selectedId = "";
  state.quiz.answerValue = "";
  saveState();
  renderAll();
}

function clearQuiz() {
  state.quiz = null;
  saveState();
  renderAll();
}

function resetProgress() {
  const confirmed = window.confirm("确定重置所有掌握进度吗？");
  if (!confirmed) return;
  state.mastered = {};
  state.quiz = null;
  state.expandedId = "";
  saveState();
  showToast("进度已重置");
  renderAll();
}

function installApp() {
  if (deferredInstallPrompt) {
    deferredInstallPrompt.prompt();
    deferredInstallPrompt.userChoice.finally(() => {
      deferredInstallPrompt = null;
    });
    return;
  }
  showToast("iPhone 请用 Safari：分享按钮 → 添加到主屏幕");
}

function getKanaChar(item) {
  return state.kanaMode === "katakana" ? item.k : item.h;
}

function getFlatKana() {
  return kanaSections.flatMap((section) => section.rows.flat()).filter(Boolean);
}

function getKanaById(id) {
  return getFlatKana().find((item) => item.h === id);
}

function getKanaProgress() {
  const kana = getFlatKana();
  const done = kana.filter((item) => isMastered(`kana:${item.h}`)).length;
  return { total: kana.length, done, percent: percent(done, kana.length) };
}

function getLevelProgress(levelKey) {
  const grammar = levels[levelKey].grammar;
  const done = grammar.filter((item) => isMastered(item.id)).length;
  return { total: grammar.length, done, percent: percent(done, grammar.length) };
}

function getTotalProgress() {
  const kana = getKanaProgress();
  const grammar = Object.keys(levels).flatMap((levelKey) => levels[levelKey].grammar);
  const vocab = Object.keys(levels).flatMap((levelKey) => getLevelWords(levelKey));
  const kanji = Object.keys(levels).flatMap((levelKey) => [...levels[levelKey].kanji].map((char) => `kanji:${levelKey}:${char}`));
  const grammarDone = grammar.filter((item) => isMastered(item.id)).length;
  const vocabDone = vocab.filter((item) => isMastered(item.id)).length;
  const kanjiDone = kanji.filter((id) => isMastered(id)).length;
  const total = kana.total + grammar.length + vocab.length + kanji.length;
  const done = kana.done + grammarDone + vocabDone + kanjiDone;
  return {
    total,
    done,
    percent: percent(done, total),
    grammarTotal: grammar.length,
    grammarDone
  };
}

function getPracticePoolSize() {
  return getFlatKana().length + Object.keys(levels).reduce((sum, levelKey) => {
    const level = levels[levelKey];
    return sum + level.grammar.length + getLevelWords(levelKey).length + level.kanji.length;
  }, 0);
}

function isMastered(id) {
  return Boolean(state.mastered[id]);
}

function matchGrammar(item, query) {
  if (!query) return true;
  return normalize(`${item.title} ${item.zh} ${item.pattern} ${item.example} ${item.exampleZh} ${(item.tags || []).join(" ")}`).includes(query);
}

function percent(done, total) {
  if (!total) return 0;
  return Math.round((done / total) * 100);
}

function sample(items, count) {
  return shuffle(items).slice(0, count);
}

function shuffle(items) {
  const copy = [...items];
  for (let index = copy.length - 1; index > 0; index -= 1) {
    const randomIndex = Math.floor(Math.random() * (index + 1));
    [copy[index], copy[randomIndex]] = [copy[randomIndex], copy[index]];
  }
  return copy;
}

function normalize(value) {
  return String(value || "").trim().toLowerCase();
}

function normalizeAnswer(value) {
  return toHalfWidth(String(value || ""))
    .trim()
    .toLowerCase()
    .replace(/\s+/g, "");
}

function normalizeSpeech(value) {
  return toHalfWidth(String(value || ""))
    .toLowerCase()
    .replace(/[、。,.!?！？「」『』（）()\s]/g, "");
}

function scoreSpeechAnswer(answer, acceptedAnswers) {
  const normalizedAnswer = normalizeSpeech(answer);
  if (!normalizedAnswer) return 0;

  return Math.max(...acceptedAnswers.map((expected) => {
    const normalizedExpected = normalizeSpeech(expected);
    if (!normalizedExpected) return 0;
    if (normalizedAnswer === normalizedExpected) return 1;
    if (normalizedAnswer.includes(normalizedExpected) || normalizedExpected.includes(normalizedAnswer)) return 0.86;
    return lcsRatio(normalizedAnswer, normalizedExpected);
  }));
}

function lcsRatio(a, b) {
  const rows = a.length + 1;
  const cols = b.length + 1;
  const table = Array.from({ length: rows }, () => Array(cols).fill(0));
  for (let i = 1; i < rows; i += 1) {
    for (let j = 1; j < cols; j += 1) {
      table[i][j] = a[i - 1] === b[j - 1]
        ? table[i - 1][j - 1] + 1
        : Math.max(table[i - 1][j], table[i][j - 1]);
    }
  }
  return table[a.length][b.length] / Math.max(a.length, b.length);
}

function toHalfWidth(value) {
  return value.replace(/[Ａ-Ｚａ-ｚ０-９]/g, (char) => String.fromCharCode(char.charCodeAt(0) - 0xfee0));
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function escapeAttr(value) {
  return escapeHtml(value);
}

function speakText(text) {
  if (!text || !window.speechSynthesis) return;
  const utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = "ja-JP";
  utterance.rate = 0.86;
  window.speechSynthesis.cancel();
  window.speechSynthesis.speak(utterance);
}

function showToast(message) {
  const toast = document.getElementById("toast");
  toast.textContent = message;
  toast.classList.add("is-visible");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    toast.classList.remove("is-visible");
  }, 1800);
}

function registerServiceWorker() {
  if (!("serviceWorker" in navigator)) return;
  navigator.serviceWorker.register("./sw.js").catch(() => {});
}
