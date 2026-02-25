// Test Database Connection for Kondan The Retreat
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY

console.log('Testing Kondan The Retreat Database Connection...')
console.log('Supabase URL:', supabaseUrl)
console.log('Anon Key:', supabaseKey ? 'Set ✓' : 'Missing ✗')

const supabase = createClient(supabaseUrl, supabaseKey)

async function testConnection() {
  try {
    // Test 1: Check if we can connect
    console.log('\n--- Test 1: Basic Connection ---')
    const { data, error } = await supabase.from('rooms').select('count')
    
    if (error) {
      console.log('❌ Connection Error:', error.message)
      return false
    }
    console.log('✅ Database connected successfully!')
    
    // Test 2: Check rooms table
    console.log('\n--- Test 2: Rooms Table ---')
    const { data: rooms, error: roomsError } = await supabase
      .from('rooms')
      .select('*')
      .limit(5)
    
    if (roomsError) {
      console.log('❌ Rooms table error:', roomsError.message)
    } else {
      console.log(`✅ Found ${rooms.length} rooms`)
      if (rooms.length > 0) {
        console.log('Sample room:', rooms[0].name)
      }
    }
    
    // Test 3: Check admin table
    console.log('\n--- Test 3: Admin Table ---')
    const { data: admin, error: adminError } = await supabase
      .from('admin')
      .select('email, first_name, last_name')
      .limit(1)
    
    if (adminError) {
      console.log('❌ Admin table error:', adminError.message)
    } else {
      console.log(`✅ Admin table accessible`)
      if (admin.length > 0) {
        console.log('Admin email:', admin[0].email)
      }
    }
    
    // Test 4: Check bookings table
    console.log('\n--- Test 4: Bookings Table ---')
    const { data: bookings, error: bookingsError } = await supabase
      .from('bookings')
      .select('count')
    
    if (bookingsError) {
      console.log('❌ Bookings table error:', bookingsError.message)
    } else {
      console.log('✅ Bookings table accessible')
    }
    
    console.log('\n✅ All tests completed!')
    return true
    
  } catch (error) {
    console.log('❌ Unexpected error:', error.message)
    return false
  }
}

testConnection()
