-- ============================================
-- SETUP NEW DATABASE - RUN AFTER SCHEMA
-- ============================================
-- Run this AFTER running complete_database_schema.sql
-- ============================================

-- 1. Add missing columns to rooms (video_url, extra_mattress_price)
ALTER TABLE rooms 
ADD COLUMN IF NOT EXISTS video_url TEXT;

ALTER TABLE rooms 
ADD COLUMN IF NOT EXISTS extra_mattress_price NUMERIC(10, 2) DEFAULT 200;

-- 2. Add password_hash column to users for admin login
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS password_hash VARCHAR(255);

-- 3. Rename faq to faqs and add order_num
ALTER TABLE faq RENAME TO faqs;
ALTER TABLE faqs ADD COLUMN IF NOT EXISTS order_num INTEGER DEFAULT 0;

-- 4. Add columns to house_rules for compatibility
ALTER TABLE house_rules ADD COLUMN IF NOT EXISTS rule_text TEXT;
ALTER TABLE house_rules ADD COLUMN IF NOT EXISTS order_num INTEGER DEFAULT 0;

-- Copy title to rule_text if needed
UPDATE house_rules SET rule_text = title WHERE rule_text IS NULL;

-- 5. Create attractions view (so both names work)
CREATE OR REPLACE VIEW attractions AS 
SELECT * FROM tourist_attractions;

-- 6. Insert default maintenance mode setting
INSERT INTO calendar_settings (setting_key, setting_value, description)
VALUES ('maintenance_mode', 'false', 'Enable/disable maintenance mode')
ON CONFLICT (setting_key) DO NOTHING;

-- 7. Verify setup
SELECT 'Setup complete!' as status;
SELECT 'Tables created: ' || COUNT(*) as tables_count 
FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
