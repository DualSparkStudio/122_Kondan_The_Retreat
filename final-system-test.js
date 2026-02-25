// Final System Test for Kondan The Retreat
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY

console.log('🎯 FINAL SYSTEM TEST - KONDAN THE RETREAT\n')
console.log('======================================================================')

const supabase = createClient(supabaseUrl, supabaseKey)

async function finalTest() {
  const results = {
    passed: 0,
    failed: 0,
    warnings: 0
  }

  // Test 1: Database Connection
  console.log('\n🔌 Test 1: Database Connection')
  console.log('   URL:', supabaseUrl)
  try {
    const { error } = await supabase.from('users').select('count').limit(1)
    if (error) throw error
    console.log('   ✅ Database connected successfully')
    results.passed++
  } catch (error) {
    console.log('   ❌ Connection failed:', error.message)
    results.failed++
  }

  // Test 2: All Tables Exist
  console.log('\n📋 Test 2: Database Tables')
  const tables = ['rooms', 'bookings', 'users', 'admin', 'tourist_attractions', 'reviews']
  
  for (const table of tables) {
    try {
      const { error } = await supabase.from(table).select('count').limit(1)
      if (error) throw error
      console.log(`   ✅ ${table} table exists`)
      results.passed++
    } catch (error) {
      console.log(`   ❌ ${table} table missing`)
      results.failed++
    }
  }

  // Test 3: Admin User
  console.log('\n👨‍💼 Test 3: Admin User')
  try {
    const { data: admin, error } = await supabase
      .from('admin')
      .select('email, first_name, last_name')
      .limit(1)
    
    if (error) throw error
    
    if (admin && admin.length > 0) {
      console.log(`   ✅ Admin user exists: ${admin[0].email}`)
      console.log(`   👤 Name: ${admin[0].first_name} ${admin[0].last_name}`)
      results.passed++
    } else {
      console.log('   ⚠️  No admin user found')
      results.warnings++
    }
  } catch (error) {
    console.log('   ❌ Admin check failed:', error.message)
    results.failed++
  }

  // Test 4: Data Status
  console.log('\n📊 Test 4: Data Status')
  
  const dataChecks = [
    { table: 'rooms', name: 'Rooms' },
    { table: 'bookings', name: 'Bookings' },
    { table: 'users', name: 'Users' },
    { table: 'tourist_attractions', name: 'Attractions' },
    { table: 'reviews', name: 'Reviews' }
  ]
  
  for (const check of dataChecks) {
    try {
      const { data, error } = await supabase
        .from(check.table)
        .select('id')
      
      if (error) throw error
      
      const count = data.length
      if (count > 0) {
        console.log(`   ✅ ${check.name}: ${count} record(s)`)
        results.passed++
      } else {
        console.log(`   ⚠️  ${check.name}: Empty (needs data)`)
        results.warnings++
      }
    } catch (error) {
      console.log(`   ❌ ${check.name}: Check failed`)
      results.failed++
    }
  }

  // Test 5: Environment Variables
  console.log('\n🔐 Test 5: Environment Variables')
  const envVars = [
    { key: 'VITE_SUPABASE_URL', value: process.env.VITE_SUPABASE_URL },
    { key: 'VITE_SUPABASE_ANON_KEY', value: process.env.VITE_SUPABASE_ANON_KEY },
    { key: 'VITE_RAZORPAY_KEY_ID', value: process.env.VITE_RAZORPAY_KEY_ID },
    { key: 'MAIL_USERNAME', value: process.env.MAIL_USERNAME }
  ]
  
  for (const env of envVars) {
    if (env.value && env.value !== 'your_google_api_key_here') {
      console.log(`   ✅ ${env.key}: Set`)
      results.passed++
    } else {
      console.log(`   ⚠️  ${env.key}: Not set`)
      results.warnings++
    }
  }

  // Final Summary
  console.log('\n======================================================================')
  console.log('📈 FINAL RESULTS')
  console.log('======================================================================')
  console.log(`✅ Passed: ${results.passed}`)
  console.log(`❌ Failed: ${results.failed}`)
  console.log(`⚠️  Warnings: ${results.warnings}`)
  console.log('======================================================================')
  
  if (results.failed === 0) {
    console.log('\n🎉 ALL CRITICAL TESTS PASSED!')
    console.log('✨ Kondan The Retreat system is READY!')
    console.log('\n📝 Next Steps:')
    console.log('   1. Add room data through admin panel')
    console.log('   2. Test admin login at /admin/login')
    console.log('   3. Deploy to production (Netlify)')
    console.log('   4. Update Netlify environment variables')
  } else {
    console.log('\n⚠️  SOME TESTS FAILED')
    console.log('Please review the errors above and fix them.')
  }
  
  console.log('\n======================================================================')
}

finalTest()
