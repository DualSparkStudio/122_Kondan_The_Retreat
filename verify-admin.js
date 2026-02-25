// Verify Admin User for Kondan The Retreat
import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY

const supabase = createClient(supabaseUrl, supabaseKey)

async function verifyAdmin() {
  console.log('🔍 Verifying Admin User for Kondan The Retreat\n')
  console.log('==================================================')
  
  try {
    // Get all admin users
    const { data: admins, error } = await supabase
      .from('admin')
      .select('id, email, first_name, last_name, phone, address, created_at')
      .order('created_at', { ascending: false })
    
    if (error) {
      console.log('❌ Error fetching admin users:', error.message)
      return
    }
    
    if (!admins || admins.length === 0) {
      console.log('❌ No admin users found in the database')
      console.log('\n💡 Run: node create-admin.js to create an admin user')
      return
    }
    
    console.log(`✅ Found ${admins.length} admin user(s):\n`)
    
    admins.forEach((admin, index) => {
      console.log(`Admin #${index + 1}:`)
      console.log('  ID:', admin.id)
      console.log('  Email:', admin.email)
      console.log('  Name:', `${admin.first_name} ${admin.last_name}`)
      console.log('  Phone:', admin.phone || 'Not provided')
      console.log('  Address:', admin.address || 'Not provided')
      console.log('  Created:', new Date(admin.created_at).toLocaleString())
      console.log('')
    })
    
    console.log('==================================================')
    console.log('✅ Admin verification complete!')
    console.log('\n🔑 You can now login at: /admin/login')
    
  } catch (error) {
    console.log('❌ Unexpected error:', error.message)
  }
}

verifyAdmin()
