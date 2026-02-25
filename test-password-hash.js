// Test Password Hash
import { createClient } from '@supabase/supabase-js'
import bcrypt from 'bcryptjs'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY

const supabase = createClient(supabaseUrl, supabaseKey)

async function testPasswordHash() {
  console.log('🔐 Testing Password Hash\n')
  
  const email = 'admin@kondantheretreat.com'
  const password = 'Admin@123'
  
  try {
    // Get admin from database
    const { data: admin, error } = await supabase
      .from('admin')
      .select('*')
      .eq('email', email)
      .single()
    
    if (error) {
      console.log('❌ Error fetching admin:', error.message)
      return
    }
    
    console.log('✅ Admin found:')
    console.log('   Email:', admin.email)
    console.log('   is_active:', admin.is_active)
    console.log('   password_hash exists:', !!admin.password_hash)
    console.log('   password_hash length:', admin.password_hash?.length)
    
    // Test password
    console.log('\n🔄 Testing password:', password)
    const isValid = await bcrypt.compare(password, admin.password_hash)
    
    if (isValid) {
      console.log('✅ PASSWORD MATCHES!')
    } else {
      console.log('❌ PASSWORD DOES NOT MATCH')
      console.log('\n⚠️  The password hash in the database is incorrect.')
      console.log('   Run: node set-admin-password.js to reset it')
    }
    
  } catch (error) {
    console.log('❌ Error:', error.message)
  }
}

testPasswordHash()
