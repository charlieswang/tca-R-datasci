# 每週星期一早上7點執行，以因應早上9點營業額檢討週會

# !!!!注意，請調整成工作目錄
# 請設定工作目錄為本次課程進行的目錄,因為會需要讀取範例檔
# 實務工作中請自行設定 
# 可用 getwd() 檢查

#setwd("/Users/LaiR/Desktop/R_EDA_by_KA_201609")
setwd("E:/Rworking/tca-R-datasci")

# 載入套件
library(data.table)
library(dplyr)
library(ggplot2)
library(tidyr)
library(lubridate)
library(openxlsx)
library(readxl)
library(readr)

# 執行程式碼
# 為了避免中文編碼的問題，故只連結 star_03_order_main star_04_order_detail
# 故缺乏價格、中文品名、中文地址等資訊
star_03_order_main <- 
  fread("R_EDA_by_KA_201609/01_star/01_big5/star_03_order_main.csv",data.table = FALSE)
star_04_order_detail <-
  fread("R_EDA_by_KA_201609/01_star/01_big5/star_04_order_detail.csv",data.table = FALSE)

raw_data <-  
  left_join( star_03_order_main , star_04_order_detail , by = "order_id")



# 執行週報相關計算

# 先定義各週的起始
#本週第1天
w0_start = today() - wday( today()) + 1
w0_start
#前1週第一天
w1_start = w0_start - 7
w1_start
#前2週最後一天
w2_start = w0_start -7-7
w2_start

# 先將原先資料中的order_date 轉為日期格式
raw_data$order_date <- raw_data$order_date %>% ymd


# 程式排程化執行時 

# 前1週的銷賣總杯數
w1_cups <- raw_data %>% 
  filter(order_date >= w1_start & 
           order_date <= w1_start + 6 ) %>% 
  summarise( total_cups = sum(sale_n))
w1_cups

# 前2週的銷賣總杯數
w2_cups <-raw_data %>% 
  filter(order_date >= w2_start & 
           order_date <= w2_start + 6 ) %>% 
  summarise( total_cups = sum(sale_n))
w2_cups

# 前1週的銷賣總杯數排名前10的店家編碼
w1_cups_top10 <- raw_data %>% 
  filter(order_date >= w1_start & 
           order_date <= w1_start + 6 ) %>% 
  group_by(store_id) %>% 
  summarise( total_cups = sum(sale_n)) %>%
  arrange(total_cups %>% desc) %>%
  head(10)

w1_cups_top10

# 前1週的銷賣總杯數排名前10的店家編碼
w2_cups_top10 <- raw_data %>% 
  filter(order_date >= w2_start & 
           order_date <= w2_start + 6 ) %>% 
  group_by(store_id) %>% 
  summarise( total_cups = sum(sale_n)) %>% 
  arrange(total_cups %>% desc) %>%
  head(10)

w2_cups_top10

# 輸出4個csv文字檔案
# R 還能輸出更華麗的文件(含圖表)，請待下期資料視覺化課程介紹!
write.csv(w1_cups,"w1_cups.csv" , row.names = FALSE)
write.csv(w2_cups,"w2_cups.csv", row.names = FALSE)
write.csv(w1_cups_top10,"w1_cups_top10.csv", row.names = FALSE)
write.csv(w2_cups_top10,"w2_cups_top10.csv", row.names = FALSE)

