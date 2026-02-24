-- ============================================
-- Fix Table Names and Columns to Match Code
-- ============================================
-- Run this in Supabase SQL Editor
-- ============================================

-- 1. Rename 'faq' table to 'faqs' (if it exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'faq') THEN
        ALTER TABLE faq RENAME TO faqs;
        RAISE NOTICE 'Renamed faq to faqs';
    END IF;
END $$;

-- 2. Add 'order_num' column to faqs if it doesn't exist
ALTER TABLE faqs 
ADD COLUMN IF NOT EXISTS order_num INTEGER DEFAULT 0;

-- Update display_order to order_num if needed
UPDATE faqs SET order_num = display_order WHERE order_num = 0 AND display_order IS NOT NULL;

-- 3. Create 'attractions' as a view or rename 'tourist_attractions'
-- Option A: Create a view (keeps both names working)
CREATE OR REPLACE VIEW attractions AS 
SELECT * FROM tourist_attractions;

-- Option B: Or rename the table (uncomment if you prefer this)
-- DO $$ 
-- BEGIN
--     IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tourist_attractions') THEN
--         ALTER TABLE tourist_attractions RENAME TO attractions;
--         RAISE NOTICE 'Renamed tourist_attractions to attractions';
--     END IF;
-- END $$;

-- 4. Fix house_rules columns
-- Add rule_text column if it doesn't exist
ALTER TABLE house_rules 
ADD COLUMN IF NOT EXISTS rule_text TEXT;

-- Add order_num column if it doesn't exist
ALTER TABLE house_rules 
ADD COLUMN IF NOT EXISTS order_num INTEGER DEFAULT 0;

-- Copy data from title/description to rule_text if needed
UPDATE house_rules 
SET rule_text = COALESCE(title, description)
WHERE rule_text IS NULL;

-- Copy display_order to order_num if needed
UPDATE house_rules 
SET order_num = display_order 
WHERE order_num = 0 AND display_order IS NOT NULL;

-- 5. Verify changes
SELECT 'faqs' as table_name, COUNT(*) as row_count FROM faqs
UNION ALL
SELECT 'attractions' as table_name, COUNT(*) as row_count FROM attractions
UNION ALL
SELECT 'house_rules' as table_name, COUNT(*) as row_count FROM house_rules;

-- Show house_rules columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'house_rules'
ORDER BY ordinal_position;
