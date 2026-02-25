-- ============================================
-- CREATE ADMIN USER FOR KONDAN THE RETREAT
-- ============================================

-- First, ensure the admin table exists
CREATE TABLE IF NOT EXISTS admin (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_admin_email ON admin(email);

-- ============================================
-- INSERT DEFAULT ADMIN USER
-- ============================================
-- Email: admin@kondantheretreat.com
-- Password: Admin@123
-- Password hash generated using bcrypt with salt rounds = 10

INSERT INTO admin (
    email, 
    password_hash, 
    first_name, 
    last_name, 
    phone,
    address,
    created_at,
    updated_at
)
VALUES (
    'admin@kondantheretreat.com',
    '$2a$10$YourBcryptHashWillGoHere',  -- This needs to be generated
    'Admin',
    'Kondan',
    '+91 8275063636',
    'Kondan The Retreat, Mahabaleshwar, Maharashtra 412806',
    NOW(),
    NOW()
)
ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    updated_at = NOW();

-- ============================================
-- VERIFICATION QUERY
-- ============================================
-- Run this to verify the admin was created:
-- SELECT id, email, first_name, last_name, phone, created_at FROM admin;

-- ============================================
-- NOTES
-- ============================================
-- The password hash above is a placeholder.
-- To generate a proper bcrypt hash, use the Node.js script:
-- node create-admin.js
--
-- Or use an online bcrypt generator:
-- https://bcrypt-generator.com/
-- Use 10 rounds for the salt
