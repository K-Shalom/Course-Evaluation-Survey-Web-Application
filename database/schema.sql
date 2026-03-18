-- ============================================================
-- Course Evaluation Survey System - Database Schema
-- Tables: Users, Roles, Courses, Teachers, Surveys,
--         Survey Questions, Survey Options,
--         Survey Responses, Respondents
-- ============================================================

CREATE DATABASE IF NOT EXISTS course_evaluation_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE course_evaluation_db;

-- ============================================================
-- 1. ROLES
-- ============================================================
CREATE TABLE roles (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL UNIQUE,   -- ADMIN, INITIATOR, TEACHER, RESPONDENT
    description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 2. USERS
--    All system actors: Admin, Initiator, Teacher, Respondent
--    Every account waits for ADMIN approval (except ADMIN itself)
-- ============================================================
CREATE TABLE users (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    username            VARCHAR(100) NOT NULL UNIQUE,
    email               VARCHAR(150) NOT NULL UNIQUE,
    password            VARCHAR(255) NOT NULL,
    first_name          VARCHAR(100) NOT NULL,
    last_name           VARCHAR(100) NOT NULL,
    role_id             INT          NOT NULL,
    status              ENUM('PENDING','ACTIVE','REJECTED','SUSPENDED')
                            NOT NULL DEFAULT 'PENDING',
    email_verified      TINYINT(1)  NOT NULL DEFAULT 0,
    verification_token  VARCHAR(255),           -- email-verify token
    token_expiry        DATETIME,               -- token expiration
    reset_token         VARCHAR(255),           -- password-reset token
    reset_token_expiry  DATETIME,
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 3. COURSES
-- ============================================================
CREATE TABLE courses (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    name        VARCHAR(200) NOT NULL,
    description TEXT,
    credits     INT          NOT NULL DEFAULT 3,
    department  VARCHAR(150),
    is_active   TINYINT(1)  NOT NULL DEFAULT 1,
    created_by  INT          NOT NULL,          -- FK -> users (ADMIN)
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 4. TEACHERS
--    Maps approved teacher users to their assigned courses.
--    One teacher can teach many courses; one course can have many teachers.
-- ============================================================
CREATE TABLE teachers (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,                   -- FK -> users (role=TEACHER)
    course_id   INT NOT NULL,                   -- FK -> courses
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    assigned_by INT NOT NULL,                   -- FK -> users (ADMIN)
    UNIQUE KEY uq_teacher_course (user_id, course_id),
    FOREIGN KEY (user_id)     REFERENCES users(id)   ON DELETE CASCADE,
    FOREIGN KEY (course_id)   REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 5. SURVEYS
-- ============================================================
CREATE TABLE surveys (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    title             VARCHAR(300) NOT NULL,
    description       TEXT,
    course_id         INT NOT NULL,             -- FK -> courses
    created_by        INT NOT NULL,             -- FK -> users (role=INITIATOR)
    status            ENUM('DRAFT','ACTIVE','CLOSED','ARCHIVED')
                          NOT NULL DEFAULT 'DRAFT',
    access_type       ENUM('AUTHENTICATED','GUEST','BOTH')
                          NOT NULL DEFAULT 'BOTH',
    require_email     TINYINT(1) NOT NULL DEFAULT 1,  -- guest must supply email
    send_confirmation TINYINT(1) NOT NULL DEFAULT 1,  -- send confirmation email
    allow_anonymous   TINYINT(1) NOT NULL DEFAULT 0,
    start_date        DATETIME,
    end_date          DATETIME,
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id)  REFERENCES courses(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 6. SURVEY_QUESTIONS
-- ============================================================
CREATE TABLE survey_questions (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    survey_id     INT  NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('SINGLE_CHOICE','MULTIPLE_CHOICE','TEXT','RATING','YES_NO')
                      NOT NULL DEFAULT 'SINGLE_CHOICE',
    is_required   TINYINT(1) NOT NULL DEFAULT 1,
    order_index   INT        NOT NULL DEFAULT 0,
    FOREIGN KEY (survey_id) REFERENCES surveys(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 7. SURVEY_OPTIONS
--    Predefined answer choices for a question.
-- ============================================================
CREATE TABLE survey_options (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT          NOT NULL,
    option_text VARCHAR(500) NOT NULL,
    order_index INT          NOT NULL DEFAULT 0,
    FOREIGN KEY (question_id) REFERENCES survey_questions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 8. RESPONDENTS
--    Authenticated students OR guests who take a survey.
-- ============================================================
CREATE TABLE respondents (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT,                        -- NULL for guest
    email           VARCHAR(150),               -- provided by guest or from user account
    display_name    VARCHAR(200),
    respondent_type ENUM('STUDENT','GUEST') NOT NULL DEFAULT 'GUEST',
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 9. SURVEY_RESPONSES
--    Stores every answer submitted. One row = one answer.
--    submission_id groups all answers belonging to one attempt.
-- ============================================================
CREATE TABLE survey_responses (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    survey_id       INT NOT NULL,
    respondent_id   INT NOT NULL,
    question_id     INT NOT NULL,
    option_id       INT,                        -- NULL for text/free answers
    answer_text     TEXT,                       -- used when option_id is NULL
    submission_id   VARCHAR(36) NOT NULL,       -- UUID groups one full submission
    submitted_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    confirmation_sent TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (survey_id)    REFERENCES surveys(id)          ON DELETE CASCADE,
    FOREIGN KEY (respondent_id)REFERENCES respondents(id)      ON DELETE CASCADE,
    FOREIGN KEY (question_id)  REFERENCES survey_questions(id) ON DELETE CASCADE,
    FOREIGN KEY (option_id)    REFERENCES survey_options(id)   ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- INDEXES for performance
-- ============================================================
CREATE INDEX idx_users_email      ON users(email);
CREATE INDEX idx_users_status     ON users(status);
CREATE INDEX idx_users_role       ON users(role_id);
CREATE INDEX idx_surveys_course   ON surveys(course_id);
CREATE INDEX idx_surveys_status   ON surveys(status);
CREATE INDEX idx_survey_resp_sub  ON survey_responses(submission_id);
CREATE INDEX idx_survey_resp_surv ON survey_responses(survey_id);
CREATE INDEX idx_teachers_user    ON teachers(user_id);
CREATE INDEX idx_teachers_course  ON teachers(course_id);

-- ============================================================
-- SEED DATA
-- ============================================================

-- Roles
INSERT INTO roles (id, name, description) VALUES
(1, 'ADMIN',     'System administrator with full access'),
(2, 'INITIATOR', 'Designs and publishes evaluation surveys'),
(3, 'TEACHER',   'Linked to courses; monitors survey participation'),
(4, 'RESPONDENT','Student or guest who answers surveys');

-- Default Admin (password = Admin@1234)
-- BCrypt hash generated with 10 rounds
INSERT INTO users (username, email, password, first_name, last_name,
                   role_id, status, email_verified) VALUES
('admin', 'admin@ces.edu',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHni',
 'System', 'Administrator',
 1, 'ACTIVE', 1);
-- ⚠️  Change the admin password immediately after first login!
