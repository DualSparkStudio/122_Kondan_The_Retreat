-- ============================================
-- COMPLETE DATABASE SCHEMA - GRAND VALLEY RESORT
-- Updated with all migrations applied
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_is_admin ON users(is_admin);

-- ============================================
-- 2. ROOMS TABLE (WITH ALL MIGRATIONS)
-- ============================================
CREATE TABLE IF NOT EXISTS rooms (
    id SERIAL PRIMARY KEY,
    room_number VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    slug TEXT UNIQUE,
    description TEXT NOT NULL,
    
    -- Pricing (Updated Pricing Structure)
    price_per_night NUMERIC(10, 2) NOT NULL, -- Base price for 2 adults (couple)
    extra_guest_price NUMERIC(10, 2) DEFAULT 0, -- Price per extra adult per night
    child_above_5_price NUMERIC(10, 2) DEFAULT 0, -- Price per child above 5 years per night
    gst_percentage NUMERIC(5, 2) DEFAULT 12, -- GST percentage (default 12%)
    
    -- Capacity
    max_capacity INTEGER DEFAULT 4, -- Maximum number of guests allowed
    max_occupancy INTEGER, -- Deprecated, kept for backward compatibility
    
    -- Times
    check_in_time TEXT DEFAULT '12:00 PM', -- Check-in time (hardcoded)
    check_out_time TEXT DEFAULT '10:00 AM', -- Check-out time (hardcoded)
    
    -- Room Details
    amenities TEXT[], -- Array of amenities
    image_url TEXT,
    images TEXT[], -- Array of image URLs
    accommodation_details TEXT,
    floor INTEGER,
    
    -- Quantity
    quantity INTEGER DEFAULT 1, -- Number of rooms of this type
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    is_available BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE, -- Soft delete flag
    deleted_at TIMESTAMP WITH TIME ZONE DEFAULT NULL, -- Soft delete timestamp
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for rooms
CREATE INDEX IF NOT EXISTS idx_rooms_slug ON rooms(slug);
CREATE INDEX IF NOT EXISTS idx_rooms_is_active ON rooms(is_active);
CREATE INDEX IF NOT EXISTS idx_rooms_is_available ON rooms(is_available);
CREATE INDEX IF NOT EXISTS idx_rooms_room_number ON rooms(room_number);
CREATE INDEX IF NOT EXISTS idx_rooms_deleted ON rooms(is_deleted, deleted_at);

-- Comments
COMMENT ON COLUMN rooms.price_per_night IS 'Base price per night for 2 adults (couple)';
COMMENT ON COLUMN rooms.extra_guest_price IS 'Price per extra adult per night (beyond base 2 adults)';
COMMENT ON COLUMN rooms.child_above_5_price IS 'Price per child above 5 years per night';
COMMENT ON COLUMN rooms.gst_percentage IS 'GST percentage to apply (default 12%)';
COMMENT ON COLUMN rooms.max_capacity IS 'Maximum number of guests allowed in this room type';
COMMENT ON COLUMN rooms.check_in_time IS 'Check-in time (hardcoded to 12:00 PM)';
COMMENT ON COLUMN rooms.check_out_time IS 'Check-out time (hardcoded to 10:00 AM)';
COMMENT ON COLUMN rooms.quantity IS 'Number of rooms of this type available';
COMMENT ON COLUMN rooms.is_deleted IS 'Boolean flag for soft delete (TRUE = deleted, FALSE = active)';
COMMENT ON COLUMN rooms.deleted_at IS 'Timestamp when room was soft deleted (NULL = not deleted)';

-- ============================================
-- 3. ROOM IMAGES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS room_images (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text TEXT,
    is_primary BOOLEAN DEFAULT FALSE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_room_images_room_id ON room_images(room_id);
CREATE INDEX IF NOT EXISTS idx_room_images_is_primary ON room_images(is_primary);

-- ============================================
-- 4. BOOKINGS TABLE (WITH GUEST DETAILS)
-- ============================================
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES rooms(id) ON DELETE RESTRICT,
    
    -- Dates
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    
    -- Guest Information
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    
    -- Guest Count (Updated Structure)
    num_guests INTEGER NOT NULL DEFAULT 2, -- Total number of guests
    num_extra_adults INTEGER DEFAULT 0, -- Number of extra adults beyond base 2
    num_children_above_5 INTEGER DEFAULT 0, -- Number of children above 5 years
    
    special_requests TEXT,
    
    -- Pricing (Updated with GST breakdown)
    subtotal_amount NUMERIC(10, 2) DEFAULT 0, -- Amount before GST
    gst_amount NUMERIC(10, 2) DEFAULT 0, -- GST amount
    gst_percentage NUMERIC(5, 2) DEFAULT 12, -- GST percentage applied
    total_amount NUMERIC(10, 2) NOT NULL, -- Final amount with GST
    
    -- Status
    booking_status VARCHAR(20) DEFAULT 'pending' CHECK (booking_status IN ('pending', 'confirmed', 'cancelled')),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed')),
    
    -- Payment
    payment_gateway VARCHAR(20) DEFAULT 'direct' CHECK (payment_gateway IN ('direct', 'razorpay')),
    razorpay_order_id VARCHAR(255),
    razorpay_payment_id VARCHAR(255),
    
    -- Metadata
    booking_source VARCHAR(50) DEFAULT 'website',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT check_dates_valid CHECK (check_out_date > check_in_date)
);

-- Indexes for bookings
CREATE INDEX IF NOT EXISTS idx_bookings_room_id ON bookings(room_id);
CREATE INDEX IF NOT EXISTS idx_bookings_check_in_date ON bookings(check_in_date);
CREATE INDEX IF NOT EXISTS idx_bookings_check_out_date ON bookings(check_out_date);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_status ON bookings(booking_status);
CREATE INDEX IF NOT EXISTS idx_bookings_payment_status ON bookings(payment_status);
CREATE INDEX IF NOT EXISTS idx_bookings_email ON bookings(email);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_source ON bookings(booking_source);
CREATE INDEX IF NOT EXISTS idx_bookings_razorpay_order_id ON bookings(razorpay_order_id);

-- Comments
COMMENT ON COLUMN bookings.num_guests IS 'Total number of guests (2 base adults + extra adults + children)';
COMMENT ON COLUMN bookings.num_extra_adults IS 'Number of extra adults beyond the base 2';
COMMENT ON COLUMN bookings.num_children_above_5 IS 'Number of children above 5 years';
COMMENT ON COLUMN bookings.subtotal_amount IS 'Total amount before GST';
COMMENT ON COLUMN bookings.gst_amount IS 'GST amount';
COMMENT ON COLUMN bookings.gst_percentage IS 'GST percentage applied';

-- ============================================
-- 5. BLOCKED DATES TABLE (WITH SOURCE TRACKING)
-- ============================================
CREATE TABLE IF NOT EXISTS blocked_dates (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason VARCHAR(255) NOT NULL,
    notes TEXT,
    
    -- Source tracking (for calendar sync)
    source VARCHAR(50) DEFAULT 'manual', -- 'manual', 'airbnb', 'booking.com', etc.
    external_id VARCHAR(255), -- External reference ID from source platform
    platform_data JSONB, -- Additional metadata from source platform
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT check_blocked_dates_valid CHECK (end_date >= start_date)
);

-- Indexes for blocked_dates
CREATE INDEX IF NOT EXISTS idx_blocked_dates_room_id ON blocked_dates(room_id);
CREATE INDEX IF NOT EXISTS idx_blocked_dates_start_date ON blocked_dates(start_date);
CREATE INDEX IF NOT EXISTS idx_blocked_dates_end_date ON blocked_dates(end_date);
CREATE INDEX IF NOT EXISTS idx_blocked_dates_source ON blocked_dates(source);
CREATE INDEX IF NOT EXISTS idx_blocked_dates_external_id ON blocked_dates(external_id);

-- Comments
COMMENT ON COLUMN blocked_dates.source IS 'Source of the blocked date: manual (admin panel), airbnb, booking.com, etc.';
COMMENT ON COLUMN blocked_dates.external_id IS 'External reference ID from the source platform';
COMMENT ON COLUMN blocked_dates.platform_data IS 'Additional metadata from the source platform (JSON format)';

-- ============================================
-- 6. FACILITIES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS facilities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_facilities_is_active ON facilities(is_active);

-- ============================================
-- 7. FEATURES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS features (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    icon_name VARCHAR(100),
    category VARCHAR(100),
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_features_is_active ON features(is_active);
CREATE INDEX IF NOT EXISTS idx_features_is_featured ON features(is_featured);
CREATE INDEX IF NOT EXISTS idx_features_category ON features(category);

-- ============================================
-- 8. TESTIMONIALS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS testimonials (
    id SERIAL PRIMARY KEY,
    guest_name VARCHAR(255) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    source VARCHAR(50) DEFAULT 'website' CHECK (source IN ('website', 'google')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_testimonials_is_featured ON testimonials(is_featured);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_active ON testimonials(is_active);
CREATE INDEX IF NOT EXISTS idx_testimonials_rating ON testimonials(rating);

-- ============================================
-- 9. CONTACT MESSAGES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS contact_messages (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contact_messages_is_read ON contact_messages(is_read);
CREATE INDEX IF NOT EXISTS idx_contact_messages_email ON contact_messages(email);
CREATE INDEX IF NOT EXISTS idx_contact_messages_created_at ON contact_messages(created_at);

-- ============================================
-- 10. TOURIST ATTRACTIONS TABLE (WITH IMAGES)
-- ============================================
CREATE TABLE IF NOT EXISTS tourist_attractions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    
    -- Images (updated to support multiple images)
    image_url TEXT, -- Primary image (deprecated, use images array)
    images TEXT[], -- Array of image URLs
    
    -- Location
    location VARCHAR(255) NOT NULL,
    distance VARCHAR(50), -- e.g., '5 km', '10 km'
    travel_time VARCHAR(50), -- e.g., '15 minutes', '30 minutes'
    
    -- Details
    type VARCHAR(100), -- e.g., 'beach', 'fort', 'temple'
    category VARCHAR(100),
    highlights TEXT[], -- Array of highlights
    best_time VARCHAR(100), -- Best time to visit
    
    -- Metadata
    rating NUMERIC(3, 2) CHECK (rating >= 0 AND rating <= 5),
    google_maps_url TEXT,
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INTEGER DEFAULT 0,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tourist_attractions_is_featured ON tourist_attractions(is_featured);
CREATE INDEX IF NOT EXISTS idx_tourist_attractions_is_active ON tourist_attractions(is_active);
CREATE INDEX IF NOT EXISTS idx_tourist_attractions_category ON tourist_attractions(category);
CREATE INDEX IF NOT EXISTS idx_tourist_attractions_type ON tourist_attractions(type);
CREATE INDEX IF NOT EXISTS idx_tourist_attractions_display_order ON tourist_attractions(display_order);

-- ============================================
-- 11. SOCIAL MEDIA LINKS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS social_media_links (
    id SERIAL PRIMARY KEY,
    platform VARCHAR(100) NOT NULL,
    url TEXT NOT NULL,
    icon_class VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_social_media_links_is_active ON social_media_links(is_active);
CREATE INDEX IF NOT EXISTS idx_social_media_links_display_order ON social_media_links(display_order);

-- ============================================
-- 12. HOUSE RULES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS house_rules (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    icon_name VARCHAR(100),
    category VARCHAR(100),
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_house_rules_is_active ON house_rules(is_active);
CREATE INDEX IF NOT EXISTS idx_house_rules_category ON house_rules(category);

-- ============================================
-- 13. FAQ TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS faq (
    id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100),
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_faq_is_active ON faq(is_active);
CREATE INDEX IF NOT EXISTS idx_faq_category ON faq(category);

-- ============================================
-- 14. ADMIN SETTINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS admin_settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(255) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(50) DEFAULT 'text', -- 'text', 'number', 'boolean', 'json'
    description TEXT,
    category VARCHAR(100),
    is_public BOOLEAN DEFAULT FALSE, -- Whether setting is visible to public
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_admin_settings_key ON admin_settings(setting_key);
CREATE INDEX IF NOT EXISTS idx_admin_settings_category ON admin_settings(category);

-- ============================================
-- 15. CALENDAR SETTINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS calendar_settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(255) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_calendar_settings_key ON calendar_settings(setting_key);

-- ============================================
-- 16. RESORT CLOSURES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS resort_closures (
    id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason VARCHAR(255) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT check_closure_dates_valid CHECK (end_date >= start_date)
);

CREATE INDEX IF NOT EXISTS idx_resort_closures_start_date ON resort_closures(start_date);
CREATE INDEX IF NOT EXISTS idx_resort_closures_end_date ON resort_closures(end_date);
CREATE INDEX IF NOT EXISTS idx_resort_closures_is_active ON resort_closures(is_active);

-- ============================================
-- 17. WHATSAPP SETTINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS whatsapp_settings (
    id SERIAL PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL,
    welcome_message TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    position VARCHAR(20) DEFAULT 'bottom-right', -- Widget position
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to bookings
CREATE TRIGGER update_bookings_updated_at
    BEFORE UPDATE ON bookings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to calendar_settings
CREATE TRIGGER update_calendar_settings_updated_at
    BEFORE UPDATE ON calendar_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to admin_settings
CREATE TRIGGER update_admin_settings_updated_at
    BEFORE UPDATE ON admin_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to features
CREATE TRIGGER update_features_updated_at
    BEFORE UPDATE ON features
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to tourist_attractions
CREATE TRIGGER update_tourist_attractions_updated_at
    BEFORE UPDATE ON tourist_attractions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to house_rules
CREATE TRIGGER update_house_rules_updated_at
    BEFORE UPDATE ON house_rules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to faq
CREATE TRIGGER update_faq_updated_at
    BEFORE UPDATE ON faq
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply trigger to whatsapp_settings
CREATE TRIGGER update_whatsapp_settings_updated_at
    BEFORE UPDATE ON whatsapp_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- END OF COMPLETE SCHEMA
-- ============================================
-- 
-- NOTES:
-- 1. This schema includes all migrations applied
-- 2. Pricing model: Base price (2 adults) + Extra adult price + Child price + GST
-- 3. Children below 5 years are FREE (not stored in database)
-- 4. Total guests = 2 (base) + num_extra_adults + num_children_above_5
-- 5. Soft delete implemented for rooms (is_deleted, deleted_at)
-- 6. Check-in: 12:00 PM, Check-out: 10:00 AM (hardcoded)
-- 7. GST default: 12%
-- ============================================
