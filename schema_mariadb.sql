-- ========================================
-- 이음(Eum) 프로젝트 - MariaDB DDL
-- 생성일: 2024-11-23
-- 데이터베이스: MariaDB 10.x 이상
-- ========================================

-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS eume_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE eume_db;

-- ========================================
-- 1. 조직/그룹 테이블
-- ========================================

-- 조직 그룹
CREATE TABLE sigungu (
sigungu_id VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '시군구 ID',
sido VARCHAR(50) NOT NULL COMMENT '시도',
sigungu VARCHAR(50) NOT NULL COMMENT '시군구',
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='시군구 그룹';

-- ========================================
-- 2. 관리자 관련 테이블
-- ========================================

-- 관리자 계정
CREATE TABLE eume_admin (
admin_id VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '관리자 ID',
admin_login_id VARCHAR(100) NOT NULL UNIQUE COMMENT '로그인 ID',
admin_pw VARCHAR(200) NOT NULL COMMENT '비밀번호',
admin_name VARCHAR(100) NOT NULL COMMENT '관리자명',
admin_email VARCHAR(200) NOT NULL UNIQUE COMMENT '이메일',
admin_phone VARCHAR(20) COMMENT '전화번호',
admin_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
sigungu_id VARCHAR(50) COMMENT '시군구 ID',
last_login_date DATETIME COMMENT '마지막 로그인',
login_fail_count INT NOT NULL DEFAULT 0 COMMENT '로그인 실패 횟수',
reg_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
upd_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
FOREIGN KEY (sigungu_id) REFERENCES sigungu(sigungu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='관리자 계정';

-- ========================================
-- 3. 사용자 관련 테이블
-- ========================================

-- 사용자 계정
CREATE TABLE eume_user (
user_id VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '사용자 ID',
email VARCHAR(200) NOT NULL UNIQUE COMMENT '이메일',
user_name VARCHAR(100) NOT NULL COMMENT '사용자명',
nickname VARCHAR(100) COMMENT '닉네임',
profile_image VARCHAR(500) COMMENT '프로필 이미지',
provider_id VARCHAR(200) COMMENT '소셜 로그인 Provider ID',
user_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '상태',
sigungu_id VARCHAR(50) COMMENT '시군구 ID',
birth_date DATE COMMENT '생년월일',
gender VARCHAR(10) COMMENT '성별',
phone VARCHAR(20) COMMENT '전화번호',
last_login_date DATETIME COMMENT '마지막 로그인',
login_fail_count INT NOT NULL DEFAULT 0 COMMENT '로그인 실패 횟수',
reg_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
upd_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
background_theme VARCHAR(100) DEFAULT 'DEFAULT' COMMENT '배경 테마',
FOREIGN KEY (sigungu_id) REFERENCES sigungu(sigungu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 계정';

-- ========================================
-- 4. 일반 채팅 관련 테이블
-- ========================================
CREATE TABLE user_chat_list (
chat_room_id VARCHAR(50) NOT NULL COMMENT '채팅방 ID',
user_id VARCHAR(50) NOT NULL COMMENT '사용자 ID',
room_title VARCHAR(200) COMMENT '채팅방 제목',
room_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '채팅방 상태',
reg_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
upd_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
-- 🔥 복합 Primary Key 설정
PRIMARY KEY (chat_room_id, user_id),
FOREIGN KEY (user_id) REFERENCES eume_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='일반 채팅 리스트';


-- 일반 채팅 내용
CREATE TABLE user_chat_content (
message_id VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '메시지 ID',
chat_room_id VARCHAR(50) NOT NULL COMMENT '채팅방 ID',
user_id VARCHAR(50) NOT NULL COMMENT '사용자 ID',
message_type VARCHAR(10) NOT NULL COMMENT '메시지 유형 (USER/AI)',
message_content TEXT NOT NULL COMMENT '메시지 내용',
reg_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
FOREIGN KEY (chat_room_id) REFERENCES user_chat_list(chat_room_id),
FOREIGN KEY (user_id) REFERENCES eume_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='일반 채팅 내용';

-- ========================================
-- 5. 이음(AI) 채팅 관련 테이블
-- ========================================

-- 이음 채팅방
CREATE TABLE eume_chat_list (
eume_chat_id VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '이음 채팅방 ID',
user_id VARCHAR(50) NOT NULL COMMENT '사용자 ID',
chat_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '선제적 대화 상태',
reg_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
upd_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
PRIMARY KEY (eume_chat_id, user_id),
FOREIGN KEY (user_id) REFERENCES eume_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='이음 채팅방';

-- 이음 채팅 내용
CREATE TABLE eume_chat_content (
eume_message_id VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '이음 메시지 ID',
eume_chat_id VARCHAR(50) NOT NULL COMMENT '이음 채팅방 ID',
user_id VARCHAR(50) NOT NULL COMMENT '사용자 ID',
message_type VARCHAR(10) NOT NULL COMMENT '메시지 유형 (AI/USER)',
message_content TEXT NOT NULL COMMENT '메시지 내용',
reg_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
FOREIGN KEY (eume_chat_id) REFERENCES eume_chat_list(eume_chat_id),
FOREIGN KEY (user_id) REFERENCES eume_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='이음 채팅 내용';

-- ========================================
-- 6. 감정/상태 분석 관련 테이블
-- ========================================

우울 점수 → depression_score

불안 점수 → anxiety_score

스트레스 점수 → stress_score
-- 감정 분석 결과
CREATE TABLE user_emotion (
emotion_id VARCHAR(50) NOT NULL PRIMARY KEY COMMENT '감정 ID',
user_id VARCHAR(50) NOT NULL COMMENT '사용자 ID',
depression_score INT COMMENT '우울 점수',
anxiety_score INT COMMENT '불안 점수',
stress_score INT COMMENT '스트레스 점수',
emotion_score INT COMMENT '감정 점수',
keywords JSON COMMENT '키워드',
analysis_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '분석 일시',
model_version VARCHAR(20) COMMENT '모델 버전',
FOREIGN KEY (user_id) REFERENCES eume_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='감정 분석 결과';



-- ========================================
-- 인덱스 생성
-- ========================================

-- 사용자 테이블 인덱스
CREATE INDEX idx_user_email ON eume_user(email);
CREATE INDEX idx_user_status ON eume_user(user_status);
CREATE INDEX idx_user_login_type ON eume_user(login_type);

-- 채팅 관련 인덱스
CREATE INDEX idx_user_chat_list_user ON pj_user_chat_list(user_id);
CREATE INDEX idx_user_chat_content_room ON pj_user_chat_content(chat_room_id);
CREATE INDEX idx_eum_chat_list_user ON pj_eum_chat_list(user_id);
CREATE INDEX idx_eum_chat_list_date ON pj_eum_chat_list(chat_date);
CREATE INDEX idx_eum_chat_content_chat ON pj_eum_chat_content(eum_chat_id);

-- 감정 분석 인덱스
CREATE INDEX idx_user_emotion_user ON pj_user_emotion(user_id);
CREATE INDEX idx_user_life_data_user ON pj_user_life_data(user_id);
CREATE INDEX idx_user_life_data_date ON pj_user_life_data(status_date);


-- ========================================
-- 완료
-- ========================================