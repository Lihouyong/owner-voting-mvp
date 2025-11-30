-- 用户表
CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  openid VARCHAR(64) NOT NULL UNIQUE,
  unionid VARCHAR(64),
  name VARCHAR(64),
  id_number_encrypted VARBINARY(255),
  phone VARCHAR(20),
  status ENUM('pending','verified','rejected') DEFAULT 'pending',
  role ENUM('owner','committee','admin','auditor') DEFAULT 'owner',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 房产表
CREATE TABLE properties (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  estate_name VARCHAR(128),
  building VARCHAR(32),
  unit VARCHAR(32),
  room VARCHAR(32),
  owner_user_id BIGINT,
  house_code VARCHAR(64) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_user_id) REFERENCES users(id)
);

-- 投票事项表
CREATE TABLE votes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(256) NOT NULL,
  description TEXT,
  proposer_user_id BIGINT,
  announce_start DATETIME,
  vote_start DATETIME,
  vote_end DATETIME,
  min_participation_ratio DECIMAL(5,4) DEFAULT 0.5000,
  status ENUM('draft','announcing','voting','closed','archived') DEFAULT 'draft',
  snapshot_hash VARCHAR(64),
  snapshot_url VARCHAR(512),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 投票选项表
CREATE TABLE vote_options (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  vote_id BIGINT,
  option_label VARCHAR(128),
  option_value VARCHAR(128),
  FOREIGN KEY (vote_id) REFERENCES votes(id) ON DELETE CASCADE
);

-- 投票记录表（最核心）
CREATE TABLE vote_records (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  vote_id BIGINT,
  user_id BIGINT,
  property_id BIGINT,
  option_id BIGINT,
  weight DECIMAL(10,4) DEFAULT 1.0000,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  signature VARCHAR(256),
  tx_hash VARCHAR(128),
  UNIQUE INDEX idx_unique_vote_user (vote_id, user_id),
  FOREIGN KEY (vote_id) REFERENCES votes(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

--  -- 审计日志表（不可删）
CREATE TABLE audit_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT,
  action VARCHAR(128),
  target_type VARCHAR(64),
  target_id BIGINT,
  meta JSON,
  ip VARCHAR(45),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
