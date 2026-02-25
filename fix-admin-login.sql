-- Fix Admin Login Issue for Kondan The Retreat
-- Add is_active column if it doesn't exist

-- Add is_active column to admin table
ALTER TABLE admin 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;

-- Update existing admin to be active
UPDATE admin 
SET is_active = TRUE 
WHERE email = 'admin@kondantheretreat.com';

-- Verify the update
SELECT id, email, first_name, last_name, is_active, created_at 
FROM admin 
WHERE email = 'admin@kondantheretreat.com';
