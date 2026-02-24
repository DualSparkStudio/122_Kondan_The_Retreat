-- ============================================
-- DROP ALL TABLES - KONDAN THE RETREAT
-- WARNING: This will delete ALL data permanently!
-- ============================================
-- Run this script to completely remove the database schema
-- Make sure you have a backup before running this!
-- ============================================

-- Disable triggers temporarily
SET session_replication_role = 'replica';

-- Drop all tables in reverse order (to handle foreign key dependencies)
-- ============================================

-- Drop WhatsApp tables
DROP TABLE IF EXISTS whatsapp_messages CASCADE;
DROP TABLE IF EXISTS whatsapp_sessions CASCADE;
DROP TABLE IF EXISTS whatsapp_settings CASCADE;

-- Drop settings and configuration tables
DROP TABLE IF EXISTS resort_closures CASCADE;
DROP TABLE IF EXISTS calendar_settings CASCADE;
DROP TABLE IF EXISTS admin_settings CASCADE;

-- Drop content tables
DROP TABLE IF EXISTS faq CASCADE;
DROP TABLE IF EXISTS house_rules CASCADE;
DROP TABLE IF EXISTS social_media_links CASCADE;
DROP TABLE IF EXISTS tourist_attractions CASCADE;
DROP TABLE IF EXISTS contact_messages CASCADE;
DROP TABLE IF EXISTS testimonials CASCADE;
DROP TABLE IF EXISTS features CASCADE;
DROP TABLE IF EXISTS facilities CASCADE;

-- Drop booking-related tables
DROP TABLE IF EXISTS blocked_dates CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;

-- Drop room-related tables
DROP TABLE IF EXISTS room_images CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;

-- Drop user table
DROP TABLE IF EXISTS users CASCADE;

-- ============================================
-- Drop functions and triggers
-- ============================================

DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- ============================================
-- Drop extensions (optional - uncomment if needed)
-- ============================================

-- DROP EXTENSION IF EXISTS "uuid-ossp" CASCADE;

-- Re-enable triggers
SET session_replication_role = 'origin';

-- ============================================
-- Verify all tables are dropped
-- ============================================

-- Run this query to check if any tables remain:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- ============================================
-- END OF DROP SCRIPT
-- ============================================

-- NOTES:
-- 1. This script uses CASCADE to automatically drop dependent objects
-- 2. All data will be permanently deleted
-- 3. Make sure you have a backup before running
-- 4. After running this, you can run complete_database_schema.sql to recreate
-- ============================================
