USE `isupipe`;

DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `icons`;
DROP TABLE IF EXISTS `themes`;
DROP TABLE IF EXISTS `livestreams`;
DROP TABLE IF EXISTS `reservation_slots`;
DROP TABLE IF EXISTS `tags`;
DROP TABLE IF EXISTS `livestream_tags`;
DROP TABLE IF EXISTS `livestream_viewers_history`;
DROP TABLE IF EXISTS `livecomments`;
DROP TABLE IF EXISTS `livecomment_reports`;
DROP TABLE IF EXISTS `ng_words`;
DROP TABLE IF EXISTS `reactions`;
DROP TABLE IF EXISTS `scores`;

DROP TRIGGER IF EXISTS update_user_theme;
DROP TRIGGER IF EXISTS initialize_scores;
DROP TRIGGER IF EXISTS update_scores_tip;
DROP TRIGGER IF EXISTS update_scores_tip_deletion;
DROP TRIGGER IF EXISTS update_scores_reaction;


-- ユーザ (配信者、視聴者)
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `display_name` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `icon_hash` VARCHAR(255) NOT NULL DEFAULT 'd9f8294e9d895f81ce62e73dc7d5dff862a4fa40bd4e0fecf53f7526a8edcac0', -- default: no image hash
  `dark_mode` BOOLEAN NOT NULL DEFAULT true,
  `theme_id` BIGINT NOT NULL DEFAULT 0,
  UNIQUE `uniq_user_name` (`name`),
  KEY `icon_hash` (`icon_hash`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- プロフィール画像
CREATE TABLE `icons` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `image` LONGBLOB NOT NULL,
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- ユーザごとのカスタムテーマ
CREATE TABLE `themes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `dark_mode` BOOLEAN NOT NULL,
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- ライブ配信
CREATE TABLE `livestreams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` text NOT NULL,
  `playlist_url` VARCHAR(255) NOT NULL,
  `thumbnail_url` VARCHAR(255) NOT NULL,
  `start_at` BIGINT NOT NULL,
  `end_at` BIGINT NOT NULL,
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- ライブ配信予約枠
CREATE TABLE `reservation_slots` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `slot` BIGINT NOT NULL,
  `start_at` BIGINT NOT NULL,
  `end_at` BIGINT NOT NULL,
  KEY `start_end` (`start_at`, `end_at`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- ライブストリームに付与される、サービスで定義されたタグ
CREATE TABLE `tags` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  UNIQUE `uniq_tag_name` (`name`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- ライブ配信とタグの中間テーブル
CREATE TABLE `livestream_tags` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `livestream_id` BIGINT NOT NULL,
  `tag_id` BIGINT NOT NULL,
  KEY `livestream_id` (`livestream_id`),
  KEY `tag_id` (`tag_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- ライブ配信視聴履歴
CREATE TABLE `livestream_viewers_history` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  `created_at` BIGINT NOT NULL,
  KEY `livestream_id` (`livestream_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- ライブ配信に対するライブコメント
CREATE TABLE `livecomments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  `comment` VARCHAR(255) NOT NULL,
  `tip` BIGINT NOT NULL DEFAULT 0,
  `created_at` BIGINT NOT NULL,
  KEY `livestream_id` (`livestream_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- ユーザからのライブコメントのスパム報告
CREATE TABLE `livecomment_reports` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  `livecomment_id` BIGINT NOT NULL,
  `created_at` BIGINT NOT NULL,
  KEY `livestream_id` (`livestream_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- 配信者からのNGワード登録
CREATE TABLE `ng_words` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  `word` VARCHAR(255) NOT NULL,
  `created_at` BIGINT NOT NULL,
  KEY `livestream_id` (`livestream_id`),
  KEY `user_id` (`user_id`),
  KEY `live_user` (`livestream_id`, `user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE INDEX ng_words_word ON ng_words(`word`);

-- ライブ配信に対するリアクション
CREATE TABLE `reactions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT NOT NULL,
  `livestream_id` BIGINT NOT NULL,
  -- :innocent:, :tada:, etc...
  `emoji_name` VARCHAR(255) NOT NULL,
  `created_at` BIGINT NOT NULL,
  KEY `livestream_id` (`livestream_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

CREATE TABLE `scores` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `livestream_id` BIGINT NOT NULL,
  `score` BIGINT NOT NULL,
  UNIQUE `uniq_livestream_id` (`livestream_id`),
  KEY `livestream_id` (`livestream_id`)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

delimiter |
CREATE TRIGGER update_user_theme AFTER INSERT ON themes
FOR EACH ROW
BEGIN
UPDATE users SET dark_mode = NEW.dark_mode, theme_id = NEW.id WHERE id = NEW.user_id;
END;
|
CREATE TRIGGER initialize_scores AFTER INSERT ON livestreams
FOR EACH ROW
BEGIN
REPLACE INTO scores SET livestream_id=NEW.id, score = 0;
END;
|
CREATE TRIGGER update_scores_tip BEFORE INSERT ON livecomments
FOR EACH ROW
BEGIN
UPDATE scores SET score = score + NEW.tip WHERE livestream_id = NEW.livestream_id;
END;
|
CREATE TRIGGER update_scores_tip_deletion BEFORE DELETE ON livecomments
FOR EACH ROW
BEGIN
UPDATE scores SET score = score - OLD.tip WHERE livestream_id = OLD.livestream_id;
END;
|
CREATE TRIGGER update_scores_reaction BEFORE INSERT ON reactions
FOR EACH ROW
BEGIN
UPDATE scores SET score = score + 1 WHERE livestream_id = NEW.livestream_id;
END;
|

delimiter ;

-- use `isudns`;

-- ALTER TABLE `records` 
-- ADD INDEX name(`name`);