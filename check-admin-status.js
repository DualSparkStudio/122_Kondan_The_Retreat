// Check Admin Status
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY

const supabase = createClient(supabaseUrl, supabaseKey)

async function checkAdmin() {
  console.log('🔍 Checking Admin Status\n')
  
  try {
    const { data, error } = await supabase
      .from('admin')
      .select('*')
      .eq('email', 'admin@kondantheretreat.com')
      .single()
    
    if (error) {
      console.log('❌ Error:', error.message)
      return
    }
    
    console.log('✅ Admin found:')
    console.log('   Email:', data.email)
    console.log('   Name:', data.first_name, data.last_name)
    console.log('   is_active:', data.is_active)
    console.log('   password_hash:', data.password_hash ? 'Set ✓' : 'Missing ✗')
    
    if (data.is_active === true) {
      console.log('\n✅ Admin is active - login should work!')
    } else {
      console.log('\n⚠️  Admin is NOT active - this is the problem')
    }
    
  } catch (error) {
    console.log('❌ Error:', error.message)
  }
}

checkAdmin()
