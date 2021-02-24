README.md

# このアプリの概要
  このアプリはトイレを探している人がアプリ内で検索することによって自分が行きたいトイレを見つけることができるアプリです。
![1AC7C1FB-CC57-4546-98E4-0F550DA7E3C0_1_105_c](https://user-images.githubusercontent.com/65130181/107905445-9b49bb00-6f1c-11eb-9ba6-f766960d4d5a.jpeg)

## URL
http://18.182.138.190/


## 作った理由
  私は元々トイレが近かったというのもあるんですが、カナダに１年間住んだ時にトイレに困ることがたくさんありました。カナダに住むこと自体が初めてだったということもありましたし、日本みたいに沢山トイレがあるわけではなく探すのにすごく苦労しました。またトイレがあったとしても綺麗ではないトイレが多くありました。そのため、外出する際には毎回トイレの心配をしないといけませんでした。自分が全然知らない土地に行ったとしてもアプリで検索さえすればトイレを見つけることができる。そんなアプリがあれば安心して外出できるのではないかと考えこのアプリを作ろうと思いました。

## 機能一覧

### ユーザーの機能
* 新規登録、ログイン、ログアウト、編集機能
* ゲストログイン機能


### 投稿機能
* トイレの投稿・編集・削除
* トイレの一覧・詳細の表示
* トイレのキーワード検索機能


### 通知機能
* 投稿がお気に入り、コメントされたことによる通知機能

### お気に入り機能
* よく使うであろうトイレのお気に入り機能

### コメント機能
* 投稿に対するコメント投稿機能

### フォロー機能
* ユーザーのフォロー・フォロー解除機能
* フォローしているユーザーとフォロワーの一覧の表示


## 環境、使用技術
### フロントエンド
* HTML
* SCSS
* JavaScript (jQuery)
* Bootstrap

### バックエンド
* Ruby:2.6.5
* Ruby on Rails:5.2.1

### データベース
* MySQL2

### テスト
* RSpec
* FactoryBot
* Rubocop

### 本番環境
* AWS(VPC, EC2, IAM, S3)
* Nginx, Unicron

### 開発環境
* Docker/Docker-compose

### DB設計
![179BF5D5-A062-488F-AE8B-228B31D49429](https://user-images.githubusercontent.com/65130181/107879903-9992df80-6ea9-11eb-8a67-10cdd40b7ad2.jpeg)

### インフラ構成
![F398F190-46EE-4138-8EDF-166184D93CD9](https://user-images.githubusercontent.com/65130181/108999809-db254680-7670-11eb-91ab-0d4d8b416f85.jpeg)

## 今後の課題
* マップを用いてユーザーがよりトイレを見つけやすくする機能の導入
* テストコードの改善
* リファクタリング

ひとまず以上のことを次の課題としています。
これらが出来次第、次の課題をユーザー視点から見つけ、改善していこうと考えています。







