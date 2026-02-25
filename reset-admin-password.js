// Reset Admin Password for Kondan The Retreat
import { createClient } from '@supabase/supabase-js'
import bcrypt from 'bcryptjs'
import dotenv from 'dotenv'
import readline from 'readline'

dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.VITE_SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_SERVICE_ROLE_KEY

const supabase = createClient(supabaseUrl, supabaseKey)

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
})

function question(query) {
  return new Promise(resolve => rl.question(query, resolve))
}

async function resetPassword() {
  console.log('🔐 Reset Admin Password for Kondan The Retreat\n')
  console.log('==================================================')
  
  try {
    const email = await question('Enter admin email (admin@kondantheretreat.com): ') || 'admin@kondantheretreat.com'
    const newPassword = await question('Enter new password: ')
    
    if (!newPassword || newPassword.length < 6) {
      console.log('\n❌ Password must be at least 6 characters long')
      rl.close()
      return
    }
    
    console.log('\n🔄 Resetting password...')
    
    // Hash new password
    const passwordHash = await bcrypt.hash(newPassword, 10)
    
    // Update admin password
    const { data, error } = await supabase
      .from('admin')
      .update({
        password_hash: passwordHash,
        updated_at: new Date().toISOString()
      })
      .eq('email', email.trim())
      .select()
    
    if (error) {
      console.log('\n❌ Error resetting password:', error.message)
      rl.close()
      return
    }
    
    if (!data || data.length === 0) {
      console.log('\n❌ Admin user not found with email:', email)
      rl.close()
      return
    }
    
    console.log('\n✅ Password reset successfully!')
    console.log('\n📋 New Login Credentials:')
    console.log('   Email:', email)
    console.log('   Password:', newPassword)
    console.log('\n🔑 You can now login at: /admin/login')
    console.log('\n⚠️  IMPORTANT: Save these credentials securely!')
    
  } catch (error) {
    console.log('\n❌ Unexpected error:', error.message)
  }
  
  rl.close()
}

resetPassword()
