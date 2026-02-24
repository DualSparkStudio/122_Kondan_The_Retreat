-- ============================================
-- Add Missing Columns to Rooms Table
-- ============================================
-- Run this in Supabase SQL Editor
-- ============================================

-- 1. Add video_url column
ALTER TABLE rooms 
ADD COLUMN IF NOT EXISTS video_url TEXT;

-- 2. Add extra_mattress_price column
ALTER TABLE rooms 
ADD COLUMN IF NOT EXISTS extra_mattress_price NUMERIC(10, 2) DEFAULT 200;

-- 3. Add comments for documentation
COMMENT ON COLUMN rooms.video_url IS 'Cloudinary video URL for room tour/preview';
COMMENT ON COLUMN rooms.extra_mattress_price IS 'Price per extra mattress per night (default: ₹200)';

-- 4. Verify columns were added
SELECT column_name, data_type, column_default
FROM information_schema.columns 
WHERE table_name = 'rooms' 
AND column_name IN ('video_url', 'extra_mattress_price')
ORDER BY column_name;

-- 5. Show all rooms columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'rooms'
ORDER BY ordinal_position;
