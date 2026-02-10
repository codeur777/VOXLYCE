-- Database and user are already created by docker-compose environment variables
-- This script runs in the context of voxlyce_db database

-- Create classrooms table
CREATE TABLE IF NOT EXISTS classrooms (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    level VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    role VARCHAR(50) NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    two_factor_enabled BOOLEAN DEFAULT TRUE,
    two_factor_code VARCHAR(10),
    classroom_id BIGINT REFERENCES classrooms(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create elections table
CREATE TABLE IF NOT EXISTS elections (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    classroom_id BIGINT REFERENCES classrooms(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create positions table
CREATE TABLE IF NOT EXISTS positions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    election_id BIGINT REFERENCES elections(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create candidates table
CREATE TABLE IF NOT EXISTS candidates (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    position_id BIGINT REFERENCES positions(id),
    manifesto TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, position_id)
);

-- Create votes table (anonymous voting)
CREATE TABLE IF NOT EXISTS votes (
    id BIGSERIAL PRIMARY KEY,
    voter_hash VARCHAR(255) NOT NULL,
    candidate_id BIGINT REFERENCES candidates(id),
    position_id BIGINT REFERENCES positions(id),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(voter_hash, position_id)
);

-- Create audit_logs table
CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    action VARCHAR(255) NOT NULL,
    description TEXT,
    user_id BIGINT REFERENCES users(id),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Insert default classrooms
INSERT INTO classrooms (name, level) VALUES
('Licence 1 Informatique', 'L1'),
('Licence 2 Informatique', 'L2'),
('Licence 3 Informatique', 'L3'),
('Master 1 Informatique', 'M1'),
('Master 2 Informatique', 'M2')
ON CONFLICT (name) DO NOTHING;

-- Users will be created via the API /auth/register endpoint
