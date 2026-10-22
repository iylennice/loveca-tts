-- GENERATED: python tools/build_importer.py
-- Paste this file once into TTS Global. Do not edit the generated file.
-- Import is explicit; onLoad never creates cards.

local SAMPLE_CARDS = JSON.decode([=[[{"card_no":"PL!-bp3-021-SRL","img":"https://llofficial-cardgame.com/wordpress/wp-content/images/cardlist/PBLL02/PL!-bp3-021-SRL.png","name":"愛してるばんざーい!","product":"プレミアムブースター ラブライブ！DUO","type":"ライブ","rare":"SRL","series":"ラブライブ！","score":6,"need_heart":{"heart0":7,"heart01":3,"heart06":4},"blade_heart":{"b_heart06":1},"special_heart":{"draw":1},"faq":[],"rare_list":[{"card_no":"PL!-bp3-021-SRL","name":"愛してるばんざーい!"},{"card_no":"PL!-bp3-021-L","name":"愛してるばんざーい!"}],"_img":"img/cards/PBLL02/PL!-bp3-021-SRL.png"},{"card_no":"PL!-pb2-000-R","img":"https://llofficial-cardgame.com/wordpress/wp-content/images/cardlist/PBLL02/PL!-pb2-000-R.png","name":"星空 凛&小泉花陽","product":"プレミアムブースター ラブライブ！DUO","type":"メンバー","rare":"R","series":"ラブライブ！","cost":15,"base_heart":{"heart01":2,"heart03":2,"heart06":1},"blade_heart":{"b_heart03":1},"blade":7,"ability":"{{jyouji.png|常時}}このカードのプレイに際し、2人のメンバーとバトンタッチしてもよい。 \n{{toujyou.png|登場}}『μ's』のメンバー2人からバトンタッチして登場した場合、自分の控え室にある『μ's』のライブカードを1枚手札に加え、さらに、そのメンバー2人のコストの合計が15の場合、ライブ終了時まで、「{{jyouji.png|常時}}ライブの合計スコアを＋１する。」を得る。","faq":[],"rare_list":[{"card_no":"PL!-pb2-000-R","name":"星空 凛&小泉花陽"},{"card_no":"PL!-pb2-000-DUO","name":"星空 凛&小泉花陽"}],"_img":"img/cards/PBLL02/PL!-pb2-000-R.png"},{"card_no":"PL!S-PR-034-PR＋","img":"https://llofficial-cardgame.com/wordpress/wp-content/images/cardlist/PR/PL!S-PR-034-PR2.png","name":"","product":"PRカード","type":"エネルギー","rare":"PR+","series":"ラブライブ！サンシャイン!!","unit":"CYaRon！","faq":[],"rare_list":[{"card_no":"PL!S-PR-034-PR＋","name":""}],"_img":"img/cards/PR/PL!S-PR-034-PR2.png"}]]=])

local POINT_SYSTEM = JSON.decode([=[{"source":"https://llofficial-cardgame.com/lovecapointsystem/","effective_date":"2026-08-08","deck_limit":9,"points":{"LL-bp2-001":5,"PL!N-bp1-003":4,"PL!N-bp1-012":3,"PL!N-bp1-002":2,"PL!N-sd1-008":2,"PL!HS-bp2-014":2,"PL!N-pb1-011":2,"PL!SP-bp1-005":1,"PL!N-bp1-029":1,"PL!SP-sd1-019":1,"PL!SP-sd1-020":1,"PL!SP-pb1-014":1,"PL!N-bp3-030":1,"PL!N-bp4-030":1}}]=])

local MARKER_OBJECT_SCRIPT = [=[-- Presentation only. Japanese source keys never replace metadata or ability prose.
-- Bundled into Global and standalone marker scripts by build_importer.py.
local LANGUAGE = "zh"
local ZH_TEXT = {
    ["デッキ導入"] = "导入牌组", ["LoveCa デッキ導入"] = "LoveCa 牌组导入",
    ["盤面計算"] = "场面计算", ["LoveCa 盤面計算"] = "LoveCa 场面计算",
    ["数値マーカー"] = "数值标记", ["先攻・後攻を決定"] = "决定先后手",
    ["閉じる"] = "关闭", ["更新"] = "刷新", ["詳細"] = "详情",
    ["カード番号 枚数（1行1種類）"] = "卡号 张数（每行一种）",
    ["準備完了（読込時には自動生成しません）"] = "准备就绪（载入存档时不会自动生成卡牌）",
    ["読込中…"] = "读取中…", ["初期値"] = "初始值", ["配置先"] = "放置区域",
    ["マーカー作成"] = "创建标记", ["必要なマーカーだけ作成できます。"] = "按需选择类型、数值和区域，再创建标记。",
    ["図柄を移動、外側の数値：左 +1 ／ 右 −1\n補正欄に置くと盤面計算に反映（保管は無効）\n交代時は保管へ戻し、新しい対象の欄に置き直す"] = "拖动图案移动；外侧数字：左键 +1／右键 −1\n放入补正栏后计入场面计算（保管区不生效）\n更换对象时先放回保管区，再放入新对象的栏位",
    ["メンバー 左"] = "成员 左", ["メンバー 中"] = "成员 中", ["メンバー 右"] = "成员 右",
    ["保管（無効）"] = "保管（不生效）", ["Live 合計 S"] = "Live 总分 S", ["エール補正"] = "应援补正",
    ["Live 合計"] = "Live 合计", ["保管"] = "保管", ["エール"] = "应援",
    ["非公開カード 処理エリア"] = "不公开卡牌 处理区",
    ["非公開カードを確認・選択\n処理後は効果で指定された場所へ"] = "查看、挑选不公开的卡牌\n处理后移至效果指定区域",
    ["メンバー"] = "成员", ["ライブ"] = "Live", ["エネルギー"] = "能量",
    ["White"] = "白色", ["Brown"] = "棕色", ["Red"] = "红色", ["Orange"] = "橙色",
    ["Yellow"] = "黄色", ["Green"] = "绿色", ["Teal"] = "青绿色", ["Blue"] = "蓝色",
    ["Purple"] = "紫色", ["Pink"] = "粉色", ["Black"] = "主持人", ["Grey"] = "旁观者",
    ["桃"] = "粉", ["赤"] = "红", ["緑"] = "绿", ["青"] = "蓝",
    ["桃ハート"] = "粉色爱心", ["赤ハート"] = "红色爱心", ["黄ハート"] = "黄色爱心",
    ["緑ハート"] = "绿色爱心", ["青ハート"] = "蓝色爱心", ["紫ハート"] = "紫色爱心",
    ["無色／無指定ハート"] = "无色／无指定爱心", ["ALLハート"] = "ALL 爱心",
    ["桃♥"] = "粉♥", ["赤♥"] = "红♥", ["緑♥"] = "绿♥", ["青♥"] = "蓝♥", ["無♥"] = "无♥",
    ["ブレード"] = "光刃", ["スコア"] = "分数", ["ハート"] = "爱心",
    ["無指定ハート"] = "无指定爱心", ["なし"] = "无",
    ["【常時】"] = "【常驻】", ["【登場】"] = "【登场】", ["【起動】"] = "【起动】", ["【自動】"] = "【自动】",
    ["【ライブ開始時】"] = "【Live 开始时】", ["【ライブ成功時】"] = "【Live 成功时】",
    ["【センター】"] = "【中央】", ["【左サイド】"] = "【左侧】", ["【右サイド】"] = "【右侧】",
    ["無指定×"] = "无指定×", ["無色×"] = "无色×",
    ["種類："] = "类型：", ["コスト："] = "费用：", ["ハート："] = "爱心：", ["ブレード："] = "光刃：",
    ["スコア："] = "分数：", ["必要ハート："] = "所需爱心：",
    ["コスト：—"] = "费用：—", ["ハート：—"] = "爱心：—", ["ブレード：—"] = "光刃：—",
    ["ブレードハート："] = "应援爱心：", ["エール加点："] = "应援加分：", ["エールドロー："] = "应援抽牌：",
    ["ラブカポイント："] = "LoveCa 积分：", ["作品："] = "作品：", ["ユニット："] = "组合：", ["収録商品："] = "收录商品：",
    ["カード番号とレアリティが一致しません："] = "卡号与稀有度不一致：",
    ["未配置"] = "未放置", ["（種類が対象外）"] = "（此类型不适用）", ["移動中"] = "移动中",
    ["領域が重複（補正無効）"] = "区域重叠（补正不生效）", ["（データ要確認）"] = "（请检查数据）",
    ["\n図柄をドラッグして移動\n外側の数値：左クリック +1 ／ 右クリック −1\n右クリックメニュー：直接入力・符号反転・0・削除\n補正欄で盤面計算に反映（保管は無効）\n交代時は保管へ戻してから置き直す"] = "\n拖动图案移动\n外侧数字：左键 +1／右键 −1\n右键菜单：直接输入、反号、归零、删除\n放入补正栏后计入场面计算（保管区不生效）\n更换对象时先放回保管区，再重新放置",
    ["\n左 +1 ／ 右 −1"] = "\n左键 +1／右键 −1",
    ["符号付き整数を入力してください。"] = "请输入带正负号的整数。",
    ["符号付き整数を入力してください。例：+2、-1"] = "请输入带正负号的整数，例如 +2、-1。",
    ["数値を入力"] = "输入数值", ["（符号付き整数）"] = "（带正负号的整数）",
    ["符号を反転"] = "正负反转", ["0 に戻す"] = "归零", ["マーカーを削除"] = "删除标记",
    ["種類・配置先・プレイヤーを確認してください。"] = "请检查标记类型、放置区域和玩家。",
    [" は "] = " 不适用于 ", [" の対象外です。"] = "。",
    ["プレイマットがありません。"] = "找不到桌垫。",
    ["配置先が埋まっています。マーカーやカードを移動してください。"] = "放置区域已满，请先移开标记或卡牌。",
    ["作成できませんでした："] = "创建失败：",
    ["数値データが不正です"] = "数值数据无效", ["ハートデータがありません"] = "缺少爱心数据",
    ["未判定\n集計中"] = "未判定\n统计中", ["未判定\n"] = "未判定\n",
    ["補正後の数値が整数範囲外"] = "补正后的数值超出整数范围",
    ["補正対象の公開カードを確認："] = "请检查补正对象是否为公开卡牌：",
    ["補正対象が交代：保管へ戻して置き直す（"] = "补正对象已更换：请先放回保管区再重新放置（",
    ["マーカー移動中"] = "标记移动中", ["マーカーの領域が重複"] = "标记区域重叠",
    ["領域とマーカー種類が不一致"] = "标记类型与区域不匹配", ["マーカーデータが不正"] = "标记数据无效",
    ["マーカー個体番号が重複"] = "标记实例编号重复", ["マーカーを確認"] = "请检查标记",
    ["補正の合計が整数範囲外："] = "补正合计超出整数范围：", ["他プレイヤーのカード："] = "其他玩家的卡牌：",
    ["ライブ不可\n効果による禁止を手動指定"] = "无法进行 Live\n已手动指定禁止效果",
    ["未公開カードがあります"] = "存在未公开卡牌", ["カード数値・配置を確認"] = "请检查卡牌数值及摆放",
    ["Liveカードを置いてください"] = "请放置 Live 卡", ["負の必要ハートを確認"] = "请确认负数的所需爱心",
    ["ハート合計が整数範囲外"] = "爱心合计超出整数范围", ["負の所有ハートを確認"] = "请确认负数的持有爱心",
    ["ライブ成功（現在値）\nハート "] = "Live 成功（当前数值）\n爱心 ", [" / 必要 "] = " / 所需 ",
    ["ライブ失敗\n色不足 "] = "Live 失败\n颜色不足 ", [" / 総数不足 "] = " / 总数不足 ",
    [" ［要確認］"] = " ［待确认］", ["ステージ  "] = "舞台  ",
    ["\nブレード "] = "\n光刃 ", ["　Active "] = "　就绪 ", [" / Wait "] = " / 休息 ",
    ["ライブ  公開 "] = "Live  公开 ", [" / 裏 "] = " / 盖放 ",
    ["\n無指定 "] = "\n无指定 ", ["　スコア "] = "　分数 ", ["エール  公開 "] = "应援  公开 ",
    ["\n無色 "] = "\n无色 ", ["　加点 "] = "　加分 ", ["　ドロー "] = "　抽牌 ",
    ["\nActive "] = "\n就绪 ", ["　Wait "] = "　休息 ", ["　合計 "] = "　合计 ", ["　不明 "] = "　未知 ",
    ["ほか "] = "另有 ", [" 件（詳細ボタン）"] = " 项（查看详情）",
    ["配置を自動更新中　補正 "] = "摆放自动更新中　补正 ", [" 件"] = " 项",
    ["プレイマットがありません："] = "找不到桌垫：", ["カード移動中"] = "卡牌移动中",
    ["この領域は単独カードで配置："] = "此区域请逐张放置卡牌：", ["牌庫をエールに置かないでください："] = "请勿将牌库放入应援区：",
    ["個体番号が重複："] = "实例编号重复：", ["カードデータを確認："] = "请检查卡牌数据：",
    ["領域とカード種類が不一致："] = "卡牌类型与区域不匹配：", ["メンバーの重なりを確認"] = "：请检查成员堆叠",
    ["メンバー数値を確認："] = "请检查成员数值：", ["メンバーの向きが不明"] = "：成员朝向不明确",
    ["Live は 1 枚ずつ配置"] = "：Live 请逐张放置", ["Live 数値を確認："] = "请检查 Live 数值：",
    ["エール種類"] = "应援类型", ["特殊ハート"] = "特殊爱心", ["エール数値を確認："] = "请检查应援数值：",
    ["エネルギーの向きが不明："] = "能量朝向不明确：", ["集計エラー（詳細はログ）"] = "统计出错（详情见日志）",
    ["未判定\n集計エラー（詳細はログ）"] = "未判定\n统计出错（详情见日志）",
    ["\n色別不足（ALL充当前） "] = "\n各色缺口（使用 ALL 前） ", ["\nALL充当 "] = "\n使用 ALL ", [" / 所有 "] = " / 持有 ",
    ["抽選待ち\nプレイヤーが未着席"] = "等待抽选\n尚无玩家入座",
    ["GM・観戦者以外のプレイヤーが着席してから抽選してください。"] = "请等待普通玩家入座后再抽选，主持人和旁观者不参与。",
    ["[%sプレイヤー]が\n先攻・後攻を決定"] = "由[%s玩家]\n决定先后手",
    ["Live不可（効果・手動）"] = "禁止 Live（效果·手动）",
    ["禁止効果は手動で反映してください。ハート判定は現在の入力値で自動更新します。"] = "禁止效果请手动勾选，爱心条件根据当前数值自动更新。",
    ["GM・観戦者を除き、着席者から先攻／後攻を選ぶ人をランダム抽選"] = "从已入座玩家中随机抽取先后选择权，排除主持人和旁观者",
    ["行 "] = "第 ", ["：カード番号と 1～"] = " 行：请输入卡号及 1～", [" の枚数を入力してください。"] = " 的张数。",
    ["：カード番号の形式が正しくありません。"] = " 行：卡号格式不正确。",
    ["一度のインポートは "] = "单次最多导入 ", [" 枚までです。"] = " 张。", [" 種類までです。"] = " 种。",
    ["カードリストが空です。"] = "卡牌列表为空。", ["通信エラー（HTTP "] = "网络错误（HTTP ",
    ["カード API が JSON を返しませんでした（"] = "卡牌 API 未返回 JSON（",
    ["カード API が有効な JSON を返しませんでした / URL: "] = "卡牌 API 未返回有效 JSON / URL: ",
    ["カード API の文字コードを変換できませんでした / URL: "] = "卡牌 API 字符编码转换失败 / URL: ",
    ["カード API の応答がタイムアウトしました / URL: "] = "卡牌 API 响应超时 / URL: ",
    ["技能アイコンに画像パスがありません。"] = "能力图标缺少图片路径。", ["数値フィールドが不正です："] = "数值字段无效：",
    ["カードの詳細データが不足しています。"] = "卡牌详情数据不完整。", ["検索結果と詳細のカード番号が一致しません。"] = "检索结果与详情中的卡号不一致。",
    ["未対応のカード種類です："] = "不支持的卡牌类型：", ["カード画像パスが不正です。"] = "卡牌图片路径无效。",
    ["該当するカード番号がありません："] = "找不到对应卡号：",
    ["インポート用の空きスペースがありません。中央のカードを移動してから再実行してください。"] = "没有足够的导入空间，请先移开中央卡牌再重试。",
    ["メインデッキ"] = "主牌组", ["エネルギーデッキ"] = "能量牌组", ["インポート "] = "导入 ", [" 枚"] = " 张",
    ["カードのメタデータが不足しています。"] = "卡牌元数据不完整。", ["カードの個体番号が重複、または予定外です："] = "卡牌实例编号重复或不在生成计划内：",
    ["生成したカードがリストと一致しません。"] = "生成的卡牌与列表不一致。", ["カード GUID がありません。"] = "卡牌缺少 GUID。",
    ["カード GUID が重複しています。"] = "卡牌 GUID 重复。", ["牌組の枚数が一致しません：予定 "] = "牌组张数不一致：预期 ", [" / 実際 "] = " / 实际 ",
    ["生成枚数が一致しません：予定 "] = "生成张数不一致：预期 ", ["予定したカードがありません："] = "缺少计划生成的卡牌：",
    ["画像と生成枚数を確認しています："] = "正在检查图片和生成张数：", ["生成結果の確認に失敗："] = "生成结果检查失败：",
    ["。生成物を確認してください。"] = "。请检查已生成的物体。", ["インポート完了：メイン "] = "导入完成：主牌组 ", [" / エネルギー "] = " / 能量 ",
    [" / 合計 "] = " / 合计 ", [" 枚 / ポイント "] = " 张 / 积分 ", [" 版）。"] = " 版）。",
    ["牌組は生成済みです。画像読み込みが未完了のため枚数の最終確認を中止しました。"] = "牌组已生成；图片尚未载入完成，未完成最终张数检查。",
    ["生成途中で停止："] = "生成中途停止：", ["牌組の生成がタイムアウトしました。生成済みの物体は保持されています。"] = "牌组生成超时，已生成的物体予以保留。",
    ["カードを生成しています："] = "正在生成卡牌：", ["確認中 "] = "检查中 ", ["。カードは生成していません。"] = "。未生成卡牌。",
    ["言語を選択"] = "选择语言", ["全員に適用・保存時に記録"] = "对全房生效，随存档保存",
    ["日本語原文・未翻訳"] = "日文原文·未翻译",
    ["言語"] = "语言", ["能力："] = "能力：", ["能力（%s）："] = "能力（%s）：",
    ["ターン%s回"] = "每回合%s次", ["%s は %s の対象外です。"] = "%s 不支持 %s。"
}

local EN_TEXT = {
    ["デッキ導入"] = "Import deck", ["LoveCa デッキ導入"] = "LoveCa Deck Import",
    ["盤面計算"] = "Field totals", ["LoveCa 盤面計算"] = "LoveCa Field Totals",
    ["数値マーカー"] = "Value markers", ["先攻・後攻を決定"] = "Decide turn order",
    ["閉じる"] = "Close", ["更新"] = "Refresh", ["詳細"] = "Details",
    ["カード番号 枚数（1行1種類）"] = "Card number Quantity (one type per line)",
    ["準備完了（読込時には自動生成しません）"] = "Ready (loading a save never creates cards automatically)",
    ["読込中…"] = "Loading...", ["初期値"] = "Value", ["配置先"] = "Target area",
    ["マーカー作成"] = "Create marker", ["必要なマーカーだけ作成できます。"] = "Choose a resource, value and area, then create a marker.",
    ["図柄を移動、外側の数値：左 +1 ／ 右 −1\n補正欄に置くと盤面計算に反映（保管は無効）\n交代時は保管へ戻し、新しい対象の欄に置き直す"] = "Drag icon; outer value: left +1 / right -1\nModifiers count in their slots, not in storage\nTo retarget: store first, then move to the new slot",
    ["メンバー 左"] = "Member left", ["メンバー 中"] = "Member center", ["メンバー 右"] = "Member right",
    ["Live 左"] = "Live left", ["Live 中"] = "Live center", ["Live 右"] = "Live right",
    ["保管（無効）"] = "Storage (off)", ["Live 合計 S"] = "Live total S", ["エール補正"] = "Cheer modifiers",
    ["Live 合計"] = "Live total", ["保管"] = "Storage", ["エール"] = "Cheer",
    ["非公開カード 処理エリア"] = "Private card resolution area",
    ["非公開カードを確認・選択\n処理後は効果で指定された場所へ"] = "View and choose cards privately\nThen move them as the effect instructs",
    ["メンバー"] = "Member", ["ライブ"] = "Live", ["エネルギー"] = "Energy",
    ["White"] = "White", ["Brown"] = "Brown", ["Red"] = "Red", ["Orange"] = "Orange",
    ["Yellow"] = "Yellow", ["Green"] = "Green", ["Teal"] = "Teal", ["Blue"] = "Blue",
    ["Purple"] = "Purple", ["Pink"] = "Pink", ["Black"] = "GM", ["Grey"] = "Spectator",
    ["桃"] = "Pink", ["赤"] = "Red", ["黄"] = "Yellow", ["緑"] = "Green", ["青"] = "Blue", ["紫"] = "Purple",
    ["左"] = "Left", ["中"] = "Center", ["右"] = "Right", [" 人"] = " members",
    ["桃ハート"] = "Pink Heart", ["赤ハート"] = "Red Heart", ["黄ハート"] = "Yellow Heart",
    ["緑ハート"] = "Green Heart", ["青ハート"] = "Blue Heart", ["紫ハート"] = "Purple Heart",
    ["無色／無指定ハート"] = "Colorless / unspecified Heart", ["ALLハート"] = "ALL Heart",
    ["桃♥"] = "Pink ♥", ["赤♥"] = "Red ♥", ["黄♥"] = "Yellow ♥", ["緑♥"] = "Green ♥",
    ["青♥"] = "Blue ♥", ["紫♥"] = "Purple ♥", ["無♥"] = "N ♥",
    ["ブレード"] = "Blade", ["スコア"] = "Score", ["ハート"] = "Heart",
    ["無指定ハート"] = "Unspecified Heart", ["なし"] = "None",
    ["【常時】"] = "[Continuous]", ["【登場】"] = "[On play]", ["【起動】"] = "[Activate]", ["【自動】"] = "[Auto]",
    ["【ライブ開始時】"] = "[Live start]", ["【ライブ成功時】"] = "[Live success]",
    ["【センター】"] = "[Center]", ["【左サイド】"] = "[Left side]", ["【右サイド】"] = "[Right side]",
    ["無指定×"] = "Unspecified x", ["無色×"] = "Colorless x",
    ["種類："] = "Type: ", ["コスト："] = "Cost: ", ["ハート："] = "Hearts: ", ["ブレード："] = "Blade: ",
    ["スコア："] = "Score: ", ["必要ハート："] = "Required Hearts: ",
    ["コスト：—"] = "Cost: -", ["ハート：—"] = "Hearts: -", ["ブレード：—"] = "Blade: -",
    ["ブレードハート："] = "Blade Hearts: ", ["エール加点："] = "Cheer bonus: ", ["エールドロー："] = "Cheer draws: ",
    ["ラブカポイント："] = "LoveCa points: ", ["作品："] = "Series: ", ["ユニット："] = "Unit: ", ["収録商品："] = "Product: ",
    ["カード番号とレアリティが一致しません："] = "Card number and rarity do not match: ",
    ["未配置"] = "Unassigned", ["（種類が対象外）"] = " (resource not allowed)", ["移動中"] = "Moving",
    ["領域が重複（補正無効）"] = "Overlapping areas (modifier ignored)", ["（データ要確認）"] = " (check data)",
    ["\n図柄をドラッグして移動\n外側の数値：左クリック +1 ／ 右クリック −1\n右クリックメニュー：直接入力・符号反転・0・削除\n補正欄で盤面計算に反映（保管は無効）\n交代時は保管へ戻してから置き直す"] = "\nDrag the icon to move\nOuter value: left-click +1 / right-click -1\nRight-click menu: enter value, invert, reset, delete\nOnly applicable slots count; storage has no effect\nTo retarget, move to storage before placing again",
    ["\n左 +1 ／ 右 −1"] = "\nLeft +1 / Right -1",
    ["符号付き整数を入力してください。"] = "Enter a signed integer.",
    ["符号付き整数を入力してください。例：+2、-1"] = "Enter a signed integer, e.g. +2 or -1.",
    ["数値を入力"] = "Enter value", ["（符号付き整数）"] = " (signed integer)",
    ["符号を反転"] = "Invert sign", ["0 に戻す"] = "Reset to zero", ["マーカーを削除"] = "Delete marker",
    ["種類・配置先・プレイヤーを確認してください。"] = "Check the resource, target area and player.",
    [" は "] = " does not support ", [" の対象外です。"] = ".",
    ["プレイマットがありません。"] = "Playmat not found.",
    ["配置先が埋まっています。マーカーやカードを移動してください。"] = "Target area is full. Move markers or cards first.",
    ["作成できませんでした："] = "Could not create marker: ",
    ["数値データが不正です"] = "Invalid numeric data", ["ハートデータがありません"] = "Missing Heart data",
    ["未判定\n集計中"] = "Pending\nCounting", ["未判定\n"] = "Pending\n",
    ["補正後の数値が整数範囲外"] = "Adjusted value exceeds the integer range",
    ["補正対象の公開カードを確認："] = "Check the face-up modifier target: ",
    ["補正対象が交代：保管へ戻して置き直す（"] = "Target changed: store and place again (",
    ["マーカー移動中"] = "Marker moving", ["マーカーの領域が重複"] = "Marker areas overlap",
    ["領域とマーカー種類が不一致"] = "Marker resource does not match area", ["マーカーデータが不正"] = "Invalid marker data",
    ["マーカー個体番号が重複"] = "Duplicate marker instance", ["マーカーを確認"] = "Check marker",
    ["補正の合計が整数範囲外："] = "Modifier total exceeds the integer range: ", ["他プレイヤーのカード："] = "Another player's card: ",
    ["ライブ不可\n効果による禁止を手動指定"] = "Live blocked\nBlocking effect set manually",
    ["未公開カードがあります"] = "Some cards are not revealed", ["カード数値・配置を確認"] = "Check card values and placement",
    ["Liveカードを置いてください"] = "Place a Live card", ["負の必要ハートを確認"] = "Check negative Heart requirements",
    ["ハート合計が整数範囲外"] = "Heart total exceeds the integer range", ["負の所有ハートを確認"] = "Check negative available Hearts",
    ["ライブ成功（現在値）\nハート "] = "Live successful (current values)\nHearts ", [" / 必要 "] = " / Required ",
    ["ライブ失敗\n色不足 "] = "Live failed\nColor shortfall ", [" / 総数不足 "] = " / Total shortfall ",
    [" ［要確認］"] = " [Check]", ["ステージ  "] = "Stage  ",
    ["\nブレード "] = "\nBlade ", ["　Active "] = "  Active ", [" / Wait "] = " / Wait ",
    ["ライブ  公開 "] = "Live  Revealed ", [" / 裏 "] = " / Hidden ",
    ["\n無指定 "] = "\nUnspecified ", ["　スコア "] = "  Score ", ["エール  公開 "] = "Cheer  Revealed ",
    ["\n無色 "] = "\nColorless ", ["　加点 "] = "  Bonus ", ["　ドロー "] = "  Draw ",
    ["\nActive "] = "\nActive ", ["　Wait "] = "  Wait ", ["　合計 "] = "  Total ", ["　不明 "] = "  Unknown ",
    ["ほか "] = "Plus ", [" 件（詳細ボタン）"] = " more (see Details)",
    ["配置を自動更新中　補正 "] = "Auto-updating | Modifiers ", [" 件"] = "",
    ["プレイマットがありません："] = "Playmat not found: ", ["カード移動中"] = "Card moving",
    ["この領域は単独カードで配置："] = "Place individual cards in this area: ", ["牌庫をエールに置かないでください："] = "Do not place a deck in the cheer area: ",
    ["個体番号が重複："] = "Duplicate card instance: ", ["カードデータを確認："] = "Check card data: ",
    ["領域とカード種類が不一致："] = "Card type does not match area: ", ["メンバーの重なりを確認"] = ": check overlapping members",
    ["メンバー数値を確認："] = "Check member values: ", ["メンバーの向きが不明"] = ": unclear member orientation",
    ["Live は 1 枚ずつ配置"] = ": place Lives individually", ["Live 数値を確認："] = "Check Live values: ",
    ["エール種類"] = "Cheer card type", ["特殊ハート"] = "Special Hearts", ["エール数値を確認："] = "Check cheer values: ",
    ["エネルギーの向きが不明："] = "Unclear energy orientation: ", ["集計エラー（詳細はログ）"] = "Calculation error (see log)",
    ["未判定\n集計エラー（詳細はログ）"] = "Pending\nCalculation error (see log)",
    ["\n色別不足（ALL充当前） "] = "\nColor deficits before ALL: ", ["\nALL充当 "] = "\nALL used ", [" / 所有 "] = " / Available ",
    ["抽選待ち\nプレイヤーが未着席"] = "Waiting for draw\nNo players seated",
    ["GM・観戦者以外のプレイヤーが着席してから抽選してください。"] = "Seat a player before drawing. GM and spectators are excluded.",
    ["[%sプレイヤー]が\n先攻・後攻を決定"] = "[%s player]\ndecides turn order",
    ["Live不可（効果・手動）"] = "Block Live (effect/manual)",
    ["禁止効果は手動で反映してください。ハート判定は現在の入力値で自動更新します。"] = "Set blocking effects manually. Heart conditions update from current values.",
    ["GM・観戦者を除き、着席者から先攻／後攻を選ぶ人をランダム抽選"] = "Randomly select who chooses first or second, excluding GM and spectators",
    ["行 "] = "Line ", ["：カード番号と 1～"] = ": enter a card number and a quantity from 1 to ", [" の枚数を入力してください。"] = ".",
    ["：カード番号の形式が正しくありません。"] = ": invalid card-number format.",
    ["一度のインポートは "] = "Each import is limited to ", [" 枚までです。"] = " cards.", [" 種類までです。"] = " types.",
    ["カードリストが空です。"] = "The card list is empty.", ["通信エラー（HTTP "] = "Network error (HTTP ",
    ["カード API が JSON を返しませんでした（"] = "Card API did not return JSON (",
    ["カード API が有効な JSON を返しませんでした / URL: "] = "Card API returned invalid JSON / URL: ",
    ["カード API の文字コードを変換できませんでした / URL: "] = "Could not decode card API text / URL: ",
    ["カード API の応答がタイムアウトしました / URL: "] = "Card API request timed out / URL: ",
    ["技能アイコンに画像パスがありません。"] = "An ability icon has no image path.", ["数値フィールドが不正です："] = "Invalid numeric field: ",
    ["カードの詳細データが不足しています。"] = "Card detail data is incomplete.", ["検索結果と詳細のカード番号が一致しません。"] = "Search and detail card numbers do not match.",
    ["未対応のカード種類です："] = "Unsupported card type: ", ["カード画像パスが不正です。"] = "Invalid card image path.",
    ["該当するカード番号がありません："] = "Card number not found: ",
    ["インポート用の空きスペースがありません。中央のカードを移動してから再実行してください。"] = "No room to import. Move cards away from the center and retry.",
    ["メインデッキ"] = "Main deck", ["エネルギーデッキ"] = "Energy deck", ["インポート "] = "Import ", [" 枚"] = " cards",
    ["カードのメタデータが不足しています。"] = "Card metadata is incomplete.", ["カードの個体番号が重複、または予定外です："] = "Duplicate or unexpected card instance: ",
    ["生成したカードがリストと一致しません。"] = "Generated cards do not match the list.", ["カード GUID がありません。"] = "A card has no GUID.",
    ["カード GUID が重複しています。"] = "Duplicate card GUID.", ["牌組の枚数が一致しません：予定 "] = "Deck count mismatch: expected ", [" / 実際 "] = " / Actual ",
    ["生成枚数が一致しません：予定 "] = "Generated count mismatch: expected ", ["予定したカードがありません："] = "An expected card is missing: ",
    ["画像と生成枚数を確認しています："] = "Checking images and card count: ", ["生成結果の確認に失敗："] = "Generation check failed: ",
    ["。生成物を確認してください。"] = ". Check the generated objects.", ["インポート完了：メイン "] = "Import complete: Main ", [" / エネルギー "] = " / Energy ",
    [" / 合計 "] = " / Total ", [" 枚 / ポイント "] = " cards / Points ", [" 版）。"] = " snapshot).",
    ["牌組は生成済みです。画像読み込みが未完了のため枚数の最終確認を中止しました。"] = "Decks created. Final count verification stopped because images have not finished loading.",
    ["生成途中で停止："] = "Generation stopped: ", ["牌組の生成がタイムアウトしました。生成済みの物体は保持されています。"] = "Deck generation timed out. Objects already created have been kept.",
    ["カードを生成しています："] = "Creating cards: ", ["確認中 "] = "Checking ", ["。カードは生成していません。"] = ". No cards were created.",
    ["言語を選択"] = "Choose language", ["全員に適用・保存時に記録"] = "Applies to everyone; stored when saving",
    ["日本語原文・未翻訳"] = "Japanese original; untranslated", ["言語"] = "Language",
    ["能力："] = "Ability:", ["能力（%s）："] = "Ability (%s):", ["ターン%s回"] = "%s/turn",
    ["%s は %s の対象外です。"] = "%s does not support %s."
}

local function isLovecaLanguage(language)
    return language == "zh" or language == "ja" or language == "en"
end

local function tr(text)
    local translations = LANGUAGE == "zh" and ZH_TEXT or LANGUAGE == "en" and EN_TEXT
    if translations and translations[text] ~= nil then return translations[text] end
    return text
end

-- These arguments are display values; never use their result as a seat identifier.
local function colorName(color)
    return tr(color)
end

-- Shared by Global and standalone markers. Visuals reuse the existing table's
-- circular Custom_Tile assets, inspected on 2026-10-19; originals stay untouched.
local MARKER_RESOURCES = {
    {key = "heart01", name = "桃ハート", short = "桃♥", body = {1, .80, .89}, ink = {.58, .06, .28}},
    {key = "heart02", name = "赤ハート", short = "赤♥", body = {1, .79, .76}, ink = {.64, .08, .04}},
    {key = "heart03", name = "黄ハート", short = "黄♥", body = {1, .94, .60}, ink = {.46, .30, .02}},
    {key = "heart04", name = "緑ハート", short = "緑♥", body = {.72, .94, .76}, ink = {.05, .38, .17}},
    {key = "heart05", name = "青ハート", short = "青♥", body = {.69, .88, 1}, ink = {.03, .30, .53}},
    {key = "heart06", name = "紫ハート", short = "紫♥", body = {.87, .77, .98}, ink = {.38, .12, .58}},
    {key = "heart0", name = "無色／無指定ハート", short = "無♥", body = {.91, .92, .94}, ink = {.25, .28, .35}},
    {key = "all", name = "ALLハート", short = "ALL♥", body = {1, .86, .96}, ink = {.56, .08, .44}},
    {key = "blade", name = "ブレード", short = "B", body = {.72, .88, .97}, ink = {.08, .28, .43}},
    {key = "score", name = "スコア", short = "S", body = {1, .88, .61}, ink = {.48, .28, .03}}
}

local MARKER_ASSET_ROOT = "https://steamusercontent-a.akamaihd.net/ugc/"
local MARKER_IMAGES = {
    heart01 = "27692883760551143/E6A0F26BAF08D054F679C42E719E2806064F4580/", -- 58e089
    heart02 = "27692883760545449/77F8B562BDCA71A9D563D68D99349150540DAEB9/", -- 137858
    heart03 = "27692883760543848/92C3F93CDF07665F12B7504978CB0378786C6071/", -- 013095
    heart04 = "27692883760549385/583C7E129E1367A7408EBCBD5A2AB0D7169600E7/", -- 96cdf3
    heart05 = "27692883760550184/4617E265C3A3C3EB78C40C82DE5D71BA8312685B/", -- 12afee
    heart06 = "27692883760529876/48C4B9F40E745EFCCA632482D44A779A5740389B/", -- 384cf6
    heart0 = "27692883760548302/4E38F6364D80FAD6F443A8FED31D570F38BDCE39/", -- c8c282
    all = "27692883760546326/83CA850BB9C6F6CDA4C93819341EB34361B065EB/", -- 186e6c
    blade = "27692883750484188/98D46E0E83471E6586F631087D917FA000CF7A58/", -- ef63ee
    score = "27692883750489229/04A3283304E3ABC61BE754B199575B36063A2E36/" -- 266a7a
}
for _, definition in ipairs(MARKER_RESOURCES) do
    definition.image = MARKER_ASSET_ROOT .. MARKER_IMAGES[definition.key]
end

local function markerDefinition(key)
    for _, definition in ipairs(MARKER_RESOURCES) do
        if definition.key == key then return definition end
    end
end

-- Standalone object script, bundled with marker_resources.lua by the build tool.
-- Memo is the current source of truth. All persistent keys/values are ASCII.
local marker, definition
local placementText = {member = "メンバー", live = "Live", score = "Live 合計", cheer = "エール", storage = "保管"}
local slotText = {"左", "中", "右"}

local function signed(value)
    return string.format("%+d", value)
end

local function integer(value)
    if type(value) == "string" and not string.match(value, "^[%+%-]?%d+$") then return nil end
    value = tonumber(value)
    if not value or value ~= value or value == math.huge or value == -math.huge
        or value ~= math.floor(value) or math.abs(value) > 9007199254740991 then return nil end
    return value
end

local function describe()
    local p = marker.placement or {}
    local scope = tr(placementText[p.scope] or "未配置")
    if p.slot then scope = scope .. " " .. tr(slotText[p.slot] or "?") end
    if p.color then scope = colorName(p.color) .. " / " .. scope end
    if p.code == "wrong_resource" then scope = scope .. tr("（種類が対象外）") end
    if p.code == "moving" then scope = tr("移動中") end
    if p.code == "ambiguous" then scope = tr("領域が重複（補正無効）") end
    if p.code == "invalid_data" or p.code == "duplicate" then scope = scope .. tr("（データ要確認）") end
    self.setName(tr(definition.name) .. " " .. signed(marker.value))
    self.setDescription(scope .. tr("\n図柄をドラッグして移動\n外側の数値：左クリック +1 ／ 右クリック −1\n右クリックメニュー：直接入力・符号反転・0・削除\n補正欄で盤面計算に反映（保管は無効）\n交代時は保管へ戻してから置き直す"))
end

local function persist()
    self.memo = JSON.encode(marker)
    describe()
end

local function render()
    local value = signed(marker.value)
    local font = math.min(140, math.floor(440 / math.max(3, #value)))
    self.setColorTint({1, 1, 1}) -- Keep the supplied art's original colors.
    local button = {label = value,
        font_size = font, font_color = {.08, .10, .15},
        tooltip = tr(definition.name) .. " " .. value .. tr("\n左 +1 ／ 右 −1")}
    if #(self.getButtons() or {}) == 0 then
        button.click_function = "adjustMarker"
        button.function_owner = self
        -- Keep the whole art/collider available for native dragging. Only the
        -- detached value badge handles clicks; nothing overlays the icon.
        button.position = {0, .36, 1.65}
        button.rotation = {0, 0, 0}
        -- TTS scales the button canvas again on small custom tiles.
        -- Compensate so the signed value stays legible without enlarging art.
        local canvasScale = 1 / self.getScale().x
        button.scale = {canvasScale, canvasScale, canvasScale}
        button.width, button.height = 340, 150
        button.color = {1, 1, 1, .97}
        button.hover_color = {1, .94, .76, 1}
        button.press_color = {1, .86, .54, 1}
        self.createButton(button)
    else
        button.index = 0
        self.editButton(button)
    end
    persist()
end

function setMarkerValue(args)
    if not marker then return false end
    local value = integer(args.value)
    if value == nil then
        if args.player then printToColor(tr("符号付き整数を入力してください。"), args.player, {1, .65, .4}) end
        return false
    end
    marker.value = value
    render()
    return true
end

function adjustMarker(object, player_color, alt_click)
    if marker then setMarkerValue({value = marker.value + (alt_click and -1 or 1), player = player_color}) end
end

function getMarkerState()
    return marker and JSON.decode(self.memo) or nil
end

function setMarkerPlacement(info)
    if not marker then return end
    local previous = marker.placement or {}
    if previous.color == info.color and previous.scope == info.scope and previous.slot == info.slot
        and previous.code == info.code then return end
    marker.placement = {color = info.color, scope = info.scope, slot = info.slot, code = info.code}
    persist()
end

function onSave()
    return marker and JSON.encode(marker) or ""
end

local function rebuildMarkerMenu()
    self.clearContextMenu()
    self.addContextMenuItem(tr("数値を入力"), function(color)
        Player[color].showInputDialog(tr(definition.name) .. tr("（符号付き整数）"), signed(marker.value), function(text)
            if not self.isDestroyed() then setMarkerValue({value = text, player = color}) end
        end)
    end)
    self.addContextMenuItem(tr("符号を反転"), function() setMarkerValue({value = -marker.value}) end)
    self.addContextMenuItem(tr("0 に戻す"), function() setMarkerValue({value = 0}) end)
    self.addContextMenuItem(tr("マーカーを削除"), function() self.destruct() end)
end

function setMarkerLanguage(args)
    if not marker or not args or not isLovecaLanguage(args.language) then return end
    LANGUAGE = args.language
    rebuildMarkerMenu()
    render()
end

function onLoad(saved_data)
    local ok, data = pcall(JSON.decode, self.memo ~= "" and self.memo or saved_data or "")
    if not ok or type(data) ~= "table" or data.schema ~= "loveca.marker" or data.schema_version ~= 1 then return end
    definition = markerDefinition(data.resource)
    if not definition or integer(data.value) == nil then return end
    marker = data
    marker.instance_id = "loveca.marker." .. self.getGUID() -- Clones are separate adjustable markers.
    self.sticky, self.use_grid, self.use_snap_points, self.use_hands = false, false, false, false
    self.clearButtons()
    LANGUAGE = Global.getVar("LovecaLanguage") or LANGUAGE
    rebuildMarkerMenu()
    render()
end
]=]

-- Presentation only. Japanese source keys never replace metadata or ability prose.
-- Bundled into Global and standalone marker scripts by build_importer.py.
local LANGUAGE = "zh"
local ZH_TEXT = {
    ["デッキ導入"] = "导入牌组", ["LoveCa デッキ導入"] = "LoveCa 牌组导入",
    ["盤面計算"] = "场面计算", ["LoveCa 盤面計算"] = "LoveCa 场面计算",
    ["数値マーカー"] = "数值标记", ["先攻・後攻を決定"] = "决定先后手",
    ["閉じる"] = "关闭", ["更新"] = "刷新", ["詳細"] = "详情",
    ["カード番号 枚数（1行1種類）"] = "卡号 张数（每行一种）",
    ["準備完了（読込時には自動生成しません）"] = "准备就绪（载入存档时不会自动生成卡牌）",
    ["読込中…"] = "读取中…", ["初期値"] = "初始值", ["配置先"] = "放置区域",
    ["マーカー作成"] = "创建标记", ["必要なマーカーだけ作成できます。"] = "按需选择类型、数值和区域，再创建标记。",
    ["図柄を移動、外側の数値：左 +1 ／ 右 −1\n補正欄に置くと盤面計算に反映（保管は無効）\n交代時は保管へ戻し、新しい対象の欄に置き直す"] = "拖动图案移动；外侧数字：左键 +1／右键 −1\n放入补正栏后计入场面计算（保管区不生效）\n更换对象时先放回保管区，再放入新对象的栏位",
    ["メンバー 左"] = "成员 左", ["メンバー 中"] = "成员 中", ["メンバー 右"] = "成员 右",
    ["保管（無効）"] = "保管（不生效）", ["Live 合計 S"] = "Live 总分 S", ["エール補正"] = "应援补正",
    ["Live 合計"] = "Live 合计", ["保管"] = "保管", ["エール"] = "应援",
    ["非公開カード 処理エリア"] = "不公开卡牌 处理区",
    ["非公開カードを確認・選択\n処理後は効果で指定された場所へ"] = "查看、挑选不公开的卡牌\n处理后移至效果指定区域",
    ["メンバー"] = "成员", ["ライブ"] = "Live", ["エネルギー"] = "能量",
    ["White"] = "白色", ["Brown"] = "棕色", ["Red"] = "红色", ["Orange"] = "橙色",
    ["Yellow"] = "黄色", ["Green"] = "绿色", ["Teal"] = "青绿色", ["Blue"] = "蓝色",
    ["Purple"] = "紫色", ["Pink"] = "粉色", ["Black"] = "主持人", ["Grey"] = "旁观者",
    ["桃"] = "粉", ["赤"] = "红", ["緑"] = "绿", ["青"] = "蓝",
    ["桃ハート"] = "粉色爱心", ["赤ハート"] = "红色爱心", ["黄ハート"] = "黄色爱心",
    ["緑ハート"] = "绿色爱心", ["青ハート"] = "蓝色爱心", ["紫ハート"] = "紫色爱心",
    ["無色／無指定ハート"] = "无色／无指定爱心", ["ALLハート"] = "ALL 爱心",
    ["桃♥"] = "粉♥", ["赤♥"] = "红♥", ["緑♥"] = "绿♥", ["青♥"] = "蓝♥", ["無♥"] = "无♥",
    ["ブレード"] = "光刃", ["スコア"] = "分数", ["ハート"] = "爱心",
    ["無指定ハート"] = "无指定爱心", ["なし"] = "无",
    ["【常時】"] = "【常驻】", ["【登場】"] = "【登场】", ["【起動】"] = "【起动】", ["【自動】"] = "【自动】",
    ["【ライブ開始時】"] = "【Live 开始时】", ["【ライブ成功時】"] = "【Live 成功时】",
    ["【センター】"] = "【中央】", ["【左サイド】"] = "【左侧】", ["【右サイド】"] = "【右侧】",
    ["無指定×"] = "无指定×", ["無色×"] = "无色×",
    ["種類："] = "类型：", ["コスト："] = "费用：", ["ハート："] = "爱心：", ["ブレード："] = "光刃：",
    ["スコア："] = "分数：", ["必要ハート："] = "所需爱心：",
    ["コスト：—"] = "费用：—", ["ハート：—"] = "爱心：—", ["ブレード：—"] = "光刃：—",
    ["ブレードハート："] = "应援爱心：", ["エール加点："] = "应援加分：", ["エールドロー："] = "应援抽牌：",
    ["ラブカポイント："] = "LoveCa 积分：", ["作品："] = "作品：", ["ユニット："] = "组合：", ["収録商品："] = "收录商品：",
    ["カード番号とレアリティが一致しません："] = "卡号与稀有度不一致：",
    ["未配置"] = "未放置", ["（種類が対象外）"] = "（此类型不适用）", ["移動中"] = "移动中",
    ["領域が重複（補正無効）"] = "区域重叠（补正不生效）", ["（データ要確認）"] = "（请检查数据）",
    ["\n図柄をドラッグして移動\n外側の数値：左クリック +1 ／ 右クリック −1\n右クリックメニュー：直接入力・符号反転・0・削除\n補正欄で盤面計算に反映（保管は無効）\n交代時は保管へ戻してから置き直す"] = "\n拖动图案移动\n外侧数字：左键 +1／右键 −1\n右键菜单：直接输入、反号、归零、删除\n放入补正栏后计入场面计算（保管区不生效）\n更换对象时先放回保管区，再重新放置",
    ["\n左 +1 ／ 右 −1"] = "\n左键 +1／右键 −1",
    ["符号付き整数を入力してください。"] = "请输入带正负号的整数。",
    ["符号付き整数を入力してください。例：+2、-1"] = "请输入带正负号的整数，例如 +2、-1。",
    ["数値を入力"] = "输入数值", ["（符号付き整数）"] = "（带正负号的整数）",
    ["符号を反転"] = "正负反转", ["0 に戻す"] = "归零", ["マーカーを削除"] = "删除标记",
    ["種類・配置先・プレイヤーを確認してください。"] = "请检查标记类型、放置区域和玩家。",
    [" は "] = " 不适用于 ", [" の対象外です。"] = "。",
    ["プレイマットがありません。"] = "找不到桌垫。",
    ["配置先が埋まっています。マーカーやカードを移動してください。"] = "放置区域已满，请先移开标记或卡牌。",
    ["作成できませんでした："] = "创建失败：",
    ["数値データが不正です"] = "数值数据无效", ["ハートデータがありません"] = "缺少爱心数据",
    ["未判定\n集計中"] = "未判定\n统计中", ["未判定\n"] = "未判定\n",
    ["補正後の数値が整数範囲外"] = "补正后的数值超出整数范围",
    ["補正対象の公開カードを確認："] = "请检查补正对象是否为公开卡牌：",
    ["補正対象が交代：保管へ戻して置き直す（"] = "补正对象已更换：请先放回保管区再重新放置（",
    ["マーカー移動中"] = "标记移动中", ["マーカーの領域が重複"] = "标记区域重叠",
    ["領域とマーカー種類が不一致"] = "标记类型与区域不匹配", ["マーカーデータが不正"] = "标记数据无效",
    ["マーカー個体番号が重複"] = "标记实例编号重复", ["マーカーを確認"] = "请检查标记",
    ["補正の合計が整数範囲外："] = "补正合计超出整数范围：", ["他プレイヤーのカード："] = "其他玩家的卡牌：",
    ["ライブ不可\n効果による禁止を手動指定"] = "无法进行 Live\n已手动指定禁止效果",
    ["未公開カードがあります"] = "存在未公开卡牌", ["カード数値・配置を確認"] = "请检查卡牌数值及摆放",
    ["Liveカードを置いてください"] = "请放置 Live 卡", ["負の必要ハートを確認"] = "请确认负数的所需爱心",
    ["ハート合計が整数範囲外"] = "爱心合计超出整数范围", ["負の所有ハートを確認"] = "请确认负数的持有爱心",
    ["ライブ成功（現在値）\nハート "] = "Live 成功（当前数值）\n爱心 ", [" / 必要 "] = " / 所需 ",
    ["ライブ失敗\n色不足 "] = "Live 失败\n颜色不足 ", [" / 総数不足 "] = " / 总数不足 ",
    [" ［要確認］"] = " ［待确认］", ["ステージ  "] = "舞台  ",
    ["\nブレード "] = "\n光刃 ", ["　Active "] = "　就绪 ", [" / Wait "] = " / 休息 ",
    ["ライブ  公開 "] = "Live  公开 ", [" / 裏 "] = " / 盖放 ",
    ["\n無指定 "] = "\n无指定 ", ["　スコア "] = "　分数 ", ["エール  公開 "] = "应援  公开 ",
    ["\n無色 "] = "\n无色 ", ["　加点 "] = "　加分 ", ["　ドロー "] = "　抽牌 ",
    ["\nActive "] = "\n就绪 ", ["　Wait "] = "　休息 ", ["　合計 "] = "　合计 ", ["　不明 "] = "　未知 ",
    ["ほか "] = "另有 ", [" 件（詳細ボタン）"] = " 项（查看详情）",
    ["配置を自動更新中　補正 "] = "摆放自动更新中　补正 ", [" 件"] = " 项",
    ["プレイマットがありません："] = "找不到桌垫：", ["カード移動中"] = "卡牌移动中",
    ["この領域は単独カードで配置："] = "此区域请逐张放置卡牌：", ["牌庫をエールに置かないでください："] = "请勿将牌库放入应援区：",
    ["個体番号が重複："] = "实例编号重复：", ["カードデータを確認："] = "请检查卡牌数据：",
    ["領域とカード種類が不一致："] = "卡牌类型与区域不匹配：", ["メンバーの重なりを確認"] = "：请检查成员堆叠",
    ["メンバー数値を確認："] = "请检查成员数值：", ["メンバーの向きが不明"] = "：成员朝向不明确",
    ["Live は 1 枚ずつ配置"] = "：Live 请逐张放置", ["Live 数値を確認："] = "请检查 Live 数值：",
    ["エール種類"] = "应援类型", ["特殊ハート"] = "特殊爱心", ["エール数値を確認："] = "请检查应援数值：",
    ["エネルギーの向きが不明："] = "能量朝向不明确：", ["集計エラー（詳細はログ）"] = "统计出错（详情见日志）",
    ["未判定\n集計エラー（詳細はログ）"] = "未判定\n统计出错（详情见日志）",
    ["\n色別不足（ALL充当前） "] = "\n各色缺口（使用 ALL 前） ", ["\nALL充当 "] = "\n使用 ALL ", [" / 所有 "] = " / 持有 ",
    ["抽選待ち\nプレイヤーが未着席"] = "等待抽选\n尚无玩家入座",
    ["GM・観戦者以外のプレイヤーが着席してから抽選してください。"] = "请等待普通玩家入座后再抽选，主持人和旁观者不参与。",
    ["[%sプレイヤー]が\n先攻・後攻を決定"] = "由[%s玩家]\n决定先后手",
    ["Live不可（効果・手動）"] = "禁止 Live（效果·手动）",
    ["禁止効果は手動で反映してください。ハート判定は現在の入力値で自動更新します。"] = "禁止效果请手动勾选，爱心条件根据当前数值自动更新。",
    ["GM・観戦者を除き、着席者から先攻／後攻を選ぶ人をランダム抽選"] = "从已入座玩家中随机抽取先后选择权，排除主持人和旁观者",
    ["行 "] = "第 ", ["：カード番号と 1～"] = " 行：请输入卡号及 1～", [" の枚数を入力してください。"] = " 的张数。",
    ["：カード番号の形式が正しくありません。"] = " 行：卡号格式不正确。",
    ["一度のインポートは "] = "单次最多导入 ", [" 枚までです。"] = " 张。", [" 種類までです。"] = " 种。",
    ["カードリストが空です。"] = "卡牌列表为空。", ["通信エラー（HTTP "] = "网络错误（HTTP ",
    ["カード API が JSON を返しませんでした（"] = "卡牌 API 未返回 JSON（",
    ["カード API が有効な JSON を返しませんでした / URL: "] = "卡牌 API 未返回有效 JSON / URL: ",
    ["カード API の文字コードを変換できませんでした / URL: "] = "卡牌 API 字符编码转换失败 / URL: ",
    ["カード API の応答がタイムアウトしました / URL: "] = "卡牌 API 响应超时 / URL: ",
    ["技能アイコンに画像パスがありません。"] = "能力图标缺少图片路径。", ["数値フィールドが不正です："] = "数值字段无效：",
    ["カードの詳細データが不足しています。"] = "卡牌详情数据不完整。", ["検索結果と詳細のカード番号が一致しません。"] = "检索结果与详情中的卡号不一致。",
    ["未対応のカード種類です："] = "不支持的卡牌类型：", ["カード画像パスが不正です。"] = "卡牌图片路径无效。",
    ["該当するカード番号がありません："] = "找不到对应卡号：",
    ["インポート用の空きスペースがありません。中央のカードを移動してから再実行してください。"] = "没有足够的导入空间，请先移开中央卡牌再重试。",
    ["メインデッキ"] = "主牌组", ["エネルギーデッキ"] = "能量牌组", ["インポート "] = "导入 ", [" 枚"] = " 张",
    ["カードのメタデータが不足しています。"] = "卡牌元数据不完整。", ["カードの個体番号が重複、または予定外です："] = "卡牌实例编号重复或不在生成计划内：",
    ["生成したカードがリストと一致しません。"] = "生成的卡牌与列表不一致。", ["カード GUID がありません。"] = "卡牌缺少 GUID。",
    ["カード GUID が重複しています。"] = "卡牌 GUID 重复。", ["牌組の枚数が一致しません：予定 "] = "牌组张数不一致：预期 ", [" / 実際 "] = " / 实际 ",
    ["生成枚数が一致しません：予定 "] = "生成张数不一致：预期 ", ["予定したカードがありません："] = "缺少计划生成的卡牌：",
    ["画像と生成枚数を確認しています："] = "正在检查图片和生成张数：", ["生成結果の確認に失敗："] = "生成结果检查失败：",
    ["。生成物を確認してください。"] = "。请检查已生成的物体。", ["インポート完了：メイン "] = "导入完成：主牌组 ", [" / エネルギー "] = " / 能量 ",
    [" / 合計 "] = " / 合计 ", [" 枚 / ポイント "] = " 张 / 积分 ", [" 版）。"] = " 版）。",
    ["牌組は生成済みです。画像読み込みが未完了のため枚数の最終確認を中止しました。"] = "牌组已生成；图片尚未载入完成，未完成最终张数检查。",
    ["生成途中で停止："] = "生成中途停止：", ["牌組の生成がタイムアウトしました。生成済みの物体は保持されています。"] = "牌组生成超时，已生成的物体予以保留。",
    ["カードを生成しています："] = "正在生成卡牌：", ["確認中 "] = "检查中 ", ["。カードは生成していません。"] = "。未生成卡牌。",
    ["言語を選択"] = "选择语言", ["全員に適用・保存時に記録"] = "对全房生效，随存档保存",
    ["日本語原文・未翻訳"] = "日文原文·未翻译",
    ["言語"] = "语言", ["能力："] = "能力：", ["能力（%s）："] = "能力（%s）：",
    ["ターン%s回"] = "每回合%s次", ["%s は %s の対象外です。"] = "%s 不支持 %s。"
}

local EN_TEXT = {
    ["デッキ導入"] = "Import deck", ["LoveCa デッキ導入"] = "LoveCa Deck Import",
    ["盤面計算"] = "Field totals", ["LoveCa 盤面計算"] = "LoveCa Field Totals",
    ["数値マーカー"] = "Value markers", ["先攻・後攻を決定"] = "Decide turn order",
    ["閉じる"] = "Close", ["更新"] = "Refresh", ["詳細"] = "Details",
    ["カード番号 枚数（1行1種類）"] = "Card number Quantity (one type per line)",
    ["準備完了（読込時には自動生成しません）"] = "Ready (loading a save never creates cards automatically)",
    ["読込中…"] = "Loading...", ["初期値"] = "Value", ["配置先"] = "Target area",
    ["マーカー作成"] = "Create marker", ["必要なマーカーだけ作成できます。"] = "Choose a resource, value and area, then create a marker.",
    ["図柄を移動、外側の数値：左 +1 ／ 右 −1\n補正欄に置くと盤面計算に反映（保管は無効）\n交代時は保管へ戻し、新しい対象の欄に置き直す"] = "Drag icon; outer value: left +1 / right -1\nModifiers count in their slots, not in storage\nTo retarget: store first, then move to the new slot",
    ["メンバー 左"] = "Member left", ["メンバー 中"] = "Member center", ["メンバー 右"] = "Member right",
    ["Live 左"] = "Live left", ["Live 中"] = "Live center", ["Live 右"] = "Live right",
    ["保管（無効）"] = "Storage (off)", ["Live 合計 S"] = "Live total S", ["エール補正"] = "Cheer modifiers",
    ["Live 合計"] = "Live total", ["保管"] = "Storage", ["エール"] = "Cheer",
    ["非公開カード 処理エリア"] = "Private card resolution area",
    ["非公開カードを確認・選択\n処理後は効果で指定された場所へ"] = "View and choose cards privately\nThen move them as the effect instructs",
    ["メンバー"] = "Member", ["ライブ"] = "Live", ["エネルギー"] = "Energy",
    ["White"] = "White", ["Brown"] = "Brown", ["Red"] = "Red", ["Orange"] = "Orange",
    ["Yellow"] = "Yellow", ["Green"] = "Green", ["Teal"] = "Teal", ["Blue"] = "Blue",
    ["Purple"] = "Purple", ["Pink"] = "Pink", ["Black"] = "GM", ["Grey"] = "Spectator",
    ["桃"] = "Pink", ["赤"] = "Red", ["黄"] = "Yellow", ["緑"] = "Green", ["青"] = "Blue", ["紫"] = "Purple",
    ["左"] = "Left", ["中"] = "Center", ["右"] = "Right", [" 人"] = " members",
    ["桃ハート"] = "Pink Heart", ["赤ハート"] = "Red Heart", ["黄ハート"] = "Yellow Heart",
    ["緑ハート"] = "Green Heart", ["青ハート"] = "Blue Heart", ["紫ハート"] = "Purple Heart",
    ["無色／無指定ハート"] = "Colorless / unspecified Heart", ["ALLハート"] = "ALL Heart",
    ["桃♥"] = "Pink ♥", ["赤♥"] = "Red ♥", ["黄♥"] = "Yellow ♥", ["緑♥"] = "Green ♥",
    ["青♥"] = "Blue ♥", ["紫♥"] = "Purple ♥", ["無♥"] = "N ♥",
    ["ブレード"] = "Blade", ["スコア"] = "Score", ["ハート"] = "Heart",
    ["無指定ハート"] = "Unspecified Heart", ["なし"] = "None",
    ["【常時】"] = "[Continuous]", ["【登場】"] = "[On play]", ["【起動】"] = "[Activate]", ["【自動】"] = "[Auto]",
    ["【ライブ開始時】"] = "[Live start]", ["【ライブ成功時】"] = "[Live success]",
    ["【センター】"] = "[Center]", ["【左サイド】"] = "[Left side]", ["【右サイド】"] = "[Right side]",
    ["無指定×"] = "Unspecified x", ["無色×"] = "Colorless x",
    ["種類："] = "Type: ", ["コスト："] = "Cost: ", ["ハート："] = "Hearts: ", ["ブレード："] = "Blade: ",
    ["スコア："] = "Score: ", ["必要ハート："] = "Required Hearts: ",
    ["コスト：—"] = "Cost: -", ["ハート：—"] = "Hearts: -", ["ブレード：—"] = "Blade: -",
    ["ブレードハート："] = "Blade Hearts: ", ["エール加点："] = "Cheer bonus: ", ["エールドロー："] = "Cheer draws: ",
    ["ラブカポイント："] = "LoveCa points: ", ["作品："] = "Series: ", ["ユニット："] = "Unit: ", ["収録商品："] = "Product: ",
    ["カード番号とレアリティが一致しません："] = "Card number and rarity do not match: ",
    ["未配置"] = "Unassigned", ["（種類が対象外）"] = " (resource not allowed)", ["移動中"] = "Moving",
    ["領域が重複（補正無効）"] = "Overlapping areas (modifier ignored)", ["（データ要確認）"] = " (check data)",
    ["\n図柄をドラッグして移動\n外側の数値：左クリック +1 ／ 右クリック −1\n右クリックメニュー：直接入力・符号反転・0・削除\n補正欄で盤面計算に反映（保管は無効）\n交代時は保管へ戻してから置き直す"] = "\nDrag the icon to move\nOuter value: left-click +1 / right-click -1\nRight-click menu: enter value, invert, reset, delete\nOnly applicable slots count; storage has no effect\nTo retarget, move to storage before placing again",
    ["\n左 +1 ／ 右 −1"] = "\nLeft +1 / Right -1",
    ["符号付き整数を入力してください。"] = "Enter a signed integer.",
    ["符号付き整数を入力してください。例：+2、-1"] = "Enter a signed integer, e.g. +2 or -1.",
    ["数値を入力"] = "Enter value", ["（符号付き整数）"] = " (signed integer)",
    ["符号を反転"] = "Invert sign", ["0 に戻す"] = "Reset to zero", ["マーカーを削除"] = "Delete marker",
    ["種類・配置先・プレイヤーを確認してください。"] = "Check the resource, target area and player.",
    [" は "] = " does not support ", [" の対象外です。"] = ".",
    ["プレイマットがありません。"] = "Playmat not found.",
    ["配置先が埋まっています。マーカーやカードを移動してください。"] = "Target area is full. Move markers or cards first.",
    ["作成できませんでした："] = "Could not create marker: ",
    ["数値データが不正です"] = "Invalid numeric data", ["ハートデータがありません"] = "Missing Heart data",
    ["未判定\n集計中"] = "Pending\nCounting", ["未判定\n"] = "Pending\n",
    ["補正後の数値が整数範囲外"] = "Adjusted value exceeds the integer range",
    ["補正対象の公開カードを確認："] = "Check the face-up modifier target: ",
    ["補正対象が交代：保管へ戻して置き直す（"] = "Target changed: store and place again (",
    ["マーカー移動中"] = "Marker moving", ["マーカーの領域が重複"] = "Marker areas overlap",
    ["領域とマーカー種類が不一致"] = "Marker resource does not match area", ["マーカーデータが不正"] = "Invalid marker data",
    ["マーカー個体番号が重複"] = "Duplicate marker instance", ["マーカーを確認"] = "Check marker",
    ["補正の合計が整数範囲外："] = "Modifier total exceeds the integer range: ", ["他プレイヤーのカード："] = "Another player's card: ",
    ["ライブ不可\n効果による禁止を手動指定"] = "Live blocked\nBlocking effect set manually",
    ["未公開カードがあります"] = "Some cards are not revealed", ["カード数値・配置を確認"] = "Check card values and placement",
    ["Liveカードを置いてください"] = "Place a Live card", ["負の必要ハートを確認"] = "Check negative Heart requirements",
    ["ハート合計が整数範囲外"] = "Heart total exceeds the integer range", ["負の所有ハートを確認"] = "Check negative available Hearts",
    ["ライブ成功（現在値）\nハート "] = "Live successful (current values)\nHearts ", [" / 必要 "] = " / Required ",
    ["ライブ失敗\n色不足 "] = "Live failed\nColor shortfall ", [" / 総数不足 "] = " / Total shortfall ",
    [" ［要確認］"] = " [Check]", ["ステージ  "] = "Stage  ",
    ["\nブレード "] = "\nBlade ", ["　Active "] = "  Active ", [" / Wait "] = " / Wait ",
    ["ライブ  公開 "] = "Live  Revealed ", [" / 裏 "] = " / Hidden ",
    ["\n無指定 "] = "\nUnspecified ", ["　スコア "] = "  Score ", ["エール  公開 "] = "Cheer  Revealed ",
    ["\n無色 "] = "\nColorless ", ["　加点 "] = "  Bonus ", ["　ドロー "] = "  Draw ",
    ["\nActive "] = "\nActive ", ["　Wait "] = "  Wait ", ["　合計 "] = "  Total ", ["　不明 "] = "  Unknown ",
    ["ほか "] = "Plus ", [" 件（詳細ボタン）"] = " more (see Details)",
    ["配置を自動更新中　補正 "] = "Auto-updating | Modifiers ", [" 件"] = "",
    ["プレイマットがありません："] = "Playmat not found: ", ["カード移動中"] = "Card moving",
    ["この領域は単独カードで配置："] = "Place individual cards in this area: ", ["牌庫をエールに置かないでください："] = "Do not place a deck in the cheer area: ",
    ["個体番号が重複："] = "Duplicate card instance: ", ["カードデータを確認："] = "Check card data: ",
    ["領域とカード種類が不一致："] = "Card type does not match area: ", ["メンバーの重なりを確認"] = ": check overlapping members",
    ["メンバー数値を確認："] = "Check member values: ", ["メンバーの向きが不明"] = ": unclear member orientation",
    ["Live は 1 枚ずつ配置"] = ": place Lives individually", ["Live 数値を確認："] = "Check Live values: ",
    ["エール種類"] = "Cheer card type", ["特殊ハート"] = "Special Hearts", ["エール数値を確認："] = "Check cheer values: ",
    ["エネルギーの向きが不明："] = "Unclear energy orientation: ", ["集計エラー（詳細はログ）"] = "Calculation error (see log)",
    ["未判定\n集計エラー（詳細はログ）"] = "Pending\nCalculation error (see log)",
    ["\n色別不足（ALL充当前） "] = "\nColor deficits before ALL: ", ["\nALL充当 "] = "\nALL used ", [" / 所有 "] = " / Available ",
    ["抽選待ち\nプレイヤーが未着席"] = "Waiting for draw\nNo players seated",
    ["GM・観戦者以外のプレイヤーが着席してから抽選してください。"] = "Seat a player before drawing. GM and spectators are excluded.",
    ["[%sプレイヤー]が\n先攻・後攻を決定"] = "[%s player]\ndecides turn order",
    ["Live不可（効果・手動）"] = "Block Live (effect/manual)",
    ["禁止効果は手動で反映してください。ハート判定は現在の入力値で自動更新します。"] = "Set blocking effects manually. Heart conditions update from current values.",
    ["GM・観戦者を除き、着席者から先攻／後攻を選ぶ人をランダム抽選"] = "Randomly select who chooses first or second, excluding GM and spectators",
    ["行 "] = "Line ", ["：カード番号と 1～"] = ": enter a card number and a quantity from 1 to ", [" の枚数を入力してください。"] = ".",
    ["：カード番号の形式が正しくありません。"] = ": invalid card-number format.",
    ["一度のインポートは "] = "Each import is limited to ", [" 枚までです。"] = " cards.", [" 種類までです。"] = " types.",
    ["カードリストが空です。"] = "The card list is empty.", ["通信エラー（HTTP "] = "Network error (HTTP ",
    ["カード API が JSON を返しませんでした（"] = "Card API did not return JSON (",
    ["カード API が有効な JSON を返しませんでした / URL: "] = "Card API returned invalid JSON / URL: ",
    ["カード API の文字コードを変換できませんでした / URL: "] = "Could not decode card API text / URL: ",
    ["カード API の応答がタイムアウトしました / URL: "] = "Card API request timed out / URL: ",
    ["技能アイコンに画像パスがありません。"] = "An ability icon has no image path.", ["数値フィールドが不正です："] = "Invalid numeric field: ",
    ["カードの詳細データが不足しています。"] = "Card detail data is incomplete.", ["検索結果と詳細のカード番号が一致しません。"] = "Search and detail card numbers do not match.",
    ["未対応のカード種類です："] = "Unsupported card type: ", ["カード画像パスが不正です。"] = "Invalid card image path.",
    ["該当するカード番号がありません："] = "Card number not found: ",
    ["インポート用の空きスペースがありません。中央のカードを移動してから再実行してください。"] = "No room to import. Move cards away from the center and retry.",
    ["メインデッキ"] = "Main deck", ["エネルギーデッキ"] = "Energy deck", ["インポート "] = "Import ", [" 枚"] = " cards",
    ["カードのメタデータが不足しています。"] = "Card metadata is incomplete.", ["カードの個体番号が重複、または予定外です："] = "Duplicate or unexpected card instance: ",
    ["生成したカードがリストと一致しません。"] = "Generated cards do not match the list.", ["カード GUID がありません。"] = "A card has no GUID.",
    ["カード GUID が重複しています。"] = "Duplicate card GUID.", ["牌組の枚数が一致しません：予定 "] = "Deck count mismatch: expected ", [" / 実際 "] = " / Actual ",
    ["生成枚数が一致しません：予定 "] = "Generated count mismatch: expected ", ["予定したカードがありません："] = "An expected card is missing: ",
    ["画像と生成枚数を確認しています："] = "Checking images and card count: ", ["生成結果の確認に失敗："] = "Generation check failed: ",
    ["。生成物を確認してください。"] = ". Check the generated objects.", ["インポート完了：メイン "] = "Import complete: Main ", [" / エネルギー "] = " / Energy ",
    [" / 合計 "] = " / Total ", [" 枚 / ポイント "] = " cards / Points ", [" 版）。"] = " snapshot).",
    ["牌組は生成済みです。画像読み込みが未完了のため枚数の最終確認を中止しました。"] = "Decks created. Final count verification stopped because images have not finished loading.",
    ["生成途中で停止："] = "Generation stopped: ", ["牌組の生成がタイムアウトしました。生成済みの物体は保持されています。"] = "Deck generation timed out. Objects already created have been kept.",
    ["カードを生成しています："] = "Creating cards: ", ["確認中 "] = "Checking ", ["。カードは生成していません。"] = ". No cards were created.",
    ["言語を選択"] = "Choose language", ["全員に適用・保存時に記録"] = "Applies to everyone; stored when saving",
    ["日本語原文・未翻訳"] = "Japanese original; untranslated", ["言語"] = "Language",
    ["能力："] = "Ability:", ["能力（%s）："] = "Ability (%s):", ["ターン%s回"] = "%s/turn",
    ["%s は %s の対象外です。"] = "%s does not support %s."
}

local function isLovecaLanguage(language)
    return language == "zh" or language == "ja" or language == "en"
end

local function tr(text)
    local translations = LANGUAGE == "zh" and ZH_TEXT or LANGUAGE == "en" and EN_TEXT
    if translations and translations[text] ~= nil then return translations[text] end
    return text
end

-- These arguments are display values; never use their result as a seat identifier.
local function colorName(color)
    return tr(color)
end

-- Shared LoveCa card data and presentation. Bundled by tools/build_importer.py.
local BACK_URL = "https://loveca.lovelivefun.xyz/back.jpg"
local MIRROR_ROOT = "https://raw.githubusercontent.com/wlt233/llocg_db/master/"
local CARD_SCALE = {1, 1, 1} -- Use the same model multiplier for cards that will share a deck.
-- All three rendered faces are portrait PNGs on a 451 x 629 canvas.
-- Public transformation URLs are used by every player; no local asset path is required.
local RENDERED_FACES = {
    ["PL!-bp3-021-SRL"] = "https://wsrv.nl/?url=https%3A%2F%2Fraw.githubusercontent.com%2Fwlt233%2Fllocg_db%2Fmaster%2Fimg%2Fcards%2FPBLL02%2FPL%21-bp3-021-SRL.png&ro=90&output=png",
    ["PL!S-PR-034-PR＋"] = "https://wsrv.nl/?url=https%3A%2F%2Fraw.githubusercontent.com%2Fwlt233%2Fllocg_db%2Fmaster%2Fimg%2Fcards%2FPR%2FPL%21S-PR-034-PR2.png&w=451&h=629&fit=fill&output=png"
}

local HEARTS = {
    {"01", "桃"}, {"02", "赤"}, {"03", "黄"},
    {"04", "緑"}, {"05", "青"}, {"06", "紫"}
}

local function copy(value)
    if type(value) ~= "table" then return value end
    local result = {}
    for key, item in pairs(value) do result[copy(key)] = copy(item) end
    return result
end

-- TTS UI strings may use a native Unicode character; JSON/source strings may use
-- three UTF-8 bytes. MoonSharp supports string.char(0xFF0B); standard Lua may not.
local FULLWIDTH_PLUS_BYTES = string.char(239, 188, 139)
local nativePlusAvailable, FULLWIDTH_PLUS_NATIVE = pcall(string.char, 0xFF0B)

local function unicodeCharacter(code)
    if code < 0 or code > 0x10FFFF or (code >= 0xD800 and code <= 0xDFFF) then code = 0xFFFD end
    if nativePlusAvailable then
        if code <= 0xFFFF then return string.char(code) end
        -- TTS uses native UTF-16 strings; supplementary characters require a surrogate pair.
        local supplementary = code - 0x10000
        return string.char(0xD800 + math.floor(supplementary / 1024), 0xDC00 + supplementary % 1024)
    end
    -- Standard Lua uses UTF-8 bytes, so retain its usual string representation.
    if code < 128 then return string.char(code) end
    if code < 2048 then return string.char(192 + math.floor(code / 64), 128 + code % 64) end
    if code < 65536 then
        return string.char(224 + math.floor(code / 4096), 128 + math.floor(code / 64) % 64, 128 + code % 64)
    end
    return string.char(240 + math.floor(code / 262144), 128 + math.floor(code / 4096) % 64,
        128 + math.floor(code / 64) % 64, 128 + code % 64)
end

local function nativeUTF8Text(value)
    if not nativePlusAvailable then return value end
    local parts, index = {}, 1
    while index <= #value do
        local first = string.byte(value, index)
        if first < 128 then
            -- Preserve characters already supplied as native Unicode; string.byte may report '?'.
            table.insert(parts, string.sub(value, index, index))
            index = index + 1
        else
            local length, minimum, code
            if first >= 194 and first <= 223 then length, minimum, code = 2, 128, first - 192
            elseif first >= 224 and first <= 239 then length, minimum, code = 3, 2048, first - 224
            elseif first >= 240 and first <= 244 then length, minimum, code = 4, 65536, first - 240
            else return value end -- Invalid UTF-8 or an existing native Latin-1 character: preserve it.
            if index + length - 1 > #value then return value end
            for offset = 1, length - 1 do
                local byte = string.byte(value, index + offset)
                if byte < 128 or byte > 191 then return value end
                code = code * 64 + byte - 128
            end
            if code < minimum or code > 0x10FFFF or (code >= 0xD800 and code <= 0xDFFF) then return value end
            table.insert(parts, unicodeCharacter(code))
            index = index + length
        end
    end
    return table.concat(parts)
end

local function nativeJSONText(value)
    if type(value) == "string" then return nativeUTF8Text(value) end
    if type(value) ~= "table" then return value end
    local result = {}
    for key, item in pairs(value) do result[nativeJSONText(key)] = nativeJSONText(item) end
    return result
end

local function encodeJSON(value)
    if not nativePlusAvailable then return JSON.encode(value) end
    -- TTS's encoder loses some native Unicode punctuation (e.g. U+3005).
    -- Give it ASCII strings while retaining its existing object/array/number
    -- handling; never replace the global JSON or string functions.
    local function escapeStrings(item)
        if type(item) == "string" then
            local parts = {}
            for index = 1, #item do
                local code = string.unicode(item, index) -- Native UTF-16 code unit, not string.byte.
                if code == 92 or code > 127 then
                    table.insert(parts, string.format("\\u%04x", code))
                else
                    table.insert(parts, string.sub(item, index, index))
                end
            end
            return table.concat(parts)
        end
        if type(item) ~= "table" then return item end
        local result = {}
        for key, child in pairs(item) do result[escapeStrings(key)] = escapeStrings(child) end
        return result
    end
    local encoded = JSON.encode(escapeStrings(value))
    -- The encoder escaped the backslashes we introduced. Unescape exactly
    -- those Unicode sequences. Original backslashes became \u005c first,
    -- so literal text such as "\u3005" is not mistaken for a character.
    return (string.gsub(encoded, "\\\\u(%x%x%x%x)", "\\u%1"))
end

local function decodeJSON(text)
    -- Escaped JSON characters decode as UTF-8 bytes in TTS; restore the native
    -- representation used by script literals, UI strings, and comparisons.
    return nativeJSONText(JSON.decode(text))
end

local function normalizeCardNumber(value)
    value = string.gsub(value, FULLWIDTH_PLUS_BYTES, "+")
    if nativePlusAvailable then value = string.gsub(value, FULLWIDTH_PLUS_NATIVE, "+") end
    return value
end

local function baseCardNumber(card)
    local base, suffix = string.match(card.card_no, "^(.*)%-([^%-]+)$")
    local normalizedSuffix = suffix and normalizeCardNumber(suffix)
    local normalizedRarity = normalizeCardNumber(card.rare)
    if not base or normalizedSuffix ~= normalizedRarity then
        error(tr("カード番号とレアリティが一致しません：") .. card.card_no)
    end
    -- Original card_no and rare remain unchanged, including their original plus signs.
    return base
end

local function escapeURL(value)
    return (string.gsub(value, "([^%w%-%._~])", function(character)
        return string.format("%%%02X", string.byte(character))
    end))
end

local function faceURL(card)
    -- The source record supplies the repository path; do not derive filenames from rarity.
    if RENDERED_FACES[card.card_no] then return RENDERED_FACES[card.card_no] end
    local mirror = MIRROR_ROOT .. card._img
    if card.card_no == "PL!-pb2-000-R" then return mirror end
    -- Normalize every new card to the tested portrait canvas, including unusual energy sizes.
    -- WSRV resizes BEFORE rotating: request a landscape canvas for Live art so
    -- its final 90-degree rotation produces the same 451 x 629 portrait face.
    local parameters = card.type == "ライブ" and "&w=629&h=451&ro=90" or "&w=451&h=629"
    return "https://wsrv.nl/?url=" .. escapeURL(mirror) .. parameters .. "&fit=fill&output=png"
end

local function buildCardData(source)
    local card = copy(source)
    card.schema = "loveca.card"
    card.schema_version = 1
    card.base_card_no = baseCardNumber(source)
    card.face_img = faceURL(source)
    -- Keep hand silhouettes identical; native sideways also affects hand layout.
    -- Live's tabletop orientation is controlled separately by initialRotation().
    card.preview_sideways = false
    card.face_canvas = {width = 451, height = 629}
    card.back_img = BACK_URL
    card.language = LANGUAGE
    card.source = copy(source.source or {url = "https://raw.githubusercontent.com/wlt233/llocg_db/refs/heads/master/json/cards.json", sampled_on = "2026-10-15"})

    -- This is the complete, previously verified official point-list snapshot.
    -- Unlisted cards are zero only within this explicit snapshot, not on lookup failure.
    card.loveca_point = POINT_SYSTEM.points[card.base_card_no] or 0
    card.point_system = {source = POINT_SYSTEM.source,
        effective_date = POINT_SYSTEM.effective_date, deck_limit = POINT_SYSTEM.deck_limit}
    card.printed = {
        cost = card.cost,
        blade = card.blade,
        score = card.score,
        base_heart = copy(card.base_heart or {}),
        need_heart = copy(card.need_heart or {}),
        blade_heart = copy(card.blade_heart or {}),
        special_heart = copy(card.special_heart or {})
    }
    card.current = copy(card.printed)
    card.modifiers = {}

    -- Original Japanese name and ability stay in the source fields.
    -- Translations affect presentation only, never identity or numerical calculations.
    card.translations = copy(source.translations or {})
    card.translations.zh = card.translations.zh or {name = "", ability = ""}
    card.translations.en = card.translations.en or {name = "", ability = ""}
    return card
end

local function textFor(card, field)
    local translation = (card.translations or {})[LANGUAGE]
    if translation and translation[field] and translation[field] ~= "" then
        return translation[field]
    end
    return card[field] or ""
end

local function displayName(card)
    local name = textFor(card, "name")
    if name == "" and card.type == "エネルギー" then
        return tr("エネルギー") -- Display fallback only; keep the source name empty.
    end
    return name
end

local function displayAbility(ability)
    if ability == "" then return tr("なし") end
    -- Only adjacent identical resource icons are counted together. Never combine
    -- resources across wording, line breaks, colours, or separate skill costs.
    -- The original token string in card.ability remains unchanged.
    local triggers = {
        ["jyouji.png"] = tr("【常時】"),
        ["toujyou.png"] = tr("【登場】"),
        ["kidou.png"] = tr("【起動】"), ["jidou.png"] = tr("【自動】"),
        ["live_start.png"] = tr("【ライブ開始時】"), ["live_success.png"] = tr("【ライブ成功時】"),
        ["center.png"] = tr("【センター】"), ["leftside.png"] = tr("【左サイド】"),
        ["rightside.png"] = tr("【右サイド】")
    }
    local resources = {
        ["heart_00.png"] = tr("無指定ハート"), ["icon_all.png"] = tr("ALLハート"),
        ["icon_blade.png"] = tr("ブレード"), ["icon_energy.png"] = tr("エネルギー")
    }
    for _, colour in ipairs(HEARTS) do resources["heart_" .. colour[1] .. ".png"] = tr(colour[2]) .. tr("ハート") end
    local parts = {}
    local pendingResource, pendingCount = nil, 0
    local function flushResource()
        if pendingResource then
            table.insert(parts, "【" .. pendingResource .. " x" .. tostring(pendingCount) .. "】")
            pendingResource, pendingCount = nil, 0
        end
    end
    local function appendText(text)
        if text == "" then return end
        flushResource()
        table.insert(parts, text)
    end
    local cursor = 1
    while cursor <= #ability do
        local first = string.find(ability, "{{", cursor, true)
        if not first then
            appendText(string.sub(ability, cursor))
            break
        end
        appendText(string.sub(ability, cursor, first - 1))
        local last = string.find(ability, "}}", first + 2, true)
        if not last then
            appendText(string.sub(ability, first))
            break
        end

        local token = string.sub(ability, first + 2, last - 1)
        local separator = string.find(token, "|", 1, true)
        if separator then
            local file = string.sub(token, 1, separator - 1)
            local alternative = string.sub(token, separator + 1)
            local resource = resources[file]
            if resource then
                if pendingResource ~= resource then flushResource() end
                pendingResource, pendingCount = resource, pendingCount + 1
            else
                local replacement = triggers[file]
                -- Fixed turn badges are labels, not ability prose or resources.
                if not replacement and string.match(file, "^turn%d+%.png$") and alternative ~= "" then
                    local turns = string.match(file, "^turn(%d+)%.png$")
                    replacement = "【" .. (LANGUAGE ~= "ja" and turns and string.format(tr("ターン%s回"), turns) or alternative) .. "】"
                end
                appendText(replacement or (alternative ~= "" and alternative or ("[" .. file .. "]")))
            end
        else
            appendText(string.sub(ability, first, last + 1))
        end
        cursor = last + 2
    end
    flushResource()
    return table.concat(parts)
end

local function heartText(values, prefix, isRequirement)
    local parts = {}
    for _, colour in ipairs(HEARTS) do
        local count = values[prefix .. colour[1]] or 0
        if count ~= 0 then
            table.insert(parts, tr(colour[2]) .. "×" .. tostring(count))
        end
    end
    if isRequirement then
        if (values.heart0 or 0) ~= 0 then
            table.insert(parts, tr("無指定×") .. tostring(values.heart0))
        end
    else
        if (values.b_heart07 or 0) ~= 0 then
            table.insert(parts, tr("無色×") .. tostring(values.b_heart07))
        end
        if (values.b_all or 0) ~= 0 then
            table.insert(parts, "ALL×" .. tostring(values.b_all))
        end
    end
    return #parts > 0 and table.concat(parts, "／") or tr("なし")
end

local function descriptionFor(card)
    local current = card.current
    local lines = {tr("種類：") .. tr(card.type)}
    if card.type == "メンバー" then
        table.insert(lines, tr("コスト：") .. tostring(current.cost))
        table.insert(lines, tr("ハート：") .. heartText(current.base_heart, "heart", false))
        table.insert(lines, tr("ブレード：") .. tostring(current.blade))
    elseif card.type == "ライブ" then
        table.insert(lines, tr("スコア：") .. tostring(current.score))
        table.insert(lines, tr("必要ハート：") .. heartText(current.need_heart, "heart", true))
    elseif card.type == "エネルギー" then
        table.insert(lines, tr("コスト：—"))
        table.insert(lines, tr("ハート：—"))
        table.insert(lines, tr("ブレード：—"))
    end

    if card.type ~= "エネルギー" then
        table.insert(lines, tr("ブレードハート：") .. heartText(current.blade_heart, "b_heart", false))
        table.insert(lines, tr("エール加点：") .. tostring(current.special_heart.score or 0))
        table.insert(lines, tr("エールドロー：") .. tostring(current.special_heart.draw or 0))
    end
    table.insert(lines, tr("ラブカポイント：") .. tostring(card.loveca_point))
    table.insert(lines, "")
    local translatedAbility = ((card.translations or {})[LANGUAGE] or {}).ability
    table.insert(lines, LANGUAGE ~= "ja" and (not translatedAbility or translatedAbility == "")
        and card.ability and card.ability ~= "" and string.format(tr("能力（%s）："), tr("日本語原文・未翻訳")) or tr("能力："))
    table.insert(lines, displayAbility(textFor(card, "ability")))
    table.insert(lines, "")
    table.insert(lines, tr("作品：") .. (card.series or "—"))
    table.insert(lines, tr("ユニット：") .. (card.unit and card.unit ~= "" and card.unit or "—"))
    table.insert(lines, tr("収録商品：") .. (card.product or "—"))
    return table.concat(lines, "\n")
end

local function cardTags(card)
    local tags, seen = {}, {}
    for _, field in ipairs({"name", "series", "unit", "product"}) do
        local value = card[field]
        if value and value ~= "" and not seen[value] then
            table.insert(tags, value)
            seen[value] = true
        end
    end
    return tags
end

local function applyCardPresentation(object, card)
    object.setName(displayName(card) .. " [" .. card.base_card_no .. "] [" .. card.rare .. "]")
    object.setDescription(descriptionFor(card))

    -- Preserve unrelated tags. Empty source names do not become fallback-name tags.
    for _, value in ipairs(cardTags(card)) do object.addTag(value) end
    object.tooltip = true
end

local function refreshCardPresentation(object)
    if not object or object.isDestroyed() then return end
    if object.type == "Card" then
        local ok, card = pcall(decodeJSON, object.memo or "")
        if ok and type(card) == "table" and card.schema == "loveca.card" and card.schema_version == 1 then
            applyCardPresentation(object, card)
        end
    elseif object.type == "Deck" then
        local ok, deck = pcall(decodeJSON, object.memo or "")
        if ok and type(deck) == "table" and deck.schema == "loveca.deck" and deck.schema_version == 1 then
            object.setName(deck.pile == "main" and tr("メインデッキ") or tr("エネルギーデッキ"))
            object.setDescription(tr("インポート ") .. tostring(deck.batch_id) .. " / " .. object.getQuantity() .. tr(" 枚"))
        end
    end
end

local function refreshCardLanguage()
    for _, object in ipairs(getObjects()) do refreshCardPresentation(object) end
end

-- Contained cards are updated on extraction without rebuilding/shuffling a deck.
function onObjectLeaveContainer(container, object)
    Wait.frames(function() refreshCardPresentation(object) end, 1)
end

function onObjectSpawn(object)
    Wait.frames(function() refreshCardPresentation(object) end, 1)
end

local function customCardParameters(source)
    return {
        type = 0,
        face = faceURL(source),
        back = BACK_URL,
        sideways = false -- No type-revealing sideways layout in players' hands.
    }
end

local function initialRotation(source)
    -- The Live art is clockwise 90 degrees inside a portrait card model.
    -- Turn the table object back by 90 degrees relative to the other samples.
    return {0, source.type == "ライブ" and 90 or 180, 0}
end

local function cardObjectData(card, definitionID)
    local rotation = initialRotation(card)
    local custom = {
        FaceURL = card.face_img, BackURL = card.back_img, NumWidth = 1, NumHeight = 1,
        BackIsHidden = true, UniqueBack = false, Type = 0
    }
    -- Native fields were checked against getData() from the working TTS cards.
    -- Memo is present before the object exists; a callback never assigns per-card identities.
    return {
        Name = "CardCustom", CardID = definitionID * 100,
        CustomDeck = {[tostring(definitionID)] = custom},
        Transform = {posX = 0, posY = 0, posZ = 0,
            rotX = rotation[1], rotY = rotation[2], rotZ = rotation[3],
            scaleX = CARD_SCALE[1], scaleY = CARD_SCALE[2], scaleZ = CARD_SCALE[3]},
        Nickname = displayName(card) .. " [" .. card.base_card_no .. "] [" .. card.rare .. "]",
        Description = descriptionFor(card), Memo = encodeJSON(card), Tags = cardTags(card),
        SidewaysCard = card.preview_sideways, ColorDiffuse = {r = 0.713235259, g = 0.713235259, b = 0.713235259, a = 1},
        Locked = false, Grid = true, Snap = true, Sticky = true, Tooltip = true,
        Hands = true, HideWhenFaceDown = true, DragSelectable = true,
        LuaScript = "", LuaScriptState = "", XmlUI = ""
    }
end

-- Shared by Global and standalone markers. Visuals reuse the existing table's
-- circular Custom_Tile assets, inspected on 2026-10-19; originals stay untouched.
local MARKER_RESOURCES = {
    {key = "heart01", name = "桃ハート", short = "桃♥", body = {1, .80, .89}, ink = {.58, .06, .28}},
    {key = "heart02", name = "赤ハート", short = "赤♥", body = {1, .79, .76}, ink = {.64, .08, .04}},
    {key = "heart03", name = "黄ハート", short = "黄♥", body = {1, .94, .60}, ink = {.46, .30, .02}},
    {key = "heart04", name = "緑ハート", short = "緑♥", body = {.72, .94, .76}, ink = {.05, .38, .17}},
    {key = "heart05", name = "青ハート", short = "青♥", body = {.69, .88, 1}, ink = {.03, .30, .53}},
    {key = "heart06", name = "紫ハート", short = "紫♥", body = {.87, .77, .98}, ink = {.38, .12, .58}},
    {key = "heart0", name = "無色／無指定ハート", short = "無♥", body = {.91, .92, .94}, ink = {.25, .28, .35}},
    {key = "all", name = "ALLハート", short = "ALL♥", body = {1, .86, .96}, ink = {.56, .08, .44}},
    {key = "blade", name = "ブレード", short = "B", body = {.72, .88, .97}, ink = {.08, .28, .43}},
    {key = "score", name = "スコア", short = "S", body = {1, .88, .61}, ink = {.48, .28, .03}}
}

local MARKER_ASSET_ROOT = "https://steamusercontent-a.akamaihd.net/ugc/"
local MARKER_IMAGES = {
    heart01 = "27692883760551143/E6A0F26BAF08D054F679C42E719E2806064F4580/", -- 58e089
    heart02 = "27692883760545449/77F8B562BDCA71A9D563D68D99349150540DAEB9/", -- 137858
    heart03 = "27692883760543848/92C3F93CDF07665F12B7504978CB0378786C6071/", -- 013095
    heart04 = "27692883760549385/583C7E129E1367A7408EBCBD5A2AB0D7169600E7/", -- 96cdf3
    heart05 = "27692883760550184/4617E265C3A3C3EB78C40C82DE5D71BA8312685B/", -- 12afee
    heart06 = "27692883760529876/48C4B9F40E745EFCCA632482D44A779A5740389B/", -- 384cf6
    heart0 = "27692883760548302/4E38F6364D80FAD6F443A8FED31D570F38BDCE39/", -- c8c282
    all = "27692883760546326/83CA850BB9C6F6CDA4C93819341EB34361B065EB/", -- 186e6c
    blade = "27692883750484188/98D46E0E83471E6586F631087D917FA000CF7A58/", -- ef63ee
    score = "27692883750489229/04A3283304E3ABC61BE754B199575B36063A2E36/" -- 266a7a
}
for _, definition in ipairs(MARKER_RESOURCES) do
    definition.image = MARKER_ASSET_ROOT .. MARKER_IMAGES[definition.key]
end

local function markerDefinition(key)
    for _, definition in ipairs(MARKER_RESOURCES) do
        if definition.key == key then return definition end
    end
end

-- Public field statistics. Regions are in each playmat's local coordinate system.
-- Skills, drawing, energy payment and card movement remain manual.
local FIELD_DEFAULTS = {version = 1, players = {
    {color = "White", mat = "0e661d"}, {color = "Pink", mat = "bab5f6"}
}}
local fieldConfig = copy(FIELD_DEFAULTS)
local fieldOwners, fieldCache, fieldSnapshot, fieldText = {}, {}, {}, {}
local fieldSticky = {}
local fieldMarkerBindings = {}
local fieldBlocked, initiativeWinner, initiativeText = {}, nil, ""
local LOVECA_PANEL_OFFSET = "250 -80" -- Shared top-left origin for all three panels.
local FIELD_SLOTS = {0.780, 0.017, -0.700}
local FIELD_LIVES = {0.695, -0.011, -0.698}
local FIELD_CHEER = {left = 1.94, right = 2.94, top = -0.80, bottom = 0.80}
local FIELD_SLOT_NAMES = {"左", "中", "右"}
local FIELD_PRIVATE_ZONES = {White = "b8f30b", Pink = "d5d052"}

local function fieldRegion(p)
    if p.y < -0.10 or p.y > 1.4 then return nil end
    if p.x >= FIELD_CHEER.left and p.x <= FIELD_CHEER.right
        and p.z >= FIELD_CHEER.top and p.z <= FIELD_CHEER.bottom then return "cheer" end
    -- The cheer area is on the table, lower than the playmat's top surface.
    if p.y < 0.07 then return nil end
    if p.z >= -0.94 and p.z <= -0.40 then
        for i, x in ipairs(FIELD_LIVES) do if math.abs(p.x - x) <= 0.31 then return "live", i end end
    end
    if p.z >= -0.38 and p.z <= 0.36 then
        for i, x in ipairs(FIELD_SLOTS) do if math.abs(p.x - x) <= 0.34 then return "stage", i end end
    end
    if p.x >= -1.04 and p.x <= 1.05 and p.z >= 0.39 and p.z <= 0.98 then return "energy" end
    if p.x >= -1.80 and p.x <= -1.18 then
        if p.z >= -0.96 and p.z <= -0.37 then return "main" end
        if p.z >= -0.34 and p.z <= 0.31 then return "waiting" end
        if p.z >= 0.36 and p.z <= 0.99 then return "energy_deck" end
    end
    if p.x >= 1.18 and p.x <= 1.80 and p.z >= -0.55 and p.z <= 0.20 then return "success" end
end

local function fieldIssue(sheet, section, message)
    sheet.complete[section] = false
    if not sheet.issueSet[message] then
        sheet.issueSet[message] = true
        table.insert(sheet.issues, message)
    end
end

local function fieldNumber(value)
    if type(value) ~= "number" or value ~= value or value < 0 or value == math.huge
        or value ~= math.floor(value) then error(tr("数値データが不正です")) end
    return value
end

local function fieldMap(value, keys)
    if type(value) ~= "table" then error(tr("ハートデータがありません")) end
    local result = {}
    for _, key in ipairs(keys) do result[key] = fieldNumber(value[key] == nil and 0 or value[key]) end
    return result
end

local FIELD_HEART_KEYS = {"heart01", "heart02", "heart03", "heart04", "heart05", "heart06", "heart0"}
local FIELD_CHEER_KEYS = {"b_heart01", "b_heart02", "b_heart03", "b_heart04",
    "b_heart05", "b_heart06", "b_heart07", "b_all"}

local function fieldCard(guid, memo)
    local cached = fieldCache[guid]
    if cached and cached.memo == memo then return cached.card end
    local ok, card = pcall(decodeJSON, memo or "")
    if not ok or type(card) ~= "table" or card.schema ~= "loveca.card" or card.schema_version ~= 1
        or type(card.instance_id) ~= "string" or card.instance_id == ""
        or type(card.current) ~= "table" then return nil end
    fieldCache[guid] = {memo = memo, card = card}
    return card
end

local function fieldAdd(target, values)
    for key, value in pairs(values) do target[key] = (target[key] or 0) + value end
end

local function fieldState(object, mat)
    if object.getTransformUp().y < 0.94 then return "unknown" end
    local angle = (object.getRotation().y - mat.getRotation().y) % 180
    if math.min(angle, 180 - angle) <= 20 then return "active" end
    if math.abs(angle - 90) <= 20 then return "wait" end
    return "unknown"
end

local function fieldSheet(player)
    return {color = player.color, mat = player.mat, issues = {}, issueSet = {},
        modifiers = {member = {{}, {}, {}}, live = {{}, {}, {}}, cheer = {}, score = {}, count = 0},
        complete = {stage = true, live = true, cheer = true, energy = true},
        judgement = {status = "pending", message = tr("未判定\n集計中")},
        stage = {hearts = {}, blade = 0, count = 0, active = 0, wait = 0, slots = {}},
        live = {hearts = {}, score = 0, count = 0, hidden = 0, slots = {}},
        cheer = {hearts = {}, score = 0, draw = 0, count = 0, hidden = 0},
        energy = {active = 0, wait = 0, unknown = 0, total = 0}}
end

local function fieldMarkerSection(scope)
    if scope == "member" then return "stage" end
    if scope == "score" then return "live" end
    if scope == "live" or scope == "cheer" then return scope end
end

local function fieldExactSum(base, change)
    local limit = 9007199254740991
    if (change > 0 and base > limit - change) or (change < 0 and base < -limit - change) then return nil end
    return base + change
end

local function fieldAdjusted(sheet, section, base, change)
    local value = fieldExactSum(base, change)
    if value then return value end
    fieldIssue(sheet, section, tr("補正後の数値が整数範囲外"))
    return base -- Incomplete result; never present a rounded integer as exact.
end

-- A marker targets the visible card present when it is placed, not whichever
-- card later occupies the same slot. Storage/unassigned placement releases it.
-- Bindings are automatic; players never have to enter a card GUID.
local function fieldMarkerTarget(sheet, marker)
    local p = marker.placement
    if p.scope ~= "member" and p.scope ~= "live" then return true end
    local section = fieldMarkerSection(p.scope)
    local card = sheet[section].slots[p.slot]
    local subject = card and (card.guid .. "/" .. card.instance_id) or ""
    local binding = fieldMarkerBindings[marker.guid]
    if not binding or binding.color ~= p.color or binding.scope ~= p.scope or binding.slot ~= p.slot then
        binding = {color = p.color, scope = p.scope, slot = p.slot, subject = subject}
        fieldMarkerBindings[marker.guid] = binding
    end
    if not card then
        fieldIssue(sheet, section, tr("補正対象の公開カードを確認：") .. marker.guid)
        return false
    end
    if binding.subject ~= subject then
        fieldIssue(sheet, section, tr("補正対象が交代：保管へ戻して置き直す（") .. marker.guid .. "）")
        return false
    end
    return true
end

local function fieldCollectMarkers(sheets)
    local byColor, seen = {}, {}
    for _, sheet in ipairs(sheets) do byColor[sheet.color] = sheet end
    local reasons = {moving = tr("マーカー移動中"), ambiguous = tr("マーカーの領域が重複"),
        wrong_resource = tr("領域とマーカー種類が不一致"), invalid_data = tr("マーカーデータが不正"),
        duplicate = tr("マーカー個体番号が重複")}
    for _, marker in ipairs(refreshLovecaMarkers(fieldConfig.players)) do
        local p, guid = marker.placement, marker.guid
        seen[guid] = true
        if p.code == "unassigned" or (p.code == "placed" and p.scope == "storage") then
            fieldMarkerBindings[guid] = nil
        elseif marker.value == 0 and p.code == "placed" then
            fieldMarkerBindings[guid] = nil
        else
            local sheet, section = byColor[p.color], fieldMarkerSection(p.scope)
            if p.code ~= "placed" then
                local function report(color, scope)
                    local affected = byColor[color]
                    local region = fieldMarkerSection(scope)
                    if affected and region then fieldIssue(affected, region, tr(reasons[p.code] or "マーカーを確認") .. "：" .. guid) end
                end
                report(p.color, p.scope)
                for _, match in ipairs(p.matches or {}) do report(match.color, match.scope) end
                local previous = fieldMarkerBindings[guid]
                if previous then report(previous.color, previous.scope) end
            elseif sheet and section and fieldMarkerTarget(sheet, marker) then
                local bucket = sheet.modifiers[p.scope]
                if p.slot then bucket = bucket[p.slot] end
                local resource = marker.resource
                local sum = fieldExactSum(bucket[resource] or 0, marker.value)
                if sum == nil then
                    fieldIssue(sheet, section, tr("補正の合計が整数範囲外：") .. guid)
                    bucket.invalid = true
                else
                    bucket[resource] = sum
                    sheet.modifiers.count = sheet.modifiers.count + 1
                end
            end
        end
    end
    for guid in pairs(fieldMarkerBindings) do if not seen[guid] then fieldMarkerBindings[guid] = nil end end
end

local function fieldModifiedHearts(sheet, section, hearts, modifiers, keys)
    -- Comprehensive rules v1.06 p.1 [IP]: numeric information may be negative.
    -- Sum signed effects per subject; do not clamp individual markers or totals.
    local result = {}
    for _, key in ipairs(keys) do result[key] = fieldAdjusted(sheet, section, hearts[key] or 0, modifiers[key] or 0) end
    return result
end

local function fieldApplyMarkers(sheet)
    for slot, card in pairs(sheet.stage.slots) do
        local modifiers = sheet.modifiers.member[slot]
        if not modifiers.invalid then
            local effective = {hearts = fieldModifiedHearts(sheet, "stage", card.hearts, modifiers, FIELD_HEART_KEYS),
                blade = fieldAdjusted(sheet, "stage", card.blade, modifiers.blade or 0)}
            for _, key in ipairs(FIELD_HEART_KEYS) do
                sheet.stage.hearts[key] = fieldAdjusted(sheet, "stage", sheet.stage.hearts[key] or 0, modifiers[key] or 0)
            end
            if card.state == "active" then sheet.stage.blade = fieldAdjusted(sheet, "stage", sheet.stage.blade, modifiers.blade or 0) end
            card.effective = effective
        end
    end
    for slot, card in pairs(sheet.live.slots) do
        local modifiers = sheet.modifiers.live[slot]
        if not modifiers.invalid then
            local effective = {hearts = fieldModifiedHearts(sheet, "live", card.hearts, modifiers, FIELD_HEART_KEYS),
                score = fieldAdjusted(sheet, "live", card.score, modifiers.score or 0)}
            for _, key in ipairs(FIELD_HEART_KEYS) do
                sheet.live.hearts[key] = fieldAdjusted(sheet, "live", sheet.live.hearts[key] or 0, modifiers[key] or 0)
            end
            sheet.live.score = fieldAdjusted(sheet, "live", sheet.live.score, modifiers.score or 0)
            card.effective = effective
        end
    end
    if not sheet.modifiers.score.invalid then
        sheet.live.score = fieldAdjusted(sheet, "live", sheet.live.score, sheet.modifiers.score.score or 0)
    end
    local cheer = sheet.modifiers.cheer
    if not cheer.invalid then
        for _, resource in ipairs(MARKER_RESOURCES) do
            local key = resource.key
            local target = key == "all" and "b_all" or key == "heart0" and "b_heart07" or "b_" .. key
            if key == "score" then sheet.cheer.score = fieldAdjusted(sheet, "cheer", sheet.cheer.score, cheer.score or 0)
            elseif key ~= "blade" then
                sheet.cheer.hearts[target] = fieldAdjusted(sheet, "cheer", sheet.cheer.hearts[target] or 0, cheer[key] or 0)
            end
        end
    end
end

-- A card physically beneath the chosen member is attached, not another member.
-- Equal-height or non-overlapping candidates remain ambiguous rather than being summed.
local function fieldUnder(lower, upper)
    if upper.object.getPosition().y - lower.object.getPosition().y < 0.008 then return false end
    local relative = upper.object.positionToLocal(lower.object.getPosition())
    local size, scale = upper.object.getBoundsNormalized().size, upper.object.getScale()
    return math.abs(relative.x) < size.x / scale.x * 0.5 - 0.04
        and math.abs(relative.z) < size.z / scale.z * 0.5 - 0.04
end

local function fieldClaim(sheet, section, guid)
    local owner = fieldOwners[guid]
    if owner and owner ~= sheet.color then
        if section then fieldIssue(sheet, section, tr("他プレイヤーのカード：") .. guid) end
        return false
    end
    fieldOwners[guid] = sheet.color
    return true
end

local function fieldSetText(id, value)
    if fieldText[id] ~= value then
        fieldText[id] = value
        UI.setAttribute(id, "text", value)
    end
end

local function fieldJudgeLive(sheet)
    local function pending(reason)
        return {status = "pending", message = tr("未判定\n") .. reason}
    end
    if fieldBlocked[sheet.color] then return {status = "blocked", message = tr("ライブ不可\n効果による禁止を手動指定")} end
    if sheet.live.hidden > 0 or sheet.cheer.hidden > 0 then return pending(tr("未公開カードがあります")) end
    if not sheet.complete.stage or not sheet.complete.live or not sheet.complete.cheer then
        return pending(tr("カード数値・配置を確認"))
    end
    if sheet.live.count == 0 then return pending(tr("Liveカードを置いてください")) end
    -- Negative modifiers are already applied. Negative resulting requirements
    -- need a rules ruling for icon allocation, not an invented clamp to zero.
    for _, card in pairs(sheet.live.slots) do
        for _, value in pairs(card.effective.hearts) do
            if value < 0 then return pending(tr("負の必要ハートを確認")) end
        end
    end
    local all = sheet.cheer.hearts.b_all or 0
    local neutral = fieldExactSum(sheet.stage.hearts.heart0 or 0, sheet.cheer.hearts.b_heart07 or 0)
    local neutralNeed = sheet.live.hearts.heart0 or 0
    if not neutral then return pending(tr("ハート合計が整数範囲外")) end
    if all < 0 or neutral < 0 then return pending(tr("負の所有ハートを確認")) end
    local availableTotal, requiredTotal = fieldExactSum(all, neutral), neutralNeed
    if not availableTotal then return pending(tr("ハート合計が整数範囲外")) end
    local deficits, available, missing = {}, {}, 0
    for _, heart in ipairs(HEARTS) do
        local key = "heart" .. heart[1]
        local amount = fieldExactSum(sheet.stage.hearts[key] or 0, sheet.cheer.hearts["b_" .. key] or 0)
        local needed = sheet.live.hearts[key] or 0
        if not amount then return pending(tr("ハート合計が整数範囲外")) end
        if amount < 0 then return pending(tr("負の所有ハートを確認")) end
        available[key] = amount
        deficits[key] = math.max(0, needed - amount)
        missing = fieldExactSum(missing, deficits[key])
        availableTotal = fieldExactSum(availableTotal, amount)
        requiredTotal = fieldExactSum(requiredTotal, needed)
        if not missing or not availableTotal or not requiredTotal then return pending(tr("ハート合計が整数範囲外")) end
    end
    -- One shared pool for ALL Live cards. ALL fills colored deficits once;
    -- neutral hearts only contribute to total quantity, never colored deficits.
    local colorShortfall = math.max(0, missing - all)
    local totalShortfall = math.max(0, requiredTotal - availableTotal)
    local success = colorShortfall == 0 and totalShortfall == 0
    return {status = success and "success" or "failure", available = available,
        neutral = neutral, all = all, all_used = math.min(missing, all), deficits = deficits,
        total_available = availableTotal, total_required = requiredTotal,
        color_shortfall = colorShortfall, total_shortfall = totalShortfall,
        message = success and (tr("ライブ成功（現在値）\nハート ") .. availableTotal .. tr(" / 必要 ") .. requiredTotal)
            or (tr("ライブ失敗\n色不足 ") .. colorShortfall .. tr(" / 総数不足 ") .. totalShortfall)}
end

local function fieldHeartRows(values, prefix, last)
    local parts = {}
    for _, heart in ipairs(HEARTS) do table.insert(parts, tr(heart[2]) .. " " .. (values[prefix .. heart[1]] or 0)) end
    return table.concat(parts, "　", 1, 3) .. "\n" .. table.concat(parts, "　", 4, 6)
        .. (last and ("\n" .. last) or "")
end

local function fieldRender(sheet)
    local prefix = "lc_field_" .. sheet.color .. "_"
    local function title(section, text)
        return text .. (sheet.complete[section] and "" or tr(" ［要確認］"))
    end
    fieldSetText(prefix .. "stage", title("stage", tr("ステージ  ") .. sheet.stage.count .. tr(" 人")) .. "\n"
        .. fieldHeartRows(sheet.stage.hearts, "heart") .. tr("\nブレード ") .. sheet.stage.blade
        .. tr("　Active ") .. sheet.stage.active .. tr(" / Wait ") .. sheet.stage.wait)
    fieldSetText(prefix .. "live", title("live", tr("ライブ  公開 ") .. sheet.live.count .. tr(" / 裏 ") .. sheet.live.hidden)
        .. "\n" .. fieldHeartRows(sheet.live.hearts, "heart")
        .. tr("\n無指定 ") .. (sheet.live.hearts.heart0 or 0) .. tr("　スコア ") .. sheet.live.score)
    fieldSetText(prefix .. "cheer", title("cheer", tr("エール  公開 ") .. sheet.cheer.count .. tr(" / 裏 ") .. sheet.cheer.hidden)
        .. "\n" .. fieldHeartRows(sheet.cheer.hearts, "b_heart")
        .. tr("\n無色 ") .. (sheet.cheer.hearts.b_heart07 or 0) .. "　ALL " .. (sheet.cheer.hearts.b_all or 0)
        .. tr("　加点 ") .. sheet.cheer.score .. tr("　ドロー ") .. sheet.cheer.draw)
    fieldSetText(prefix .. "energy", title("energy", tr("エネルギー")) .. tr("\nActive ") .. sheet.energy.active
        .. tr("　Wait ") .. sheet.energy.wait .. tr("　合計 ") .. sheet.energy.total
        .. (sheet.energy.unknown > 0 and (tr("　不明 ") .. sheet.energy.unknown) or ""))
    fieldSetText(prefix .. "judgement", sheet.judgement.message)
    local resultColor = sheet.judgement.status == "success" and "#94E5AB"
        or sheet.judgement.status == "failure" and "#FFAAAA" or "#FFD58A"
    if fieldText[prefix .. "result_color"] ~= resultColor then
        fieldText[prefix .. "result_color"] = resultColor
        UI.setAttribute(prefix .. "judgement", "color", resultColor)
    end
    local blocked = fieldBlocked[sheet.color] and "true" or "false"
    if fieldText[prefix .. "blocked"] ~= blocked then
        fieldText[prefix .. "blocked"] = blocked
        UI.setAttribute(prefix .. "blocked", "isOn", blocked)
    end
    local issues = {}
    for i = 1, math.min(3, #sheet.issues) do issues[i] = sheet.issues[i] end
    if #sheet.issues > 3 then table.insert(issues, tr("ほか ") .. (#sheet.issues - 3) .. tr(" 件（詳細ボタン）")) end
    fieldSetText(prefix .. "issues", #issues == 0 and (tr("配置を自動更新中　補正 ") .. sheet.modifiers.count .. tr(" 件"))
        or table.concat(issues, "\n"))
end

local function fieldCalculate()
    local sheets, instances, seenCache, managed = {}, {}, {}, {}
    local objects = getObjects()
    for _, player in ipairs(fieldConfig.players) do
        local sheet, groups = fieldSheet(player), {stage = {{}, {}, {}}, live = {{}, {}, {}}, cheer = {}, energy = {}}
        table.insert(sheets, sheet)
        local mat = getObjectFromGUID(player.mat)
        if not mat then
            for _, section in ipairs({"stage", "live", "cheer", "energy"}) do fieldIssue(sheet, section, tr("プレイマットがありません：") .. player.mat) end
        else
            local function addRecord(object, section, slot, guid, memo, hidden, child)
                local record = {object = object, section = section, slot = slot, guid = guid,
                    memo = memo, hidden = hidden, child = child, sheet = sheet, mat = mat}
                if slot then table.insert(groups[section][slot], record) else table.insert(groups[section], record) end
                if not hidden then
                    record.card = fieldCard(guid, memo)
                    seenCache[guid] = true
                    if record.card then
                        local id = record.card.instance_id
                        instances[id] = instances[id] or {}
                        table.insert(instances[id], record)
                    end
                end
            end
            for _, object in ipairs(objects) do
                if object.type == "Card" or object.type == "Deck" then
                    local section, slot = fieldRegion(mat.positionToLocal(object.getPosition()))
                    if section then
                        local counted = groups[section] ~= nil
                        if object.held_by_color then
                            if counted then fieldIssue(sheet, section, tr("カード移動中")) end
                        elseif object.type == "Deck" then
                            if section == "stage" or section == "live" or section == "energy" then
                                fieldIssue(sheet, section, tr("この領域は単独カードで配置：") .. object.getGUID())
                            elseif section == "cheer" then
                                local deckMemo = object.memo or ""
                                local ok, meta = pcall(decodeJSON, deckMemo)
                                if ok and type(meta) == "table" and meta.schema == "loveca.deck" then
                                    fieldIssue(sheet, section, tr("牌庫をエールに置かないでください：") .. object.getGUID())
                                else
                                    -- getObjects() has Memo but no transforms in the live TTS API.
                                    -- ContainedObjects preserves each card's recorded face orientation.
                                    for _, child in ipairs(object.getData().ContainedObjects or {}) do
                                        -- The container and each contained card must both be face up.
                                        local t = child.Transform
                                        local hidden = object.is_face_down or not t
                                            or math.cos(math.rad(t.rotX or 0)) * math.cos(math.rad(t.rotZ or 0)) < 0.94
                                        addRecord(object, section, nil, child.GUID, child.Memo, hidden, true)
                                    end
                                end
                            else
                                for _, child in ipairs(object.getObjects()) do fieldClaim(sheet, nil, child.guid) end
                            end
                        elseif counted then
                            addRecord(object, section, slot, object.getGUID(), object.memo, object.is_face_down, false)
                            if section == "stage" or section == "live" or section == "energy" then
                                local guid = object.getGUID()
                                managed[guid] = true
                                if not fieldSticky[guid] then fieldSticky[guid] = {object = object, sticky = object.sticky} end
                                object.sticky = false
                            end
                        else
                            fieldClaim(sheet, nil, object.getGUID())
                        end
                    end
                end
            end
        end
        sheet.groups = groups
    end
    -- Reject all copies of a repeated instance, including duplicates across players.
    for _, entries in pairs(instances) do
        if #entries > 1 then
            for _, entry in ipairs(entries) do
                entry.duplicate = true
                fieldIssue(entry.sheet, entry.section, tr("個体番号が重複：") .. entry.guid)
            end
        end
    end
    local function usable(record, expected)
        local sheet, section = record.sheet, record.section
        if record.hidden then fieldIssue(sheet, section, tr("未公開カードがあります")); return false end
        if record.duplicate then return false end
        if not record.card then fieldIssue(sheet, section, tr("カードデータを確認：") .. record.guid); return false end
        if expected and record.card.type ~= expected then fieldIssue(sheet, section, tr("領域とカード種類が不一致：") .. record.guid); return false end
        if not fieldClaim(sheet, section, record.guid) then return false end
        return true
    end
    for _, sheet in ipairs(sheets) do
        local groups = sheet.groups
        for slot, candidates in ipairs(groups.stage) do
            -- Only one top card may represent the deployed member.
            table.sort(candidates, function(a, b) return a.object.getPosition().y > b.object.getPosition().y end)
            local top, ambiguous = candidates[1], false
            if top then
                for i = 2, #candidates do
                    if not fieldUnder(candidates[i], top) then ambiguous = true end
                end
                if ambiguous then fieldIssue(sheet, "stage", tr(FIELD_SLOT_NAMES[slot]) .. tr("メンバーの重なりを確認"))
                elseif usable(top, "メンバー") then
                    local ok, hearts, blade = pcall(function()
                        return fieldMap(top.card.current.base_heart, FIELD_HEART_KEYS), fieldNumber(top.card.current.blade)
                    end)
                    if not ok then fieldIssue(sheet, "stage", tr("メンバー数値を確認：") .. top.guid)
                    else
                        local state = fieldState(top.object, top.mat)
                        fieldAdd(sheet.stage.hearts, hearts)
                        sheet.stage.count = sheet.stage.count + 1
                        sheet.stage.slots[slot] = {guid = top.guid, instance_id = top.card.instance_id,
                            state = state, attached = #candidates - 1, hearts = hearts, blade = blade}
                        if state == "unknown" then fieldIssue(sheet, "stage", tr(FIELD_SLOT_NAMES[slot]) .. tr("メンバーの向きが不明"))
                        else
                            sheet.stage[state] = sheet.stage[state] + 1
                            if state == "active" then sheet.stage.blade = sheet.stage.blade + blade end
                        end
                    end
                end
            end
        end
        for slot, candidates in ipairs(groups.live) do
            for _, record in ipairs(candidates) do if record.hidden then sheet.live.hidden = sheet.live.hidden + 1 end end
            if #candidates > 1 then fieldIssue(sheet, "live", tr(FIELD_SLOT_NAMES[slot]) .. tr("Live は 1 枚ずつ配置"))
            elseif #candidates == 1 and usable(candidates[1], "ライブ") then
                local record = candidates[1]
                local ok, hearts, score = pcall(function()
                    return fieldMap(record.card.current.need_heart, FIELD_HEART_KEYS), fieldNumber(record.card.current.score)
                end)
                if not ok then fieldIssue(sheet, "live", tr("Live 数値を確認：") .. record.guid)
                else
                    fieldAdd(sheet.live.hearts, hearts)
                    sheet.live.score, sheet.live.count = sheet.live.score + score, sheet.live.count + 1
                    sheet.live.slots[slot] = {guid = record.guid, instance_id = record.card.instance_id,
                        hearts = hearts, score = score}
                end
            end
        end
        for _, record in ipairs(groups.cheer) do
            if record.hidden then sheet.cheer.hidden = sheet.cheer.hidden + 1 end
            if usable(record) then
                local ok, hearts, score, draw = pcall(function()
                    if record.card.type ~= "メンバー" and record.card.type ~= "ライブ" then error(tr("エール種類")) end
                    local current = record.card.current
                    if type(current.special_heart) ~= "table" then error(tr("特殊ハート")) end
                    return fieldMap(current.blade_heart, FIELD_CHEER_KEYS),
                        fieldNumber(current.special_heart.score == nil and 0 or current.special_heart.score),
                        fieldNumber(current.special_heart.draw == nil and 0 or current.special_heart.draw)
                end)
                if not ok then fieldIssue(sheet, "cheer", tr("エール数値を確認：") .. record.guid)
                else
                    fieldAdd(sheet.cheer.hearts, hearts)
                    sheet.cheer.count = sheet.cheer.count + 1
                    sheet.cheer.score, sheet.cheer.draw = sheet.cheer.score + score, sheet.cheer.draw + draw
                end
            end
        end
        for _, record in ipairs(groups.energy) do
            if usable(record, "エネルギー") then
                local state = fieldState(record.object, record.mat)
                sheet.energy.total = sheet.energy.total + 1
                sheet.energy[state] = sheet.energy[state] + 1
                if state == "unknown" then fieldIssue(sheet, "energy", tr("エネルギーの向きが不明：") .. record.guid) end
            end
        end
        sheet.groups = nil
    end
    fieldCollectMarkers(sheets)
    for _, sheet in ipairs(sheets) do
        fieldApplyMarkers(sheet)
        sheet.judgement = fieldJudgeLive(sheet)
        sheet.issueSet = nil
    end
    for guid, entry in pairs(fieldSticky) do
        if not managed[guid] then
            if entry.object and not entry.object.isDestroyed() then entry.object.sticky = entry.sticky end
            fieldSticky[guid] = nil
        end
    end
    for guid in pairs(fieldCache) do if not seenCache[guid] then fieldCache[guid] = nil end end
    return sheets
end

function refreshLovecaField()
    local ok, sheets = pcall(fieldCalculate)
    if not ok then
        local message = tostring(sheets)
        -- Replace stale numbers with explicit incomplete results after a scanner error.
        sheets = {}
        for _, player in ipairs(fieldConfig.players) do
            local sheet = fieldSheet(player)
            for _, section in ipairs({"stage", "live", "cheer", "energy"}) do fieldIssue(sheet, section, tr("集計エラー（詳細はログ）")) end
            sheet.judgement = {status = "pending", message = tr("未判定\n集計エラー（詳細はログ）")}
            table.insert(sheets, sheet)
        end
        if fieldText.error ~= message then print("[LoveCa Field] " .. message); fieldText.error = message end
    else
        fieldText.error = nil
    end
    fieldSnapshot = sheets
    if not UI.loading then
        for _, sheet in ipairs(sheets) do fieldRender(sheet) end
        fieldSetText("lc_field_initiative_result", initiativeText)
    end
    return copy(sheets)
end

function getLovecaFieldSnapshot()
    return copy(fieldSnapshot)
end

function openLovecaField()
    showLovecaPanel("field")
    refreshLovecaField()
end

function closeLovecaField()
    closeLovecaPanel("field")
end

function lovecaFieldDetails(player)
    for _, sheet in ipairs(fieldSnapshot) do
        local message = colorName(sheet.color) .. ": " .. sheet.judgement.message
            .. (#sheet.issues == 0 and "" or ("\n" .. table.concat(sheet.issues, "\n")))
        if sheet.judgement.deficits then
            message = message .. tr("\n色別不足（ALL充当前） ") .. fieldHeartRows(sheet.judgement.deficits, "heart")
                .. tr("\nALL充当 ") .. sheet.judgement.all_used .. tr(" / 所有 ") .. sheet.judgement.all
        end
        if player then printToColor(message, player.color, {1, 0.85, 0.5}) else print(message) end
    end
end

local function initiativeResult(color)
    return string.format(tr("[%sプレイヤー]が\n先攻・後攻を決定"), colorName(color))
end

function drawLovecaInitiative(player)
    local colors = {}
    for _, color in ipairs(getSeatedPlayers()) do
        -- GM and spectator are roles represented by Black/Grey seats. A host
        -- seated at a normal player color is still eligible; admin is irrelevant.
        if color ~= "Black" and color ~= "Grey" then table.insert(colors, color) end
    end
    if #colors == 0 then
        initiativeWinner, initiativeText = nil, tr("抽選待ち\nプレイヤーが未着席")
        fieldSetText("lc_field_initiative_result", initiativeText)
        if player then printToColor(tr("GM・観戦者以外のプレイヤーが着席してから抽選してください。"), player.color, {1, .85, .5}) end
        return nil
    end
    -- Use the engine's existing PRNG; never reseed on each click.
    initiativeWinner = colors[math.random(#colors)]
    initiativeText = initiativeResult(initiativeWinner)
    fieldSetText("lc_field_initiative_result", initiativeText)
    broadcastToAll("[LoveCa] " .. string.gsub(initiativeText, "\n", " "), {1, .85, .5})
    return initiativeWinner
end

function lovecaFieldBlockedChanged(player, value, id)
    local color = string.match(id or "", "^lc_field_(%w+)_blocked$")
    for _, configured in ipairs(fieldConfig.players) do
        if color == configured.color then
            fieldBlocked[color] = value == true or value == "True" or value == "true"
            refreshLovecaField()
            return
        end
    end
end

local function fieldNode(tag, attributes, children)
    return {tag = tag, attributes = attributes, children = children}
end

local function fieldUI()
    local children = {
        fieldNode("Text", {text = tr("LoveCa 盤面計算"), fontSize = "22", color = "#FFFFFF", width = "400", height = "36",
            alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "20 -10"}),
        fieldNode("Button", {text = tr("更新"), onClick = "refreshLovecaField", fontSize = "17", width = "75", height = "32",
            rectAlignment = "UpperRight", offsetXY = "-155 -12", color = "#40557A", textColor = "#FFFFFF"}),
        fieldNode("Button", {text = tr("詳細"), onClick = "lovecaFieldDetails", fontSize = "17", width = "75", height = "32",
            rectAlignment = "UpperRight", offsetXY = "-72 -12", color = "#40557A", textColor = "#FFFFFF"}),
        fieldNode("Button", {text = "×", onClick = "closeLovecaField", fontSize = "24", width = "34", height = "34",
            rectAlignment = "UpperRight", offsetXY = "-16 -10", color = "#40557A", textColor = "#FFFFFF"})
    }
    for i, player in ipairs(fieldConfig.players) do
        local column = {fieldNode("Text", {text = colorName(player.color), fontSize = "21", color = i == 1 and "#FFFFFF" or "#FFABC9",
            width = "310", height = "30", alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "12 -8"})}
        for _, row in ipairs({{"stage", 46, 112}, {"live", 170, 112}, {"cheer", 294, 112},
            {"judgement", 418, 76}, {"energy", 540, 62}, {"issues", 612, 72}}) do
            table.insert(column, fieldNode("Text", {id = "lc_field_" .. player.color .. "_" .. row[1], text = tr("読込中…"),
                fontSize = row[1] == "issues" and "16" or "18", color = row[1] == "issues" and "#FFD58A" or "#EFF3FF",
                width = "332", height = tostring(row[3]), alignment = "UpperLeft", rectAlignment = "UpperLeft",
                offsetXY = "12 -" .. row[2]}))
        end
        table.insert(column, fieldNode("Toggle", {id = "lc_field_" .. player.color .. "_blocked",
            text = tr("Live不可（効果・手動）"), onValueChanged = "lovecaFieldBlockedChanged",
            isOn = fieldBlocked[player.color] and "true" or "false", width = "332", height = "26", fontSize = "17",
            textColor = "#EFF3FF", rectAlignment = "UpperLeft", offsetXY = "12 -502",
            tooltip = tr("禁止効果は手動で反映してください。ハート判定は現在の入力値で自動更新します。")}))
        table.insert(children, fieldNode("Panel", {width = "356", height = "696", color = "#303B4E",
            rectAlignment = "UpperLeft", offsetXY = (i == 1 and "16" or "388") .. " -56"}, column))
    end
    return {
        fieldNode("Button", {id = "lc_field_launcher", onClick = "openLovecaField", text = tr("盤面計算"), width = "160",
            height = "44", rectAlignment = "UpperLeft", offsetXY = "80 -134", fontSize = "18", color = "#38594F", textColor = "#FFFFFF"}),
        fieldNode("Panel", {id = "lc_field_panel", width = "760", height = "770", color = "#202735F5",
            rectAlignment = "UpperLeft", offsetXY = LOVECA_PANEL_OFFSET, allowDragging = "true", active = "false"}, children),
        fieldNode("Button", {id = "lc_field_initiative", onClick = "drawLovecaInitiative", text = tr("先攻・後攻を決定"),
            width = "160", height = "44", rectAlignment = "UpperLeft", offsetXY = "80 -242", fontSize = "18",
            color = "#66513D", textColor = "#FFFFFF", tooltip = tr("GM・観戦者を除き、着席者から先攻／後攻を選ぶ人をランダム抽選")}),
        fieldNode("Text", {id = "lc_field_initiative_result", text = initiativeText,
            width = "160", height = "58", rectAlignment = "UpperLeft", offsetXY = "80 -296", fontSize = "15",
            color = "#FFD58A", alignment = "UpperLeft"})
    }
end

-- Text-only labels sit at the hidden area's center without intercepting cards.
-- This area supports manual effects; it is not another statistics region.
function lovecaPrivateAreaLabel() end

local function fieldPrivateArea(mat, color)
    local buttons = mat.getButtons() or {}
    for i = #buttons, 1, -1 do
        if buttons[i].click_function == "lovecaPrivateAreaLabel" then mat.removeButton(buttons[i].index) end
    end
    local guid = FIELD_PRIVATE_ZONES[color]
    local zone = guid and getObjectFromGUID(guid)
    if not zone or zone.type ~= "Fog" or zone.getData().FogColor ~= color then return end
    local title = tr("非公開カード 処理エリア")
    local help = tr("非公開カードを確認・選択\n処理後は効果で指定された場所へ")
    zone.setName(title)
    zone.setDescription(help)
    local center = mat.positionToLocal(zone.positionToWorld({0, -0.5, 0}))
    for _, row in ipairs({{title, -0.08, 85, {0.12, 0.18, 0.25}},
        {help, 0.12, 40, {0.24, 0.28, 0.34}}}) do
        mat.createButton({click_function = "lovecaPrivateAreaLabel", function_owner = Global,
            label = row[1], position = {-center.x, center.y + 0.01, center.z + row[2]}, rotation = {0, 0, 0},
            width = 0, height = 0, font_size = row[3], font_color = row[4]})
    end
end

local function fieldOutline(mat, color)
    local lines = mat.getVectorLines() or {}
    -- Match the complete outline, not just its first point, to preserve unrelated lines.
    local kept = {}
    local r = FIELD_CHEER
    local expected = {{r.left, r.top}, {r.right, r.top}, {r.right, r.bottom}, {r.left, r.bottom}, {r.left, r.top}}
    for _, line in ipairs(lines) do
        local ours = line.points and #line.points == #expected
        if ours then
            for i, point in ipairs(line.points) do
                if math.abs((point.x or point[1] or 0) - expected[i][1]) > 0.0001
                    or math.abs((point.z or point[3] or 0) - expected[i][2]) > 0.0001 then ours = false end
            end
        end
        if not ours then table.insert(kept, line) end
    end
    table.insert(kept, {points = {{r.left, 0.115, r.top}, {r.right, 0.115, r.top},
        {r.right, 0.115, r.bottom}, {r.left, 0.115, r.bottom}, {r.left, 0.115, r.top}},
        color = {0.25, 0.65, 0.55}, thickness = 0.025, rotation = {0, 0, 0}})
    mat.setVectorLines(kept)
    for _, button in ipairs(mat.getButtons() or {}) do
        if button.click_function == "openLovecaField" then mat.removeButton(button.index) end
    end
    mat.createButton({click_function = "openLovecaField", function_owner = Global, label = tr("エール"),
        position = {-2.44, 0.13, -0.90}, rotation = {0, 0, 0}, width = 0, height = 0,
        font_size = 70, font_color = {0.2, 0.45, 0.38}})
    fieldPrivateArea(mat, color)
end

local function fieldSave()
    local sticky = {}
    for guid, entry in pairs(fieldSticky) do sticky[guid] = entry.sticky end
    return {version = 1, config = copy(fieldConfig), owners = copy(fieldOwners), sticky = sticky,
        marker_bindings = copy(fieldMarkerBindings), blocked = copy(fieldBlocked), initiative = initiativeWinner}
end

local function fieldLoad(state)
    if type(state) == "table" and state.version == 1 then
        if type(state.config) == "table" and type(state.config.players) == "table" then fieldConfig = copy(state.config) end
        if type(state.owners) == "table" then fieldOwners = copy(state.owners) end
        if type(state.marker_bindings) == "table" then fieldMarkerBindings = copy(state.marker_bindings) end
        for _, player in ipairs(fieldConfig.players) do
            fieldBlocked[player.color] = type(state.blocked) == "table" and state.blocked[player.color] == true
        end
        if type(state.initiative) == "string" and state.initiative ~= "Black" and state.initiative ~= "Grey" then
            initiativeWinner = state.initiative
            initiativeText = initiativeResult(initiativeWinner)
        end
        for guid, sticky in pairs(state.sticky or {}) do
            local object = getObjectFromGUID(guid)
            if object then fieldSticky[guid] = {object = object, sticky = sticky} end
        end
    end
    if LovecaFieldTimer then Wait.stop(LovecaFieldTimer) end
    fieldText = {}
    for _, player in ipairs(fieldConfig.players) do
        local mat = getObjectFromGUID(player.mat)
        if mat then fieldOutline(mat, player.color) end
    end
    Wait.frames(refreshLovecaField, 3)
    -- Polling also covers physics and programmatic moves that player events miss.
    LovecaFieldTimer = Wait.time(refreshLovecaField, 1, -1)
end

local function refreshFieldLanguage()
    fieldText = {}
    if initiativeWinner then initiativeText = initiativeResult(initiativeWinner)
    elseif initiativeText ~= "" then initiativeText = tr("抽選待ち\nプレイヤーが未着席") end
    for _, player in ipairs(fieldConfig.players) do
        local mat = getObjectFromGUID(player.mat)
        if mat then fieldOutline(mat, player.color) end
    end
end

function tryObjectEnterContainer(container, object)
    if isLovecaMarker(container) or isLovecaMarker(object) then return false end
    if not object or (object.type ~= "Card" and object.type ~= "Deck") then return true end
    for _, player in ipairs(fieldConfig.players) do
        local mat = getObjectFromGUID(player.mat)
        if mat then
            for _, candidate in ipairs({container, object}) do
                local section = fieldRegion(mat.positionToLocal(candidate.getPosition()))
                if section == "stage" or section == "live" or section == "energy" then return false end
            end
        end
    end
    return true
end

-- Adjustable marker creation and placement. Field calculation owns numeric effects.
local markerForm = {color = "White", resource = "heart01", value = "+1", target = "storage"}
local markerPanel = nil
local markerSnapshot = {}
-- Member lanes sit to each card's right (owner-facing local X decreases).
-- Live lanes sit in the gap between Live and member cards, never between mats.
local markerTargets = {
    {key = "member1", scope = "member", slot = 1, label = "メンバー 左", short = "M1", x = .397, z = -.03, w = .11, d = .60, cols = 1, rows = 4},
    {key = "member2", scope = "member", slot = 2, label = "メンバー 中", short = "M2", x = -.32, z = -.03, w = .11, d = .60, cols = 1, rows = 4},
    {key = "member3", scope = "member", slot = 3, label = "メンバー 右", short = "M3", x = -1.08, z = -.03, w = .11, d = .60, cols = 1, rows = 4},
    {key = "live1", scope = "live", slot = 1, label = "Live 左", short = "L1", x = .695, z = -.41, w = .64, d = .16, cellOffsetZ = -.025, cols = 4, rows = 1},
    {key = "live2", scope = "live", slot = 2, label = "Live 中", short = "L2", x = -.011, z = -.41, w = .64, d = .16, cellOffsetZ = -.025, cols = 4, rows = 1},
    {key = "live3", scope = "live", slot = 3, label = "Live 右", short = "L3", x = -.698, z = -.41, w = .64, d = .16, cellOffsetZ = -.025, cols = 4, rows = 1},
    {key = "storage", scope = "storage", label = "保管（無効）", x = -2.75, z = .45, w = .85, d = .70, cols = 5, rows = 4},
    {key = "score", scope = "score", label = "Live 合計 S", x = 1.55, z = -.72, w = .44, d = .32, cols = 3, rows = 2},
    {key = "cheer", scope = "cheer", label = "エール補正", x = 2.44, z = 1.05, w = 1.0, d = .24, cols = 6, rows = 1}
}
-- Remove exactly the prototype's old outlines when migrating a saved table.
local markerLegacyAreas = {
    {x = 1.16, z = -.03, w = .11, d = .60},
    {x = .695, z = -.41, w = .64, d = .13}, {x = -.011, z = -.41, w = .64, d = .13},
    {x = -.698, z = -.41, w = .64, d = .13},
    {x = .780, z = 1.82, w = .70, d = .35}, {x = .017, z = 1.82, w = .70, d = .35},
    {x = -.700, z = 1.82, w = .70, d = .35}, {x = .780, z = 1.34, w = .70, d = .35},
    {x = .017, z = 1.34, w = .70, d = .35}, {x = -.700, z = 1.34, w = .70, d = .35},
    {x = -2.45, z = .55, w = 1.10, d = .74}, {x = 1.44, z = 1.34, w = .48, d = .35},
    {x = 2.44, z = 1.34, w = 1.0, d = .35}
}

local function markerNode(tag, attributes, children)
    return {tag = tag, attributes = attributes, children = children}
end

local function markerTarget(key)
    for _, target in ipairs(markerTargets) do if target.key == key then return target end end
end

local function markerPlayers()
    local players = {}
    for _, sheet in ipairs(getLovecaFieldSnapshot()) do table.insert(players, {color = sheet.color, mat = sheet.mat}) end
    return players
end

local function markerPlayer(color)
    for _, player in ipairs(markerPlayers()) do if player.color == color then return player end end
end

local function markerCompatible(scope, resource)
    if type(resource) ~= "string" or not markerDefinition(resource) then return false end
    if scope == "storage" then return true end
    if scope == "score" then return resource == "score" end
    if scope == "member" then return resource == "blade" or string.match(resource, "^heart0[1-6]$") ~= nil end
    if scope == "live" then return resource == "score" or resource == "heart0" or string.match(resource, "^heart0[1-6]$") ~= nil end
    if scope == "cheer" then return resource ~= "blade" end
    return false
end

function isLovecaMarker(object)
    if not object or not object.memo or object.memo == "" then return false end
    -- Avoid decoding large card metadata in the container guard.
    if not string.find(object.memo, "loveca.marker", 1, true) then return false end
    local ok, data = pcall(JSON.decode, object.memo)
    return ok and type(data) == "table" and data.schema == "loveca.marker" and data.schema_version == 1
end

function showLovecaPanel(mode)
    markerPanel = mode
    for _, name in ipairs({"import", "field", "marker", "locale"}) do
        local panel = "lc_" .. name .. "_panel"
        if mode == name then
            UI.setAttribute(panel, "offsetXY", LOVECA_PANEL_OFFSET)
            UI.show(panel)
        else
            UI.hide(panel)
        end
        UI.show("lc_" .. name .. "_launcher")
    end
end

function closeLovecaPanel(mode)
    if markerPanel == mode then showLovecaPanel(nil) end
end

local function markerStatus(text)
    UI.setAttribute("lc_marker_status", "text", text)
end

local function markerFormRender()
    if UI.loading then return end
    for _, definition in ipairs(MARKER_RESOURCES) do
        UI.setAttribute("lc_marker_resource_" .. definition.key, "color", markerForm.resource == definition.key and "#54789B" or "#35445B")
    end
    for _, target in ipairs(markerTargets) do
        UI.setAttribute("lc_marker_target_" .. target.key, "color", markerForm.target == target.key and "#54789B" or "#35445B")
    end
    for _, color in ipairs({tr("White"), tr("Pink")}) do
        UI.setAttribute("lc_marker_player_" .. color, "color", markerForm.color == color and "#54789B" or "#35445B")
    end
    UI.setAttribute("lc_marker_value", "text", markerForm.value)
end

function openLovecaMarkers(player)
    if player and markerPlayer(player.color) then markerForm.color = player.color end
    showLovecaPanel("marker")
    markerFormRender()
end

function closeLovecaMarkers()
    closeLovecaPanel("marker")
end

function selectLovecaMarkerResource(player, value, id)
    local key = string.match(id, "^lc_marker_resource_(.+)$")
    if markerDefinition(key) then markerForm.resource = key; markerFormRender() end
end

function selectLovecaMarkerTarget(player, value, id)
    local key = string.match(id, "^lc_marker_target_(.+)$")
    if markerTarget(key) then markerForm.target = key; markerFormRender() end
end

function selectLovecaMarkerPlayer(player, value, id)
    local color = string.match(id, "^lc_marker_player_(.+)$")
    if markerPlayer(color) then markerForm.color = color; markerFormRender() end
end

function lovecaMarkerValueChanged(player, value)
    markerForm.value = value
end

local function markerInteger(text)
    if type(text) ~= "string" or not string.match(text, "^[%+%-]?%d+$") then return nil end
    local value = tonumber(text)
    if not value or value ~= math.floor(value) or math.abs(value) > 9007199254740991 then return nil end
    return value
end

function stepLovecaMarkerValue(player, value, id)
    local current = markerInteger(markerForm.value)
    if not current then markerStatus(tr("符号付き整数を入力してください。例：+2、-1")); return end
    markerForm.value = string.format("%+d", current + (id == "lc_marker_minus" and -1 or 1))
    markerFormRender()
end

local function markerCells(mat, target)
    local positions = {}
    for row = 1, target.rows do
        for col = 1, target.cols do
            table.insert(positions, mat.positionToWorld({x = target.x + (col - (target.cols + 1) / 2) * .16,
                y = .32, z = target.z + (target.cellOffsetZ or 0) + (row - (target.rows + 1) / 2) * .15}))
        end
    end
    return positions
end

local function markerVacant(mat, target)
    local mats, occupied = {}, {}
    for _, player in ipairs(markerPlayers()) do mats[player.mat] = true end
    for _, object in ipairs(getObjects()) do
        if not mats[object.getGUID()] and object.type ~= "Hand" then
            table.insert(occupied, {position = object.getPosition(), size = object.getBounds().size})
        end
    end
    for _, position in ipairs(markerCells(mat, target)) do
        local free = true
        for _, entry in ipairs(occupied) do
            if math.abs(entry.position.x - position.x) < entry.size.x / 2 + .30
                and math.abs(entry.position.z - position.z) < entry.size.z / 2 + .30 then free = false; break end
        end
        if free then return position end
    end
end

function createLovecaMarker(player, value, id)
    local definition, target = markerDefinition(markerForm.resource), markerTarget(markerForm.target)
    local number, owner = markerInteger(markerForm.value), markerPlayer(markerForm.color)
    if number == nil then markerStatus(tr("符号付き整数を入力してください。例：+2、-1")); return end
    if not definition or not target or not owner then markerStatus(tr("種類・配置先・プレイヤーを確認してください。")); return end
    if not markerCompatible(target.scope, definition.key) then
        markerStatus(string.format(tr("%s は %s の対象外です。"), tr(target.label), tr(definition.name)))
        return
    end
    local mat = getObjectFromGUID(owner.mat)
    if not mat then markerStatus(tr("プレイマットがありません。")); return end
    local position = markerVacant(mat, target)
    if not position then markerStatus(tr("配置先が埋まっています。マーカーやカードを移動してください。")); return end
    local data = {Name = "Custom_Tile", Memo = JSON.encode({schema = "loveca.marker", schema_version = 1,
        resource = definition.key, value = number}), LuaScript = MARKER_OBJECT_SCRIPT, LuaScriptState = "",
        CustomImage = {ImageURL = definition.image, ImageSecondaryURL = definition.image,
            ImageScalar = 1, WidthScale = 0,
            CustomTile = {Type = 2, Thickness = .20, Stackable = false, Stretch = true}},
        Transform = {posX = position.x, posY = position.y, posZ = position.z, rotX = 0,
            rotY = mat.getRotation().y, rotZ = 0, scaleX = .28, scaleY = .50, scaleZ = .28},
        ColorDiffuse = {r = 1, g = 1, b = 1, a = 1},
        Locked = false, Grid = false, Snap = false, Sticky = false, Hands = false,
        HideWhenFaceDown = false, Tooltip = true, DragSelectable = true}
    local ok, object = pcall(spawnObjectData, {data = data})
    if not ok then markerStatus(tr("作成できませんでした：") .. tostring(object)); return end
    markerStatus(tr(definition.name) .. " " .. string.format("%+d", number) .. " → " .. colorName(owner.color) .. " / " .. tr(target.label))
    return object.getGUID()
end

local function markerPlacement(object, players)
    local matches = {}
    for _, player in ipairs(players) do
        local mat = getObjectFromGUID(player.mat)
        if mat then
            local p = mat.positionToLocal(object.getPosition())
            if p.y >= -.15 and p.y <= 1.3 then
                for _, target in ipairs(markerTargets) do
                    if math.abs(p.x - target.x) <= target.w / 2 and math.abs(p.z - target.z) <= target.d / 2 then
                        table.insert(matches, {color = player.color, scope = target.scope, slot = target.slot, code = "placed"})
                    end
                end
            end
        end
    end
    local placement = #matches == 1 and matches[1]
        or {code = #matches == 0 and "unassigned" or "ambiguous", matches = matches}
    if object.held_by_color or object.resting == false then placement.code = "moving" end
    return placement
end

function refreshLovecaMarkers(players)
    -- UI callbacks pass a player object, not this internal configuration list.
    if type(players) ~= "table" or not players[1] then players = markerPlayers() end
    local snapshot, instances = {}, {}
    for _, object in ipairs(getObjects()) do
        if isLovecaMarker(object) then
            local data = JSON.decode(object.memo)
            local placement = markerPlacement(object, players)
            local valid = markerDefinition(data.resource) and type(data.value) == "number"
                and data.value == data.value and math.abs(data.value) <= 9007199254740991
                and data.value == math.floor(data.value)
                and type(data.instance_id) == "string" and data.instance_id ~= ""
            if not valid then placement.code = "invalid_data"
            elseif placement.code == "placed" and not markerCompatible(placement.scope, data.resource) then
                placement.code = "wrong_resource"
            end
            local entry = {guid = object.getGUID(), instance_id = data.instance_id,
                resource = data.resource, value = data.value, placement = placement}
            table.insert(snapshot, entry)
            if valid then
                instances[data.instance_id] = instances[data.instance_id] or {}
                table.insert(instances[data.instance_id], entry)
            end
        end
    end
    for _, entries in pairs(instances) do
        if #entries > 1 then
            for _, entry in ipairs(entries) do entry.placement.code = "duplicate" end
        end
    end
    for _, entry in ipairs(snapshot) do
        local object = getObjectFromGUID(entry.guid)
        if object and object.getLuaScript() == MARKER_OBJECT_SCRIPT then
            object.call("setMarkerPlacement", entry.placement)
        end
    end
    markerSnapshot = snapshot
    return snapshot
end

function getLovecaMarkerSnapshot()
    return markerSnapshot
end

function saveLovecaMarkers()
    return {version = 1, form = {color = markerForm.color, resource = markerForm.resource,
        value = markerForm.value, target = markerForm.target}}
end

function lovecaMarkerUI()
    local children = {
        markerNode("Text", {text = tr("数値マーカー"), fontSize = "22", color = "#FFFFFF", width = "380", height = "35",
            alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "20 -10"}),
        markerNode("Button", {text = "×", onClick = "closeLovecaMarkers", width = "34", height = "34", fontSize = "24",
            rectAlignment = "UpperRight", offsetXY = "-12 -8", color = "#3A4560", textColor = "#FFFFFF"})
    }
    for i, color in ipairs({tr("White"), tr("Pink")}) do
        table.insert(children, markerNode("Button", {id = "lc_marker_player_" .. color, text = colorName(color), onClick = "selectLovecaMarkerPlayer",
            width = "100", height = "34", fontSize = "18", textColor = "#FFFFFF", color = "#35445B",
            rectAlignment = "UpperLeft", offsetXY = (20 + (i - 1) * 112) .. " -58"}))
    end
    for i, definition in ipairs(MARKER_RESOURCES) do
        table.insert(children, markerNode("Button", {id = "lc_marker_resource_" .. definition.key,
            text = tr(definition.short), tooltip = tr(definition.name), onClick = "selectLovecaMarkerResource",
            width = "78", height = "38", fontSize = "18", textColor = "#FFFFFF", color = "#35445B",
            rectAlignment = "UpperLeft", offsetXY = (20 + (i - 1) % 5 * 87) .. " -" .. (112 + math.floor((i - 1) / 5) * 46)}))
    end
    table.insert(children, markerNode("Text", {text = tr("初期値"), width = "80", height = "34", fontSize = "18", color = "#FFFFFF",
        rectAlignment = "UpperLeft", offsetXY = "20 -218"}))
    table.insert(children, markerNode("InputField", {id = "lc_marker_value", text = markerForm.value,
        onValueChanged = "lovecaMarkerValueChanged", width = "140", height = "36", fontSize = "21", textColor = "#182233",
        rectAlignment = "UpperLeft", offsetXY = "104 -216"}))
    for i, item in ipairs({{"minus", "−1"}, {"plus", "+1"}}) do
        table.insert(children, markerNode("Button", {id = "lc_marker_" .. item[1], text = item[2], onClick = "stepLovecaMarkerValue",
            width = "72", height = "36", fontSize = "18", textColor = "#FFFFFF", color = "#35445B",
            rectAlignment = "UpperLeft", offsetXY = (262 + (i - 1) * 83) .. " -216"}))
    end
    table.insert(children, markerNode("Text", {text = tr("配置先"), width = "180", height = "28", fontSize = "18", color = "#FFFFFF",
        alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "20 -272"}))
    for i, target in ipairs(markerTargets) do
        table.insert(children, markerNode("Button", {id = "lc_marker_target_" .. target.key, text = tr(target.label),
            onClick = "selectLovecaMarkerTarget", width = "136", height = "36", fontSize = "16", color = "#35445B", textColor = "#FFFFFF",
            rectAlignment = "UpperLeft", offsetXY = (20 + (i - 1) % 3 * 144) .. " -" .. (308 + math.floor((i - 1) / 3) * 44)}))
    end
    table.insert(children, markerNode("Button", {text = tr("マーカー作成"), onClick = "createLovecaMarker", width = "260", height = "40",
        fontSize = "20", color = "#3C655A", textColor = "#FFFFFF", rectAlignment = "UpperCenter", offsetXY = "0 -452"}))
    table.insert(children, markerNode("Text", {id = "lc_marker_status", text = tr("必要なマーカーだけ作成できます。"), width = "430", height = "54",
        fontSize = "16", color = "#FFD58A", alignment = "UpperLeft", rectAlignment = "UpperLeft", offsetXY = "20 -510"}))
    table.insert(children, markerNode("Text", {text = tr("図柄を移動、外側の数値：左 +1 ／ 右 −1\n補正欄に置くと盤面計算に反映（保管は無効）\n交代時は保管へ戻し、新しい対象の欄に置き直す"), width = "430", height = "76",
        fontSize = "17", color = "#D5DDEA", alignment = "UpperLeft", rectAlignment = "UpperLeft", offsetXY = "20 -574"}))
    return {
        markerNode("Button", {id = "lc_marker_launcher", text = tr("数値マーカー"), onClick = "openLovecaMarkers", width = "160", height = "44",
            rectAlignment = "UpperLeft", offsetXY = "80 -188", fontSize = "18", color = "#675438", textColor = "#FFFFFF"}),
        markerNode("Panel", {id = "lc_marker_panel", width = "470", height = "666", rectAlignment = "UpperLeft", offsetXY = LOVECA_PANEL_OFFSET,
            color = "#202735F5", allowDragging = "true", active = "false"}, children)
    }
end

local function markerDrawAreas()
    for _, player in ipairs(markerPlayers()) do
        local mat = getObjectFromGUID(player.mat)
        if mat then
            local kept = {}
            for _, line in ipairs(mat.getVectorLines() or {}) do
                local first = line.points and line.points[1]
                local ours = false
                if first and line.points and #line.points == 5 then
                    local areas = {}
                    for _, area in ipairs(markerTargets) do table.insert(areas, area) end
                    for _, area in ipairs(markerLegacyAreas) do table.insert(areas, area) end
                    for _, target in ipairs(areas) do
                        local x, z, w, d = target.x, target.z, target.w / 2, target.d / 2
                        local corners = {{x - w, z - d}, {x + w, z - d}, {x + w, z + d}, {x - w, z + d}, {x - w, z - d}}
                        local matches = true
                        for i, point in ipairs(line.points) do
                            if math.abs((point.x or point[1] or 0) - corners[i][1]) > .0001
                                or math.abs((point.z or point[3] or 0) - corners[i][2]) > .0001 then matches = false end
                        end
                        if matches then ours = true end
                    end
                end
                if not ours then table.insert(kept, line) end
            end
            local buttons = mat.getButtons() or {}
            -- Remove in reverse order to keep native indices valid.
            for i = #buttons, 1, -1 do
                if buttons[i].click_function == "openLovecaMarkers" then mat.removeButton(buttons[i].index) end
            end
            for _, target in ipairs(markerTargets) do
                local x, z, w, d = target.x, target.z, target.w / 2, target.d / 2
                local color = target.scope == "member" and {.35, .48, .72}
                    or target.scope == "live" and {.72, .47, .25} or {.35, .57, .50}
                table.insert(kept, {points = {{x - w, .125, z - d}, {x + w, .125, z - d},
                    {x + w, .125, z + d}, {x - w, .125, z + d}, {x - w, .125, z - d}},
                    color = color, thickness = .012, rotation = {0, 0, 0}})
                local labelX, labelZ = x, z + d + .06
                -- Center the label inside its own Live frame, between the two
                -- middle value badges. Do not place it beside the next frame.
                if target.scope == "live" then labelX, labelZ = x, z + d - .025 end
                mat.createButton({click_function = "openLovecaMarkers", function_owner = Global,
                    label = tr(target.short or target.label), tooltip = tr(target.label),
                    -- TTS button canvases mirror local X versus vector lines.
                    -- Verified on both mats: negate X only, keep local Z.
                    position = {-labelX, .14, labelZ}, rotation = {0, 0, 0}, width = 0, height = 0,
                    font_size = target.short and 30 or 38, font_color = {.12, .20, .30}})
            end
            mat.setVectorLines(kept)
        end
    end
end

local function refreshMarkerLanguage()
    markerDrawAreas()
    markerFormRender()
    for _, object in ipairs(getObjects()) do
        if isLovecaMarker(object) and object.getLuaScript() == MARKER_OBJECT_SCRIPT then
            object.call("setMarkerLanguage", {language = LANGUAGE})
        end
    end
end

function initializeLovecaMarkers(state)
    if state and state.version == 1 and type(state.form) == "table" then
        local form = state.form
        if markerDefinition(form.resource) then markerForm.resource = form.resource end
        if markerTarget(form.target) then markerForm.target = form.target end
        if type(form.value) == "string" then markerForm.value = form.value end
        if form.color == "White" or form.color == "Pink" then markerForm.color = form.color end
    end
    if LovecaMarkerTimer then Wait.stop(LovecaMarkerTimer) end
    Wait.frames(function() refreshMarkerLanguage(); refreshLovecaMarkers() end, 5)
    -- The field timer scans cards and markers together; no second stale poll.
end

function installLovecaMarkerUI()
    local active = UI.getAttribute("lc_import_panel", "active") == "true" and "import"
        or UI.getAttribute("lc_field_panel", "active") == "true" and "field"
        or UI.getAttribute("lc_marker_panel", "active") == "true" and "marker" or nil
    local ui = {}
    for _, node in ipairs(UI.getXmlTable()) do
        if not string.match((node.attributes or {}).id or "", "^lc_marker_") then table.insert(ui, node) end
    end
    for _, node in ipairs(lovecaMarkerUI()) do table.insert(ui, node) end
    UI.setXmlTable(ui)
    Wait.frames(function() showLovecaPanel(active); markerFormRender() end, 5)
end

-- Runtime batch importer. Shared helpers and JSON data are prepended by the build tool.
-- A line is: exact card number, one space, positive integer quantity.
-- UI locale affects presentation only; source identity, tags and stats stay unchanged.
local API_ROOT = "https://llofficial-cardgame.com/manage/card-list-user/"
-- The official host returns 404 to UnityPlayer clients. Verified in the running TTS engine.
-- WebRequest.custom allows us to provide an accepted User-Agent for these JSON requests.
local API_HEADERS = {
    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/130.0.0.0 Safari/537.36",
    ["Accept"] = "application/json",
    ["Referer"] = "https://llofficial-cardgame.com/cardlist/"
}
local MAX_CARDS = 200 -- Import size guard, not a deck-building legality rule.
local MAX_TYPES = 60
local IMPORT_ORIGIN = {x = 0, y = 3, z = 12}
local DEFAULT_LIST = "PL!-bp3-021-SRL 2\nPL!-pb2-000-R 4\nPL!S-PR-034-PR+ 6"
local importText = DEFAULT_LIST
local batchSequence = 0
local running = false
local sourceCache = {}
local activeJob = nil
local importStatusText = nil
local SERIES = {
    ["μ's"] = "ラブライブ！", ["Aqours"] = "ラブライブ！サンシャイン!!",
    ["虹ヶ咲"] = "ラブライブ！虹ヶ咲学園スクールアイドル同好会",
    ["Liella!"] = "ラブライブ！スーパースター!!",
    ["蓮ノ空"] = "ラブライブ！蓮ノ空女学院スクールアイドルクラブ",
    ["IKZ"] = "イキヅライブ！ LOVELIVE! BLUEBIRD"
}

local function normalizeNumber(number)
    return normalizeCardNumber(number)
end

local function trim(text)
    return (string.gsub(string.gsub(text, "^%s+", ""), "%s+$", ""))
end

local function status(text)
    importStatusText = text
    UI.setAttribute("lc_import_status", "text", text)
    print("[LoveCa] " .. text)
end

local function finishJob(message)
    -- Failed or timed-out imports must not leave suspended cards locked in place.
    if activeJob then
        for _, entry in ipairs(activeJob.objects) do
            if entry.timer then Wait.stop(entry.timer) end
            if entry.object and not entry.object.isDestroyed() then entry.object.setLock(false) end
        end
    end
    activeJob = nil
    running = false
    UI.setAttribute("lc_import_button", "interactable", "true")
    status(message)
end

local function parseList(text)
    local entries, byNumber, total, lineNumber = {}, {}, 0, 0
    text = normalizeCardNumber(text)
    text = string.gsub(text, "\r", "")
    for line in string.gmatch(text .. "\n", "(.-)\n") do
        lineNumber = lineNumber + 1
        line = trim(line)
        if line ~= "" and string.sub(line, 1, 1) ~= "#" then
            local number, countText = string.match(line, "^(%S+)%s+(%d+)$")
            local count = tonumber(countText)
            if not number or not count or count < 1 or count > MAX_CARDS then
                error(tr("行 ") .. lineNumber .. tr("：カード番号と 1～") .. MAX_CARDS .. tr(" の枚数を入力してください。"))
            end
            if not string.match(number, "^[%w!%+%-]+$")
                and not string.match(normalizeNumber(number), "^[%w!%+%-]+$") then
                error(tr("行 ") .. lineNumber .. tr("：カード番号の形式が正しくありません。"))
            end
            local key = normalizeNumber(number)
            if not byNumber[key] then
                byNumber[key] = {number = number, count = 0}
                table.insert(entries, byNumber[key])
            end
            byNumber[key].count = byNumber[key].count + count
            total = total + count
            if total > MAX_CARDS then error(tr("一度のインポートは ") .. MAX_CARDS .. tr(" 枚までです。")) end
            if #entries > MAX_TYPES then error(tr("一度のインポートは ") .. MAX_TYPES .. tr(" 種類までです。")) end
        end
    end
    if total == 0 then error(tr("カードリストが空です。")) end
    return entries, total
end

local function requestJSON(url, callback)
    local completed, request, timer = false, nil, nil
    local function complete(data, message)
        if completed then return end
        completed = true
        if timer then Wait.stop(timer) end
        callback(data, message)
    end
    request = WebRequest.custom(url, "GET", true, "", API_HEADERS, function(response)
        local contentType = response.getResponseHeader("Content-Type") or ""
        if response.is_error or response.response_code ~= 200 then
            print("[LoveCa HTTP] GET " .. url .. " / status=" .. tostring(response.response_code)
                .. " / Content-Type=" .. contentType .. " / error=" .. tostring(response.error or ""))
            complete(nil, tr("通信エラー（HTTP ") .. tostring(response.response_code) .. "）："
                .. tostring(response.error or "") .. " / URL: " .. url)
            return
        end
        if not string.find(string.lower(contentType), "application/json", 1, true) then
            complete(nil, tr("カード API が JSON を返しませんでした（") .. contentType .. "） / URL: " .. url)
            return
        end
        local ok, data = pcall(JSON.decode, response.text)
        if not ok or type(data) ~= "table" then
            complete(nil, tr("カード API が有効な JSON を返しませんでした / URL: ") .. url)
            return
        end
        -- TTS JSON.decode expands \u escapes into UTF-8 byte strings, while script/UI
        -- literals are native Unicode. Normalize names, types, icons and keys together.
        local normalized, nativeData = pcall(nativeJSONText, data)
        if not normalized then
            complete(nil, tr("カード API の文字コードを変換できませんでした / URL: ") .. url)
            return
        end
        complete(nativeData)
    end)
    timer = Wait.time(function()
        if completed then return end
        if request then request.dispose() end
        complete(nil, tr("カード API の応答がタイムアウトしました / URL: ") .. url)
    end, 25)
end

local function utf8Character(code)
    return unicodeCharacter(code)
end

local function decodeHTML(text)
    local entities = {amp = "&", lt = "<", gt = ">", quot = '"', apos = "'", nbsp = " "}
    return (string.gsub(text, "&([^;]+);", function(entity)
        local hex = string.match(entity, "^#[xX]([%da-fA-F]+)$")
        local decimal = string.match(entity, "^#(%d+)$")
        local code = hex and tonumber(hex, 16) or (decimal and tonumber(decimal))
        return code and utf8Character(code) or entities[entity] or ("&" .. entity .. ";")
    end))
end

local function abilityFrom(raw)
    if not raw.text_html or raw.text_html == "" then
        return raw.text and raw.text ~= "-" and raw.text or ""
    end
    local text = string.gsub(raw.text_html, "<[iI][mM][gG]%s[^>]*>", function(tag)
        local src = string.match(tag, 'src%s*=%s*"([^"]+)"') or string.match(tag, "src%s*=%s*'([^']+)'")
        local alt = string.match(tag, 'alt%s*=%s*"([^"]*)"') or string.match(tag, "alt%s*=%s*'([^']*)'") or ""
        if not src then error(tr("技能アイコンに画像パスがありません。")) end
        return "{{" .. (string.match(src, "([^/]+)$") or src) .. "|" .. alt .. "}}"
    end)
    text = string.gsub(text, "<[bB][rR]%s*/?>", "\n")
    text = string.gsub(text, "<[^>]+>", "")
    text = trim(decodeHTML(text))
    -- Some official records escape their line-break markup (e.g. Eutopia).
    -- Decode it as a line break too, without changing any source wording.
    text = string.gsub(text, "<[bB][rR]%s*/?>[ \t]*\r?\n?", "\n")
    return text ~= "-" and text or ""
end

local function numericField(raw, field, absentValue)
    if absentValue ~= nil and (raw[field] == nil or raw[field] == "" or raw[field] == "-") then
        return absentValue
    end
    local value = tonumber(raw[field])
    if not value or value < 0 or value ~= math.floor(value) then
        error(tr("数値フィールドが不正です：") .. field)
    end
    return value
end

local function cheerHearts(text)
    local result = {}
    local colors = {{"桃", "01"}, {"赤", "02"}, {"黄", "03"},
        {"緑", "04"}, {"青", "05"}, {"紫", "06"}, {"無", "07"}, {"ALL", "all"}}
    for _, color in ipairs(colors) do
        for count in string.gmatch(text or "", color[1] .. "(%d+)") do
            local key = color[2] == "all" and "b_all" or ("b_heart" .. color[2])
            result[key] = (result[key] or 0) + tonumber(count)
        end
    end
    return result
end

local function convertOfficial(data, requested, detailURL)
    local raw = data.card
    if type(raw) ~= "table" or not raw.card_number or not raw.picture then
        error(tr("カードの詳細データが不足しています。"))
    end
    if normalizeNumber(raw.card_number) ~= normalizeNumber(requested) then
        error(tr("検索結果と詳細のカード番号が一致しません。"))
    end
    if raw.card_kind ~= "ライブ" and raw.card_kind ~= "メンバー" and raw.card_kind ~= "エネルギー" then
        error(tr("未対応のカード種類です：") .. tostring(raw.card_kind))
    end
    if string.sub(raw.picture, 1, 1) == "/" or string.find(raw.picture, "..", 1, true)
        or string.find(raw.picture, "\\", 1, true) then error(tr("カード画像パスが不正です。")) end
    local products = {}
    for _, product in ipairs(data.expansions or {}) do
        if product.name and product.name ~= "" then table.insert(products, product.name) end
    end
    local card = {card_no = raw.card_number, name = raw.card_name or "", rare = raw.rare,
        type = raw.card_kind, product = table.concat(products, " / "),
        img = "https://llofficial-cardgame.com/wordpress/wp-content/images/cardlist/" .. raw.picture,
        _img = "img/cards/" .. raw.picture, ability = abilityFrom(raw),
        faq = copy(data.faqs or {}), rare_list = copy(data.relationCards or {}),
        source = {url = detailURL, kind = "official_api"}, official = copy(raw)}
    local titles = {}
    for title in string.gmatch(raw.work_title or "", "[^/]+") do
        title = trim(title)
        if title ~= "" and title ~= "-" then table.insert(titles, SERIES[title] or title) end
    end
    card.series = table.concat(titles, "\n")
    if raw.unit_name and raw.unit_name ~= "-" then card.unit = raw.unit_name end
    local hearts = {}
    for index = 0, 6 do
        local key = index == 0 and "heart0" or string.format("heart%02d", index)
        local value = (raw[key] == nil or raw[key] == "") and 0 or numericField(raw, key)
        if value ~= 0 then hearts[key] = value end
    end
    if card.type == "メンバー" then
        card.cost = numericField(raw, "cost")
        -- The official API uses '-' for members with no printed Blade icons (verified on card 30).
        card.blade = numericField(raw, (raw.blade and raw.blade ~= "" and raw.blade ~= "-") and "blade" or "attack", 0)
        card.base_heart = hearts
        card.blade_heart = cheerHearts(raw.blade_heart)
    elseif card.type == "ライブ" then
        card.score = numericField(raw, "blade_heart")
        card.need_heart = hearts
        card.blade_heart = cheerHearts(raw.blade or raw.attack)
        card.special_heart = {}
        for _, item in ipairs({{"スコア", "score"}, {"ドロー", "draw"}}) do
            for count in string.gmatch(raw.cost or "", item[1] .. "(%d*)") do
                card.special_heart[item[2]] = (card.special_heart[item[2]] or 0) + (tonumber(count) or 1)
            end
        end
    end
    baseCardNumber(card) -- Reject malformed rarity suffixes before creating any objects.
    return card
end

local function fetchSource(number, callback)
    local key = normalizeNumber(number)
    if sourceCache[key] then callback(sourceCache[key]); return end
    -- Search by base number, then require the exact variant locally. This also supports
    -- ASCII '+' input when the official card number contains the full-width '＋'.
    local searchNumber = string.match(number, "^(.*)%-[^%-]+$") or number
    local url = API_ROOT .. "list?keyword=" .. escapeURL(searchNumber)
        .. "&keyword_type=no&page=1&per_page=100&sort=no"
    requestJSON(url, function(data, message)
        if not data then callback(nil, message); return end
        local selected = nil
        for _, item in ipairs(data.items or {}) do
            if item.card_number and normalizeNumber(item.card_number) == key then selected = item; break end
        end
        if not selected or not selected.id then callback(nil, tr("該当するカード番号がありません：") .. number); return end
        local detailURL = API_ROOT .. "detail?id=" .. escapeURL(tostring(selected.id))
        requestJSON(detailURL, function(detail, detailError)
            if not detail then callback(nil, detailError); return end
            local ok, card = pcall(convertOfficial, detail, number, detailURL)
            if not ok then callback(nil, tostring(card)); return end
            sourceCache[key] = card
            callback(card)
        end)
    end)
end

local function recoveredSequence()
    local largest = batchSequence
    local function inspect(data)
        if data.Memo and data.Memo ~= "" then
            local ok, memo = pcall(decodeJSON, data.Memo)
            if ok and type(memo) == "table" and memo.schema == "loveca.card" and memo.import then
                largest = math.max(largest, tonumber(memo.import.sequence) or 0)
            end
        end
        for _, child in ipairs(data.ContainedObjects or {}) do inspect(child) end
    end
    for _, object in ipairs(getObjects()) do inspect(object.getData()) end
    return largest
end

local function importPositions(count)
    local positions = {}
    local occupied = {}
    for _, object in ipairs(getObjects()) do
        if object.type == "Card" or object.type == "Deck" then
            table.insert(occupied, object.getPosition())
        end
    end
    -- Keep new batches away from old cards/decks, which could otherwise merge on landing.
    for _, offset in ipairs({{-4, -8}, {4, -8}, {-4, -16}, {4, -16},
        {-4, 0}, {4, 0}, {-4, -24}, {4, -24}}) do
        local position = {x = IMPORT_ORIGIN.x + offset[1], y = IMPORT_ORIGIN.y,
            z = IMPORT_ORIGIN.z + offset[2]}
        local free = true
        for _, existing in ipairs(occupied) do
            if math.abs(existing.x - position.x) < 4.5 and math.abs(existing.z - position.z) < 6 then
                free = false
                break
            end
        end
        if free then
            table.insert(positions, position)
            if #positions == count then return positions end
        end
    end
    error(tr("インポート用の空きスペースがありません。中央のカードを移動してから再実行してください。"))
end

local function buildImportObjects(job)
    local groups = {main = {cards = {}, definitions = {}, ids = {}},
        energy = {cards = {}, definitions = {}, ids = {}}}
    local definitionIDs, nextDefinition = {}, 0
    local reservedGUIDs = {}
    local function reserveExisting(data)
        if data.GUID and data.GUID ~= "" then reservedGUIDs[data.GUID] = true end
        for _, child in ipairs(data.ContainedObjects or {}) do reserveExisting(child) end
    end
    for _, object in ipairs(getObjects()) do reserveExisting(object.getData()) end
    local function cardGUID()
        local guid
        repeat guid = string.format("%06x", math.random(0, 0xFFFFFF)) until not reservedGUIDs[guid]
        reservedGUIDs[guid] = true
        return guid
    end
    job.expected = {}
    for index, entry in ipairs(job.copies) do
        local sourceKey = normalizeNumber(entry.source.card_no)
        if not definitionIDs[sourceKey] then
            nextDefinition = nextDefinition + 1
            definitionIDs[sourceKey] = nextDefinition
        end
        local card = buildCardData(entry.source)
        card.import = {batch_id = job.id, sequence = batchSequence, copy_index = index,
            requested_count = entry.count, pile = entry.pile}
        card.instance_id = job.id .. "." .. index
        job.expected[card.instance_id] = {card_no = sourceKey, pile = entry.pile, index = index}
        local definitionID = definitionIDs[sourceKey]
        local data = cardObjectData(card, definitionID)
        data.GUID = cardGUID() -- Contained cards need their own GUID before the deck is created.
        local groupData = groups[entry.pile]
        table.insert(groupData.cards, data)
        table.insert(groupData.ids, data.CardID)
        groupData.definitions[tostring(definitionID)] = data.CustomDeck[tostring(definitionID)]
    end
    local plans = {}
    for _, pile in ipairs({"main", "energy"}) do
        local groupData = groups[pile]
        local count = #groupData.cards
        if count > 0 then
            local data
            if count == 1 then
                data = groupData.cards[1]
            else
                data = {
                    Name = "DeckCustom", DeckIDs = groupData.ids,
                    ContainedObjects = groupData.cards, CustomDeck = groupData.definitions,
                    Transform = {posX = 0, posY = 0, posZ = 0, rotX = 0, rotY = 180, rotZ = 0,
                        scaleX = CARD_SCALE[1], scaleY = CARD_SCALE[2], scaleZ = CARD_SCALE[3]},
                    Nickname = pile == "main" and tr("メインデッキ") or tr("エネルギーデッキ"),
                    Description = tr("インポート ") .. job.id .. " / " .. count .. tr(" 枚"),
                    Memo = encodeJSON({schema = "loveca.deck", schema_version = 1,
                        batch_id = job.id, sequence = batchSequence, pile = pile, count = count}),
                    ColorDiffuse = {r = 0.713235259, g = 0.713235259, b = 0.713235259, a = 1},
                    SidewaysCard = false, Grid = true, Snap = true, Sticky = true,
                    Tooltip = true, Hands = true, HideWhenFaceDown = true,
                    DragSelectable = true, LuaScript = "", LuaScriptState = "", XmlUI = ""
                }
            end
            data.Locked = true
            table.insert(plans, {data = data, pile = pile, count = count})
        end
    end
    local positions = importPositions(#plans)
    for index, plan in ipairs(plans) do
        plan.position = positions[index]
        plan.data.Transform.posX = plan.position.x
        plan.data.Transform.posY = plan.position.y + 6
        plan.data.Transform.posZ = plan.position.z
    end
    return plans
end

local function auditImport(job)
    local seen, guids, count, piles = {}, {}, 0, {main = 0, energy = 0}
    local function inspect(data, pile)
        if data.Name == "CardCustom" or data.Name == "Card" then
            local ok, card = pcall(decodeJSON, data.Memo or "")
            if not ok or type(card) ~= "table" or card.schema ~= "loveca.card" then
                error(tr("カードのメタデータが不足しています。"))
            end
            -- Scan the whole current batch, including any extra objects outside the planned roots.
            if not card.import or card.import.batch_id ~= job.id then return end
            local expected = job.expected[card.instance_id]
            if not expected or seen[card.instance_id] then
                error(tr("カードの個体番号が重複、または予定外です：") .. tostring(card.instance_id))
            end
            pile = pile or card.import.pile
            if card.import.pile ~= pile or expected.pile ~= pile or normalizeNumber(card.card_no) ~= expected.card_no
                or card.import.copy_index ~= expected.index then error(tr("生成したカードがリストと一致しません。")) end
            if not data.GUID or data.GUID == "" then error(tr("カード GUID がありません。")) end
            if guids[data.GUID] then error(tr("カード GUID が重複しています。")) end
            guids[data.GUID] = true
            seen[card.instance_id] = true
            count = count + 1
            piles[pile] = piles[pile] + 1
        end
        if data.Memo and data.Name == "DeckCustom" then
            local ok, memo = pcall(decodeJSON, data.Memo)
            if ok and type(memo) == "table" and memo.schema == "loveca.deck" and memo.batch_id == job.id then
                pile = memo.pile
            end
        end
        for _, child in ipairs(data.ContainedObjects or {}) do inspect(child, pile) end
    end
    for _, root in ipairs(job.objects) do
        local quantity = root.object.type == "Deck" and root.object.getQuantity() or 1
        if quantity ~= root.count then error(tr("牌組の枚数が一致しません：予定 ") .. root.count .. tr(" / 実際 ") .. quantity) end
    end
    for _, object in ipairs(getObjects()) do inspect(object.getData()) end
    if count ~= job.total then
        error(tr("生成枚数が一致しません：予定 ") .. job.total .. tr(" / 実際 ") .. count)
    end
    for instance in pairs(job.expected) do
        if not seen[instance] then error(tr("予定したカードがありません：") .. instance) end
    end
    return piles
end

local function completeSpawn(job)
    if job.finishing then return end
    job.finishing = true
    status(tr("画像と生成枚数を確認しています：") .. job.total .. tr(" 枚"))
    Wait.condition(function()
        if activeJob ~= job then return end
        local ok, piles = pcall(auditImport, job)
        if not ok then
            finishJob(tr("生成結果の確認に失敗：") .. tostring(piles) .. tr("。生成物を確認してください。"))
            return
        end
        for _, root in ipairs(job.objects) do
            root.object.setPosition({root.position.x, root.position.y, root.position.z})
        end
        finishJob(tr("インポート完了：メイン ") .. piles.main .. tr(" / エネルギー ") .. piles.energy
            .. tr(" / 合計 ") .. job.total .. tr(" 枚 / ポイント ") .. job.points
            .. "（" .. POINT_SYSTEM.effective_date .. tr(" 版）。"))
    end, function()
        for _, root in ipairs(job.objects) do
            local object = root.object
            if not object or object.isDestroyed() then return false end
            if object.loading_custom or object.getBoundsNormalized().size.x <= 0 then return false end
        end
        return true
    end, 60, function()
        if activeJob == job then
            finishJob(tr("牌組は生成済みです。画像読み込みが未完了のため枚数の最終確認を中止しました。"))
        end
    end)
end

local function spawnCopies(job)
    local ok, plans = pcall(buildImportObjects, job)
    if not ok then finishJob(tostring(plans)); return end
    job.pending = #plans
    for index, plan in ipairs(plans) do
        if activeJob ~= job then return end
        local root = {pile = plan.pile, count = plan.count, position = plan.position, completed = false}
        job.objects[index] = root
        local spawned, object = pcall(spawnObjectData, {data = plan.data,
            callback_function = function(created)
                -- A repeated completion must never advance the job or assign another identity.
                if root.completed then return end
                root.completed = true
                if root.timer then Wait.stop(root.timer) end
                if activeJob ~= job then return end
                root.object = created
                job.pending = job.pending - 1
                if job.pending == 0 then completeSpawn(job) end
            end})
        if not spawned then finishJob(tr("生成途中で停止：") .. tostring(object)); return end
        root.object = root.object or object
        if not root.completed then
            root.timer = Wait.time(function()
                if activeJob == job and not root.completed then
                    finishJob(tr("牌組の生成がタイムアウトしました。生成済みの物体は保持されています。"))
                end
            end, 30)
        end
    end
end

function openLovecaImporter(player, value, id)
    showLovecaPanel("import")
end

function closeLovecaImporter(player, value, id)
    -- Hide only: keep the input, status, and any running import intact.
    closeLovecaPanel("import")
end

function lovecaImportChanged(player, value, id)
    importText = normalizeCardNumber(value)
end

function importCards(player, value, id)
    if running then return end
    local ok, entries, total = pcall(parseList, importText)
    if not ok then status(tostring(entries)); return end
    running = true
    UI.setAttribute("lc_import_button", "interactable", "false")
    local job = {total = total, copies = {}, objects = {}, points = 0}
    activeJob = job
    local index = 0
    local function resolveNext()
        if activeJob ~= job then return end
        index = index + 1
        if index > #entries then
            batchSequence = recoveredSequence() + 1
            job.id = "loveca.import." .. batchSequence
            status(tr("カードを生成しています：") .. total .. tr(" 枚"))
            spawnCopies(job)
            return
        end
        local entry = entries[index]
        status(tr("確認中 ") .. index .. "/" .. #entries .. "：" .. entry.number)
        fetchSource(entry.number, function(source, message)
            if activeJob ~= job then return end
            if not source then finishJob(message .. tr("。カードは生成していません。")); return end
            local built, card = pcall(buildCardData, source)
            if not built then finishJob(tostring(card) .. tr("。カードは生成していません。")); return end
            job.points = job.points + card.loveca_point * entry.count
            for _ = 1, entry.count do
                table.insert(job.copies, {source = source, count = entry.count,
                    pile = source.type == "エネルギー" and "energy" or "main"})
            end
            resolveNext()
        end)
    end
    resolveNext()
end

function onSave()
    return encodeJSON({schema = "loveca.importer", version = 1,
        input = importText, batch_sequence = batchSequence, language = LANGUAGE, locale_version = 1, field = fieldSave(), markers = saveLovecaMarkers()})
end

local function localeUI()
    local children = {
        fieldNode("Text", {text = tr("言語を選択"), fontSize = "22", color = "#FFFFFF", width = "360", height = "35",
            rectAlignment = "UpperLeft", alignment = "MiddleLeft", offsetXY = "20 -10"}),
        fieldNode("Button", {text = "×", onClick = "closeLovecaLanguage", width = "34", height = "34", fontSize = "24",
            rectAlignment = "UpperRight", offsetXY = "-12 -8", color = "#3A4560", textColor = "#FFFFFF"}),
        fieldNode("Text", {text = tr("全員に適用・保存時に記録"), fontSize = "17", color = "#D5DDEA", width = "430", height = "28",
            rectAlignment = "UpperLeft", alignment = "MiddleLeft", offsetXY = "20 -54"})
    }
    for i, option in ipairs({{"zh", "中文"}, {"ja", "日本語"}, {"en", "English"}}) do
        table.insert(children, fieldNode("Button", {id = "lc_locale_" .. option[1], text = option[2],
            onClick = "selectLovecaLanguage", width = "136", height = "46", fontSize = "21", textColor = "#FFFFFF",
            color = LANGUAGE == option[1] and "#3C7565" or "#35445B", rectAlignment = "UpperLeft",
            offsetXY = (20 + (i - 1) * 147) .. " -104"}))
    end
    return {
        fieldNode("Button", {id = "lc_locale_launcher", text = tr("言語"), onClick = "openLovecaLanguage",
            width = "160", height = "44", rectAlignment = "UpperLeft", offsetXY = "80 -370", fontSize = "18",
            color = "#465571", textColor = "#FFFFFF"}),
        fieldNode("Panel", {id = "lc_locale_panel", width = "470", height = "180", rectAlignment = "UpperLeft",
            offsetXY = LOVECA_PANEL_OFFSET, color = "#202735F5", allowDragging = "true", active = "false"}, children)
    }
end

local localeGeneration = 0
local function installLovecaUI(active)
    -- Replace only our roots; retain unrelated UI and its custom assets.
    local ui = {}
    for _, node in ipairs(UI.getXmlTable()) do
        local id = (node.attributes or {}).id or ""
        if not string.match(id, "^lc_import_") and not string.match(id, "^lc_field_")
            and not string.match(id, "^lc_marker_") and not string.match(id, "^lc_locale_") then table.insert(ui, node) end
    end
    table.insert(ui, fieldNode("Button", {id = "lc_import_launcher", onClick = "openLovecaImporter", text = tr("デッキ導入"),
        width = "160", height = "44", rectAlignment = "UpperLeft", offsetXY = "80 -80", fontSize = "18",
        color = "#324268", textColor = "#FFFFFF", tooltip = tr("デッキ導入")}))
    table.insert(ui, fieldNode("Panel", {id = "lc_import_panel", width = "470", height = "410", rectAlignment = "UpperLeft",
        offsetXY = LOVECA_PANEL_OFFSET, color = "#202735EE", allowDragging = "true", active = "false"}, {
        fieldNode("Text", {text = tr("LoveCa デッキ導入"), fontSize = "22", color = "#FFFFFF", width = "380", height = "35",
            alignment = "MiddleLeft", rectAlignment = "UpperLeft", offsetXY = "20 -8"}),
        fieldNode("Button", {id = "lc_import_close", onClick = "closeLovecaImporter", text = "×", width = "34", height = "34",
            rectAlignment = "UpperRight", offsetXY = "-12 -8", fontSize = "24", color = "#3A4560", textColor = "#FFFFFF", tooltip = tr("閉じる")}),
        fieldNode("Text", {text = tr("カード番号 枚数（1行1種類）"), fontSize = "16", color = "#FFFFFF",
            rectAlignment = "UpperCenter", offsetXY = "0 -60", height = "25"}),
        fieldNode("InputField", {id = "lc_import_input", onValueChanged = "lovecaImportChanged", lineType = "MultiLineNewLine",
            fontSize = "18", characterLimit = "12000", width = "430", height = "180", rectAlignment = "UpperCenter",
            offsetXY = "0 -90", textColor = "#151515", text = importText}),
        fieldNode("Button", {id = "lc_import_button", onClick = "importCards", text = tr("デッキ導入"), interactable = running and "false" or "true", width = "200", height = "38",
            rectAlignment = "UpperCenter", offsetXY = "0 -280", fontSize = "18", color = "#324268", textColor = "#FFFFFF"}),
        fieldNode("Text", {id = "lc_import_status", text = importStatusText or tr("準備完了（読込時には自動生成しません）"), width = "430", height = "60",
            rectAlignment = "UpperCenter", offsetXY = "0 -333", fontSize = "15", color = "#FFFFFF"})
    }))
    for _, node in ipairs(fieldUI()) do table.insert(ui, node) end
    for _, node in ipairs(lovecaMarkerUI()) do table.insert(ui, node) end
    for _, node in ipairs(localeUI()) do table.insert(ui, node) end
    UI.setXmlTable(ui)
    localeGeneration = localeGeneration + 1
    local generation = localeGeneration
    Wait.condition(function()
        if generation ~= localeGeneration then return end
        showLovecaPanel(active)
        markerFormRender()
        refreshLovecaField()
    end, function() return not UI.loading end)
end

function getLovecaLanguage()
    return LANGUAGE
end

function openLovecaLanguage()
    showLovecaPanel("locale")
end

function closeLovecaLanguage()
    closeLovecaPanel("locale")
end

function selectLovecaLanguage(player, value, id)
    local language = string.match(id or "", "^lc_locale_(%w+)$")
    if not isLovecaLanguage(language) or language == LANGUAGE then return end
    LANGUAGE, LovecaLanguage = language, language
    refreshFieldLanguage()
    installLovecaUI(markerPanel)
    refreshMarkerLanguage()
    refreshCardLanguage()
end

function onLoad(saved_data)
    local fieldState = nil
    local markerState = nil
    if saved_data and saved_data ~= "" then
        local ok, state = pcall(decodeJSON, saved_data)
        if ok and type(state) == "table" and state.schema == "loveca.importer" then
            if state.locale_version == 1 and isLovecaLanguage(state.language) then
                LANGUAGE = state.language
            end
            if type(state.input) == "string" then importText = normalizeCardNumber(state.input) end
            batchSequence = tonumber(state.batch_sequence) or 0
            fieldState = state.field
            markerState = state.markers
        end
    end
    for _, source in ipairs(SAMPLE_CARDS) do sourceCache[normalizeNumber(source.card_no)] = source end
    LovecaLanguage = LANGUAGE
    installLovecaUI(nil)
    fieldLoad(fieldState)
    initializeLovecaMarkers(markerState)
    refreshCardLanguage()
end
