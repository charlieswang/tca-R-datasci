#讀取神奇寶貝基本資料檔
#檔名 pokemon721.csv 或 pokemon721.xlsx 
  
  
# 載入需要的library 
library(data.table)
library(dplyr)


# 讀入資料的方法有很多種，這裡使用最簡單的 read.csv 
# 或是使用 fread 也可以(但記得要先載入 data.table套件)

pokemon <- read.csv("R_EDA_by_KA_201609/05_homework_pokemon/pokemon721.csv")

#總共有幾筆資料
pokemon %>% nrow

#神奇寶貝中 (提示 head(數字) ) 
#身高最高的前8名的神奇寶貝是? 
# 方法一。升序排列，是由小排到大，所以最高的前8名，應該是在最後的8個位置
# 因為只問神奇寶貝，所以我們可以只選出名字與身體就好
pokemon %>% arrange(height) %>% tail(8) %>% select(pokemon,height)

# 方法二。直接對身高做降序排列，所以是由大排到小, 所以我們只要用head就可以找出前8名的神奇寶貝。
pokemon %>% arrange(desc(height)) %>% head(8) %>% select(pokemon,height)

#體重最重的前6名的的神奇寶貝是?
#回答此時時，可以直接偷懶將上一題的程式碼複製後，將 height 替換為 weight 即可
#但要記得題目是問前"6"名，所以別忘了將8改成6
pokemon %>% arrange(desc(weight)) %>% head(6) %>% select(pokemon,weight)

#攻擊力最強的前10名的神奇寶貝是?
# 如同上題，這一題，我們也可以直接用上面的程式碼來改
pokemon %>% arrange(desc(attack)) %>% head(10) %>% select(pokemon,attack)

#血量(hp)最多的的神奇寶貝是?
# 進行此題時，如果你可以直接將程式碼修改如下，就可以得到答案 
pokemon %>% arrange(desc(hp)) %>% head(1) %>% select(pokemon,hp)
# 如果你怕答案可能是錯的，為了確認程式是否正確，你可以試試
pokemon %>% arrange(desc(hp)) %>% head(10) %>% select(pokemon,hp)
# 嗯，第一名都是 blissey 表示我們的寫法沒錯

#以主要屬性(type_1)群組，計算以下資訊
#那種屬性數量最多? 那種數量屬性最少?
#我們先用 group_by + summarise 來看看各屬性各有多少
pokemon %>% group_by(type_1) %>% summarise( my_count = n())
# 可知總共有18種屬性，神奇寶貝故事中，一隻神奇寶貝最多擁有第2種附加屬性，最少擁有一種主要屬性。舉例而言，暴鯉龍擁有飛行的附加屬性是升級前的鯉魚王所沒有的。
# 求算主要屬性最多的是?
pokemon %>% group_by(type_1) %>% summarise( my_count = n()) %>% 
  arrange(my_count) %>% tail(1)
# 求算主要屬性最少的是? 
pokemon %>% group_by(type_1) %>% summarise( my_count = n()) %>% 
  arrange(my_count) %>% head(1)

#平均攻擊力
pokemon %>% group_by(type_1) %>% summarise( my_attack = mean(attack))  

#平均體重
pokemon %>% group_by(type_1) %>% summarise( my_attack = mean(weight))  

#最高攻擊力
pokemon %>% group_by(type_1) %>% summarise( type_max_attack = max(attack))  

#最低攻擊力
pokemon %>% group_by(type_1) %>% summarise( type_max_attack = min(attack)) 
# 此處大家應該也可以發現在 summarise 中，你可以自己決定新欄位(Column)的名稱，
# 例如:你覺得 "type_max_attack" 不好要改成"MAX_POWER" 也是可以的

# 追加問題，各屬性中最高攻擊力的數值我已經知道了，但如果我想要知道是那一隻神奇寶貝?
pokemon %>% group_by(type_1) %>% filter( attack == max(attack))  %>%
  select(pokemon ,type_1, attack)

#分別將身高、體重轉換為公尺、公斤?
#產生新變數
# 這次神奇寶貝的資料是來自於"外國人"提供的神奇寶貝API
# 因為在電腦中儲存整理有很多優點，
# 所以你在資料中看到的體重7指的其實是0.7公尺，看到的69其實是6.9公斤
# 但是這樣不直覺啊
# 可以試試
pokemon %>%  mutate( kg = weight/10 , m = height/10)
# 因為資料筆數很多，有時候看不到欄位名稱，可以使用 head 輸出前6筆就好
pokemon %>%  mutate( m = weight/10 , kg = height/10) %>% head

# 確定無誤後，我們將結果再次存到 pokemon 物件中
pokemon <- pokemon %>%  mutate( kg = weight/10 , m = height/10)


# 做了這些問題後，除了成就感之外
# 大家有沒有覺得很火大呢? 因為這些資料都沒有提供中文資訊… 
#  bulbasaur ??

# 大家可以試試，我用網路爬蟲由神奇寶貝圖鑑網站中取得的資料
library(readxl)
read_excel("R_EDA_by_KA_201609/05_homework_pokemon/pokemon_name.xlsx") 
