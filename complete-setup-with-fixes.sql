-- ============================================
-- COMPLETE DATABASE SETUP WITH ALL FIXES
-- Kondan The Retreat - Resort Booking System
-- ============================================
-- Run this single file to set up everything
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
    password_hash VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_is_admin ON users(is_admin);

-- ============================================
-- 2. ROOMS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS rooms (
    id SERIAL PRIMARY KEY,
    room_number VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    slug TEXT UNIQUE,
    description TEXT NOT NULL,
    price_per_night NUMERIC(10, 2) NOT NULL,
    extra_guest_price NUMERIC(10, 2) DEFAULT 0,
    child_above_5_price NUMERIC(10, 2) DEFAULT 0,
    gst_percentage NUMERIC(5, 2) DEFAULT 12,
    max_capacity INTEGER DEFAULT 4,
    max_occupancy INTEGER,
    check_in_time TEXT DEFAULT '12:00 PM',
    check_out_time TEXT DEFAULT '10:00 AM',
    amenities TEXT[],
    image_url TEXT,
    images TEXT[],
    video_url TEXT,
    accommodation_details TEXT,
    floor INTEGER,
    quantity INTEGER DEFAULT 1,
    extra_mattress_price NUMERIC(10, 2) DEFAULT 200,
    is_active BOOLEAN DEFAULT TRUE,
    is_available BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_rooms_slug ON rooms(slug);
CREATE INDEX IF NOT EXISTS idx_rooms_is_active ON rooms(is_active);
CREATE INDEX IF NOT EXISTS idx_rooms_is_available ON rooms(is_available);
CREATE INDEX IF NOT EXISTS idx_rooms_room_number ON rooms(room_number);
CREATE INDEX IF NOT EXISTS idx_rooms_deleted ON rooms(is_deleted, deleted_at);

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
-- 4. BOOKINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES rooms(id) ON DELETE RESTRICT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    num_guests INTEGER NOT NULL DEFAULT 2,
    num_extra_adults INTEGER DEFAULT 0,
    num_children_above_5 INTEGER DEFAULT 0,
    special_requests TEXT,
    subtotal_amount NUMERIC(10, 2) DEFAULT 0,
    gst_amount NUMERIC(10, 2) DEFAULT 0,
    gst_percentage NUMERIC(5, 2) DEFAULT 12,
    total_amount NUMERIC(10, 2) NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'pending' CHECK (booking_status IN ('pending', 'confirmed', 'cancelled')),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed')),
    payment_gateway VARCHAR(20) DEFAULT 'direct' CHECK (payment_gateway IN ('direct', 'razorpay')),
    razorpay_order_id VARCHAR(255),
    razorpay_payment_id VARCHAR(255),
    booking_source VARCHAR(50) DEFAULT 'website',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT check_dates_valid CHECK (check_out_date > check_in_date)
);

CREATE INDEX IF NOT EXISTS idx_bookings_room_id ON bookings(room_id);
CREATE INDEX IF NOT EXISTS idx_bookings_check_in_date ON bookings(check_in_date);
CREATE INDEX IF NOT EXISTS idx_bookings_check_out_date ON bookings(check_out_date);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_status ON bookings(booking_status);
CREATE INDEX IF NOT EXISTS idx_bookings_payment_status ON bookings(payment_status);
CREATE INDEX IF NOT EXISTS idx_bookings_email ON bookings(email);
CREATE INDEX IF NOT EXISTS idx_bookings_booking_source ON bookings(booking_source);
CREATE INDEX IF NOT EXISTS idx_bookings_razorpay_order_id ON bookings(razorpay_order_id);

-- ============================================
-- 5. BLOCKED DATES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS blocked_dates (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason VARCHAR(255) NOT NULL,
    notes TEXT,
    source VARCHAR(50) DEFAULT 'manual',
    external_id VARCHAR(255),
    platform_data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT check_blocked_dates_valid CHECK (end_date >= start_date)
);

CREATE INDEX IF NOT EXISTS idx_blocked_dates_room_id ON blocked_dates(room_id);
CREATE INDEX IF NOT EXISTS idx_blocked_dates_start_date ON blocked_dates(start_date);
CREATE INDEX IF NOT EXISTS idx_blocked_dates_end_date ON blocked_dates(end_date);
CREATE INDEX IF NOT EXISTS idx_blocked_dates_source ON blocked_dates(source);
CREATE INDEX IF NOT EXISTS idx_blocked_dates_external_id ON blocked_dates(external_id);

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
-- 10. TOURIST ATTRACTIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tourist_attractions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    images TEXT[],
    location VARCHAR(255) NOT NULL,
    distance VARCHAR(50),
    travel_time VARCHAR(50),
    type VARCHAR(100),
    category VARCHAR(100),
    highlights TEXT[],
    best_time VARCHAR(100),
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
    rule_text TEXT,
    icon_name VARCHAR(100),
    category VARCHAR(100),
    display_order INTEGER DEFAULT 0,
    order_num INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_house_rules_is_active ON house_rules(is_active);
CREATE INDEX IF NOT EXISTS idx_house_rules_category ON house_rules(category);

-- ============================================
-- 13. FAQ TABLE (named faqs for code compatibility)
-- ============================================
CREATE TABLE IF NOT EXISTS faqs (
    id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100),
    display_order INTEGER DEFAULT 0,
    order_num INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_faqs_is_active ON faqs(is_active);
CREATE INDEX IF NOT EXISTS idx_faqs_category ON faqs(category);

-- ============================================
-- 14. ADMIN SETTINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS admin_settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(255) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(50) DEFAULT 'text',
    description TEXT,
    category VARCHAR(100),
    is_public BOOLEAN DEFAULT FALSE,
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
    position VARCHAR(20) DEFAULT 'bottom-right',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- CREATE ATTRACTIONS VIEW (for code compatibility)
-- ============================================
CREATE OR REPLACE VIEW attractions AS 
SELECT * FROM tourist_attractions;

-- ============================================
-- TRIGGERS
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON bookings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_calendar_settings_updated_at BEFORE UPDATE ON calendar_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_admin_settings_updated_at BEFORE UPDATE ON admin_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_features_updated_at BEFORE UPDATE ON features FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tourist_attractions_updated_at BEFORE UPDATE ON tourist_attractions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_house_rules_updated_at BEFORE UPDATE ON house_rules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_faqs_updated_at BEFORE UPDATE ON faqs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_whatsapp_settings_updated_at BEFORE UPDATE ON whatsapp_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocked_dates ENABLE ROW LEVEL SECURITY;
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE features ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE tourist_attractions ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_media_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE house_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE calendar_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE resort_closures ENABLE ROW LEVEL SECURITY;
ALTER TABLE whatsapp_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_images ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS POLICIES - PUBLIC READ ACCESS
-- ============================================
CREATE POLICY "Allow public read" ON rooms FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON features FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON tourist_attractions FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON house_rules FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON faqs FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON users FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON facilities FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON testimonials FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON social_media_links FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON calendar_settings FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON whatsapp_settings FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON room_images FOR SELECT USING (true);
CREATE POLICY "Allow public read" ON bookings FOR SELECT USING (true);

-- ============================================
-- RLS POLICIES - INSERT/UPDATE/DELETE
-- ============================================
CREATE POLICY "Allow insert on rooms" ON rooms FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow update on rooms" ON rooms FOR UPDATE USING (true);
CREATE POLICY "Allow delete on rooms" ON rooms FOR DELETE USING (true);

CREATE POLICY "Allow public insert" ON bookings FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public insert" ON contact_messages FOR INSERT WITH CHECK (true);

-- ============================================
-- INSERT DEFAULT DATA
-- ============================================

-- Insert maintenance mode setting
INSERT INTO calendar_settings (setting_key, setting_value, description)
VALUES ('maintenance_mode', 'false', 'Enable/disable maintenance mode')
ON CONFLICT (setting_key) DO NOTHING;

-- Insert default admin user
INSERT INTO users (username, email, first_name, last_name, phone, address, is_admin, password_hash)
VALUES (
    'admin',
    'admin@kondan.com',
    'Kondan',
    'The Retreat',
    '+91-8275063636',
    'Kondan The Retreat, Mahabaleshwar, Maharashtra',
    true,
    '$2b$10$QHDMK6VP0Xqm59.LBW8Uke/55zDHA.Fekz2.mP2AX76S559sB3RKe'
)
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- VERIFICATION
-- ============================================
SELECT 'Setup complete!' as status;
SELECT 'Tables created: ' || COUNT(*) as tables_count 
FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';

-- ============================================
-- END OF COMPLETE SETUP
-- ============================================
-- 
-- ADMIN LOGIN CREDENTIALS:
-- Email: admin@kondan.com
-- Password: Admin@123
-- 
-- IMPORTANT: Change the admin password after first login!
-- ============================================
