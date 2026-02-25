// Detailed Database Test for Kondan The Retreat
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY

console.log('🔍 Detailed Database Test for Kondan The Retreat\n')
console.log('Database URL:', supabaseUrl)
console.log('==================================================\n')

const supabase = createClient(supabaseUrl, supabaseKey)

async function testDatabase() {
  let allPassed = true

  // Test 1: Rooms Table
  console.log('📋 Test 1: Rooms Table')
  try {
    const { data: rooms, error } = await supabase
      .from('rooms')
      .select('id, name, room_number, price_per_night')
      .limit(5)
    
    if (error) throw error
    
    console.log(`✅ Rooms table accessible`)
    console.log(`   Found ${rooms.length} rooms`)
    if (rooms.length > 0) {
      console.log(`   Sample: ${rooms[0].name} - ₹${rooms[0].price_per_night}/night`)
    } else {
      console.log('   ⚠️  No rooms found - database is empty')
    }
  } catch (error) {
    console.log(`❌ Rooms table error: ${error.message}`)
    allPassed = false
  }

  // Test 2: Bookings Table
  console.log('\n📅 Test 2: Bookings Table')
  try {
    const { data: bookings, error } = await supabase
      .from('bookings')
      .select('count')
    
    if (error) throw error
    
    console.log(`✅ Bookings table accessible`)
    console.log(`   Total bookings: ${bookings.length}`)
  } catch (error) {
    console.log(`❌ Bookings table error: ${error.message}`)
    allPassed = false
  }

  // Test 3: Users Table
  console.log('\n👥 Test 3: Users Table')
  try {
    const { data: users, error } = await supabase
      .from('users')
      .select('count')
    
    if (error) throw error
    
    console.log(`✅ Users table accessible`)
    console.log(`   Total users: ${users.length}`)
  } catch (error) {
    console.log(`❌ Users table error: ${error.message}`)
    allPassed = false
  }

  // Test 4: Admin Table
  console.log('\n👨‍💼 Test 4: Admin Table')
  try {
    const { data: admin, error } = await supabase
      .from('admin')
      .select('email, first_name, last_name')
      .limit(1)
    
    if (error) throw error
    
    console.log(`✅ Admin table accessible`)
    if (admin.length > 0) {
      console.log(`   Admin: ${admin[0].first_name} ${admin[0].last_name}`)
      console.log(`   Email: ${admin[0].email}`)
    } else {
      console.log('   ⚠️  No admin user found - need to create one')
    }
  } catch (error) {
    console.log(`❌ Admin table error: ${error.message}`)
    console.log('   ℹ️  This table might not exist yet')
    allPassed = false
  }

  // Test 5: Tourist Attractions Table
  console.log('\n🏞️  Test 5: Tourist Attractions Table')
  try {
    const { data: attractions, error } = await supabase
      .from('tourist_attractions')
      .select('count')
    
    if (error) throw error
    
    console.log(`✅ Tourist attractions table accessible`)
    console.log(`   Total attractions: ${attractions.length}`)
  } catch (error) {
    console.log(`❌ Tourist attractions error: ${error.message}`)
    allPassed = false
  }

  // Test 6: Reviews Table
  console.log('\n⭐ Test 6: Reviews Table')
  try {
    const { data: reviews, error } = await supabase
      .from('reviews')
      .select('count')
    
    if (error) throw error
    
    console.log(`✅ Reviews table accessible`)
    console.log(`   Total reviews: ${reviews.length}`)
  } catch (error) {
    console.log(`❌ Reviews table error: ${error.message}`)
    console.log('   ℹ️  This table might not exist yet')
  }

  // Final Summary
  console.log('\n' + '='.repeat(50))
  if (allPassed) {
    console.log('✅ ALL CRITICAL TESTS PASSED!')
    console.log('🎉 Database is ready for Kondan The Retreat')
  } else {
    console.log('⚠️  SOME TESTS FAILED')
    console.log('📝 Please check the errors above')
  }
  console.log('='.repeat(50))
}

testDatabase()
