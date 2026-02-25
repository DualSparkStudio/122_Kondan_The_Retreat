// Fix Admin Active Status for Kondan The Retreat
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.VITE_SUPABASE_SERVICE_ROLE_KEY

const supabase = createClient(supabaseUrl, supabaseKey)

async function fixAdmin() {
  console.log('🔧 Fixing Admin Login Issue for Kondan The Retreat\n')
  console.log('==================================================')
  
  try {
    const email = 'admin@kondantheretreat.com'
    
    console.log('Checking admin user...')
    
    // First, check if is_active column exists by trying to select it
    const { data: checkData, error: checkError } = await supabase
      .from('admin')
      .select('id, email, is_active')
      .eq('email', email)
      .single()
    
    if (checkError) {
      console.log('⚠️  is_active column might not exist')
      console.log('Please run this SQL in Supabase SQL Editor:\n')
      console.log('ALTER TABLE admin ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;')
      console.log('UPDATE admin SET is_active = TRUE WHERE email = \'admin@kondantheretreat.com\';')
      return
    }
    
    console.log('✅ Admin found:', checkData.email)
    console.log('   is_active:', checkData.is_active)
    
    if (checkData.is_active === false || checkData.is_active === null) {
      console.log('\n🔄 Setting is_active to TRUE...')
      
      const { data: updateData, error: updateError } = await supabase
        .from('admin')
        .update({ is_active: true })
        .eq('email', email)
        .select()
      
      if (updateError) {
        console.log('❌ Error updating:', updateError.message)
        return
      }
      
      console.log('✅ Admin activated successfully!')
    } else {
      console.log('✅ Admin is already active')
    }
    
    console.log('\n==================================================')
    console.log('✅ ADMIN LOGIN SHOULD NOW WORK!')
    console.log('==================================================')
    console.log('\n📋 Login Credentials:')
    console.log('   Email: admin@kondantheretreat.com')
    console.log('   Password: Admin@123')
    console.log('\n🔑 Try logging in again at:')
    console.log('   http://localhost:8888/admin/login')
    console.log('==================================================\n')
    
  } catch (error) {
    console.log('\n❌ Unexpected error:', error.message)
  }
}

fixAdmin()
